import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//클래스(틀) ,객체=인스턴스 (한국어와 외국어차이:실행중인게 인스턴스라는데 모르겠다)
class DatabaseHelper {
  //클래스(붕어빵) 객체=인스턴스 였다...!
  //예를들어 회사 복사기= 객체 모두가 이 복사기를 쓰니깐
  //  복사기만드는 기계(디비헬퍼)-복사기(객체=instance)1개로 가져다 쓴다- 회사에서 사람마다 다르게 복사해줌
  //  복사기 1개로 가져다 쓰는게 싱글톤 패턴- 큰 기계 하나로 모든 일을 처리하는것

  //인스턴스 이름이 인스턴스 이다. 싱글톤패턴이라 1개만 쓰니깐.
  static final DatabaseHelper _instance1 = DatabaseHelper._internal();
  //static final 데이터베이스를 여러개를 만들지 않고 하나만 쓰려고 한다.
  //static : static 이후의 변수가  DatabaseHelper 클래스자체에 속한다고
  // 클래스의 인스턴스가 공유한다 복사기 공용으로 쓰듯이

  //final : 데이터베이스 이거 하나만 쓰려고 한다.
  //그렇기에 한번만 초기화 될 수 있고 처음 할당된 이후에는 값이 변경되지 않는다
  // _instance1 이게 그 변수 이름이다. DatabaseHelper클래스가 사용하는 딱 하나의 인스턴스 이름.
  //호출할때 클래스를 부른다는데, 이거를 불러도 되지 않을까 싶다

  factory DatabaseHelper() => _instance1;
  //생성자이름이 instance1 이다
  //싱글톤을 실제로 구현하면 factory를 쓴다
  //항상동일한 객체를 내보내려고

