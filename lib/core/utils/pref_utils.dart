import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaceflight_news/pages/news/data/model/news.dart';

class PrefUtils {
  late final SharedPreferencesAsync _prefs;

  PrefUtils() {
    _prefs = SharedPreferencesAsync();
  }

  Future<void> init() async {
    debugPrint('SharedPreference Initialized');
  }

  // void clearPreferencesData() async {
  //   _sharedPreferences!.clear();
  // }

  Future<void> setBookmark(List<News> newsList) async {
    try {
      final List<String> jsonList = newsList
          .map((data) => jsonEncode(data.toJson()))
          .toList();
      await _prefs.setStringList('bookmarks', jsonList);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Failed to write bookmark data");
    }
  }

  Future<List<News>> getBookmarkData() async {
    try {
      final List<String>? listData = await _prefs.getStringList('bookmarks');
      if (listData == null) return [];
      return listData.map((json) {
        News item = News.fromJson(jsonDecode(json));
        return item;
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Failed to read bookmark data");
    }
  }
}
