import 'package:surpraise_core/src/contexts/praises/domain/entities/user.dart';
import 'package:surpraise_core/src/contexts/praises/domain/value_objects/message.dart';
import 'package:surpraise_core/src/contexts/praises/domain/value_objects/topic.dart';
import 'package:surpraise_core/src/core/models/domain_model.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

class Praise implements DomainModel {
  const Praise({
    required this.id,
    required this.communityId,
    required this.praised,
    required this.praiser,
    required this.time,
    required this.message,
    required this.topic,
  });

  final Id id;
  final Id communityId;
  final User praised;
  final User praiser;
  final DateTime time;
  final Message message;
  final Topic topic;
}
