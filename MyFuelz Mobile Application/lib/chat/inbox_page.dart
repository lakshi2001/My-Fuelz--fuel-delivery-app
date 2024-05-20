import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_page.dart';

class InboxPage extends StatefulWidget {
  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _getUserData(String userId) async {
    try {
      DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users').child(userId);
      DataSnapshot snapshot = await userRef.once().then((event) => event.snapshot); // Fetch user data once

      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        return userData;
      } else {
        print('User data not found for user ID $userId');
        return null;
      }
    } catch (error) {
      print('Error fetching user data for user ID $userId: $error');
      return null;
    }
  }


  Widget _buildChatItem(QueryDocumentSnapshot room) {
    List<String> participants = List<String>.from(room['participants']);
    participants.remove(_firebaseAuth.currentUser!.uid);

    String chatRoomId = participants.join("_");

    print('Participants: $participants');
    print('Chat Room ID: $chatRoomId');

    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserData(participants.first),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          print('Error fetching user data: ${snapshot.error}');
          return const SizedBox.shrink();
        }

        Map<String, dynamic>? userData = snapshot.data;

        if (userData == null) {
          print('User data is null for user ID ${participants.first}');
          return const SizedBox.shrink();
        }

        print('User Data: $userData');

        // check if last message is image URL
        bool hasImage = room['lastMessage']['imageUrl'] != null;

        // check if current user is sender or receiver
        bool isSender = room['lastMessage']['senderId'] == _firebaseAuth.currentUser!.uid;

        String subtitle = isSender
            ? 'Last message goes here'
            : hasImage
            ? 'New message: Photo'
            : 'New message: ${room['lastMessage']['massage']}';

        // count unseen messages
        int unseenCount = room['lastMessage']['seen'] ? 0 : 1;

        _markMessagesAsSeen(String chatRoomId) {
          _firestore
              .collection('chat_rooms')
              .doc(chatRoomId)
              .collection('massages')
              .where('seen', isEqualTo: false)
              .get()
              .then((unseenMessages) {
            unseenMessages.docs.forEach((doc) {
              // update each message individually
              _firestore
                  .collection('chat_rooms')
                  .doc(chatRoomId)
                  .collection('massages')
                  .doc(doc.id)
                  .update({'seen': true});
            });
          });
        }

        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  reciverUserId: participants.first,
                  senderId: _firebaseAuth.currentUser!.uid,
                  reciverName: userData['name'] ?? 'Unknown',
                  picture: userData['imageURL'] ?? '',
                ),
              ),
            );
            // mark all messages as seen when entering chat
            _markMessagesAsSeen(chatRoomId);
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(userData['imageURL'] ?? ''),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userData['name'] ?? 'Unknown'),
              unseenCount > 0 ? Text('New message: $unseenCount') : SizedBox.shrink(),
            ],
          ),
          subtitle: Text(subtitle),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chat_rooms')
            .where('participants', arrayContains: _firebaseAuth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.data != null && snapshot.data!.docs.isEmpty) {

            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Image.asset('assets/nochats.jpg', scale: 2.5),
                  const SizedBox(height: 10),
                  const Text(
                    'No chats',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QueryDocumentSnapshot> rooms = snapshot.data!.docs;
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              return _buildChatItem(rooms[index]);
            },
          );
        },
      ),
    );
  }
}
