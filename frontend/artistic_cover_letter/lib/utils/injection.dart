import 'package:artistic_cover_letter/repositories/app_repository.dart';
import 'package:artistic_cover_letter/repositories/images_repository.dart';
import 'package:artistic_cover_letter/services/auth_service.dart';
import 'package:artistic_cover_letter/repositories/client_repository.dart';
import 'package:artistic_cover_letter/services/album_service.dart';
import 'package:artistic_cover_letter/services/collage_service.dart';
import 'package:artistic_cover_letter/services/loading_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<ClientRepository>(() => ClientRepository());
  getIt.registerLazySingleton<ImagesRepository>(() => ImagesRepository());
  getIt.registerLazySingleton<LoadingService>(() => LoadingService());
  getIt.registerLazySingleton<CollageService>(() => CollageService());
  getIt.registerLazySingleton<AlbumService>(() => AlbumService());
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<AppRepository>(() => AppRepository());
}
