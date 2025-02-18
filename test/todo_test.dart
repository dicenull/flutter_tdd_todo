import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos/event_tracker.dart';
import 'package:todos/main.dart';
import 'package:todos/todo.dart';
import 'package:todos/todo_data.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('同じ引数のToDoクラスは等しい', () {
    final todo1 = Todo(id: '1', description: 'shopping');
    final todo2 = Todo(id: '1', description: 'shopping');

    expect(todo1 == todo2, isTrue);
  });

  group(TodoList, () {
    test('Todoを追加できる', () {
      final uuid = _MockUuid();
      final eventTracker = _MockEventTracker();
      final container = ProviderContainer(overrides: [
        uuidProvider.overrideWithValue(uuid),
        eventTrackerProvider.overrideWithValue(eventTracker),
      ]);
      when(() => uuid.v4()).thenReturn('1');
      final subscription = container.listen(todoListProvider, (_, __) {});
      final todoList = container.read(todoListProvider.notifier);

      todoList.add('buy');

      expect(subscription.read().last, Todo(description: 'buy', id: '1'));
      verify(() => eventTracker.trackAddTodo('buy')).called(1);
    });
  });
}

class _MockEventTracker extends Mock implements EventTracker {}

class _MockUuid extends Mock implements Uuid {}
