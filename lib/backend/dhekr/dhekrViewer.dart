import 'dart:core';

class Viewer{
  int index=0,counter=0;
  List<String> keys,comments;

  Viewer(this.keys, this.comments);

  void next() {
    index++;
    if(index == keys.length){
      index = 0;
    }
  }
  void previous() {
    index--;
    if(index<0){
      index= keys.length -1;
    }
  }

  List<String> current() => [
      keys[index],
      comments[index]
    ];
}