  static Database? _database;
  DatabaseHelper._internal(); //생성자 정의 _이거 의미는
  // 프라이빗 생성자로써 이 생성자가 외부에서 호출될 수 없음을 의미한다.
// 다른 클래스에서 DatabaseHelper 를 생성하거나 새로운 인스턴스를
  // 생성하지 못하도록 제한하는것

// 데이터베이스를 초기화하고 파일 경로를 설정하는 메서드
Future<Database> _initDatabase() async {
  // 데이터베이스 파일의 경로를 설정 ('user_database.db'라는 이름으로 저장)
  String path = join(await getDatabasesPath(), 'user_database.db');

  // 지정된 경로에 데이터베이스를 열거나 없으면 생성, 버전은 1로 설정
  return await openDatabase(
    path,
    version: 1,
    // 데이터베이스가 처음 생성될 때 호출되는 콜백 함수로 _onCreate를 지정
    onCreate: _onCreate,
  );
}

// 데이터베이스가 처음 생성될 때 호출되는 콜백 함수, users 테이블을 생성
Future<void> _onCreate(Database db, int version) async {
  // SQL 명령어를 실행하여 users 테이블 생성
  await db.execute('''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      -- id 컬럼, 자동 증가하는 정수형 기본 키
      login_id TEXT UNIQUE,
      -- login_id 컬럼, 고유한 텍스트 값으로 설정
      nickname TEXT,
      -- nickname 컬럼, 텍스트 형태의 사용자 닉네임
      password TEXT,
      -- password 컬럼, 텍스트 형태의 해시된 비밀번호
      avatar_path TEXT
      -- avatar_path 컬럼, 텍스트 형태의 아바타 이미지 경로
    )
  ''');
}

//*암호화 작업 비밀번호를 SHA-256 해시 알고리즘으로 해시화하는 메서드
String _hashPassword(String password) {
  // 비밀번호 문자열을 바이트 배열로 인코딩 (UTF-8 인코딩 사용)
  var bytes = utf8.encode(password);

  // 바이트 배열을 SHA-256 해시 알고리즘으로 해시화하여 digest 객체 생성
  var digest = sha256.convert(bytes);

  // 해시된 결과를 문자열로 변환하여 반환
  return digest.toString();
}

// 새로운 사용자를 데이터베이스에 삽입하는 메서드
Future<int> insertUser(Map<String, dynamic> user) async {
  // 비동기적으로 데이터베이스 인스턴스를 얻음
  Database db = await database;

  // 사용자의 비밀번호를 해시화하여 user 맵에 저장
  user['password'] = _hashPassword(user['password']);

  try {
    // users 테이블에 새로운 레코드를 삽입하고 삽입된 행의 ID를 반환
    return await db.insert('users', user);
  } catch (e) {
    // UNIQUE 제약 조건 위반(중복된 login_id) 예외 처리
    if (e.toString().contains('UNIQUE constraint failed')) {
      // 중복된 login_id가 있을 경우 예외 발생
      throw Exception('사용자 아이디가 이미 존재합니다.');
    } else {
      // 그 외의 예외 발생 시 예외를 다시 던짐
      throw e;
    }
  }
}

// 데이터베이스에서 모든 사용자 레코드를 조회하는 메서드
Future<List<Map<String, dynamic>>> getUsers() async {
  //중간중간처리
  // 비동기적으로 데이터베이스 인스턴스를 얻음
  Database db = await database; //-초기화

  // users 테이블의 모든 레코드를 조회하여 반환
  return await db.query('users');
}

// 특정 loginId와 password를 가진 사용자를 조회하는 메서드
Future<Map<String, dynamic>?> getUser(String loginId, String password) async {
  // 비동기적으로 데이터베이스 인스턴스를 얻음
  Database db = await database;

  // 입력된 비밀번호를 해시화
  String hashedPassword = _hashPassword(password);

  // users 테이블에서 login_id가 일치하는 레코드를 조회
  List<Map<String, dynamic>> results = await db.query(
    'users',
    where: 'login_id = ?',
    whereArgs: [loginId],
  );

  // 조회된 레코드가 있는지 확인
  if (results.isNotEmpty) {
    // 첫 번째 레코드를 가져옴
    Map<String, dynamic> user = results.first;

    // 데이터베이스에 저장된 해시된 비밀번호와 입력된 비밀번호를 비교
    if (user['password'] == hashedPassword) {
      // 비밀번호가 일치하면 해당 사용자 정보를 반환
      return {
        'id': user['id'],
        'login_id': user['login_id'],
        'nickname': user['nickname'],
        'avatar_path': user['avatar_path'],
      };
    }
  }
  // 사용자가 없거나 비밀번호가 일치하지 않으면 null을 반환
  return null;
}

// 사용자의 로그인 처리를 수행하는 메서드
Future<Map<String, dynamic>> loginUser(String loginId, String password) async {
  try {
    // 모든 비밀번호가 해시화되어 있는지 확인
    await ensurePasswordsAreHashed();

    // 입력된 loginId와 password로 사용자를 조회
    final user = await getUser(loginId, password);

    // 사용자가 존재하고 비밀번호가 일치하는 경우
    if (user != null) {
      // 로그인 성공 정보를 반환
      return {
        "success": true,
        "user": {
          "id": user['id'],
          "nickname": user['nickname'],
          "avatar_path": user['avatar_path'] ?? 'default_avatar.png',
        },
        "message": "로그인에 성공했습니다."
      };
    } else {
      // 로그인 실패 정보를 반환 (사용자 없음 또는 비밀번호 불일치)
      return {"success": false, "message": "아이디 또는 비밀번호가 올바르지 않습니다."};
    }
  } catch (e) {
    // 예외 발생 시 로그인 실패 정보를 반환
    return {"success": false, "message": "로그인 중 오류가 발생했습니다: $e"};
  }
}

// 모든 사용자 비밀번호가 해시화되어 있는지 확인하고 필요 시 업데이트하는 메서드
Future<void> ensurePasswordsAreHashed() async {
  // 비동기적으로 비밀번호 해시화를 확인 및 업데이트
  await updatePasswordToHash();
}

// 데이터베이스에 저장된 모든 사용자의 비밀번호를 해시화하는 메서드
Future<void> updatePasswordToHash() async {
  // 비동기적으로 데이터베이스 인스턴스를 얻음
  Database db = await database;

  // users 테이블의 모든 레코드를 조회
  List<Map<String, dynamic>> users = await db.query('users');

  // 각 사용자에 대해 비밀번호가 해시화되어 있는지 확인
  for (var user in users) {
    // SHA-256 해시는 64자이므로, 비밀번호가 해시화되지 않은 경우(길이가 64자가 아닌 경우)
    if (user['password'].length != 64) {
      // 비밀번호를 해시화
      String hashedPassword = _hashPassword(user['password']);

      // 해시화된 비밀번호로 업데이트
      await db.update(
        'users',
        {'password': hashedPassword},
        where: 'id = ?',
        whereArgs: [user['id']],
      );
    }
  }
}
