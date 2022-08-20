import '../../../../core/value_objects/id.dart';

List<Id> mapCommunityIdsFromStringList(List<String> ids) =>
    ids.map<Id>((e) => Id(e)).toList();
