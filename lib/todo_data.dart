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
