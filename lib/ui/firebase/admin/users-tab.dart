import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/ui/firebase/admin/user-profile.dart';
import 'package:flutter/material.dart';

class UsersTab extends StatefulWidget {
  const UsersTab({Key? key}) : super(key: key);

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text("Users"),),
          body:  Center(
            child: StreamBuilder(
                    stream: readUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError){return Text(snapshot.error.toString());}
                      else if(snapshot.hasData) {
                        final List<FirebaseUser> users = snapshot.data as List<FirebaseUser>;
                        return Center(
                          child: ListView(
                                children: users.map(buildUser).toList(),
                            ),
                        );
                        }
                      else{return const Center(child: CircularProgressIndicator());}
                    },
            ),
          ),
        )
    );
  }
  Stream<List<FirebaseUser>> readUsers() => FirebaseFirestore.instance
      .collection('users').snapshots()
      .map((event) => event.docs
      .map((e) => FirebaseUser.fromJson(e.data())).toList());

  Widget buildUser(FirebaseUser user) => ListTile(
    title: Text(user.firstName+" "+user.secondName+" "+user.thirdName),
    subtitle: Text(user.birthday + " - " + user.type),
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> UserProfile(uid:user.id)));
    },
  );

}
