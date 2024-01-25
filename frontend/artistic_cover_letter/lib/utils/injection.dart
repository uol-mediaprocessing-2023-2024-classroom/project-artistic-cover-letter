import 'package:artistic_cover_letter/services/image_cache_service.dart';
import 'package:artistic_cover_letter/services/image_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => ImageCacheService());
  getIt.registerLazySingleton(() => ImageService());
}
