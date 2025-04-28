import 'package:lizzwe/lizzwe.dart';
import '../models/todo.dart';

class TodoStore {
  final _store = StateStore();

  // Observable states
  late final todos = _store.create<List<Todo>>([]);
  late final isLoading = _store.create<bool>(false);
  late final error = _store.create<Object?>(null);

  Future<void> addTodo(String title) async {
    try {
      isLoading.value = true;
      error.value = null;

      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        isCompleted: false,
      );
      todos.value = [...todos.value, newTodo];
    } catch (e) {
      error.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleTodo(String id) async {
    try {
      isLoading.value = true;
      error.value = null;

      todos.value = todos.value.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(isCompleted: !todo.isCompleted);
        }
        return todo;
      }).toList();
    } catch (e) {
      error.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      isLoading.value = true;
      error.value = null;

      todos.value = todos.value.where((todo) => todo.id != id).toList();
    } catch (e) {
      error.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    _store.clear();
  }
}
