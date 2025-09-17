class Launch {
  final String launchId;
  final String provider;

  Launch({required this.launchId, required this.provider});

  factory Launch.fromJson(Map<String, dynamic> json) {
    return Launch(
      launchId: json["launch_id"] ?? "",
      provider: json["provider"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"launch_id": launchId, "provider": provider};
  }
}
