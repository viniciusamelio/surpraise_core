import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

class LeaveCommunityInput extends Equatable {
  const LeaveCommunityInput({
    required this.memberId,
    required this.communityId,
    required this.memberRole,
  });
  final String memberId;
  final String communityId;
  final String memberRole;

  @override
  List<Object?> get props => [memberId, communityId, memberRole];
}

class LeaveCommunityOutput {
  const LeaveCommunityOutput(this.communityId);
  final String message = "Community left successfully";
  final String communityId;
}

class CommunityDetailsOutput {
  const CommunityDetailsOutput({
    required this.membersCount,
    required this.ownerId,
  });
  final int membersCount;
  final String ownerId;
}
