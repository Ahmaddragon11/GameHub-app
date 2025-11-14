import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/database_service.dart';
import '../../core/services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // StorageService should be first as other services might depend on it.
    await Get.putAsync<StorageService>(
      () async {
        final service = StorageService();
        await service.init();
        return service;
      },
      permanent: true,
    );

    // DatabaseService depends on StorageService.
    await Get.putAsync<DatabaseService>(
      () async {
        final service = DatabaseService();
        await service.init();
        return service;
      },
      permanent: true,
    );

    // AuthService depends on both StorageService and DatabaseService.
    await Get.putAsync<AuthService>(
      () async {
        final service = AuthService();
        await service.init();
        return service;
      },
      permanent: true,
    );
  }
}
