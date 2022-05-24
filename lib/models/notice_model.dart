import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  NoticeModel({
    required this.title,
    required this.body,
    required this.createdAt,
    required this.uid,
  });
  late final String title;
  late final String body;
  late final Timestamp createdAt;
  late final String uid;

  NoticeModel.fromJson(Map<String, dynamic> json){
    title = json['title'];
    body = json['body'];
    createdAt = json['createdAt'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['body'] = body;
    _data['createdAt'] = createdAt;
    _data['uid'] = uid;
    return _data;
  }
}