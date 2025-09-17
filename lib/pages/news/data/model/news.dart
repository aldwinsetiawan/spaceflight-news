import 'package:equatable/equatable.dart';

import 'author.dart';
import 'event.dart';
import 'launch.dart';

// ignore: must_be_immutable
class News extends Equatable {
  final int id;
  final String title;
  final List<Author> authors;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final DateTime publishedAt;
  final DateTime updatedAt;
  final bool featured;
  final List<Launch> launches;
  final List<Event> events;

  News({
    required this.id,
    required this.title,
    required this.authors,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
    required this.updatedAt,
    required this.featured,
    required this.launches,
    required this.events,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      authors:
          (json["authors"] as List<dynamic>?)
              ?.map((e) => Author.fromJson(e))
              .toList() ??
          [],
      url: json["url"] ?? "",
      imageUrl: json["image_url"] ?? "",
      newsSite: json["news_site"] ?? "",
      summary: json["summary"] ?? "",
      publishedAt: DateTime.parse(json["published_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      featured: json["featured"] is bool
          ? json["featured"]
          : json["featured"].toString().toLowerCase() == "true",
      launches:
          (json["launches"] as List<dynamic>?)
              ?.map((e) => Launch.fromJson(e))
              .toList() ??
          [],
      events:
          (json["events"] as List<dynamic>?)
              ?.map((e) => Event.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "authors": authors.map((e) => e.toJson()).toList(),
      "url": url,
      "image_url": imageUrl,
      "news_site": newsSite,
      "summary": summary,
      "published_at": publishedAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "featured": featured,
      "launches": launches.map((e) => e.toJson()).toList(),
      "events": events.map((e) => e.toJson()).toList(),
    };
  }

  News copyWith({String? title, String? summary}) {
    return News(
      id: id,
      title: title ?? this.title,
      authors: authors,
      url: url,
      imageUrl: imageUrl,
      newsSite: newsSite,
      summary: summary ?? this.summary,
      publishedAt: publishedAt,
      updatedAt: updatedAt,
      featured: featured,
      launches: launches,
      events: events,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    authors,
    url,
    imageUrl,
    newsSite,
    summary,
    publishedAt,
    updatedAt,
    featured,
    launches,
    events,
  ];
}
