import 'package:get/get.dart';
import '../../core/services/database_service.dart';
import '../../core/services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Use putAsync for services that need asynchronous initialization
    Get.putAsync<DatabaseService>(
      () async {
        final service = DatabaseService();
        await service.init();
        return service;
      },
      permanent: true, // Make it permanent so it's available throughout the app
    );

    // Use put for services that can be initialized synchronously
    Get.putAsync<StorageService>(
       () async {
        final service = StorageService();
        await service.init();
        return service;
      },
      permanent: true,
    );

    // You can add other core services here, e.g., an AuthenticationService
    // Get.lazyPut<AuthenticationService>(() => AuthenticationService(), fenix: true);
  }
}
