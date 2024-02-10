import 'dart:convert';

List<RealtimeData> realtimeDataFromJson(String str) => List<RealtimeData>.from(json.decode(str).map((x) => RealtimeData.fromJson(x)));

String realtimeDataToJson(List<RealtimeData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RealtimeData {
    final DateTime date;
    final int driverNumber;
    final double gapToLeader;
    final double interval;
    final int meetingKey;
    final int sessionKey;

    RealtimeData({
        required this.date,
        required this.driverNumber,
        required this.gapToLeader,
        required this.interval,
        required this.meetingKey,
        required this.sessionKey,
    });

    factory RealtimeData.fromJson(Map<String, dynamic> json) => RealtimeData(
        date: DateTime.parse(json["date"]),
        driverNumber: json["driver_number"],
        gapToLeader: json["gap_to_leader"].toDouble(),
        interval: json["interval"].toDouble(),
        meetingKey: json["meeting_key"],
        sessionKey: json["session_key"],
    );

    Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "driver_number": driverNumber,
        "gap_to_leader": gapToLeader,
        "interval": interval,
        "meeting_key": meetingKey,
        "session_key": sessionKey,
    };
}