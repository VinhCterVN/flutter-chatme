
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore;

  UserService(this._firestore);

  Future<List<dynamic>> listUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      log('Error fetching user list: $e');
      return [];
    }
  }
}