import 'package:axios_admin/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login({required String email, required String pass})async{
    emit(LoginLoading());
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      User? user = credential.user;
      if(user!=null){
        final res = await firebase.collection('users').doc(user.uid).get();
        Map<String,dynamic> data = res.data()!;
        if(data['role']=='Security') {
          await FirebaseMessaging.instance.subscribeToTopic(data['residenceId']);
          await FirebaseMessaging.instance.subscribeToTopic("${data['residenceId']}-complaints");
          await box.write("city", data['city']);
          await box.write("resId", data['residenceId']);
          await box.write("res", data['residence']);
          await box.write("state", data['state']);
          emit(LoginSuccessful());
        }else{
          emit(LoginFailed("Not a security Manager"));
        }
      }else{
        emit(LoginFailed("Error, Try Again"));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        emit(LoginFailed("No account found, Try signing up first..!"));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        emit(LoginFailed("Wrong Password, Try Again"));
      }
    } catch (e) {
      emit(LoginFailed(e.toString()));
    }
  }
}
