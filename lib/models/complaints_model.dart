import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintsModel {
  ComplaintsModel({
    required this.category,
    required this.desc,
    required this.images,
    required this.createdAt,
  });
  late final String category;
  late final String desc;
  late final List<String> images;
  late final Timestamp createdAt;

  ComplaintsModel.fromJson(Map<String, dynamic> json){
    category = json['category'];
    desc = json['desc'];
    images = List.castFrom<dynamic, String>(json['images']);
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['category'] = category;
    _data['desc'] = desc;
    _data['images'] = images;
    _data['createdAt'] = createdAt;
    return _data;
  }
}