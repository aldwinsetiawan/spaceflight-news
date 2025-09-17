import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/news_repository.dart';

import '../../data/model/news.dart';
part 'news_list_state.dart';
part 'news_list_event.dart';

class NewsListBloc extends Bloc<NewslistEvent, NewsListState> {
  final NewsRepository _repo = NewsRepository();

  NewsListBloc(NewsListState initialState) : super(initialState) {
    on<FetchNews>(_fetchNews);
  }

  _fetchNews(FetchNews event, Emitter<NewsListState> emit) async {
    if (state.isLoading) return;
    if(event.refresh) {
      emit(state.copyWith(isLoading: true, newsList: [], hasNext: false));
    }
    else {
      emit(state.copyWith(isLoading: true));
    }

    try {
      Map<String, dynamic> response = await _repo.fetchNews(
        state.hasNext && !event.refresh ? state.nextURL : null,
      );
      
      state.newsList.addAll(response['result']);
      emit(state.copyWith(newsList: state.newsList, nextURL: response['hasNext'], hasNext: response['hasNext'] != null ? true : false, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
