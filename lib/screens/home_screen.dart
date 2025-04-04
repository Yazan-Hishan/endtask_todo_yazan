import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/todo_controller.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import '../utils/theme_service.dart';
import '../routes/app_pages.dart';
import 'todo_detail_screen.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TodoController _todoController = Get.find<TodoController>();
  final ThemeService _themeService = Get.find<ThemeService>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = _themeService.rxIsDarkMode.value;
      return Scaffold(
        appBar: AppBar(
          title: const Text('مهامي'),
          centerTitle: true,
          elevation: 0,
          actions: [
            // زر تبديل السمة
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                _themeService.switchTheme();
              },
              tooltip: isDark ? 'وضع النهار' : 'وضع الليل',
            ),
            Obx(() {
              final AuthController _authController = Get.find<AuthController>();
              return IconButton(
                icon: const Icon(Icons.person),
                onPressed: _authController.user != null ? () {
                  Get.toNamed(Routes.USER_INFO);
                } : null,
                tooltip: 'معلومات المستخدم',
              );
            }),
          ],
        ),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Get.theme.colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Get.theme.colorScheme.primary,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'الكل'),
                Tab(text: 'قيد التنفيذ'),
                Tab(text: 'مكتملة'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // عرض جميع المهام
                  Obx(() => _buildTodoList(_todoController.todos)),

                  // عرض المهام غير المكتملة
                  Obx(() => _buildTodoList(_todoController.incompleteTodos)),

                  // عرض المهام المكتملة
                  Obx(() => _buildTodoList(_todoController.completedTodos)),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print("Navigating to AddTodoScreen...");
            Get.to(() => AddTodoScreen());
          },
          icon: const Icon(Icons.add),
          label: const Text('مهمة جديدة'),
          tooltip: 'إضافة مهمة جديدة',
        ),
      );
    });
  }

  Widget _buildTodoList(List<Todo> todos) {
    if (todos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Get.theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد مهام حالياً',
              style: TextStyle(
                fontSize: 18,
                color: Get.theme.textTheme.bodyLarge!.color!.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: todos.length,
      padding: const EdgeInsets.only(bottom: 80),
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: TodoItem(
            todo: todo,
            onTap: () {
              Get.to(() => TodoDetailScreen(todo: todo));
            },
            onToggle: () {
              _todoController.toggleTodoCompletion(todo);
            },
            onDelete: () {
              _todoController.deleteTodo(todo);
            },
          ),
        );
      },
    );
  }
}
