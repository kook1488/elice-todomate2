import 'package:flutter/foundation.dart';
import 'todo_model.dart'; // Todo 모델의 경로를 올바르게 수정하세요
import 'package:todomate/models/signup_model.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Todo> get todos => _todos;

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
  }
}
