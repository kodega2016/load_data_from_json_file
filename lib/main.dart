import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:startup_name_generator/user.dart';

void main() {
  runApp(UserListApp());
}

class UserListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.brown, accentColor: Colors.red),
      home: NameList(),
    );
  }
}

class NameList extends StatefulWidget {
  @override
  _NameListState createState() => _NameListState();
}

class _NameListState extends State<NameList> {
  var _users = <User>[];
  var _savedUsers = <User>[];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  getUsers() async {
    final _data = await rootBundle.loadString('assets/data.json');
    final _parsed = jsonDecode(_data);
    final _userData = _parsed
        .map<User>((e) => User(
            name: e['name'],
            avatar: e['avatar'],
            email: e['email'],
            id: e['id']))
        .toList();
    setState(() {
      _users = _userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Connections'),
        centerTitle: true,
        elevation: 2.0,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_outline_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Saved Users'),
                    elevation: 2.0,
                    centerTitle: true,
                  ),
                  body: ListView(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: _savedUsers.map(
                        (user) => ListTile(
                          title: Text(
                            user.name,
                          ),
                          ),
                      ),
                    ).toList(),
                  ),
                );
              }));
            },
          )
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, i) => Divider(),
        itemCount: _users.length,
        itemBuilder: (context, i) {
          final _user = _users[i];

          var alreadyBookmarked =
              _savedUsers.map((e) => e.id).toList().contains(_user.id);

          return ListTile(
            title: Text(_user.name),
            subtitle: Text(_user.email),
            trailing: IconButton(
              icon: Icon(
                Icons.bookmark_outline_outlined,
                color:
                    alreadyBookmarked ? Theme.of(context).primaryColor : null,
              ),
              onPressed: () {
                if (alreadyBookmarked) {
                  _savedUsers.remove(_user);
                } else {
                  _savedUsers.add(_user);
                }
                setState(() {});
              },
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(_user.avatar),
            ),
          );
        },
      ),
    );
  }
}
