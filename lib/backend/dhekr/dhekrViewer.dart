import 'dart:core';

import 'package:daralarkam_main_app/backend/users/counter.dart';


class Dhekr{
  Map<String,int> list;
  int index=0,counter=0;
  List<String> keys;

  Dhekr(this.list, this.keys);

  void jumpToNext() {
    counter = 0;
    index++;
    if(index == keys.length){
      index = 0;
    }
  }

  void next() {
    if(list[keys[index]]!> counter){
      ++counter;
    }
    else{
        jumpToNext();
    }
  }
  void prev() {
    counter = 0;
    index--;
    if(index<0){
      index= keys.length -1;
    }
  }

  Set<String> current() => {
      keys[index],
      list[keys[index]].toString()
    };
}