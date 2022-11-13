import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/communities/domain/entities/community.dart';
import 'package:surpraise_core/src/core/exceptions/domain_exception.dart';

abstract class IDeleteCommunityService {
  Either<DomainException, void> call(
    Community community,
  );
}
