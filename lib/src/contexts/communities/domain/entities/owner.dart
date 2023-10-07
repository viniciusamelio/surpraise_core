import '../../../../core/entities/base_entity.dart';
import '../../../../core/exceptions/domain_exception.dart';
import '../../../../core/value_objects/id.dart';
import 'community.dart';

class Owner implements Entity {
  Owner({
    required this.id,
    required List<Community> communities,
  }) : _communities = communities;

  final Id id;
  final List<Community> _communities;

  List<Community> get communities => _communities;

  void createCommunity(Community community) {
    _communities.add(community);
  }

  void deleteCommunity(Community communityToBeRemoved) {
    if (communityToBeRemoved.members.length > 1) {
      throw DomainException(
        "A community can only be removed when there are no more members",
      );
    }
    _communities.removeWhere(
      (community) => community.id == communityToBeRemoved.id,
    );
  }
}
