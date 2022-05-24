import 'dart:convert';

import 'package:axios_admin/utils/constant_data.dart';
import 'package:http/http.dart' as http;

class FCMUtils{
  Future<bool> sendMsg({
    required String to,
    required String tile,
    required String body,
    required String payLoad
  })async{
    try{
      final res = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            'Authorization':"Bearer ${ConstantData.fcmApiKey}",
            'Content-Type':'application/json'
          },
          body: jsonEncode(
              {
                "to":to,
                "notification":{
                  "sound": "default",
                  "title":tile,
                  "body":body
                },
                "priority": "high",
                "data": {
                  "action" : payLoad
                }
              }
          )
      );
      if(res.statusCode==200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> sendTopicMsg({
    required String topicName,
    required String tile,
    required String body,
  })async{
    try{
      final String toParams = "/topics/$topicName";
      final res = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            'Authorization':"Bearer ${ConstantData.fcmApiKey}",
            'Content-Type':'application/json'
          },
          body: jsonEncode(
              {
                "to":toParams,
                "notification":{
                  "sound": "default",
                  "title":tile,
                  "body":body
                },
                "priority": "high",
                "data": {
                  "action" : topicName
                }
              }
          )
      );
      if(res.statusCode==200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }
}