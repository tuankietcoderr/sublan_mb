import 'package:sublan/formatter.dart';

class Transcript {
  final double startAt;
  final double endAt;
  final String text;

  Transcript(this.startAt, this.endAt, this.text);

  factory Transcript.fromJson(Map<String, dynamic> json) {
    return Transcript(
      json['start_at'],
      json['end_at'],
      json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_at': startAt,
      'end_at': endAt,
      'text': text,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return "${formatTime(Duration(seconds: startAt.toInt()))} --> ${formatTime(Duration(seconds: endAt.toInt()))}\n$text\n";
  }
}
