import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:todomate/models/signup_model.dart';
import 'package:todomate/models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Todo> _todos = [];
  List<Map<String, dynamic>> _friends = [];
  String? _currentUserId;

  // 현재 사용자 ID Getter
  String? get currentUserId => _currentUserId;

  // 할 일 목록 Getter
  List<Todo> get todos => _todos;

  // 친구 목록 Getter
  List<Map<String, dynamic>> get friends => _friends;

  // 추가된 할 일의 완료 여부에 따른 카운트 Getter
  int get incompleteTodoCount => _todos.where((todo) => !todo.isCompleted).length;
  int get completedTodoCount => _todos.where((todo) => todo.isCompleted).length;

  // 생성자: WebSocket 메시지 리스너 설정
  TodoProvider() {
    _dbHelper.todoUpdateStream.listen(_handleWebSocketMessage);
  }

  // 현재 사용자 ID 설정
  void setCurrentUserId(String userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  // 할 일 목록 로드
  Future<void> loadTodos(String userId) async {
    _todos = await _dbHelper.getTodos(userId);
    notifyListeners();
  }

  // 할 일 추가
  Future<void> addTodo(Todo todo) async {
    await _dbHelper.insertTodo(todo);
    _todos.add(todo);
    notifyListeners();
  }

  // 공유된 할 일 추가
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

  // 할 일 업데이트
  Future<void> updateTodo(Todo todo) async {
    await _dbHelper.updateTodo(todo);
    int index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      notifyListeners();
    }
  }

  // 할 일 삭제
  Future<void> deleteTodo(String todoId) async {
    await _dbHelper.deleteTodo(todoId);
    _todos.removeWhere((todo) => todo.id == todoId);
    notifyListeners();
  }

  // 할 일 완료 상태 토글
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

      // WebSocket을 통해 상태 전송
      _dbHelper.sendTodoUpdate(
          _currentUserId!, todoId, isCurrentUser ? updatedTodo.isCompleted : updatedTodo.isFriendCompleted);

      notifyListeners();
    }
  }

  // WebSocket 메시지 처리
  void _handleWebSocketMessage(Map<String, dynamic> data) {
    if (data['type'] == 'todo_update' && data.containsKey('todoId') && data.containsKey('isCompleted')) {
      String todoId = data['todoId'];
      bool isCompleted = data['isCompleted'];
      String updatingUserId = data['userId'];

      int index = _todos.indexWhere((todo) => todo.id == todoId || todo.friendId == todoId);
      if (index != -1) {
        Todo currentTodo = _todos[index];
        Todo updatedTodo;

        if (updatingUserId == _currentUserId) {
          updatedTodo = currentTodo.copyWith(isCompleted: isCompleted);
        } else {
          updatedTodo = currentTodo.copyWith(isFriendCompleted: isCompleted);
        }

        _todos[index] = updatedTodo;
        notifyListeners();
      }
    }
  }

  // 친구 목록 로드
  Future<void> loadFriends(String userId) async {
    _friends = await _dbHelper.getAcceptedFriends(userId);
    notifyListeners();
  }
}
