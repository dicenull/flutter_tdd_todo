import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todos/main.dart';
import 'package:todos/todo.dart';
import 'package:todos/todo_data.dart';

void main() {
  test('同じ引数のToDoクラスは等しい', () {
    final todo1 = Todo(id: '1', description: 'shopping');
    final todo2 = Todo(id: '1', description: 'shopping');

    expect(todo1 == todo2, isTrue);
  });

  group(TodoList, () {
    test('Todoを追加できる', () {
      // ProviderScopeの代わりにProviderContainerを作成
      final container = ProviderContainer();
      // TodoListNotifierがdisposeされないように
      final subscription = container.listen(todoListProvider, (_, __) {});
      // TodoListNotifierを取得
      final todoList = container.read(todoListProvider.notifier);

      todoList.add('buy');

      expect(subscription.read().last, Todo(description: 'buy', id: '1'));
    });
  });
}
