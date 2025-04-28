import 'dart:async';
import 'dart:math';
import '../models/todo.dart';

/// Mock server để giả lập API calls với delay và random errors
class MockTodoServer {
  // Simulate network delay (1-2 seconds)
  static const _minDelay = Duration(milliseconds: 1000);
  static const _maxDelay = Duration(milliseconds: 2000);

  // Simulate random errors (10% chance)
  static const _errorRate = 0.1;

  // Mock database
  final List<Todo> _todos = [];
  final _random = Random();

  Future<void> _simulateNetworkDelay() async {
    final delay = _minDelay.inMilliseconds +
        _random.nextInt(_maxDelay.inMilliseconds - _minDelay.inMilliseconds);
    await Future.delayed(Duration(milliseconds: delay));
  }

  bool _shouldThrowError() {
    return _random.nextDouble() < _errorRate;
  }

  /// Lấy danh sách todos
  Future<List<Todo>> fetchTodos() async {
    await _simulateNetworkDelay();
    if (_shouldThrowError()) {
      throw Exception('Failed to fetch todos');
    }
    return List.from(_todos);
  }

  /// Thêm todo mới
  Future<Todo> addTodo(String title) async {
    await _simulateNetworkDelay();
    if (_shouldThrowError()) {
      throw Exception('Failed to add todo');
    }

    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isCompleted: false,
    );
    _todos.add(todo);
    return todo;
  }

  /// Toggle trạng thái completed của todo
  Future<Todo> toggleTodo(String id) async {
    await _simulateNetworkDelay();
    if (_shouldThrowError()) {
      throw Exception('Failed to toggle todo');
    }

    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) throw Exception('Todo not found');

    final todo = _todos[index];
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    _todos[index] = updatedTodo;
    return updatedTodo;
  }

  /// Xóa todo
  Future<void> deleteTodo(String id) async {
    await _simulateNetworkDelay();
    if (_shouldThrowError()) {
      throw Exception('Failed to delete todo');
    }

    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) throw Exception('Todo not found');
    _todos.removeAt(index);
  }
}
