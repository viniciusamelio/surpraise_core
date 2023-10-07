import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/exceptions/domain_exception.dart';
import '../entities/community.dart';

abstract class IDeleteCommunityService {
  Either<DomainException, void> call(
    Community community,
  );
}
