## プロジェクトの準備

Zappにある Todoアプリ <https://zapp.run/edit/riverpod-todo-app-z02c06r102d0>
もしくは example/todos <https://github.com/rrousselGit/riverpod/tree/master/examples/todos>

testフォルダには、Widgetテストを行うテストがすでに用意されています。
ProviderをテストするUnitTestはないので、これを追加していきます。

## データのテストで肩慣らし

Providerを使ったテストの前に、単純なUnitTestを追加してみましょう。
Todoクラスが等しいかチェックするテストを追加します。
Todoクラスのパラメータが一致していれば、等しいと判断されるはずです。

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:todos/todo.dart';

void main() {
  test('同じ引数のToDoクラスは等しい', () {
    final todo1 = Todo(id: '1', description: 'shopping');
    final todo2 = Todo(id: '1', description: 'shopping');

    expect(todo1 == todo2, isTrue);
  });
}
```

テストを追加して、実行してみましょう。

```bash
Expected: true
  Actual: <false>

package:matcher                                     expect
package:flutter_test/src/widget_tester.dart 480:18  expect
test/todo_test.dart 9:5                             main.<fn>
```

おっと、テストが失敗してしまいました。
Todoクラスの定義を見ると、==演算子がオーバーライドされていません。
==実装は手間なので、freezedパッケージを追加して簡単に実装します。

```bash
dart pub add freezed_annotation
dart pub add dev:freezed
```

`todo_data.dart`ファイルを作成し、Todoクラスをfreezedで定義します。

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_data.freezed.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String description,
    required String id,
    @Default(false) bool completed,
  }) = _TodoData;
}
```

`flutter pub run build_runner build`で生成し、参照しているインポートを置き換えましょう。
ここまでできたら、もう一度テストを実行してみましょう。

```bash
✓ 同じ引数のToDoクラスは等しい

Exited.
```

成功しました :tada:
いよいよProviderを使ったテストを追加しましょう。

## Expect

それではTodoListNotifierをテストします。

テストの実装はTDD的に進めていきます。
まずはテストしたいことをテストリストとして列挙しましょう。

- [ ] Todoを追加できる
- [ ] Todoを削除できる
- [ ] Todoを完了にできる
- [ ] Todoを未完了にできる
- [ ] Todoの説明を編集できる

本来のTDDであれば、失敗するテストを書いて、実装し、リファクタリングを行います。
今回は、すでに実装があるので成功するテストを書いていきます。

### Todoを追加するテスト

簡単のため、Todoを追加できるテストだけ実装します。
では、追加できるテストを追加しましょう。

```dart
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
```

テストを実行してみましょう。
IDが一致せず失敗してしまいました。

```bash
Expected: _$TodoDataImpl:<Todo(description: buy, id: 1, completed: false)>
  Actual: _$TodoDataImpl:<Todo(description: buy, id: 4cb80956-05c7-436f-a916-dde353e7a678, completed: false)>

package:matcher                                     expect
package:flutter_test/src/widget_tester.dart 480:18  expect
test/todo_test.dart 32:7                            main.<fn>.<fn>
```

IDはUUIDパッケージによって生成されます。ここをモックできるよう、ProviderでDIするように変更します。

### UUIDのモック

モックのために、mocktailパッケージを追加します。

```bash
flutter pub add mocktail
```

`uuidProvider`を追加し、addメソッドではRiverpod経由でUUIDを取得するように変更します。

```dart
final uuidProvider = Provider((_) => Uuid());
```

```dart
void add(String description) {
    state = [
      ...state,
      Todo(
        // riverpod経由でUUIDを取得
        id: ref.read(uuidProvider).v4(),
        description: description,
      ),
    ];
  }
```

これでUUIDをモックする準備が整いました。
テストコードを以下のように変更します。

```dart
// UUIDのモッククラス
class MockUuid extends Mock implements Uuid {}

void main() {
  ...
  group(TodoList, () {
    test('Todoを追加できる', () {
      // --- 変更 ---
      final uuid = MockUuid();
      final container = ProviderContainer(overrides: [
        uuidProvider.overrideWithValue(uuid),
      ]);
      when(() => uuid.v4()).thenReturn('1');
      // --- 変更 ---
...
      expect(subscription.read().last, Todo(description: 'buy', id: '1'));
    });
  });
}
```

