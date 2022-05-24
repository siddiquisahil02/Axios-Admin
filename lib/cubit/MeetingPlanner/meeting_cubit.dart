import 'package:axios_admin/constants.dart';
import 'package:axios_admin/utils/network/fcm_send.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  MeetingCubit() : super(MeetingInitial());

  void uploadMeeting({required Map<String,dynamic> data})async{
    try{
      emit(MeetingLoading());
      final String resId = box.read('resId')??"N.A";
      
      await firebase
          .collection('operationalAt')
          .doc(resId)
          .collection('meeting')
          .add(data);

      final notificationRes = await FCMUtils().sendTopicMsg(
          topicName: resId,
          tile: "New Meeting Planned",
          body: data['agenda']
      );
      if(!notificationRes){
        print("error");
      }
      emit(MeetingDone());
    }on FirebaseException catch(e){
      if(e.code == 'unavailable'){
        emit(MeetingFailed(msg: "Please check your Internet Connection"));
      }else{
        emit(MeetingFailed(msg: e.message??"Unknown Error"));
      }
    }catch(e){
      emit(MeetingFailed(msg: e.toString()));
    }
  }

}
