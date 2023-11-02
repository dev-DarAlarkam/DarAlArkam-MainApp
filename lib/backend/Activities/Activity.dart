import 'package:daralarkam_main_app/backend/counter/getCounter.dart';

class Activity {
  late String id;
  late String title;
  late String content;
  late String date;
  late String thumbnail;
  late List<String> additionalMedia;

  Activity({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.thumbnail,
    required this.additionalMedia
  });

  // Factory constructor with default values and special id
  factory Activity.empty() {
    return Activity(
      id: 'activity_${DateTime.now().millisecondsSinceEpoch}',
      title: '',
      content: '',
      date: getFormattedDate(),
      thumbnail: '',
      additionalMedia: [],
    );
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      date: json['date'] as String,
      thumbnail: json['thumbnail'] as String,
      additionalMedia: (json['additionalMedia'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }


  void updateTitle(String newTitle) {
    title = newTitle;
  }
  void updateContent(String newContent) {
    content = newContent;
  }
  void updateDate(String newDate) {
    date = newDate;
  }
  void updateThumbnail(String newThumbnail) {
    thumbnail = newThumbnail;
  }
  void updateAdditionalMedia(List<String> newAdditionalMedia) {
    additionalMedia = newAdditionalMedia;
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'title': title,
    'content': content,
    'date' : date,
    'thumbnail': thumbnail,
    'additionalMedia': additionalMedia,
  };
}