part of 'notice_cubit.dart';

@immutable
abstract class NoticeState {}

class NoticeInitial extends NoticeState {
  final List<NoticeModel> listData;
  NoticeInitial({required this.listData});
}
class NoticeLoading extends NoticeState {}
class NoticeAddNew extends NoticeState {}
class NoticeError extends NoticeState {
  final String msg;
  NoticeError({required this.msg});
}
