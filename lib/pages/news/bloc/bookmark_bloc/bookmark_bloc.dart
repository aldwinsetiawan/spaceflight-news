import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/app_export.dart';

import '../../data/model/news.dart';
part 'bookmark_event.dart';
part 'bookmark_state.dart';

enum SortOrder { asc, desc, normal }

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc(BookmarkState initialState) : super(initialState) {
    on<ToggleBookmark>(_toggleBookmark);
    on<LoadBookmarks>(_loadBookmarks);
    on<EditBookmark>(_editBookmark);
    on<SortBookmark>(_sortBookmark);
  }

  _toggleBookmark(ToggleBookmark event, Emitter<BookmarkState> emit) async {
    if (state.isLoading) return;
    try {
      emit(state.copyWith(isLoading: true));
      List<News> currentData = List.from(state.bookmarksOriginal);
      if (currentData.any((n) => n.id == event.news.id)) {
        currentData.removeWhere((n) => n.id == event.news.id);
      } else {
        currentData.add(event.news);
      }
      await PrefUtils().setBookmark(currentData);
      final List<News> sorted = _sortNews(currentData, state.sortOrder);
      emit(
        state.copyWith(
          bookmarks: sorted,
          bookmarksOriginal: currentData,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  _loadBookmarks(LoadBookmarks event, Emitter<BookmarkState> emit) async {
    if (state.isLoading) return;
    try {
      emit(state.copyWith(isLoading: true));
      List<News> bookmarkData = await PrefUtils().getBookmarkData();
      emit(
        state.copyWith(
          bookmarks: bookmarkData,
          bookmarksOriginal: bookmarkData,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  _editBookmark(EditBookmark event, Emitter<BookmarkState> emit) async {
    if (state.isLoading) return;
    try {
      emit(state.copyWith(isLoading: true));
      final List<News> updatedBookmarks = state.bookmarksOriginal.map((
        bookmark,
      ) {
        if (bookmark.id == event.news.id) {
          return bookmark.copyWith(title: event.title, summary: event.summary);
        }
        return bookmark;
      }).toList();
      await PrefUtils().setBookmark(updatedBookmarks);
      final List<News> sorted = _sortNews(updatedBookmarks, state.sortOrder);
      emit(
        state.copyWith(
          bookmarks: sorted,
          bookmarksOriginal: updatedBookmarks,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  _sortBookmark(SortBookmark event, Emitter<BookmarkState> emit) async {
    SortOrder sortOrder;

    switch (state.sortOrder) {
      case SortOrder.normal:
        sortOrder = SortOrder.asc;
        break;
      case SortOrder.asc:
        sortOrder = SortOrder.desc;
        break;
      case SortOrder.desc:
        sortOrder = SortOrder.normal;
        break;
    }
    final List<News> sorted = _sortNews(state.bookmarksOriginal, sortOrder);
    emit(state.copyWith(bookmarks: sorted, sortOrder: sortOrder));
  }

  _sortNews(List<News> news, SortOrder sortOrder) {
    if (sortOrder == SortOrder.normal) {
      return List<News>.from(news);
    } else if (sortOrder == SortOrder.asc) {
      return List<News>.from(news)..sort((a, b) => a.title.compareTo(b.title));
    } else {
      return List<News>.from(news)..sort((a, b) => b.title.compareTo(a.title));
    }
  }
}
