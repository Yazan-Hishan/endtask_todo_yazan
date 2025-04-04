import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import '../models/todo.dart';

class TodoController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<Todo> _todos = <Todo>[].obs;
  final RxBool _isLoading = false.obs;
  final Rx<String?> _error = Rx<String?>(null);

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  // دالة للحصول على المهام المكتملة
  List<Todo> get completedTodos =>
      _todos.where((todo) => todo.isCompleted).toList();

  // دالة للحصول على المهام غير المكتملة
  List<Todo> get incompleteTodos =>
      _todos.where((todo) => !todo.isCompleted).toList();

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  // جلب المهام من قاعدة البيانات
  Future<void> fetchTodos() async {
    _isLoading.value = true;
    _error.value = null;

    try {
      final user = _auth.currentUser;
      if (user == null) {
        _error.value = 'يرجى تسجيل الدخول أولاً';
        return;
      }

      final todosSnapshot =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('todos')
              .orderBy('createdAt', descending: true)
              .get();

      final todos =
          todosSnapshot.docs.map((doc) {
            return Todo.fromJson({'id': doc.id, ...doc.data()});
          }).toList();

      _todos.assignAll(todos);
    } catch (e) {
      _error.value = 'خطأ في جلب المهام: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  // إضافة مهمة جديدة
  Future<void> addTodo(Todo todo) async {
    _isLoading.value = true;
    _error.value = null;

    try {
      final user = _auth.currentUser;
      if (user == null) {
        _error.value = 'يرجى تسجيل الدخول أولاً';
        return;
      }

      final docRef =
          _firestore
              .collection('users')
              .doc(user.uid)
              .collection('todos')
              .doc();

      final newTodo = todo.copyWith(id: docRef.id, createdAt: DateTime.now());

      await docRef.set(newTodo.toJson());

      // إضافة المهمة إلى القائمة المحلية
      _todos.insert(0, newTodo);

      // Schedule notification
      scheduleNotification(newTodo);
    } catch (e) {
      _error.value = 'خطأ في إضافة المهمة: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  // تحديث مهمة موجودة
  Future<void> updateTodo(Todo updatedTodo) async {
    _isLoading.value = true;
    _error.value = null;

    try {
      final user = _auth.currentUser;
      if (user == null) {
        _error.value = 'يرجى تسجيل الدخول أولاً';
        return;
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .doc(updatedTodo.id)
          .update(updatedTodo.toJson());

      // تحديث المهمة في القائمة المحلية
      final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
      if (index != -1) {
        _todos[index] = updatedTodo;
        _todos.refresh(); // لتحديث الواجهة
      }

      // Schedule notification
      scheduleNotification(updatedTodo);
    } catch (e) {
      _error.value = 'خطأ في تحديث المهمة: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  // حذف مهمة
  Future<void> deleteTodo(Todo todo) async {
    _isLoading.value = true;
    _error.value = null;

    try {
      final user = _auth.currentUser;
      if (user == null) {
        _error.value = 'يرجى تسجيل الدخول أولاً';
        return;
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .doc(todo.id)
          .delete();

      // حذف المهمة من القائمة المحلية
      _todos.removeWhere((t) => t.id == todo.id);
    } catch (e) {
      _error.value = 'خطأ في حذف المهمة: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  // الحصول على مهمة بواسطة المعرف
  Todo? getTodoById(String id) {
    return _todos.firstWhereOrNull((todo) => todo.id == id);
  }

  // تبديل حالة اكتمال المهمة
  Future<void> toggleTodoCompletion(Todo todo) async {
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    await updateTodo(updatedTodo);
  }

  Future<void> scheduleNotification(Todo todo) async {
    if (todo.dueDate == null) return;

    final scheduledDate = todo.dueDate!.subtract(const Duration(minutes: 10));
    print('dueDate: ${todo.dueDate}');
    print('scheduledDate: $scheduledDate');
    print('now: ${DateTime.now()}');
    if (scheduledDate.isBefore(DateTime.now())) return;

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'todo_channel',
      'Todo Notifications',
      channelDescription: 'Notifications for todo tasks',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        todo.id.hashCode,
        'تذكير بالمهمة',
        todo.title,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time);
  }
}
