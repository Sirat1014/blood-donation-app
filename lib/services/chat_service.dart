import 'package:cloud_firestore/cloud_firestore.dart';

String buildChatId(String a, String b) {
  final ids = [a, b]..sort();
  return ids.join('_');
}

Future<DocumentReference<Map<String, dynamic>>> createOrGetChatDoc(
    String chatId, String uidA, String uidB) async {
  final docRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
  final snapshot = await docRef.get();
  if (!snapshot.exists) {
    await docRef.set({
      'participants': [uidA, uidB],
      'lastMessage': '',
      'lastTimestamp': FieldValue.serverTimestamp(),
      'lastSender': null,
    });
  }
  return docRef;
}
