// Provider for WebView state
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/notifier.dart';

final searchProvider = StateNotifierProvider<SearchNotifier, String>((ref) {
  return SearchNotifier();
});
