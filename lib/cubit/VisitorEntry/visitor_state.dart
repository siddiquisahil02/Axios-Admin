part of 'visitor_cubit.dart';

@immutable
abstract class VisitorState {}

class VisitorInitial extends VisitorState {
  final List<HouseUidModel> houseNumber;
  VisitorInitial({required this.houseNumber});
}

class VisitorLoading extends VisitorState {}

class VisitorApproved extends VisitorState {
  final Map<String, dynamic> data;
  VisitorApproved({required this.data});
}

class VisitorDenied extends VisitorState {
  final Map<String, dynamic> data;
  VisitorDenied({required this.data});
}

class VisitorWaiting extends VisitorState {
  final String? msg;
  final Stream<DocumentSnapshot<Map<String, dynamic>>> stream;
  VisitorWaiting({required this.stream, this.msg});
}

class VisitorFailed extends VisitorState {
  final String msg;
  VisitorFailed({required this.msg});
}

class VisitorSuccess extends VisitorState {
  final String msg;
  VisitorSuccess({required this.msg});
}
