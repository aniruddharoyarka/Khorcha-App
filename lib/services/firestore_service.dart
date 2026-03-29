import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transactions.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  // ✅ Add Transaction
  Future<void> addTransaction(TransactionModel tx) async {
    if (userId == null) return;

    await _db
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .add(tx.toMap());
  }

  // ✅ Get Transactions
  Stream<List<TransactionModel>> getTransactions() {
    if (userId == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => TransactionModel.fromFirestore(doc)).toList());
  }
}