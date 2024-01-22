class PraiseInput {
  PraiseInput({
    required this.commmunityId,
    required this.message,
    required this.praisedId,
    required this.praiserId,
    required this.topic,
    this.private = false,
    this.extraPraisedIds = const [],
  });

  final String commmunityId;
  final String praiserId;
  final String praisedId;
  final String topic;
  final String message;
  final bool private;
  final List<String> extraPraisedIds;
  late String id;
}

class PraiseOutput {
  const PraiseOutput([this.praiseData]);
  final String message = "Praise sent successfully";
  final Map<String, dynamic>? praiseData;
}
