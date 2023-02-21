class AddMembersInput {
  AddMembersInput({
    required this.idCommunity,
    required this.members,
  });

  final String idCommunity;
  final List<MemberToAdd> members;
}

class MemberToAdd {
  MemberToAdd({
    required this.idMember,
    required this.role,
  });

  final String idMember;
  final String role;
}

class AddMembersOutput {
  String message = "Member(s) added successfully";
}
