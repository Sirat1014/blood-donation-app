import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUid;
  final String otherName;
  const ChatScreen({super.key, required this.chatId, required this.otherUid, required this.otherName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String get currentUid => FirebaseAuth.instance.currentUser!.uid;
  CollectionReference<Map<String, dynamic>> get messagesRef =>
      FirebaseFirestore.instance.collection('chats').doc(widget.chatId).collection('messages');

  // New: Method to mark messages as read
  @override
  void initState() {
    super.initState();
    markMessagesAsRead();
  }

  // New: Function to handle marking messages as read in Firestore
  Future<void> markMessagesAsRead() async {
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(widget.chatId);
    final chatDoc = await chatRef.get();

    if (chatDoc.exists && chatDoc.data()!['unreadBy'] != null) {
      final unreadByList = List<String>.from(chatDoc.data()!['unreadBy']);

      if (unreadByList.contains(currentUid)) {
        unreadByList.remove(currentUid);
        await chatRef.update({'unreadBy': unreadByList});
      }
    }
  }

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final now = FieldValue.serverTimestamp();

    await messagesRef.add({
      'senderId': currentUid,
      'text': text,
      'timestamp': now,
      'type': 'text',
      'seen': false,
    });

    // Modified: Add the recipient to the unreadBy array
    await FirebaseFirestore.instance.collection('chats').doc(widget.chatId).set({
      'lastMessage': text,
      'lastTimestamp': now,
      'lastSender': currentUid,
      'unreadBy': FieldValue.arrayUnion([widget.otherUid]),
    }, SetOptions(merge: true));

    _controller.clear();

    await Future.delayed(const Duration(milliseconds: 100));
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _messageBubble(Map<String, dynamic> msg) {
    final isMe = msg['senderId'] == currentUid;
    final text = msg['text'] ?? '';
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            color: isMe ? Theme.of(context).colorScheme.primary : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text, style: TextStyle(color: isMe ? Colors.white : Colors.black87)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final stream = messagesRef.orderBy('timestamp', descending: true).snapshots();

    return Scaffold(
      appBar: AppBar(title: Text(widget.otherName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: stream,
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs;
                if (docs.isEmpty) return const Center(child: Text('No messages yet'));
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final d = docs[index].data();
                    return _messageBubble(d);
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                      onPressed: sendMessage,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}