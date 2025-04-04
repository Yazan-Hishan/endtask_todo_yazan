import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo.dart';

class FirebaseService {
  // الحصول على مراجع Firestore و Authentication
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // الحصول على معرف المستخدم الحالي
  String? get currentUserId => _auth.currentUser?.uid;

  // التحقق مما إذا كان المستخدم مسجل دخول
  bool get isLoggedIn => _auth.currentUser != null;

  // مرجع مجموعة المهام للمستخدم الحالي
  CollectionReference<Map<String, dynamic>> get _todosCollection {
    if (currentUserId == null) {
      throw Exception('لا يوجد مستخدم مسجل دخول');
    }
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('todos');
  }

  // التسجيل باستخدام البريد الإلكتروني وكلمة المرور
  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('خطأ في التسجيل: $e');
      return null;
    }
  }

  // تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('خطأ في تسجيل الدخول: $e');
      return null;
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // إضافة مهمة جديدة
  Future<Todo> addTodo(Todo todo) async {
    final docRef = await _todosCollection.add(todo.toJson());
    final newTodo = todo.copyWith(id: docRef.id);
    await docRef.update({'id': docRef.id});
    return newTodo;
  }

  // تحديث مهمة
  Future<void> updateTodo(Todo todo) async {
    await _todosCollection.doc(todo.id).update(todo.toJson());
  }

  // حذف مهمة
  Future<void> deleteTodo(String todoId) async {
    await _todosCollection.doc(todoId).delete();
  }

  // الحصول على جميع المهام
  Stream<List<Todo>> getTodos() {
    return _todosCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList(),
        );
  }

  // الحصول على مهمة واحدة
  Future<Todo?> getTodoById(String todoId) async {
    final docSnapshot = await _todosCollection.doc(todoId).get();
    if (docSnapshot.exists) {
      return Todo.fromJson(docSnapshot.data()!);
    }
    return null;
  }

  // تغيير حالة المهمة (مكتملة/غير مكتملة)
  Future<void> toggleTodoStatus(String todoId, bool isCompleted) async {
    await _todosCollection.doc(todoId).update({'isCompleted': isCompleted});
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('لا يوجد مستخدم مسجل الدخول');
      }
      // لازم نعيد تسجيل الدخول عشان نقدر نغير كلمة المرور
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: oldPassword);
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
    } catch (e) {
      print('خطأ في تغيير كلمة المرور: $e');
      throw e; // إعادة رمي الخطأ عشان نقدر نتعامل معاه في الـ Controller
    }
  }
}
