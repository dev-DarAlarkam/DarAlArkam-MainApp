import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classroom/classroom.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';

import '../../../../../backend/classroom/classroomUtils.dart';
import '../../../../../services/utils/showSnackBar.dart';
import 'selectATeacher.dart';
import '../../../../../globals/globalColors.dart' as color;

class CreateAClassroomTab extends StatefulWidget {
  const CreateAClassroomTab({Key? key}) : super(key: key);

  @override
  State<CreateAClassroomTab> createState() => _CreateAClassroomTabState();
}

class _CreateAClassroomTabState extends State<CreateAClassroomTab> {
  String selectedNumber = '1'; // Default value for the dropdown
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // Controller for the text input

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: color.green,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Center(
                child: SingleChildScrollView(
              child: SizedBox(
                  width: width * 0.8,
                  height: height,
                  child: Column(children: <Widget>[
                    const Expanded(flex: 1, child: SizedBox()),
                    SizedBox(
                      height: height * .1,
                      child: Image.asset("lib/assets/photos/main-logo.png"),
                    ),
                    SizedBox(height: 16.0),
                    boldColoredArabicText("انشئ مجموعة تربوية جديدة"),
                    const Expanded(flex: 1, child: SizedBox()),
                    TextFormField(
                      controller: _textController,
                      decoration: InputDecoration(labelText: 'إسم المجموعة'),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        coloredArabicText("الصف:"),
                        SizedBox(
                          width: 30,
                        ),
                        DropdownButton<String>(
                          value: selectedNumber,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedNumber = newValue!;
                            });
                          },
                          items: List<String>.generate(
                                  12, (index) => (index + 1).toString())
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),

                    //create a classroom button
                    ElevatedButton(
                      onPressed: () async {
                        //creating a new classId
                        final classId =
                            'Classroom_${DateTime.now().millisecondsSinceEpoch}';


                        await ClassroomMethods(classId)
                            .createANewClassroom(
                                context, _textController.text, selectedNumber)

                            .then((value) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectATeacherTab(classId: classId,)
                              ));
                            }).onError((error, stackTrace) {
                          showSnackBar(context, error.toString());
                        });
                      },
                      child: Text('انشئ'),
                    ),
                    const Expanded(flex: 3, child: SizedBox())
                  ])),
            ))));
  }
}
