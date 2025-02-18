import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todos/todo_data.dart';

final todoRepositoryProvider = Provider((_) => TodoRepository());

class TodoRepository {
  Future<List<Todo>> fetch() {
    return Future.value([]);
  }
}
