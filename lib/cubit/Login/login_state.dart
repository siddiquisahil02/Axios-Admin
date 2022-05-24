part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginIntro extends LoginState {}
class LoginInitial extends LoginState {}
class LoginFailed extends LoginState {
  final String errorMessage;
  LoginFailed(this.errorMessage);
}
class LoginSuccessful extends LoginState {}
class LoginOTP extends LoginState {
  final String phoneNumber;
  final String pincode;
  final String verificationID;

  LoginOTP({required this.phoneNumber, required this.pincode, required this.verificationID});
}
class LoginLoading extends LoginState {}
