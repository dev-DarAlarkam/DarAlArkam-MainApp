import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/userManagement/firebaseUserUtils.dart';
import 'package:daralarkam_main_app/ui/firebase/userManagement/searchAGuest.dart';
import 'package:daralarkam_main_app/ui/firebase/userManagement/user-profile.dart';
import 'package:flutter/material.dart';

import '../../../backend/userManagement/additionalInformationMethods.dart';
import '../../../backend/users/additionalInformation.dart';
import '../../../backend/users/firebaseUser.dart';

// Enum to determine the sort order for guests' list
enum SortOrder { ascending, descending}

class GuestManagementTab extends StatefulWidget {
  const GuestManagementTab({Key? key}) : super(key: key);

  @override
  State<GuestManagementTab> createState() => _GuestManagementTabState();
}

class _GuestManagementTabState extends State<GuestManagementTab> {
  // Keeps track of the current sort order (ascending by default)
  String _currentSortOrder = 'تصاعدي'; // Initialized with a default sort order
  // List to store users data
  List<FirebaseUser> users = [];

  @override
  void initState() {
    super.initState();
    // Fetch and sort the guests when the widget is initialized
    _sortUsers(_currentSortOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("الضيوف"),
            actions: [

              // Navigation button to "Search a Student" tab
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_)=> const SearchAGuestTab()));
                  },
                  icon: const Icon(Icons.search_sharp)
              ),

              // Sort dropdown menu in the app bar
              DropdownButton<String>(
                value: _currentSortOrder,
                onChanged: _onSortOrderChanged, // Call the function to update the chosen sort order
                items: ['تصاعدي', 'تنازلي'].map((String sortOrder) {
                  return DropdownMenuItem<String>(
                    value: sortOrder,
                    child: AutoSizeText(sortOrder, maxFontSize: 16, minFontSize: 5),
                  );
                }).toList(),
              )
            ],
          ),
          body:  Center(
            //fetching the guests' data from firestore
            child: StreamBuilder(
              stream: readUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError){return Text(snapshot.error.toString());}
                
                else if(snapshot.hasData) {
                  users = snapshot.data as List<FirebaseUser>;
                  _sortUsers(_currentSortOrder);
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

/// Retrieves a stream of user data for users with a specified type.
///
/// This function creates and returns a stream that listens for changes
/// in the 'users' collection of the Firestore database, specifically
/// filtering for users with the specified 'type' value ("guest").
///
/// The stream emits a list of [FirebaseUser] objects whenever there
/// is a change in the data.
///
/// Returns a [Stream] of [List] of [FirebaseUser].
Stream<List<FirebaseUser>> readUsers() =>
    FirebaseFirestore.instance
        .collection('users')
        .where('type', isEqualTo: "guest")
        .snapshots()
        .map((event) => event.docs
            .map((e) => FirebaseUser.fromJson(e.data()))
            .toList());

/// Builds a [ListTile] widget representing a user in the user list.
///
/// This function takes a [FirebaseUser] object and constructs a [ListTile]
/// with the user's full name as the title, the birthday and translated user type
/// as the subtitle. Additionally, a tap on the [ListTile] navigates to the
/// user's profile using the [UserProfile] widget.
///
/// - [user]: The [FirebaseUser] object representing the user.
///
/// Returns a [ListTile] widget.
Widget buildUser(FirebaseUser user) => ListTile(
      title: Text(user.fullName),
      subtitle: FutureBuilder(
        future: AdditionalInformationMethods(user.id).fetchInfoFromFirestore(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          else if(snapshot.hasData){
            final info = snapshot.data! as AdditionalInformation;
            return Text(info.groupName + " - " + info.teacherName + " - " + user.birthday);
          }
          else if (snapshot.connectionState == ConnectionState.waiting){
            return Text("يتم التحميل...");
          }
          else {
            return Text("لا توجد معلومات إضافية - " + user.birthday);
          }
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfile(uid: user.id)),
        );
      },
    );

 
  // Function to handle the change of the sort order
  void _onSortOrderChanged(String? newSortOrder) {
    setState(() {
      _currentSortOrder = newSortOrder!;
    });
    _sortUsers(newSortOrder!);
  }

  // Function to sort guests based on their date
  void _sortUsers(String order) {
    if (order == 'تصاعدي') {
      // Sort in ascending order (A to Z)
      users.sort((a, b) => a.fullName.compareTo(b.fullName));
    } else if(order == 'تنازلي') {
      // Sort in descending order (Z to A)
      users.sort((a, b) => b.fullName.compareTo(a.fullName));
    } else {
      // Sort in ascending order (by type)
      users.sort((a, b) => a.type.compareTo(b.type));
    }
  }


  

}
