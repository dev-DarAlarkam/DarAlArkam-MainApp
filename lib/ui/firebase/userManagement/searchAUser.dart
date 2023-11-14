import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/userManagement/firebaseUserUtils.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/ui/firebase/userManagement/user-profile.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// Enum to determine the sort order for users list
enum SortOrder { ascending, descending, byFirstName}

class SearchAUserTab extends StatefulWidget {
  const SearchAUserTab({Key? key}) : super(key: key);

  @override
  State<SearchAUserTab> createState() => _SearchAUserTabState();
}

class _SearchAUserTabState extends State<SearchAUserTab> {
  // Keeps track of the current sort order (ascending by default)
  String _currentSortOrder = 'تصاعدي'; // Initialize with a default sort order
  
  List<FirebaseUser> allUsers = [];
  // List to store users data
  List<FirebaseUser> users = [];
  // TextEditingController for the search bar
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Fetch and sort the users when the widget is initialized
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
              // Sort dropdown menu in the app bar
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
            //fetching the users' data from firestore  
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16,16,16,16), 
                  child: TextField(
                    
                    controller: controller,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "ابحث",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.green)
                      )
                    ),
                    onChanged: searchUser,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: StreamBuilder(
                          stream: readUsers(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError){return Text(snapshot.error.toString());}
                            else if(snapshot.hasData) {
                              allUsers = snapshot.data as List<FirebaseUser>;
                              // users = allUsers;
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
              ],
            ),
          ),
        )
    );
  }

  /// Retrieves a stream of user data for all users.
  ///
  /// This function creates and returns a stream that listens for changes
  /// in the 'users' collection of the Firestore database.
  ///
  /// The stream emits a list of [FirebaseUser] objects whenever there
  /// is a change in the data.
  ///
  /// Returns a [Stream] of [List] of [FirebaseUser].
  Stream<List<FirebaseUser>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .where('id', isNotEqualTo: getCurrentUserId())
      .snapshots()
      .map((event) => event.docs
      .map((e) => FirebaseUser.fromJson(e.data())).toList());

  // Function to handle the change of the sort order
  void _onSortOrderChanged(String? newSortOrder) {
    setState(() {
      _currentSortOrder = newSortOrder!;
    });
    sortUsers(newSortOrder!);
  }

  // Function to sort users based on their date
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
    title: Text(user.firstName+" "+user.secondName+" "+user.thirdName),
    subtitle: Text(user.birthday + " - " + translateUserTypes(user.type)),
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> UserProfile(uid:user.id)));
    },
  );

  void searchUser(String query){
    final List<FirebaseUser> suggestions = allUsers.where((user) {
      return user.getFullName().contains(query);
    }).toList();

    setState(() => users = suggestions);
  }
}
