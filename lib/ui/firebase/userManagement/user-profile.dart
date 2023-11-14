import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/ui/firebase/userManagement/userManagementWidgets.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';

import '../../../backend/userManagement/firebaseUserMethods.dart';
import '../../../backend/userManagement/firebaseUserUtils.dart';

/// Widget for displaying and managing the profile of a user.
///
/// This widget takes a user identifier ([uid]) and constructs a user profile screen.
/// The profile includes the user's name, type, birthday, and action buttons to change
/// the user type or delete the user. The user data is fetched asynchronously using
/// [FirebaseUserMethods], and the UI is updated using a [FutureBuilder].
///
/// - [uid]: The unique identifier of the user for whom the profile is displayed.
///
/// Returns a [Scaffold] with an [AppBar] and a [Column] containing user information.
class UserProfile extends StatelessWidget {
  const UserProfile({Key? key, required this.uid}) : super(key: key);

  /// The unique identifier of the user for whom the profile is displayed.
  final String uid;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("بيانات المستخدم"),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Icon(Icons.person),
              FutureBuilder(
                future: FirebaseUserMethods(uid).fetchUserFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    final FirebaseUser user = snapshot.data as FirebaseUser;
                    return Center(
                      child: SizedBox(
                        height: height * 0.8,
                        child: Column(
                          children: [
                            // Username
                            coloredArabicText(user.firstName +
                                " " +
                                user.secondName +
                                " " +
                                user.thirdName),
                            const SizedBox(height: 10),
                            // User type
                            coloredArabicText(translateUserTypes(user.type)),
                            const SizedBox(height: 10),
                            // Birthday
                            coloredArabicText("تاريخ الميلاد: ${user.birthday}"),
                            const Expanded(child: SizedBox()),
                            // Action buttons rows
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  userTypeChangeButton(
                                      context, user.id, "admin", "حوّل لمشرف عام"),
                                  const SizedBox(height: 10),
                                  userTypeChangeButton(
                                      context, user.id, "teacher", "حوّل لمربي"),
                                  const SizedBox(height: 10),
                                  userTypeChangeButton(
                                      context, user.id, "student", "حوّل لطالب"),
                                  const SizedBox(height: 10),
                                  userTypeChangeButton(
                                      context, user.id, "guest", "حوّل لضيف"),
                                  const SizedBox(height: 10),
                                  deleteUserButton(context, uid, user.type)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
