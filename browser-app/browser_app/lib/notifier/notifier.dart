// StateNotifier to manage the loading percentage of the WebView
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchNotifier extends StateNotifier<String> {
  SearchNotifier() : super('');

  void updateQuery(String query) {
    state = query;
  }

  void clearQuery() {
    state = '';
  }

  bool isUrl() {
    return Uri.tryParse(state)?.isAbsolute ?? false;
  }
}
