import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/diary_entry.dart';
class DiaryNotifier extends StateNotifier<List<DiaryEntry>> {
  DiaryNotifier() : super([]) {
    _loadDiaryEntries();
  }

  Future<void> _loadDiaryEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('diaryEntries');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      state = jsonList.map((e) => DiaryEntry.fromJson(e)).toList();
    }
  }

  Future<void> _saveDiaryEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(state.map((e) => e.toJson()).toList());
    await prefs.setString('diaryEntries', jsonString);
  }

  void addDiaryEntry(DiaryEntry entry) {
    state = [...state, entry];
    _saveDiaryEntries();
  }

  void removeDiaryEntry(String id) {
    state = state.where((entry) => entry.id != id).toList();
    _saveDiaryEntries();
  }

  void updateDiaryEntry(DiaryEntry entry) {
    state = state.map((e) => e.id == entry.id ? entry : e).toList();
    _saveDiaryEntries();
  }
}