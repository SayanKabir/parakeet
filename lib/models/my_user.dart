import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String id;
  String photoUrl;
  String phoneNumber;
  String nickname;
  String bio;
  List<String> friends;
  Timestamp createdAt;
  // Add other fields like profile pic, badges, friends, and other settings if needed

  MyUser({
    required this.id,
    required this.photoUrl,
    required this.phoneNumber,
    required this.nickname,
    required this.bio,
    required this.friends,
    required this.createdAt,
  });

  //convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phoneNumber,
      'nickname': nickname,
      'bio': bio,
      'photo_url': photoUrl,
      'friends_list': friends,
      'timestamp': createdAt,
    };
  }
}
