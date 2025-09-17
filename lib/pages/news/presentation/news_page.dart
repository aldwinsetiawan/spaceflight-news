import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bookmark_bloc/bookmark_bloc.dart';
import '../bloc/news_list_bloc/news_list_bloc.dart';
import 'bookmark_page.dart';
import 'news_list_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              NewsListBloc(NewsListState(newsList: []))..add(FetchNews()),
        ),
        BlocProvider(
          create: (context) =>
              BookmarkBloc(BookmarkState(bookmarks: [], bookmarksOriginal: []))
                ..add(LoadBookmarks()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("News"),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "News List"),
              Tab(text: "Bookmarks"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [NewsListPage(), BookmarkPage()],
        ),
        floatingActionButton: _tabController.index == 1
            ? BlocBuilder<BookmarkBloc, BookmarkState>(
                builder: (context, state) {
                  late String imageURL;
                  switch (state.sortOrder) {
                    case SortOrder.normal:
                      imageURL = 'assets/sort.png';
                      break;
                    case SortOrder.asc:
                      imageURL = 'assets/sort-up.png';
                      break;
                    case SortOrder.desc:
                      imageURL = 'assets/sort-down.png';
                      break;
                  }
                  return FloatingActionButton(
                    onPressed: () {
                      context.read<BookmarkBloc>().add(SortBookmark());
                    },
                    child: Image.asset(
                      imageURL,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }
}
