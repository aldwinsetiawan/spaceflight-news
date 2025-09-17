part of 'bookmark_bloc.dart';

class BookmarkState extends Equatable {
  const BookmarkState({
    required this.bookmarks,
    this.sortOrder = SortOrder.normal,
    required this.bookmarksOriginal,
    this.error,
    this.isLoading = false,
  });

  final List<News> bookmarks;
  final List<News> bookmarksOriginal;
  final SortOrder sortOrder;
  final String? error;
  final bool isLoading;

  @override
  List<Object?> get props => [
    bookmarks,
    sortOrder,
    bookmarksOriginal,
    isLoading,
    error,
  ];

  BookmarkState copyWith({
    List<News>? bookmarks,
    SortOrder? sortOrder,
    List<News>? bookmarksOriginal,
    String? error,
    bool? isLoading,
  }) {
    return BookmarkState(
      bookmarks: bookmarks ?? this.bookmarks,
      sortOrder: sortOrder ?? this.sortOrder,
      bookmarksOriginal: bookmarksOriginal ?? this.bookmarksOriginal,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
