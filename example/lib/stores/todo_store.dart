import 'package:lizzwe/lizzwe.dart';
import '../models/todo.dart';

class TodoStore {
  final StateStore _store = StateStore();
  late final Observable<List<Todo>> _todos;

  TodoStore() {
    _todos = _store.create('todos', <Todo>[]);
  }

  Observable<List<Todo>> get todos => _todos;

  void addTodo(String title) {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    _todos.value = [..._todos.value, newTodo];
  }

  void toggleTodo(String id) {
    _todos.value = _todos.value.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();
  }

  void deleteTodo(String id) {
    _todos.value = _todos.value.where((todo) => todo.id != id).toList();
  }
}
