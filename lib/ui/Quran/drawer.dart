import 'package:flutter/material.dart';


import 'Quranmain.dart';
import 'listofsurahs.dart';


class surahDrawer extends StatefulWidget {
  const surahDrawer({Key? key}) : super(key: key);

  @override
  _surahDrawerState createState() => _surahDrawerState();
}

class _surahDrawerState extends State<surahDrawer> {
  late String _place;
  late String _placeAr;
  late int _count;
  late String _titleAr;
  late int _index;
  late int _pages;
  late int _pageNum;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
          itemCount: listOfSurah.length,
          itemBuilder: (BuildContext context, int index){

          _place= listOfSurah[index]['place'] as String;
          _count= listOfSurah[index]['count'] as int;
          _titleAr= listOfSurah[index]['titleAr'] as String;
          _index= index+1;
          _pages= listOfSurah[index]['pages'] as int;
          _pageNum= listOfSurah[index]['pages'] as int;

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Image.asset("lib/assets/photos/$_place.png"),
            ),
            title: Text(_titleAr,style: TextStyle(fontFamily: 'kb')),
            subtitle: Text("رقمها $_index - آياتها $_count ",style: TextStyle(fontFamily: 'kb')),
            trailing: CircleAvatar(
              backgroundColor: Colors.white54,
               child: Text("$_pageNum", style: TextStyle(color: Colors.black,fontFamily: 'kb'),)
            ),
            onTap:() {
              _pages= listOfSurah[index]['pages'] as int;
              pdfViewerController.jumpToPage(_pages);
              Navigator.pop(context, true);},
          ),
        );
      }),

    );
  }
}
