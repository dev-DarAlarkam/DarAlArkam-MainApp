import 'package:flutter/material.dart';

class AdhkarButton extends StatelessWidget {
  final String? bg;
  final StatefulWidget nextScreen;
  const AdhkarButton({Key? key, required this.bg, required this.nextScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> nextScreen));
      },
      child: Container(
        height: 90,
        width: 318,

        decoration: BoxDecoration(
          color: const Color.fromRGBO(249, 191, 24, 1),
          borderRadius: BorderRadiusDirectional.circular(10),
          image: DecorationImage(
            image: AssetImage(bg!),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}