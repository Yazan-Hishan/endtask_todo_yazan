import 'package:get/get.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/add_todo_screen.dart';
import '../screens/todo_detail_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/user_info_screen.dart';
import '../screens/change_password_screen.dart';
import '../bindings/app_bindings.dart';
import '../models/todo.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.ADD_TODO,
      page: () => const AddTodoScreen(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.TODO_DETAIL,
      page: () => TodoDetailScreen(todo: Get.arguments as Todo),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.USER_INFO,
      page: () => const UserInfoScreen(),
      binding: AppBindings(),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => const ChangePasswordScreen(),
      binding: AppBindings(),
    ),
  ];
}
