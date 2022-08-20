class FindPraiseUsersDto {
  FindPraiseUsersDto({
    required this.praisedDto,
    required this.praiserDto,
  });

  final PraisedDto praisedDto;
  final PraiserDto praiserDto;
}

class PraiserDto {
  PraiserDto({
    required this.tag,
    required this.communities,
  });
  final String tag;
  final List<String> communities;
}

class PraisedDto {
  PraisedDto({
    required this.tag,
    required this.communities,
  });
  final String tag;
  final List<String> communities;
}
