import 'package:carousel_slider/carousel_slider.dart';
import 'package:daralarkam_main_app/backend/Activities/Activity.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transparent_image/transparent_image.dart';

class ActivityViewer extends StatefulWidget {
  final Activity activity;
  const ActivityViewer({super.key, required this.activity});

  @override
  State<ActivityViewer> createState() => _ActivityViewerState();
}

class _ActivityViewerState extends State<ActivityViewer> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Stack(
            children: [
              Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                      width: double.maxFinite,
                      height: height * 0.35,
                      child: Stack(
                        children: [
                          const Center(
                            child:
                                CircularProgressIndicator(), // Loading indicator
                          ),
                          Center(
                            child: FadeInImage.memoryNetwork(
                              placeholder:
                                  kTransparentImage, // A 1x1 transparent image as a placeholder.
                              image: generateDirectDownloadUrl(
                                  widget.activity.thumbnail),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ],
                      ))),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.green,
                    )),
              ),
              Positioned(
                  top: height * 0.3,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 30),
                    width: width,
                    height: height * 0.8,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          boldColoredArabicText(widget.activity.title),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(widget.activity.date),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(widget.activity.content),
                          const SizedBox(
                            height: 20,
                          ),
                          buildIndicator(),
                          const SizedBox(
                            height: 30,
                          ),
                          buildImageSlider(),
                          const SizedBox(
                            height: 20,
                          ),
                          buildIndicator()
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        )));
  }

  Widget buildImageSlider() => CarouselSlider.builder(
        itemCount: widget.activity.additionalMedia.length,
        options: CarouselOptions(
            initialPage: 0,
            enlargeCenterPage: true,
            height: MediaQuery.of(context).size.height * 0.5,
            onPageChanged: (index, reason) =>
                setState(() => activeIndex = index)),
        itemBuilder: (context, index, realIndex) {
          final urlImage = widget.activity.additionalMedia[index];

          return buildImage(urlImage, index);
        },
      );
  Widget buildImage(String url, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Stack(
        children: [
          const Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
          Center(
            child: FadeInImage.memoryNetwork(
              placeholder:
                  kTransparentImage, // A 1x1 transparent image as a placeholder.
              image: generateDirectDownloadUrl(url),
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }

  String generateDirectDownloadUrl(String originalUrl) {
    final urlParts = Uri.parse(originalUrl).pathSegments;
    final fileId = urlParts[urlParts.indexOf('d') + 1];
    final directDownloadUrl =
        'https://drive.google.com/uc?export=download&id=$fileId';
    return directDownloadUrl;
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: widget.activity.additionalMedia.length,
        effect: const JumpingDotEffect(
            dotColor: Colors.grey,
            activeDotColor: Colors.green,
            dotHeight: 10,
            dotWidth: 10),
      );
}
