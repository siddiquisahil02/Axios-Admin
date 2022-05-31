import 'package:axios_admin/constants.dart';
import 'package:axios_admin/models/complaints_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'complaints_state.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  ComplaintsCubit() : super(ComplaintsInitial(data: []));
  
  void getData()async{
    try{
      emit(ComplaintsLoading());
      
      final String resId = box.read('resId');

      List<ComplaintsModel> data = [];

      final res = await firebase
          .collection('operationalAt')
          .doc(resId)
          .collection("complaints")
          .orderBy("createdAt",descending: true)
          .get();

      for (var element in res.docs){
        Map<String,dynamic> ele = element.data();
        ele['id'] = element.id;
        data.add(ComplaintsModel.fromJson(ele));
      }

      emit(ComplaintsInitial(data: data));
    }on FirebaseException catch(e){
      if(e.code == 'unavailable'){
        emit(ComplaintsFailed(msg: "Please check your Internet Connection"));
      }else{
        emit(ComplaintsFailed(msg: e.message??"Unknown Error"));
      }
    }catch(e){
      emit(ComplaintsFailed(msg: e.toString()));
    }
  }
  
}
