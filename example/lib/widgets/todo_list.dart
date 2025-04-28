import 'package:flutter/material.dart';
import 'package:lizzwe/lizzwe.dart';
import '../models/todo.dart';
import '../stores/todo_store.dart';

class TodoList extends StatelessWidget {
  final TodoStore store;

  const TodoList({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateBuilder<List<Todo>>(
      observable: store.todos,
      builder: (context, todos) {
        if (todos.isEmpty) {
          return const Center(
            child: Text('No todos yet. Add one!'),
          );
        }

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return ListTile(
              leading: Checkbox(
                value: todo.isCompleted,
                onChanged: (_) => store.toggleTodo(todo.id),
              ),
              title: Text(
                todo.title,
                style: TextStyle(
                  decoration:
                      todo.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => store.deleteTodo(todo.id),
              ),
            );
          },
        );
      },
    );
  }
}
