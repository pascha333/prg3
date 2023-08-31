import 'package:flutter/material.dart';
import 'package:prg3/models/user.dart';


class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}


class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
     // ignore: non_constant_identifier_names, unused_local_variable
    var User = ModalRoute.of(context)!.settings.arguments as Users;
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Info"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Card(
          child: ListView(
            children: const [
              ListTile(
                title: Text("Full Name"),
                subtitle: Text("xxx"),
              ),
              ListTile(
                title: Text("Email"),
                subtitle: Text("xxx"),
              ),
              ListTile(
                title: Text("Gender"),
                subtitle: Text("xxx"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





    