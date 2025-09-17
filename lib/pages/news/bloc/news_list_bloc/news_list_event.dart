part of 'news_list_bloc.dart';

abstract class NewslistEvent {}

class FetchNews extends NewslistEvent {
  final bool refresh;
  FetchNews({this.refresh = false});
}