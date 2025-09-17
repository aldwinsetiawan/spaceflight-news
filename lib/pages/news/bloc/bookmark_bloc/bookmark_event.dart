part of 'bookmark_bloc.dart';

abstract class BookmarkEvent {}

class ToggleBookmark extends BookmarkEvent {
  final News news;
  ToggleBookmark(this.news);
}

class LoadBookmarks extends BookmarkEvent {}

class EditBookmark extends BookmarkEvent {
  final News news;
  final String title;
  final String summary;

  EditBookmark(this.news, this.title, this.summary);
}

class SortBookmark extends BookmarkEvent {}
