import '../../pages/news/data/model/author.dart';

String formatAuthors(List<Author> authors, {bool fullList = false}) {
  if (authors.isEmpty) return "Unknown";
  if (fullList) {
    return authors.map((a) => a.name).join(", ");
  }
  if (authors.length > 1) {
    return "${authors.first.name} and ${authors.length - 1} others";
  } else {
    return authors.first.name;
  }
}
