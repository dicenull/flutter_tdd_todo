import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final eventTrackerProvider = Provider((_) => EventTracker());

class EventTracker {
  void trackAddTodo(String description) {
    debugPrint('trackAddTodo: $description');
  }
}
