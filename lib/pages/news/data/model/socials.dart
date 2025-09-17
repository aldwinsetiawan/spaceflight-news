class Socials {
  final String x;
  final String youtube;
  final String instagram;
  final String linkedin;
  final String mastodon;
  final String bluesky;

  Socials({
    required this.x,
    required this.youtube,
    required this.instagram,
    required this.linkedin,
    required this.mastodon,
    required this.bluesky,
  });

  factory Socials.fromJson(Map<String, dynamic> json) {
    return Socials(
      x: json["x"] ?? "",
      youtube: json["youtube"] ?? "",
      instagram: json["instagram"] ?? "",
      linkedin: json["linkedin"] ?? "",
      mastodon: json["mastodon"] ?? "",
      bluesky: json["bluesky"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "x": x,
      "youtube": youtube,
      "instagram": instagram,
      "linkedin": linkedin,
      "mastodon": mastodon,
      "bluesky": bluesky,
    };
  }
}
