part of 'meeting_cubit.dart';

@immutable
abstract class MeetingState {}

class MeetingInitial extends MeetingState {}
class MeetingLoading extends MeetingState {}
class MeetingDone extends MeetingState {}
class MeetingFailed extends MeetingState {
  final String msg;
  MeetingFailed({required this.msg});
}
