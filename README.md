# Todomate 엘리스 프로젝트 3팀 

## 참여 멤버
- 팀장 고규화
- 팀원
 - 국한
 - 김기태
 - 정원교
 - 정희진


# 디렉토리 구조 및 파일명
## Chat 파트 
- /lib/chat 챗기능 메인 화면
    - chat.dart  메인 파일
    - /core 컨트롤러 디렉토리
        - scroll_controller_mixin.dart  스크롤을 위한 컨트럴러
        - database_helper.dart DB 웹소켓 연결을 대비한 헬퍼파일.. 미작동 상태
    - /view 뷰 디렉토리
        - chat_screen.dart 채팅방 목록 화면(메인 화면)
        - chat_inner_screen.dart 채팅방 메인뷰
        - chat_input_section.dart 채팅방 입력창을 위한 디자인 뷰
        - /widgets 뷰용 위젯 디렉토리
            - chats_item_widget.dart 채팅방 목록 디자인 위젯
            - chat_inner_screen_widgets.dart 채팅방 디자인 위젯
    - /models 모델 디렉토리
        - chat_model.dart  채팅목록 창에서 데이터를 연결하기 위하 모델
        - message_model.dart  채팅방에서 데이터를 연결하기 위한 모델
        - user_info.dart 메인파일에서 로그인 사용자 정보를 가져오는 모델
- /lib/assets 참조용 파일 디렉토리
    - chat_x.json id 별 채팅 내역
    - /images
        - avata_x.png 아바타 파일들 숫자는 등록된 친구 알파벳은 신규 등록 가능 친구


# 구동방법
## Chat 파트
우선 asset 과 assets 디렉토리가 통합되지 않아 임시로 ln -s 명령으로 디렉토리를 심볼릭 링크로 만들어주는 과정이 필요함.

cd  todomate
ln -s asset assets
ln -s assets/image asset/images

윈도우 환경에서는 copy 명령으로 asset 디렉토를 assets 로 복사해두면 임시로 사용가능하다.

현재 chat 관래 분분은 assets 를 참조 하도록 되어 있어 위와 같이 해주는 것이 필요함.

## 실행방법 
vscode 상에서
마우스로 todomat/lib/chat/chat.dart 파일을 선택하고. 오른쪽 버튼을 눌러 Start Debuging 을 눌러서 실행하면 Chat 파트부분이 실행됨.

## 주의사항
flutter clean
flutter pub get 
명령을 실행시켜 관련 패키지들을 다시 받아와야 할수 있다.



