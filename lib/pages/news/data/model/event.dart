class Event {
  final int eventId;
  final String provider;

  Event({required this.eventId, required this.provider});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json["event_id"] ?? 0,
      provider: json["provider"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"event_id": eventId, "provider": provider};
  }
}
