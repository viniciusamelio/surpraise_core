import '../../../../core/models/domain_model.dart';
import '../../../../core/value_objects/id.dart';
import '../entities/user.dart';
import '../value_objects/message.dart';
import '../value_objects/topic.dart';

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
