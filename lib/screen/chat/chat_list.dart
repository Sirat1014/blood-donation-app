import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat/chat_screen.dart';



class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final String currentUid = "YOUR_CURRENT_USER_UID"; // replace with FirebaseAuth
  Map<String, String> userNames = {}; // uid -> donor name

  /// Fetch donor names in batch
  Future<void> fetchUserNames(List<String> uids) async {
    final uniqueUids = uids.toSet().toList(); // remove duplicates
    if (uniqueUids.isEmpty) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: uniqueUids)
        .get();

    final Map<String, String> names = {};
    for (var doc in snapshot.docs) {
      names[doc.id] = doc['name'] ?? 'Donor';
    }

    setState(() {
      userNames = names;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatsRef = FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUid)
        .orderBy('lastMessageTime', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
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

          // Get all other UIDs
          final otherUids = chats.map((chat) {
            final participants = List<String>.from(chat['participants']);
            return participants.firstWhere((uid) => uid != currentUid);
          }).toList();

          // Fetch all donor names if not already fetched
          if (userNames.length != otherUids.length) {
            fetchUserNames(otherUids);
          }

          // Display chats using ListView.builder
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final participants = List<String>.from(chat['participants']);
              final otherUid = participants.firstWhere((uid) => uid != currentUid);
              final donorName = userNames[otherUid] ?? 'Donor';
              final lastMessage = chat['lastMessage'] ?? '';

              return ListTile(
                title: Text(donorName),
                subtitle: Text(lastMessage),
                trailing: chat['unreadBy'] != null &&
                    (chat['unreadBy'] as List).contains(currentUid)
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
      ),
    );
  }
}
