import 'package:bizorda/token_notifier.dart';
import 'package:get_it/get_it.dart';
import 'features/shared/data/repos/review_repo.dart';
import 'features/shared/services/review_service.dart';

final getIt = GetIt.instance;

final baseUrl = 'https://enterra-api.onrender.com';
final token = tokenNotifier.value;

void setupLocator() {
  getIt.registerLazySingleton<ReviewRepository>(
        () => ReviewRepository(
      baseUrl: baseUrl,
      authToken: token, // можно будет обновлять при логине
    ),
  );
  getIt.registerLazySingleton<ReviewService>(
        () => ReviewService(getIt<ReviewRepository>()),
  );
}
