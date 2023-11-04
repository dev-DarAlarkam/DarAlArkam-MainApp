import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';



Widget buildThumbnail(String url) =>CachedNetworkImage(
  imageUrl: generateDirectDownloadUrl(url),
  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  fit: BoxFit.fitWidth,
);

Widget buildImage(BuildContext context, String url, int index) {
  return GestureDetector(
    onTap: () => openImageViewer(context, url),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: CachedNetworkImage(
        imageUrl: generateDirectDownloadUrl(url),
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.fitWidth,
      ),
    ),
  );
}

void openImageViewer(BuildContext context, String imageUrl) {
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight,
  DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: Colors.transparent, //for hiding the appBar
            elevation: 0,
          ),
          extendBodyBehindAppBar: true,// You can customize the app bar here
          body: PhotoView(
            imageProvider: NetworkImage(generateDirectDownloadUrl(imageUrl)),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          ),
        ),
      );
    },
  )).then((_) {
    // Reset the orientation to portrait when you exit the image viewer
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  });;
}

String generateDirectDownloadUrl(String originalUrl) {
  final urlParts = Uri.parse(originalUrl).pathSegments;
  final fileId = urlParts[urlParts.indexOf('d') + 1];
  final directDownloadUrl =
      'https://drive.google.com/uc?export=download&id=$fileId';
  return directDownloadUrl;
}

