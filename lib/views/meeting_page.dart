import 'package:axios_admin/constants.dart';
import 'package:axios_admin/cubit/MeetingPlanner/meeting_cubit.dart';
import 'package:axios_admin/utils/text_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({Key? key}) : super(key: key);

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {

  late final MeetingCubit cubit;

  final meetingAgenda = TextEditingController();
  final meetingBody = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<MeetingCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Meeting Planner'),
        ),
        body: BlocBuilder<MeetingCubit,MeetingState>(
          builder: (BuildContext context, state){
            if(state is MeetingLoading){
              return const Center(child: CircularProgressIndicator());
            }else if(state is MeetingFailed){
              return Center(child: Text(state.msg));
            }else{
              if(state is MeetingDone){
                Future.delayed(Duration.zero,(){
                  Fluttertoast.cancel();
                  Fluttertoast.showToast(msg: "New Meeting Posted");
                  Navigator.pushNamedAndRemoveUntil(context,
                     '/home',
                          (route) => false
                  );
                });
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [

                      // Agenda
                      Container(
                        margin: const EdgeInsets.only(bottom: 8,left: 7),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Agenda',
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        controller: meetingAgenda,
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

                      // Agenda
                      Container(
                        margin: const EdgeInsets.only(bottom: 8,left: 7),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Content',
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        controller: meetingBody,
                        cursorColor: Colors.red,
                        maxLines: 10,
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
                      const SizedBox(height: 70),

                      MaterialButton(
                        child: const Text("Alert all Residents"),
                        textColor: Colors.white,
                        color: Colors.red,
                        minWidth: MediaQuery.of(context).size.width,
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed: (){
                          if(_form.currentState!.validate()){
                            Map<String,dynamic> data = {
                              "agenda":meetingAgenda.text.trim(),
                              "body":meetingBody.text.trim(),
                              "createdAt":Timestamp.now(),
                              "uid": auth.currentUser?.uid
                            };
                            cubit.uploadMeeting(data: data);
                          }else{
                            Fluttertoast.cancel();
                            Fluttertoast.showToast(msg: "Fill all the fields");
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            }
          },
        )
    );
  }
}
