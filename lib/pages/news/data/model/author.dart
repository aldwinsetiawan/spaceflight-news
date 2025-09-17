import 'socials.dart';

class Author {
  final String name;
  final Socials? socials;

  Author({required this.name, required this.socials});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json["name"] ?? "",
      socials: json["socials"] == null
          ? null
          : Socials.fromJson(json["socials"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "socials": socials?.toJson()};
  }
}
