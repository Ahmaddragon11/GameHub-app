import 'dart:async'; // Import for StreamSubscription
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/models/user_model.dart'; // Assuming UserModel exists

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = Get.find<AuthService>();
  final TextEditingController messageController = TextEditingController();

  final RxList<ChatMessage> messages = RxList<ChatMessage>();
  final RxString currentUserId = ''.obs;
  final RxString currentUserName = 'Guest'.obs;

  StreamSubscription? _messageSubscription;

  @override
  void onInit() {
    super.onInit();
    _authService.currentUser.listen((user) {
      if (user != null) {
        currentUserId.value = user.uid;
        currentUserName.value = user.displayName ?? 'User';
      } else {
        // Handle guest user or logged out state
        currentUserId.value = _authService.userModel.value?.id ?? 'guest';
        currentUserName.value = _authService.userModel.value?.username ?? 'Guest';
      }
    });
    _listenToMessages();
  }

  void _listenToMessages() {
    _messageSubscription = _firestore
        .collection('chat_messages')
        .orderBy('timestamp', descending: true)
        .limit(50) // Limit to last 50 messages
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data()))
          .toList()
          .reversed
          .toList(); // Reverse to show oldest first in list, then ListView.builder reverses again
    });
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final messageText = messageController.text.trim();
    messageController.clear();

    if (currentUserId.value.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء تسجيل الدخول أو المتابعة كضيف لإرسال الرسائل.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      await _firestore.collection('chat_messages').add({
        'senderId': currentUserId.value,
        'senderName': currentUserName.value,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(), // Use server timestamp
      });
    } catch (e) {
      Get.snackbar('خطأ', 'فشل إرسال الرسالة: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    _messageSubscription?.cancel();
    super.onClose();
  }
}

class ChatMessage {
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['senderId'] as String,
      senderName: map['senderName'] as String,
      text: map['text'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  String get formattedTimestamp {
    return DateFormat('hh:mm a').format(timestamp);
  }
}
