import 'package:axios_admin/constants.dart';
import 'package:axios_admin/cubit/Register/register_cubit.dart';
import 'package:axios_admin/models/city_model.dart';
import 'package:axios_admin/models/residence-uid_model.dart';
import 'package:axios_admin/utils/text_components.dart';
import 'package:axios_admin/utils/ui_constants.dart';
import 'package:axios_admin/utils/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  late final RegisterCubit cubit;

  final _formKey = GlobalKey<FormState>();

  final _focusNode = FocusScopeNode();

  final email = TextEditingController();

  final pass = TextEditingController();

  final name = TextEditingController();

  final phone = TextEditingController();

  int? stateIndex;
  String? state;
  String? district;
  ResidenceUidModel? residence;
  bool isLoading = false;
  String? error;
  List<ResidenceUidModel> residenceList = [];
  
  void getResidence()async{
    try{
      setState(() {
        isLoading = true;
      });
      if(district!=null){
        final rawData = await firebase.collection('operationalAt').where('city',isEqualTo: district!).get();
        if(rawData.size!=0){
          for (var element in rawData.docs){
            ResidenceUidModel model = ResidenceUidModel(
                residence: element.data()['residence'].toString(),
                residenceId: element.id
            );
            residenceList.add(model);
          }
          residenceList.sort((a,b)=> a.residence.compareTo(b.residence));
        }else{
          Fluttertoast.showToast(msg: "No Working Residence Found..!");
        }
      }
      setState(() {
        isLoading = false;
      });
    }catch(e){
      setState(() {
        isLoading = false;
        error = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<RegisterCubit>(context);
    cubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(cubit.state is RegisterFailed){
          cubit.getData();
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: BlocBuilder<RegisterCubit,RegisterState>(
            builder: (BuildContext context, state){
              if(state is RegisterLoading){
                return const Center(child: CircularProgressIndicator());
              }else if(state is RegisterFailed){
                return Center(child: Text(state.msg));
              }else if(state is RegisterReady ){
                return registerFormContent(
                    cityModel: state.cityModel
                );
              }else if(state is RegisterSuccess){
                Future.delayed(Duration.zero,()async{
                  await auth.currentUser?.reload();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Welcome to Axios...!'))
                  );
                  Navigator.pushNamedAndRemoveUntil(context,'/home', (route) => false);
                });
                return Container();
              }else{
                return Container();
              }
            },
          )
      ),
    );
  }

  Widget registerFormContent({required CityModel cityModel}){
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.centerLeft,
            child: Text("Register Here",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Enter all of your information to continue',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.black54
              ),
            ),
          ),
          const SizedBox(height: 50),
          Form(
            key: _formKey,
            child: FocusScope(
              node: _focusNode,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Full Name
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Full Name',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    controller: name,
                    cursorColor: Colors.red,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: _focusNode.nextFocus,
                    validator: (val){
                      if(val!.isEmpty){
                        return "Enter a valid name";
                      }
                      return null;
                    },
                    decoration: textInputDeco(icon: const Icon(CupertinoIcons.person_alt_circle_fill)),
                  ),
                  const SizedBox(height: 20),

                  // Email ID
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email ID',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    controller: email,
                    cursorColor: Colors.red,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: _focusNode.nextFocus,
                    validator: (val){
                      if(!RegExp(Validators.email).hasMatch(val!)){
                        return "Enter a valid Email ID";
                      }
                      return null;
                    },
                    decoration: textInputDeco(icon: const Icon(CupertinoIcons.mail_solid)),
                  ),
                  const SizedBox(height: 20),

                  // Password
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    controller: pass,
                    cursorColor: Colors.red,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    onEditingComplete: _focusNode.nextFocus,
                    validator: (val){
                      if(!RegExp(Validators.password).hasMatch(val!)){
                        return "Password should have minimum 8 characters with atleast 1 Uppercase, 1 Lowercase, 1 Digit and 1 Special character.";
                      }
                      return null;
                    },
                    decoration: textInputDeco(icon: const Icon(CupertinoIcons.padlock_solid)),
                  ),
                  const SizedBox(height: 20),

                  // State
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'State',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ),
                  DropdownButtonFormField(
                    items: cityModel.states.map((e) =>
                        DropdownMenuItem(
                          child: Text(e.state),
                          value: e.state,
                        )
                    ).toList(),
                    validator: (val){
                      if(val==null){
                        return  "Required";
                      }
                      return null;
                    },
                    value: state,
                    hint: const Text("Select anyone"),
                    decoration: textInputDeco(),
                    onChanged: (String? value){
                      stateIndex = cityModel.states.indexWhere((element) => element.state == value);
                      setState(() {
                        state = value;
                        district = null;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // City
                  if(state!=null)...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'City',
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                      ),
                      DropdownButtonFormField(
                        items: cityModel.states[stateIndex!].districts.map((e) =>
                            DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            )
                        ).toList(),
                        value: district,
                        hint: const Text("Select anyone"),
                        decoration: textInputDeco(),
                        validator: (val){
                          if(val==null){
                            return  "Required";
                          }
                          return null;
                        },
                        onChanged: (String? value){
                          setState(() {
                            district = value;
                            residenceList = [];
                            residence = null;
                            error = null;
                          });
                          getResidence();
                        },
                      ),
                  ],
                  const SizedBox(height: 20),

                  // Residence
                  if(district!=null)...[
                    if(error!=null && !isLoading)...[
                      Center(
                        child: Text(error.toString()),
                      )
                    ]
                    else if(!isLoading)...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Residence',
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                      ),
                      DropdownButtonFormField(
                        items: residenceList.map((ResidenceUidModel e) =>
                            DropdownMenuItem(
                              child: Text(e.residence),
                              value: e,
                            )
                        ).toList(),
                        validator: (val){
                          if(val==null){
                            return  "Required";
                          }
                          return null;
                        },
                        value: residence,
                        hint: const Text("Select anyone"),
                        decoration: textInputDeco(),
                        onChanged: (ResidenceUidModel? value){
                          setState(() {
                            residence = value;
                          });
                        },
                      ),
                    ] else
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],

                  const SizedBox(height: 40),

                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width - 50,
            color: appRed,
            height: 55,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            child: Text('Register',
              style: GoogleFonts.poppins(
                fontSize: 18,
                letterSpacing: 1.2,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: ()async{
              if(_formKey.currentState!.validate() && residence!=null){
                Map<String,dynamic> data = {
                  "fullName":name.text.trim(),
                  "email":email.text.trim(),
                  "pass":pass.text.trim(),
                  "state": state.toString(),
                  "city":district.toString(),
                  "residence":residence!.residence,
                  "residenceId":residence!.residenceId,
                  "role":"Security"
                };
                cubit.uploadData(data: data);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter all the information to continue !'))
                );
              }
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

}
