import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewUserTab extends StatefulWidget {
  const NewUserTab({Key? key}) : super(key: key);

  @override
  _NewUserTabState createState() => _NewUserTabState();
}

class _NewUserTabState extends State<NewUserTab> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
        )
    );
  }
}
