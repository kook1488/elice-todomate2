import 'package:flutter/foundation.dart';
import 'package:todomate/models/signup_model.dart';
import 'package:todomate/models/todo_model.dart';


class TodoProvider with ChangeNotifier {
  DatabaseHelper _dbHelper = DatabaseHelper();
  List<Todo> _todos = [];

 // final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Map<String, dynamic>> _friends = [];
  String? _currentUserId;


  List<Todo> get todos => _todos;
  List<Map<String, dynamic>> get friends => _friends;
  String? get currentUserId => _currentUserId;

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  bool isCurrentUser(String userId) {
    return userId == _currentUserId;
  }

  // 완료된 할 일의 개수를 반환하는 getter
  int get completedTodoCount => _todos.where((todo) => todo.isCompleted).length;

  // 완료되지 않은 할 일의 개수를 반환하는 getter
  int get incompleteTodoCount =>
      _todos.where((todo) => !todo.isCompleted).length;

  Future<void> loadTodos(String userId) async {
    _currentUserId = userId;
    _todos = await _dbHelper.getTodos(userId);
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    await _dbHelper.insertTodo(todo);
    _todos.add(todo);
    notifyListeners();
  }

  Future<void> addSharedTodo(Todo todo) async {
    await _dbHelper.insertTodo(todo);
    _todos.add(todo);

    if (todo.sharedWithFriend && todo.friendId != null) {
      final sharedTodo = Todo(
        id: DateTime.now().toString(),
        userId: todo.friendId!,
        title: todo.title,
        startDate: todo.startDate,
        endDate: todo.endDate,
        color: todo.color,
        isCompleted: false,
        sharedWithFriend: true,
        friendId: todo.userId,
        isFriendCompleted: false,
      );
      await _dbHelper.insertTodo(sharedTodo);
    }

    notifyListeners();
  }

  Future<void> updateTodo(Todo todo) async {
    await _dbHelper.updateTodo(todo);
    int index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String todoId) async {
    await _dbHelper.deleteTodo(todoId);
    _todos.removeWhere((todo) => todo.id == todoId);
    notifyListeners();
  }


 // Future<void> toggleTodoCompletion(Todo todo) async {
 //   final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
  //  await updateTodo(updatedTodo);
  //  notifyListeners(); // 체크 상태가 변경되었으므로 상태를 알림

  Future<void> toggleTodoCompletion(String todoId, {required bool isCurrentUser}) async {
    int index = _todos.indexWhere((todo) => todo.id == todoId);
    if (index != -1) {
      Todo currentTodo = _todos[index];
      Todo updatedTodo;

      if (isCurrentUser) {
        updatedTodo = currentTodo.copyWith(isCompleted: !currentTodo.isCompleted);
      } else {
        updatedTodo = currentTodo.copyWith(isFriendCompleted: !currentTodo.isFriendCompleted);
      }

      await _dbHelper.updateTodo(updatedTodo);
      _todos[index] = updatedTodo;

      if (updatedTodo.sharedWithFriend && updatedTodo.friendId != null) {
        // 연결된 투두리스트 업데이트
        Todo? linkedTodo = await _dbHelper.getLinkedTodo(updatedTodo.friendId!, updatedTodo.id);
        if (linkedTodo != null) {
          Todo updatedLinkedTodo = linkedTodo.copyWith(
            isCompleted: isCurrentUser ? linkedTodo.isCompleted : updatedTodo.isCompleted,
            isFriendCompleted: isCurrentUser ? updatedTodo.isCompleted : linkedTodo.isFriendCompleted,
          );
          await _dbHelper.updateTodo(updatedLinkedTodo);
        }

        // 알림 전송
        sendNotificationToFriend(
            updatedTodo.friendId!,
            updatedTodo.title,
            isCurrentUser ? updatedTodo.isCompleted : updatedTodo.isFriendCompleted
        );
      }

      notifyListeners();
    }
  }

  Future<void> loadFriends(String userId) async {
    _friends = await _dbHelper.getAcceptedFriends(userId);
    notifyListeners();
  }

  Future<void> sendFriendRequest(String userId, String friendId) async {
    await _dbHelper.sendFriendRequest(userId, friendId);
    notifyListeners();
  }

  Future<void> acceptFriendRequest(String userId, String friendId) async {
    await _dbHelper.acceptFriendRequest(userId, friendId);
    await loadFriends(userId);
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query, String userId) async {
    return await _dbHelper.searchUsers(query, userId);
  }

  Future<List<Map<String, dynamic>>> getFriendRequests(String userId) async {
    return await _dbHelper.getFriendRequests(userId);
  }

  Future<void> sendNotificationToFriend(String friendId, String todoTitle, bool isCompleted) async {
    print('알림 전송: 친구 ID $friendId, 할 일 "$todoTitle"이(가) ${isCompleted ? "완료됨" : "미완료됨"}');
    // 실제 알림 전송 로직 구현

  }
}