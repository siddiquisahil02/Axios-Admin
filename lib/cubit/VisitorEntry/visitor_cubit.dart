import 'package:axios_admin/constants.dart';
import 'package:axios_admin/models/house-uid_model.dart';
import 'package:axios_admin/utils/network/fcm_send.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'visitor_state.dart';

class VisitorCubit extends Cubit<VisitorState> {
  VisitorCubit() : super(VisitorInitial(houseNumber: const []));

  void gotoApproved({required Map<String, dynamic> data}){
    emit(VisitorApproved(data: data));
  }

  void gotoDenied({required Map<String, dynamic> data}){
    emit(VisitorDenied(data: data));
  }

  void getData()async{
    try{
      emit(VisitorLoading());
      final String city = box.read('city')??"N.A";
      final String residence = box.read('res')??"N.A";

      List<HouseUidModel> houseNumbers = [];

      final res = await firebase
          .collection('users')
          .where('city',isEqualTo: city)
          .where('residence',isEqualTo: residence)
          .get();

      for (var element in res.docs){
        if(element.data()['houseNo']!=null) {
          final String houseNo = element.data()['houseNo'];
          final String uid = element.id;
          HouseUidModel model = HouseUidModel(houseNo: houseNo, uid: uid);
          houseNumbers.add(model);
        }
      }
      emit(VisitorInitial(houseNumber: houseNumbers));
    } on FirebaseException catch(e){
      if(e.code=='unavailable'){
        emit(VisitorFailed(msg: "Check your Internet connection."));
      }
      emit(VisitorFailed(msg: e.message??"Unknown Error"));
    }catch(e){
      emit(VisitorFailed(msg: e.toString()));
    }
  }

  void uploadData({required Map<String, dynamic> data})async{
    try{
      emit(VisitorLoading());
      final String resId = box.read('resId');
      final DocumentReference ref = data['toRef'];
      final visData = await firebase
          .collection("operationalAt")
          .doc(resId)
          .collection('ActiveRequest')
          .add(data);
      final dataRef = await ref.collection('FCM').doc('token').get();
      if(dataRef.exists) {
        final String fcmToken = dataRef.data()!['token'];
        final fcmRes = await FCMUtils().sendMsg(
            to: fcmToken,
            tile: "You have a new Visitor",
            body: "Click here to respond to this request.",
            payLoad: "${visData.id}-$resId"
        );
        if(!fcmRes){
          emit(VisitorFailed(msg: "Check your Internet connection."));
          return;
        }
        // final activeRef = firebase
        //     .collection('operationalAt')
        //     .doc(resId)
        //     .collection('ActiveRequest')
        //     .doc(visData.id);
        //
        // await activeRef.set(data);
        final ref = firebase
            .collection("operationalAt")
            .doc(resId)
            .collection('visitors')
            .doc(visData.id).snapshots();
        emit(VisitorWaiting(
            msg: 'Visitor Registered',
            stream: ref
        ));
      }
    }on FirebaseException catch(e){
      if(e.code=='unavailable'){
        emit(VisitorFailed(msg: "Check your Internet connection."));
      }
      emit(VisitorFailed(msg: e.message??"Unknown Error"));
    }catch(e){
      emit(VisitorFailed(msg: e.toString()));
    }
  }
}
