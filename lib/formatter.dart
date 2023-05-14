import 'package:sublan/model.dart';

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
}

List<Transcript> fromTranscribeArrrJsonToTranscribeList(
    List<dynamic> transcripts) {
  List<Transcript> result = [];
  for (var i = 0; i < transcripts.length; i++) {
    result.add(Transcript.fromJson(transcripts[i]));
  }
  return result;
}

String fromTranscriptArrToString(List<Transcript> transcripts) {
  String result = '';
  for (var i = 0; i < transcripts.length; i++) {
    result +=
        '${i + 1}\n${transcripts[i].startAt} --> ${transcripts[i].endAt}\n${transcripts[i].text}\n';
  }
  return result;
}
