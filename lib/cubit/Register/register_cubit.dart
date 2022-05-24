import 'dart:convert';

import 'package:axios_admin/constants.dart';
import 'package:axios_admin/models/city_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  void getData()async{
    try{
      emit(RegisterLoading());
      final fileData = await rootBundle.loadString('assets/cityStateList.json');
      final listData = CityModel.fromJson(json.decode(fileData));
      emit(RegisterReady(cityModel: listData));
    }catch(e){
      emit(RegisterFailed(msg: e.toString()));
    }
  }

  void uploadData({required Map<String,dynamic> data})async{
    try{
      emit(RegisterLoading());
      final residence = data['residence'].toString();
      final email = data['email'].toString();
      final res = await firebase
          .collection('registeredEmail')
          .where('residence',isEqualTo: residence)
          .where('securityEmails',arrayContains: email)
          .get();
      if(res.size!=0){
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: data['pass']!,
        );
        User? user = credential.user;
        if(user!=null){
          data.remove('pass');
          data['uid']= user.uid;
          data['createdAt'] = Timestamp.now();
          user.updateDisplayName(data["fullName"]);
          await firebase.collection('users').doc(user.uid).set(data);
          final String? token = await FirebaseMessaging.instance.getToken();
          await firebase
              .collection('users')
              .doc(user.uid)
              .collection('FCM')
              .doc('token')
              .set({'token': token});
          await box.write("city",data['city']);
          await box.write("res",residence);
          await box.write("resId", data['residenceId']);
          await box.write("state",data['state']);
          await FirebaseMessaging.instance.subscribeToTopic(data['residenceId']);
          await FirebaseMessaging.instance.subscribeToTopic("${data['residenceId']}-complaints");
          emit(RegisterSuccess());
        }else{
          emit(RegisterFailed(msg: "User creation error..!"));
        }
      }else{
        emit(RegisterFailed(msg: "You need to register your Email id First at your RWA."));
      }
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        emit(RegisterFailed(msg: "The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailed(msg: "The account already exists for that email."));
      }else {
        emit(RegisterFailed(msg: e.message.toString()));
      }
    }catch(e){
      print(e);
      emit(RegisterFailed(msg: e.toString()));
    }
  }

}
