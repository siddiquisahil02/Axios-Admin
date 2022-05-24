import 'dart:async';

import 'package:axios_admin/cubit/Login/login_cubit.dart';
import 'package:axios_admin/utils/text_components.dart';
import 'package:axios_admin/utils/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {

  final emailRegex = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final email = TextEditingController();
  final pass = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusScopeNode();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final cubit = BlocProvider.of<LoginCubit>(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(state is LoginIntro){
              return Container();
            }
            else {
              if (state is LoginSuccessful) {
                Future.delayed(Duration.zero,(){
                  Navigator.pushNamedAndRemoveUntil(context,'/home', (route) => false);
                });
              }
              else if (state is LoginFailed) {
                Future.delayed(Duration.zero,(){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage,overflow: TextOverflow.ellipsis))
                  );
                });
              }
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          onPressed: (){
                            //cubit.getToIntro();
                          },
                          icon: const Icon(Icons.arrow_back_ios)
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Welcome to $appName !',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,

                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 7),
                              Text('Enter all of your information to continue',
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Form(
                      key: _formKey,
                      child: FocusScope(
                        node: _focusNode,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10, bottom: 8),
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
                                if(!RegExp(emailRegex).hasMatch(val!)){
                                  return "Enter a valid Email ID";
                                }
                                return null;
                              },
                              decoration: textInputDeco(icon: const Icon(CupertinoIcons.mail_solid))
                            ),
                            const SizedBox(height: 40),
                            Container(
                              margin: const EdgeInsets.only(left: 10, bottom: 8),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Password',
                                style: GoogleFonts.poppins(fontSize: 18),
                              ),
                            ),
                            TextFormField(
                              controller: pass,
                              cursorColor: Colors.red,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: _focusNode.unfocus,
                              validator: (val){
                                if(val!.isEmpty){
                                  return "Enter a valid password";
                                }
                                return null;
                              },
                              decoration: textInputDeco(icon: const Icon(CupertinoIcons.padlock_solid)),
                            ),
                            GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Forgot password ?',
                                  style: GoogleFonts.overlock(
                                      color: appLightRed,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              onTap: (){

                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 150),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width - 50,
                      color: appRed,
                      height: 55,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Text('SUBMIT',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          letterSpacing: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: ()async{
                        if(_formKey.currentState!.validate()){
                          cubit.login(email: email.text, pass: pass.text);
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter all the information to continue !'))
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'What a newbie ? ',
                          style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: 13
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context,'/register');
                          },
                          child: Text(
                            'Sign Up HERE !',
                            style: GoogleFonts.overlock(
                                color: appLightRed,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
