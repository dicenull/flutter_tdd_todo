import 'package:riverpod/riverpod.dart';
import 'package:todos/event_tracker.dart';
import 'package:todos/repository.dart';
import 'package:todos/todo_data.dart';
import 'package:uuid/uuid.dart';

final uuidProvider = Provider((_) => Uuid());

/// An object that controls a list of [Todo].
class TodoList extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => [
        const Todo(id: 'todo-0', description: 'Buy cookies'),
        const Todo(id: 'todo-1', description: 'Star Riverpod'),
        const Todo(id: 'todo-2', description: 'Have a walk'),
      ];

  void add(String description) {
    state = [
      ...state,
      Todo(
        id: ref.read(uuidProvider).v4(),
        description: description,
      ),
    ];
    ref.read(eventTrackerProvider).trackAddTodo(description);
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: !todo.completed,
            description: todo.description,
          )
        else
          todo,
    ];
  }

  void edit({required String id, required String description}) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: todo.completed,
            description: description,
          )
        else
          todo,
    ];
  }

  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }

  Future<void> fetch() async {
    final todoRepository = ref.read(todoRepositoryProvider);
    state = await todoRepository.fetch();
  }
}
