
import 'dart:developer';

import 'package:chatme/data/model/user_model.dart';
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

  Future<UserModel> getUserInfo(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception('User not found');
      }
      final data = doc.data()!;
      return UserModel(
        uid: doc.id,
        displayName: data['displayName'] ?? '',
        email: data['email'] ?? '',
        photoUrl: data['photoUrl'] ?? '',
      );
    } catch (e) {
      log('Error fetching user info: $e');
      rethrow;
    }
  }

  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    try {
      final users = <UserModel>[];
      for (final userId in userIds) {
        final user = await getUserInfo(userId);
        users.add(user);
      }
      return users;
    } catch (e) {
      log('Error fetching users by IDs: $e');
      return [];
    }
  }
}