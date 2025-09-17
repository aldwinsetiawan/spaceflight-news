import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaceflight_news/core/utils/common_utils.dart';

import '../bloc/bookmark_bloc/bookmark_bloc.dart';
import 'news_detail_page.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookmarkBloc, BookmarkState>(
      listenWhen: (previous, current) {
        return current.error != null;
      },
      listener: (context, state) {
        final snackBar = SnackBar(content: Text(state.error!));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: BlocBuilder<BookmarkBloc, BookmarkState>(
        buildWhen: (previous, current) {
          return previous.bookmarks != current.bookmarks;
        },
        builder: (context, state) {
          if (state.bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No bookmarks yet",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            key: const PageStorageKey('lastScrollPosBookmark'),
            itemCount: state.bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = state.bookmarks[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      bookmark.imageUrl,
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
                                  size: 50,
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          },
                    ),
                  ),
                  title: Text(
                    bookmark.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${formatAuthors(bookmark.authors, fullList: true)} - ${bookmark.publishedAt.toLocal().toString().split(' ').first}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        bookmark.newsSite,
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 35,
                        child: IconButton(
                          constraints: BoxConstraints(),
                          icon: Icon(Icons.mode_edit),
                          onPressed: () {
                            final bookmarkBloc = context.read<BookmarkBloc>();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: bookmarkBloc,
                                  child: NewsDetailPage(
                                    news: bookmark,
                                    editFlag: true,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 35,
                        child: IconButton(
                          constraints: BoxConstraints(),
                          icon: Icon(Icons.bookmark, color: Colors.amber),
                          onPressed: () {
                            context.read<BookmarkBloc>().add(
                              ToggleBookmark(bookmark),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    final bookmarkBloc = context.read<BookmarkBloc>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: bookmarkBloc,
                          child: NewsDetailPage(news: bookmark),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
