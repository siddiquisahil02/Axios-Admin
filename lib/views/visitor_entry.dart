import 'package:axios_admin/constants.dart';
import 'package:axios_admin/cubit/VisitorEntry/visitor_cubit.dart';
import 'package:axios_admin/models/house-uid_model.dart';
import 'package:axios_admin/utils/constant_data.dart';
import 'package:axios_admin/utils/text_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../components/ui_components.dart';

class VisitorEntry extends StatefulWidget {
  const VisitorEntry({Key? key}) : super(key: key);

  @override
  State<VisitorEntry> createState() => _VisitorEntryState();
}

class _VisitorEntryState extends State<VisitorEntry> {

  late final VisitorCubit cubit;

  final _formKey = GlobalKey<FormState>();

  final _focusNode = FocusScopeNode();

  final name = TextEditingController();

  final phoneNo = TextEditingController();

  final from = TextEditingController();

  final vehicleNo = TextEditingController();

  bool? viaVehicle = false;

  HouseUidModel? to;

  String? vehicleType;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<VisitorCubit>(context);
    cubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Visitor Entry'),
        ),
        body: BlocBuilder<VisitorCubit,VisitorState>(
          builder: (BuildContext context, state){
            if(state is VisitorLoading){
              return const Center(
                  child: CircularProgressIndicator()
              );
            }else if(state is VisitorApproved){
              Map<String,dynamic> data = state.data;
              return Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIComponents.showText(
                        title: "Name",
                        body: data['name']
                    ),
                    UIComponents.showText(
                        title: "From",
                        body: data['from']
                    ),
                    UIComponents.showText(
                        title: "Phone Number",
                        body: data['phoneNumber']
                    ),
                    UIComponents.showText(
                        title: "Check In At",
                        body: DateFormat.yMMMEd().add_jms().format(data['checkInAt'].toDate())
                    ),
                    UIComponents.showText(
                        title: "Is Accompanied by a vehicle",
                        body: data['viaVehicle']?"Yes":"No"
                    ),
                    if(data['viaVehicle'])...[
                      UIComponents.showText(
                          title: "Vehicle Type",
                          body: data['vehicleType']
                      ),
                      UIComponents.showText(
                          title: "Vehicle Number",
                          body: data['vehicleNumber']
                      ),
                    ],
                    Material(
                      elevation: 7,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Text("Owner Approved this request",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                                (route) => false
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2
                            ),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Text("Go Back to Home",
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }else if(state is VisitorDenied){
              Map<String,dynamic> data = state.data;
              return Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIComponents.showText(
                        title: "Name:",
                        body: data['name']
                    ),
                    UIComponents.showText(
                        title: "From:",
                        body: data['from']
                    ),
                    UIComponents.showText(
                        title: "Phone Number:",
                        body: data['phoneNumber']
                    ),
                    UIComponents.showText(
                        title: "Check In At:",
                        body: DateFormat.yMMMEd().add_jms().format(data['checkInAt'].toDate())
                    ),
                    UIComponents.showText(
                        title: "Is Accompanied by a vehicle:",
                        body: data['viaVehicle']?"Yes":"No"
                    ),
                    if(data['viaVehicle'])...[
                      UIComponents.showText(
                          title: "Vehicle Type:",
                          body: data['vehicleType']
                      ),
                      UIComponents.showText(
                          title: "Vehicle Number:",
                          body: data['vehicleNumber']
                      ),
                    ],
                    Material(
                      elevation: 7,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.red.shade800,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Text("Owner Denied this request",
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                                (route) => false
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                width: 2
                            ),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Text("Go Back to Home",
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }else  if(state is VisitorWaiting){
              return StreamBuilder(
                stream: state.stream,
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot){
                  if(snapshot.hasData){
                    if(snapshot.data?.data()!=null) {
                      final bool data = snapshot.data?.data()!['allowed'] as bool;
                      if (data) {
                        Fluttertoast.showToast(msg: "Approved");
                        cubit.gotoApproved(
                          data: snapshot.data?.data()??{}
                        );
                      }else {
                        Fluttertoast.showToast(msg: "Denied");
                        cubit.gotoDenied(
                          data: snapshot.data?.data()??{}
                        );
                      }
                    }
                    return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            if(state.msg!=null)...[
                              const SizedBox(height: 20),
                              const Text("Waiting for the user to Approve..!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ]
                          ],
                        )
                    );
                  }else if(snapshot.hasError){
                    return Center(
                        child: Text(snapshot.error.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        )
                    );
                  }else{
                    return const Center(
                        child: CircularProgressIndicator()
                    );
                  }
                },
              );
            }else if(state is VisitorInitial){
              List<HouseUidModel> houseNumbers = state.houseNumber;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                                'Name',
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

                            // Phone Number
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Phone Number',
                                style: GoogleFonts.poppins(fontSize: 18),
                              ),
                            ),
                            TextFormField(
                              controller: phoneNo,
                              cursorColor: Colors.red,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: _focusNode.nextFocus,
                              keyboardType: TextInputType.number,
                              validator: (val){
                                if(val!.length!=10){
                                  return "Enter a valid number";
                                }
                                return null;
                              },
                              maxLength: 10,
                              decoration: textInputDeco(
                                  icon: const Icon(CupertinoIcons.phone_circle_fill)),
                            ),
                            const SizedBox(height: 20),

                            // From
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'From',
                                style: GoogleFonts.poppins(fontSize: 18),
                              ),
                            ),
                            TextFormField(
                              controller: from,
                              cursorColor: Colors.red,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: _focusNode.nextFocus,
                              validator: (val){
                                if(val!.isEmpty){
                                  return "Enter a valid place";
                                }
                                return null;
                              },
                              decoration: textInputDeco(icon: const Icon(CupertinoIcons.location)),
                            ),
                            const SizedBox(height: 20),

                            // House Number
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'House Number',
                                style: GoogleFonts.poppins(fontSize: 18),
                              ),
                            ),
                            DropdownButtonFormField(
                              items: houseNumbers.map((HouseUidModel e) =>
                                  DropdownMenuItem(
                                    child: Text(e.houseNo),
                                    value: e,
                                  )
                              ).toList(),
                              value: to,
                              hint: const Text("Select anyone"),
                              decoration: textInputDeco(),
                              validator: (val){
                                if(val==null){
                                  return  "Required";
                                }
                                return null;
                              },
                              onChanged: (HouseUidModel? value){
                                setState(() {
                                  to = value;
                                });
                              },
                            ),
                            const SizedBox(height: 20),

                            // Vehicle
                            Row(
                              children: [
                                Checkbox(
                                    value: viaVehicle,
                                    onChanged: (val){
                                      setState(() {
                                        viaVehicle = val;
                                      });
                                    }
                                ),
                                viaVehicle??false
                                    ?Flexible(
                                  child: TextFormField(
                                    controller: vehicleNo,
                                    cursorColor: Colors.red,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: _focusNode.nextFocus,
                                    validator: (val){
                                      if(val!.isEmpty){
                                        return "Enter a valid place";
                                      }
                                      return null;
                                    },
                                    decoration: textInputDeco(
                                        icon: const Icon(CupertinoIcons.car_detailed),
                                        hintText: "Vehicle Number"
                                    ),
                                  ),
                                )
                                    :const Text("Any vehicle ?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Vehicle Type
                            if(viaVehicle??false)...[
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Vehicle Type',
                                  style: GoogleFonts.poppins(fontSize: 18),
                                ),
                              ),
                              DropdownButtonFormField(
                                items: ConstantData.vehicleTypes.map((e) =>
                                    DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    )
                                ).toList(),
                                value: vehicleType,
                                hint: const Text("Select anyone"),
                                decoration: textInputDeco(),
                                validator: (val){
                                  if(val==null){
                                    return  "Required";
                                  }
                                  return null;
                                },
                                onChanged: viaVehicle??false?(String? value){
                                  setState(() {
                                    vehicleType = value;
                                  });
                                }:null,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width - 50,
                      color: Colors.red,
                      height: 55,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Text('Submit',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          letterSpacing: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: ()async{
                        if(_formKey.currentState!.validate() && to!=null){
                          Map<String,dynamic> data = {
                            "name":name.text.trim(),
                            "phoneNumber":phoneNo.text.trim(),
                            "from":from.text.trim(),
                            "to": to?.houseNo,
                            "viaVehicle": viaVehicle,
                            "vehicleNumber":vehicleNo.text.isNotEmpty?vehicleNo.text.trim():null,
                            "vehicleType": vehicleType,
                            "checkInAt": Timestamp.now(),
                            "checkOutAt": null,
                            "allowed":false,
                            "toRef": firebase.collection("users").doc(to!.uid)
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
            }else{
              if(state is VisitorFailed){
                cubit.getData();
                Future.delayed(Duration.zero,()async{
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.msg))
                  );
                });
              }else if(state is VisitorSuccess){
                Future.delayed(Duration.zero,()async{
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.msg))
                  );
                  Navigator.pushNamedAndRemoveUntil(context,'/home', (route) => false);
                });
              }
              return Container();

            }
          },
        )
    );
  }
}
