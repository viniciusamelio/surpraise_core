import 'package:surpraise_core/src/contexts/praises/domain/entities/user.dart';
import 'package:surpraise_core/src/contexts/praises/domain/value_objects/message.dart';
import 'package:surpraise_core/src/contexts/praises/domain/value_objects/topic.dart';
import 'package:surpraise_core/src/core/models/domain_model.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

class Praise implements DomainModel {
  Praise({
    required this.id,
    required this.communityId,
    required this.praised,
    required this.praiser,
    required this.time,
    required this.message,
    required this.topic,
  });

  Id id;
  Id communityId;
  User praised;
  User praiser;
  DateTime time;
  Message message;
  Topic topic;
}
