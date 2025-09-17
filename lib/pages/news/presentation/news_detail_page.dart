import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/common_utils.dart';
import '../bloc/bookmark_bloc/bookmark_bloc.dart';
import '../data/model/news.dart';

class NewsDetailPage extends StatelessWidget {
  final News news;
  final bool editFlag;

  const NewsDetailPage({super.key, required this.news, this.editFlag = false});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(
      text: news.title,
    );
    final TextEditingController summaryController = TextEditingController(
      text: news.summary,
    );
    return BlocListener<BookmarkBloc, BookmarkState>(
      listenWhen: (previous, current) {
        return (previous.bookmarks != current.bookmarks) &&
            (previous.bookmarks.length == current.bookmarks.length);
      },
      listener: (context, state) {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("News Detail"),
          actions: editFlag
              ? null
              : [
                  BlocBuilder<BookmarkBloc, BookmarkState>(
                    builder: (context, state) {
                      final isBookmarked = state.bookmarks.any(
                        (bookmark) => bookmark.id == news.id,
                      );

                      return IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.amber : null,
                        ),
                        onPressed: () {
                          context.read<BookmarkBloc>().add(
                            ToggleBookmark(news),
                          );
                        },
                      );
                    },
                  ),
                ],
        ),
        bottomNavigationBar: !editFlag
            ? null
            : SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          child: Text(
                            'SAVE',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          onPressed: () {
                            context.read<BookmarkBloc>().add(
                              EditBookmark(
                                news,
                                titleController.text,
                                summaryController.text,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  news.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorBuilder:
                      (
                        BuildContext context,
                        Object exception,
                        StackTrace? stackTrace,
                      ) {
                        return Container(
                          height: 200,
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
              const SizedBox(height: 16),

              editFlag
                  ? TextField(controller: titleController)
                  : Text(
                      news.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const SizedBox(height: 8),

              Text(
                "By ${formatAuthors(news.authors, fullList: true)}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Published: ${news.publishedAt.toLocal().toString().split(' ').first}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),

              Text(
                "Source: ${news.newsSite}",
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              editFlag
                  ? TextField(
                      controller: summaryController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    )
                  : Text(news.summary, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 16),

              editFlag
                  ? SizedBox()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.link),
                      label: Text(
                        "Read Original",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      onPressed: () async {
                        try {
                          final uri = Uri.tryParse(news.url);
                          if (uri == null) {
                            throw Exception('Invalid url');
                          }

                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            throw Exception("Could not launch url");
                          }
                        } catch (e) {
                          final snackBar = SnackBar(
                            content: Text(e.toString()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
