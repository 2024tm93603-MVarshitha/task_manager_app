import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return {'success': true};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': e.message ?? 'Registration failed'};
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return {'success': true};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': e.message ?? 'Login failed'};
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static CollectionReference _tasksRef() {
    final uid = _auth.currentUser!.uid;
    return _db.collection('users').doc(uid).collection('tasks');
  }

  static Future<bool> createTask(String title, String description, DateTime? dueDate) async {
    try {
      await _tasksRef().add({
        'title': title,
        'description': description,
        'isCompleted': false,
        'dueDate': dueDate != null ? Timestamp.fromDate(dueDate) : null,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Stream<QuerySnapshot> getTasks() {
    return _tasksRef().orderBy('createdAt', descending: true).snapshots();
  }

  static Future<bool> updateTask(String taskId, String title, String description, DateTime? dueDate) async {
    try {
      await _tasksRef().doc(taskId).update({
        'title': title,
        'description': description,
        'dueDate': dueDate != null ? Timestamp.fromDate(dueDate) : null,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> toggleComplete(String taskId, bool isCompleted) async {
    try {
      await _tasksRef().doc(taskId).update({'isCompleted': isCompleted});
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteTask(String taskId) async {
    try {
      await _tasksRef().doc(taskId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
