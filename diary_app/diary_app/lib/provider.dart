import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diary_app/notifier/diary_notifier.dart';

import 'model/diary_entry.dart';

// Provider definition
final diaryProvider = StateNotifierProvider<DiaryNotifier, List<DiaryEntry>>(
  (ref) => DiaryNotifier(),
);
