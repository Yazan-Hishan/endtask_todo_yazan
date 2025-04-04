import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/todo_controller.dart';
import '../utils/theme_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.lazyPut<TodoController>(() => TodoController(), fenix: true);

    // لا تنشئ مثيلاً جديداً إذا كان موجوداً بالفعل
    if (!Get.isRegistered<ThemeService>()) {
      Get.lazyPut<ThemeService>(() => ThemeService(), fenix: true);
    }
  }
}
