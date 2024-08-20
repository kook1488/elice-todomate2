import 'package:flutter/foundation.dart';
import 'package:todomate/models/signup_model.dart';

import 'todo_model.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Todo> get todos => _todos;

  // 완료된 할 일의 개수를 반환하는 getter
  int get completedTodoCount => _todos.where((todo) => todo.isCompleted).length;

  // 완료되지 않은 할 일의 개수를 반환하는 getter
  int get incompleteTodoCount =>
      _todos.where((todo) => !todo.isCompleted).length;

  Future<void> loadTodos(String userId) async {
    _todos = await _databaseHelper.getTodos(userId);
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    await _databaseHelper.insertTodo(todo);
    _todos.add(todo);
    notifyListeners();
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    await _databaseHelper.updateTodo(updatedTodo);
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String todoId) async {
    await _databaseHelper.deleteTodo(todoId);
    _todos.removeWhere((todo) => todo.id == todoId);
    notifyListeners();
  }

  Future<void> toggleTodoCompletion(Todo todo) async {
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    await updateTodo(updatedTodo);
    notifyListeners(); // 체크 상태가 변경되었으므로 상태를 알림
  }
}
