import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChatListScreen extends StatelessWidget {
   ChatListScreen({super.key});

  final String currentUid = FirebaseAuth.instance.currentUser!.uid;

  Future<String> getUserName(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc['name'] ?? 'Donor';
  }

  @override
  Widget build(BuildContext context) {
    final chatsRef = FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUid)
        .orderBy('lastMessageTime', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.redAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(child: Text('No chats yet.'));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final participants = List<String>.from(chat['participants']);
              final otherUid = participants.firstWhere((uid) => uid != currentUid);
              final lastMessage = chat['lastMessage'] ?? '';

              return FutureBuilder<String>(
                future: getUserName(otherUid),
                builder: (context, nameSnapshot) {
                  final donorName = nameSnapshot.data ?? 'Donor';

                  return ListTile(
                    title: Text(donorName),
                    subtitle: Text(lastMessage),
                    trailing: chat['unreadBy'] != null && (chat['unreadBy'] as List).contains(currentUid)
                        ? const CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                    )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            chatId: chat.id,
                            otherUid: otherUid,
                            otherName: donorName,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
