part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}
class RegisterReady extends RegisterState {
  final CityModel cityModel;
  RegisterReady({required this.cityModel});
}
class RegisterLoading extends RegisterState {}
class RegisterSuccess extends RegisterState {}
class RegisterFailed extends RegisterState {
  final String msg;
  RegisterFailed({required this.msg});
}