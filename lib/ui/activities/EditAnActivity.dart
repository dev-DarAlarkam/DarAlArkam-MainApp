import 'package:daralarkam_main_app/backend/Activities/activitMethods.dart';
import 'package:daralarkam_main_app/backend/counter/getCounter.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../backend/Activities/Activity.dart';

class EditAnActivityTab extends StatefulWidget {
  EditAnActivityTab({super.key, required this.activity});
  Activity activity;
  @override
  State<EditAnActivityTab> createState() => _EditAnActivityTabState();
}

class _EditAnActivityTabState extends State<EditAnActivityTab> {
  List<TextEditingController> textControllers = [TextEditingController()];
  TextEditingController _title = TextEditingController();
  TextEditingController _content = TextEditingController();
  TextEditingController _thumbnail = TextEditingController();
  DateTime _date = DateTime.now();
  String _formattedDate = "";


  void addTextField() {
    setState(() {
      if(textControllers.length < 10){
        textControllers.add(TextEditingController());
      }
    });
  }

  void removeTextField(int index) {
    setState(() {
      textControllers.removeAt(index);
    });
  }

  Future<void> saveActivity() async{
    List<String> _urls = [];
    for (TextEditingController controller in textControllers) {
      _urls.add(controller.text);
    }

    widget.activity.updateContent(_content.text);
    widget.activity.updateTitle(_title.text);
    widget.activity.updateThumbnail(_thumbnail.text);
    widget.activity.updateDate(_formattedDate);
    widget.activity.updateAdditionalMedia(_urls);

    await ActivityMethods(widget.activity.id)
        .updateAnActivityInFirestore(context, widget.activity);
  }



  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.activity.title);
    _content = TextEditingController(text: widget.activity.content);
    _thumbnail = TextEditingController(text: widget.activity.thumbnail);
    _formattedDate = widget.activity.date;
    for(int i=0; i<widget.activity.additionalMedia.length;++i){
      if(i<1){
        textControllers[i] = TextEditingController(text: widget.activity.additionalMedia[i]);
      } else {
        textControllers.add(TextEditingController(text: widget.activity.additionalMedia[i]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () async {
                  await _showSaveConfirmationDialog(context, widget.activity);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back)
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await saveActivity();
                  Navigator.of(context).pop();
                },
                child: boldColoredArabicText("حفظ", c: Colors.white),
              )
            ],
          ),

          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: width * 0.8,
                child: Column(
                  children: [
                    const SizedBox(height: 20,),

                    coloredArabicText("معلومات الغلاف"),

                    const SizedBox(height: 10,),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _title,
                        decoration: InputDecoration(labelText: 'عنوان الفعالية'),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: null, // This allows multiple lines of text input.
                        keyboardType: TextInputType.multiline, // Sets the keyboard to a multiline input mode.
                        controller: _content,
                        decoration: InputDecoration(labelText: 'ملخص الفعالية'),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _thumbnail,
                        decoration: InputDecoration(labelText: 'رابط صورة الغلاف'),
                      ),
                    ),

                    const SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1970),
                                lastDate: DateTime(2222))
                                .then((value) {
                              setState(() {
                                _date = value!;
                                _formattedDate = formatADate(_date);
                              });
                            });
                          },
                          child: coloredArabicText("إختر تاريخ الفعالية", c: Colors.white),
                        ),

                        coloredArabicText(_formattedDate)
                      ],
                    ),
                    const SizedBox(height: 20,),

                    coloredArabicText("صور إضافية"),

                    const SizedBox(height: 10,),

                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: addTextField,
                    ),

                    SingleChildScrollView(
                      child: SizedBox(
                        height: height*0.6,
                        child: ListView.builder(
                          itemCount: textControllers.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: textControllers[index],
                                      decoration: InputDecoration(labelText: 'رابط الصورة رقم ${index+1}'),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    removeTextField(index);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  Future<void> _showSaveConfirmationDialog(BuildContext context, Activity activity) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
      false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('تأكيد الحذف'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('هل تريد الخروج دون حفظ الفعالية؟'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('إلغاء'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                child: Text('حفظ'),
                onPressed: () async {
                  await saveActivity();
                  Navigator.of(dialogContext).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

}

