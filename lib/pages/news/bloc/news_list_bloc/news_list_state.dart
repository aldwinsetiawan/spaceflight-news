part of 'news_list_bloc.dart';

class NewsListState extends Equatable {
  NewsListState({required this.newsList, this.nextURL = "", this.hasNext = false, this.isLoading = false, this.error});

  final List<News> newsList;
  final String? nextURL;
  final bool hasNext;
  final bool isLoading;
  final String? error;

  @override
  List<Object?> get props => [
    newsList,
    nextURL,
    hasNext,
    isLoading,
    error
  ];

  NewsListState copyWith({List<News>? newsList, String? nextURL, bool? hasNext, bool? isLoading, String? error}) {
    return NewsListState(
      newsList: newsList ?? this.newsList,
      nextURL: nextURL ?? this.nextURL,
      hasNext: hasNext ?? this.hasNext,
      isLoading: isLoading ?? this.isLoading,
      error: error
    );
  }
}