これで、テストを実行してみましょう。

```bash
✓ TodoList Todoを追加できる

Exited.
```

成功しました! :tada: :tada:
TodoListは以下の図の依存関係になっています。

```mermaid
graph TD;

  TodoList --> Uuid
```

テストでは、ProviderContainerによってUuidをモックに差し替えています。

```mermaid
graph TD;

subgraph アプリ
  ProviderContainer --> UuidProvider
  ProviderContainer --> TodoListProvider
  UuidProvider --> Uuid
  TodoListProvider --> TodoList
end

subgraph テスト
  ProviderContainer --> uuidProvider.overrideWithValue
  uuidProvider.overrideWithValue --> MockUuid
end
```

### AAAパターン

作成したテストをもう一度見てみましょう。
3つのパートに分けてテストを記述しています。

```dart
  group(TodoList, () {
    test('Todoを追加できる', () {
      // Arrange
      final uuid = MockUuid();
      final container = ProviderContainer(overrides: [
        uuidProvider.overrideWithValue(uuid),
      ]);
      when(() => uuid.v4()).thenReturn('1');
      final subscription = container.listen(todoListProvider, (_, __) {});
      final todoList = container.read(todoListProvider.notifier);

      // Act
      todoList.add('buy');

      // Assert
      expect(subscription.read().last, Todo(description: 'buy', id: '1'));
    });
  });
```

Arrange-Act-Assertに分けてテストを書くことをAAAパターンと呼びます。
AAAパターンに従うことで、テストの可読性が向上し、テストの目的が明確になります。

## Verify

`expect`は、テストの結果を直接比較していました。
テストの結果を間接的に検証する方法として、`verify`があります。

FirebaseEventのようなイベントトラッカーを追加して、テストの追加イベントが発生することを検証してみましょう。
簡単にするため、ダミーのイベントを発生させるクラスにします。

新しい実装なのでテストファーストで書いてみましょう。
'Todoを追加する'テストに追記します。

```dart
      test('Todoを追加できる', () {
      final uuid = MockUuid();
      final eventTracker = MockEventTracker(); // 追加
      final container = ProviderContainer(overrides: [
        uuidProvider.overrideWithValue(uuid),
        eventTrackerProvider.overrideWithValue(eventTracker), // 追加
      ]);
      when(() => uuid.v4()).thenReturn('1');
      final subscription = container.listen(todoListProvider, (_, __) {});
      final todoList = container.read(todoListProvider.notifier);

      todoList.add('buy');

      expect(subscription.read().last, Todo(description: 'buy', id: '1'));
      verify(() => eventTracker.trackAddTodo('buy')).called(1); // 追加
    });
...

class MockEventTracker extends Mock implements EventTracker {} // 追加
```

もちろんEvenTrackerがないのでコンパイルエラーになります。
eventTrackerProviderを追加して、EventTrackerを追加します。

```dart
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final eventTrackerProvider = Provider((_) => EventTracker());

class EventTracker {
  void trackAddTodo(String description) {
    debugPrint('trackAddTodo: $description');
  }
}
```

テストからインポートを追加します。
これでコンパイルが通りました。テストを実行してみましょう。

```bash
No matching calls (actually, no calls at all).
(If you called `verify(...).called(0);`, please instead use `verifyNever(...);`.)
package:matcher                            fail
package:mocktail/src/mocktail.dart 728:7   _VerifyCall._checkWith
package:mocktail/src/mocktail.dart 519:18  _makeVerify.<fn>
test/todo_test.dart 33:13                  main.<fn>.<fn>
```

テストが失敗しました。
`trackAddTodo`メソッドが呼ばれていないことが検証されています。
`add`メソッドを読んだら、`trackAddTodo`メソッドが呼ばれるように実装します。

```dart
  void add(String description) {
    state = [
      ...state,
      Todo(
        id: ref.read(uuidProvider).v4(),
        description: description,
      ),
    ];
    ref.read(eventTrackerProvider).trackAddTodo(description); // 追加
  }
```

これでテストを実行してみましょう。

```bash
✓ 同じ引数のToDoクラスは等しい
✓ TodoList Todoを追加できる

Exited.
```

成功しました! :tada: :tada: :tada:
このように、呼ばれていることだけを検証したい場合は`verify`を使います。
