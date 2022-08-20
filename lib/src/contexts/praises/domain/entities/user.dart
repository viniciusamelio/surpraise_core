import 'package:surpraise_core/src/contexts/praises/domain/models/praise.dart';
import 'package:surpraise_core/src/contexts/praises/domain/value_objects/message.dart';
import 'package:surpraise_core/src/contexts/praises/domain/value_objects/tag.dart';
import 'package:surpraise_core/src/contexts/praises/domain/value_objects/topic.dart';
import 'package:surpraise_core/src/core/entities/base_entity.dart';
import 'package:surpraise_core/src/core/exceptions/exceptions.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

class User implements Entity {
  User({
    required this.tag,
    required this.communities,
  });

  final Tag tag;
  final List<Id> communities;

  Praise praise({
    required User praised,
    required Message message,
    required Topic topic,
    required Id communityId,
    required Id id,
  }) {
    if (!communities.contains(communityId) ||
        !praised.communities.contains(communityId)) {
      throw DomainException(
        "You can only praise users that are in the same community you are",
      );
    }
    return Praise(
      id: id,
      communityId: communityId,
      praised: praised,
      praiser: this,
      time: DateTime.now(),
      message: message,
      topic: topic,
    );
  }
}
