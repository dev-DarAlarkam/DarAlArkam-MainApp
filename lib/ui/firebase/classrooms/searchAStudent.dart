import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/userManagement/firebaseUserUtils.dart';
import 'package:daralarkam_main_app/ui/firebase/userManagement/user-profile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../backend/classroom/classroomUtils.dart';
import '../../../backend/userManagement/additionalInformationMethods.dart';
import '../../../backend/users/additionalInformation.dart';
import '../../../backend/users/firebaseUser.dart';
import '../../../backend/users/student.dart';
import '../../widgets/text.dart';

// Enum to determine the sort order for users list
enum SortOrder { ascending, descending}

class SearchAStudent extends StatefulWidget {
  final String classId;
  const SearchAStudent({Key? key, required this.classId}) : super(key: key);

  @override
  State<SearchAStudent> createState() => _SearchAStudentState();
}

class _SearchAStudentState extends State<SearchAStudent> {
  // Keeps track of the current sort order (ascending by default)
  String _currentSortOrder = 'تصاعدي'; // Initialize with a default sort order

  List<Student> allFreeStudents = [];
  // List to store users data
  List<Student> filteredStudents = [];
  // TextEditingController for the search bar
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Fetch and sort the users when the widget is initialized
    sortStudents(_currentSortOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("ابحث عن طلاب"),
            actions: [
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
                    stream: readStudents(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError){return Text(snapshot.error.toString());}
                      else if(snapshot.hasData) {
                        allFreeStudents = snapshot.data as List<Student>;
                        sortStudents(_currentSortOrder);
                        return Center(
                          child: ListView(
                            children: filteredStudents.map(buildStudent).toList(),
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

  /// Retrieves a stream of Students data for allFreeStudents.
  ///
  /// This function creates and returns a stream that listens for changes
  /// in the 'users' collection of the Firestore database.
  ///
  /// The stream emits a list of [Student] objects whenever there
  /// is a change in the data.
  ///
  /// Returns a [Stream] of [List] of [Student].
  Stream<List<Student>> readStudents() => FirebaseFirestore.instance
      .collection('users')
      .where('type', isEqualTo: 'student')
      .where('classId', isEqualTo: "")
      .snapshots()
      .map((event) => event.docs.map((e) => Student.fromJson(e.data())).toList());

  // Function to handle the change of the sort order
  void _onSortOrderChanged(String? newSortOrder) {
    setState(() {
      _currentSortOrder = newSortOrder!;
    });
    sortStudents(newSortOrder!);
  }

  // Function to sort users based on their name
  void sortStudents(String order) {
    if (order == 'تصاعدي') {
      // Sort in ascending order (A to Z)
      filteredStudents.sort((a, b) => a.fullName.compareTo(b.fullName));
    } else{
      // Sort in descending order (Z to A)
      filteredStudents.sort((a, b) => b.fullName.compareTo(a.fullName));
    }
  }

  /// Builds a [ListTile] widget representing a user in the user list.
  ///
  /// This function takes a [Student] object and constructs a [ListTile]
  /// with the user's full name as the title, the birthday and translated user type
  /// as the subtitle. Additionally, a tap on the [ListTile] navigates to the
  /// user's profile using the [UserProfile] widget.
  ///
  /// - [user]: The [Student] object representing the user.
  ///
  /// Returns a [ListTile] widget.
  // Build a list tile for a student
  Widget buildStudent(Student student) => ListTile(
    title: Text(student.fullName),
    subtitle: FutureBuilder(
      future: AdditionalInformationMethods(student.id).fetchInfoFromFirestore(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        else if(snapshot.hasData){
          final info = snapshot.data! as AdditionalInformation;
          return Text(info.groupName + " - " + info.teacherName + " - " + student.birthday);
        }
        else if (snapshot.connectionState == ConnectionState.waiting){
          return Text("يتم التحميل...");
        }
        else {
          return Text("لا توجد معلومات إضافية - " + student.birthday);
        }
      },
    ),
    trailing: ElevatedButton(
      onPressed: () {
        ClassroomMethods(widget.classId).addStudentToClass(context, student.id);
      },
      child: coloredArabicText("أضف",c: Colors.white),
    ),
  );

  void searchUser(String query){
    final List<Student> suggestions = allFreeStudents.where((user) {
      return user.fullName.contains(query);
    }).toList();

    setState(() => filteredStudents = suggestions);
  }
}
