import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spaceflight_news/pages/news/bloc/news_list_bloc/news_list_bloc.dart';
import 'package:spaceflight_news/pages/news/presentation/news_detail_page.dart';

import '../../../core/utils/common_utils.dart';
import '../bloc/bookmark_bloc/bookmark_bloc.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewsListBloc, NewsListState>(
      listenWhen: (previous, current) {
        return current.error != null && current.newsList.isNotEmpty;
      },
      listener: (context, state) {
        final snackBar = SnackBar(content: Text(state.error!));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: BlocBuilder<NewsListBloc, NewsListState>(
        buildWhen: (previous, current) {
          return previous.newsList != current.newsList ||
              previous.newsList.isEmpty == current.newsList.isEmpty;
        },
        builder: (context, state) {
          if (state.error != null && state.newsList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Failed to load news.\n${state.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NewsListBloc>().add(FetchNews());
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<NewsListBloc>().add(FetchNews(refresh: true));
            },
            child: Skeletonizer(
              ignoreContainers: true,
              enabled: state.isLoading && state.newsList.isEmpty,
              child: ListView.builder(
                key: const PageStorageKey('lastScrollPos'),
                itemCount: state.hasNext
                    ? state.newsList.length + 1
                    : state.newsList.isNotEmpty
                    ? state.newsList.length
                    : 5,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (state.newsList.isEmpty ||
                      index >= state.newsList.length) {
                    return Skeletonizer(
                      ignoreContainers: true,
                      child: Card(
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                            ),
                          ),
                          title: Text("Placeholder"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Placeholder"),
                              Text("Placeholder"),
                            ],
                          ),
                          trailing: Icon(Icons.bookmark_border),
                        ),
                      ),
                    );
                  }
                  final news = state.newsList[index];
                  final isBookmarked = context
                      .watch<BookmarkBloc>()
                      .state
                      .bookmarks
                      .any((n) => n.id == news.id);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          news.imageUrl,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                          errorBuilder:
                              (
                                BuildContext context,
                                Object exception,
                                StackTrace? stackTrace,
                              ) {
                                return Container(
                                  height: 60,
                                  width: 60,
                                  color: Colors.grey,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.white70,
                                    ),
                                  ),
                                );
                              },
                        ),
                      ),
                      title: Text(
                        news.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${formatAuthors(news.authors)} - ${news.publishedAt.toLocal().toString().split(' ').first}",
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            news.newsSite,
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.amber : null,
                        ),
                        onPressed: () {
                          context.read<BookmarkBloc>().add(
                            ToggleBookmark(news),
                          );
                        },
                      ),
                      onTap: () {
                        final bookmarkBloc = context.read<BookmarkBloc>();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: bookmarkBloc,
                              child: NewsDetailPage(news: news),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<NewsListBloc>().add(FetchNews());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
