import 'package:axios_admin/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          actions: [
            IconButton(
                onPressed: ()async{
                  final String resId = box.read("resId")??"N.A";
                  await FirebaseMessaging.instance.unsubscribeFromTopic(resId);
                  await FirebaseMessaging.instance.unsubscribeFromTopic("$resId-complaints");
                  //print(auth.currentUser?.displayName);
                  await auth.signOut();
                  await box.erase();
                  Navigator.pushNamedAndRemoveUntil(context,"/", (route) => false);
                },
                icon: const Icon(Icons.login))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context,'/visitor');
                  },
                  child: Text("New Visitor..?")
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context,'/notice');
                  },
                  child: Text("New Notice..?")
              ),
              TextButton(
                  onPressed: ()async{
                    // final res = await firebase
                    //     .collection('operationalAt')
                    //     .doc('ocR3eV0mHZUTE9VqSv9I')
                    //     .collection('emergency')
                    //     .doc('data')
                    //     .get();
                    //
                    // await firebase
                    //     .collection('operationalAt')
                    //     .doc('CfINQGaRDmiZ4LKSYHQ9')
                    //     .collection('emergency')
                    //     .doc('data')
                    //     .set(res.data()!);
                    Navigator.pushNamed(context,'/complaints');
                  },
                  child: Text("Complaints")
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context,'/meeting');
                  },
                  child: Text("New Meeting..?")
              ),
            ],
          ),
        )
    );
  }
}
