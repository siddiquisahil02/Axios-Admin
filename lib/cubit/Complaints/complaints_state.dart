part of 'complaints_cubit.dart';

@immutable
abstract class ComplaintsState {}

class ComplaintsInitial extends ComplaintsState {
  final List<ComplaintsModel> data;
  ComplaintsInitial({required this.data});
}
class ComplaintsLoading extends ComplaintsState {}
class ComplaintsFailed extends ComplaintsState {
  final String msg;
  ComplaintsFailed({required this.msg});
}
