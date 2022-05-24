import 'package:axios_admin/cubit/Complaints/complaints_cubit.dart';
import 'package:axios_admin/cubit/Home/home_cubit.dart';
import 'package:axios_admin/cubit/Login/login_cubit.dart';
import 'package:axios_admin/cubit/MeetingPlanner/meeting_cubit.dart';
import 'package:axios_admin/cubit/Notice/notice_cubit.dart';
import 'package:axios_admin/cubit/Register/register_cubit.dart';
import 'package:axios_admin/cubit/VisitorEntry/visitor_cubit.dart';
import 'package:axios_admin/views/complaints_page.dart';
import 'package:axios_admin/views/home_page.dart';
import 'package:axios_admin/views/login_page.dart';
import 'package:axios_admin/views/meeting_page.dart';
import 'package:axios_admin/views/notice_board_page.dart';
import 'package:axios_admin/views/register_page.dart';
import 'package:axios_admin/views/visitor_entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => FirebaseAuth.instance.currentUser == null ? BlocProvider(
              create: (BuildContext context)=> LoginCubit(),
              child: LoginPage(),
            ):BlocProvider(
              create: (BuildContext context)=> HomeCubit(),
              child: const HomePage(),
            )
        );
      case '/home':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> HomeCubit(),
              child: const HomePage(),
            )
        );
      case '/register':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> RegisterCubit(),
              child: const RegisterPage(),
            )
        );
      case '/visitor':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> VisitorCubit(),
              child: const VisitorEntry(),
            )
        );
      case '/notice':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> NoticeCubit(),
              child: const NoticeBoardPage(),
            )
        );
      case '/complaints':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> ComplaintsCubit(),
              child: const ComplaintsPage(),
            )
        );
      case '/meeting':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context)=> MeetingCubit(),
              child: const MeetingPage(),
            )
        );
      default:
        return null;
    }
  }
}