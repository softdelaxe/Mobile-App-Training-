// Riverpod Provider
import 'package:riverpod/riverpod.dart';

import 'model/cv_model.dart';
import 'notifier/cv_notifier.dart';

final cvProvider = StateNotifierProvider<CVNotifier, CVModel>((ref) => CVNotifier());