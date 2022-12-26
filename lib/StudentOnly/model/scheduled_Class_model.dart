import 'package:flutter/foundation.dart';

class ScheduledClasses {
  final String topic;
  final DateTime startedAt;
  final int duration;
  bool hasAttended;
  final String lectureUrl;

  ScheduledClasses(
      {@required this.topic,
      @required this.startedAt,
      @required this.duration,
      @required this.lectureUrl,
      this.hasAttended = false});
}
