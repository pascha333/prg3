import 'package:flutter/material.dart';
import 'package:prg3/models/config.dart';
import 'package:prg3/models/user.dart';
import 'package:prg3/screens/login.dart';
import 'package:prg3/screens/user_from.dart';
import 'package:prg3/screens/user_info.dart';
import 'package:http/http.dart' as http;

//HOME
class Home extends StatefulWidget {
  static const routeName = '/';
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget mainBody = Container();

  List<Users> userList = [];
  Future<void> getUsers() async {
    var url = Uri.http(configure.server, "users");
    var resp = await http.get(url);
    setState(() {
      userList = usersFromJson(resp.body);
      mainBody = showUsers();
    });
  }

  Future<void> removeUsers(user) async {
    var url = Uri.http(configure.server, "users/${user.id}");
    var resp = await http.delete(url);
    print(resp.body);
    return;
  }

  Widget showUsers() {
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) {
        Users user = userList[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          child: Card(
            child: ListTile(
              title: Text("${user.fullname}"),
              subtitle: Text("${user.email}"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInfo(),
                        settings: RouteSettings(arguments: user)));
              },
              trailing: IconButton(
                onPressed: () async {
                  String result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserForm(),
                          settings: RouteSettings(arguments: user)));
                  if (result == "refresh") {
                    getUsers();
                  }
                },
                icon: Icon(Icons.edit),
              ),
            ),
          ),
          onDismissed: (direction) {
            removeUsers(user);
          },
          background: Container(
            color: Colors.red,
            margin: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Users user = configure.login;
    if (user.id != null) {
      getUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const SideMenu(),
      body: mainBody,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserForm()));
          if (result == "refresh") {
            getUsers();
          }
        },
        child: const Icon(Icons.person_add_alt_1),
      ),
    );
  }
}


//SLIDE MENU
class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    String accountName = "N/A";
    String accountEmail = "N/A";
    String accountUrl =
        "https://cdn-icons-png.flaticon.com/128/9602/9602940.png";

    Users user = configure.login;
    if (user.id != null) {
      accountName = user.fullname!;
      accountEmail = user.email!;
    }

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountName),
            accountEmail: Text(accountEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(accountUrl),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, Home.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Login'),
            onTap: () {
              Navigator.pushNamed(context, Login.routeName);
            },
          )
        ],
      ),
    );
  }
}
