import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/userManagement/usersUtils.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/ui/firebase/userManagement/user-profile.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';

// Enum to determine the sort order for counters' list
enum SortOrder { ascending, descending, byFirstName}

class UsersTab extends StatefulWidget {
  const UsersTab({Key? key}) : super(key: key);

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  // Keeps track of the current sort order (ascending by default)
  String _currentSortOrder = 'تصاعدي'; // Initialize with a default sort order
  // List to store users data
  List<FirebaseUser> users = [];

  @override
  void initState() {
    super.initState();
    // Fetch and sort the counters when the widget is initialized
    sortUsers(_currentSortOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("المستخدمون"),
            actions: [
              // Sort button in the app bar
              DropdownButton<String>(
                value: _currentSortOrder,
                onChanged: _onSortOrderChanged, // Call the function to update the chosen sort order
                items: ['تصاعدي', 'تنازلي', "نوع المستخدم"].map((String sortOrder) {
                  return DropdownMenuItem<String>(
                    value: sortOrder,
                    child: AutoSizeText(sortOrder, maxFontSize: 16, minFontSize: 5),
                  );
                }).toList(),
              )
            ],
          ),
          body:  Center(
            child: StreamBuilder(
                    stream: readUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError){return Text(snapshot.error.toString());}
                      else if(snapshot.hasData) {
                        users = snapshot.data as List<FirebaseUser>;
                        sortUsers(_currentSortOrder);
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

  // Function to handle the change of the sort order
  void _onSortOrderChanged(String? newSortOrder) {
    setState(() {
      _currentSortOrder = newSortOrder!;
    });
    sortUsers(newSortOrder!);
  }

  // Function to sort counters based on their date
  void sortUsers(String order) {
    if (order == 'تصاعدي') {
      // Sort in ascending order (A to Z)
      users.sort((a, b) => a.firstName.compareTo(b.firstName));
    } else if(order == 'تنازلي') {
      // Sort in descending order (Z to A)
      users.sort((a, b) => b.firstName.compareTo(a.firstName));
    } else {
      // Sort in ascending order (by type)
      users.sort((a, b) => a.type.compareTo(b.type));
    }
  }

  Widget buildUser(FirebaseUser user) => ListTile(
    title: Text(user.firstName+" "+user.secondName+" "+user.thirdName),
    subtitle: Text(user.birthday + " - " + translateUserTypes(user.type)),
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> UserProfile(uid:user.id)));
    },
  );

}
