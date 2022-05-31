import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintsModel {
  ComplaintsModel({
    required this.category,
    required this.desc,
    required this.images,
    required this.createdAt,
    required this.status,
    required this.id,
    required this.residence
  });
  late final String category;
  late final String desc;
  late final List<String> images;
  late String status;
  late final String id;
  late final String residence;
  late final Timestamp createdAt;

  ComplaintsModel.fromJson(Map<String, dynamic> json){
    category = json['category'];
    desc = json['desc'];
    images = List.castFrom<dynamic, String>(json['images']);
    createdAt = json['createdAt'];
    status = json['status']??"Open";
    id = json['id']??"N.A";
    residence = json['residence']??"N.A";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['category'] = category;
    _data['desc'] = desc;
    _data['images'] = images;
    _data['createdAt'] = createdAt;
    _data['status'] = status;
    _data['id'] = id;
    return _data;
  }
}