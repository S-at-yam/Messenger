import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _msgController = TextEditingController();

  void _sendmsg() async {
    final msg = _msgController.text;
    if (msg.trim().isEmpty) {
      return;
    }
    final user = FirebaseAuth.instance.currentUser!;
    final userData =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    FirebaseFirestore.instance.collection('chats').add({
      'text': msg,
      'created at': Timestamp.now(),
      'user id': user.uid,
      'username': userData.data()!['username'],
    });
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 1, bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgController,
              decoration: InputDecoration(labelText: 'Send a message ...'),
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
            ),
          ),
          IconButton(onPressed: _sendmsg, icon: Icon(Icons.send)),
        ],
      ),
    );
  }
}
