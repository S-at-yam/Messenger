import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({super.key});
  final authenticatedUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('chats')
              .orderBy('created at', descending: true)
              .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return Center(child: Text('No message found'));
        }

        if (chatSnapshots.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        final loadedMsg = chatSnapshots.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: loadedMsg.length,
          itemBuilder: (ctx, index) {
            final chatMsg = loadedMsg[index].data();

            final nextChatMsg =
                index + 1 < loadedMsg.length
                    ? loadedMsg[index + 1].data()
                    : null;

            final currentMsgUserId = chatMsg['user id'];
            final nextMsgUserId =
                nextChatMsg != null ? nextChatMsg['user id'] : null;

            final nextUserIsSame = nextMsgUserId == currentMsgUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMsg['text'],
                isMe: authenticatedUser.uid == currentMsgUserId,
              );
            } else {
              return MessageBubble.first(
                username: chatMsg['username'],
                message: chatMsg['text'],
                isMe: authenticatedUser.uid == currentMsgUserId,
              );
            }
          },
        );
      },
    );
  }
}
