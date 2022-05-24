import 'package:axios_admin/constants.dart';
import 'package:axios_admin/cubit/Notice/notice_cubit.dart';
import 'package:axios_admin/models/notice_model.dart';
import 'package:axios_admin/utils/text_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as time_ago;

class NoticeBoardPage extends StatefulWidget {
  const NoticeBoardPage({Key? key, this.data}) : super(key: key);
  final Map<String,dynamic>? data;

  @override
  State<NoticeBoardPage> createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {

  late final NoticeCubit cubit;

  final title = TextEditingController();
  final body = TextEditingController();

  final _form = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<NoticeCubit>(context);
    cubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(cubit.state is NoticeAddNew){
          cubit.getData();
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Notice Board'),
          ),
          body: BlocBuilder<NoticeCubit, NoticeState>(
            builder: (BuildContext context, state){
              if(state is NoticeLoading){
                return const Center(
                    child: CircularProgressIndicator()
                );
              }else if(state is NoticeError){
                return Center(
                    child: Text(state.msg,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    )
                );
              }else if(state is NoticeInitial){
                List<NoticeModel> listData = state.listData;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  child: Stack(
                    children: [
                      listData.isNotEmpty?ListView.separated(
                        itemCount: listData.length,
                        itemBuilder: (BuildContext context, int index){
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1
                              ),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: ListTile(
                              title: Text(listData[index].title),
                              subtitle: Text(listData[index].body,
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Container(
                                alignment: Alignment.center,
                                  width: 40,
                                  child: Text(time_ago.format(listData[index].createdAt.toDate(),locale: 'en_short'))
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index){
                          return const SizedBox(
                            height: 10,
                          );
                        },
                      ):const Center(
                        child: Text("No Notices Available"),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 5,
                        child: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(30),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.red,
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              color: Colors.white,
                              onPressed: (){
                                cubit.addNewNotice();
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }else if(state is NoticeAddNew){
                return addNewForm(
                  cubit: cubit,
                );
              }else{
                return Container();
              }
            },
          )
      ),
    );
  }

  Widget addNewForm({required NoticeCubit cubit}){
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Title
              Container(
                margin: const EdgeInsets.only(bottom: 8,left: 7),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Title',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
              TextFormField(
                controller: title,
                cursorColor: Colors.red,
                textInputAction: TextInputAction.next,
                onEditingComplete: FocusScope.of(context).nextFocus,
                validator: (val){
                  if(val==null || val.isEmpty){
                    return "Required";
                  }
                  return null;
                },
                decoration: textInputDeco(),
              ),
              const SizedBox(height: 20),

              // Body
              Container(
                margin: const EdgeInsets.only(bottom: 8,left: 7),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Body',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
              TextFormField(
                controller: body,
                maxLines: 15,
                cursorColor: Colors.red,
                textInputAction: TextInputAction.next,
                onEditingComplete: FocusScope.of(context).unfocus,
                validator: (val){
                  if(val==null || val.isEmpty){
                    return "Required";
                  }
                  return null;
                },
                decoration: textInputDeco(),
              ),
              const SizedBox(height: 80),

              // Submit Button
              MaterialButton(
                child: const Text("ADD TO THE NOTICE BOARD"),
                textColor: Colors.white,
                color: Colors.red,
                minWidth: MediaQuery.of(context).size.width,
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                onPressed: (){
                  if(_form.currentState!.validate()){
                    NoticeModel model = NoticeModel(
                        title: title.text.trim(),
                        body: body.text.trim(),
                        createdAt: Timestamp.now(),
                        uid: auth.currentUser?.uid ?? "N.A"
                    );
                    cubit.uploadNotice(model: model);
                  }else{
                    Fluttertoast.cancel();
                    Fluttertoast.showToast(msg: "Fill all the fields");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}