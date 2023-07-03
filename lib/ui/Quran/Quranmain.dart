import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../widgets/my-flutter-app-icons.dart';
import 'drawer.dart';


late PdfViewerController pdfViewerController;

class Quran extends StatefulWidget {
  const Quran({Key? key}) : super(key: key);

  @override
  _QuranState createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  @override
  void initState() {
    super.initState();
    pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            drawer: const surahDrawer(),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme:
                  const IconThemeData(color: Color.fromRGBO(15, 148, 71, 1), size: 30
                      //change your color here
                      ),
              actions: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0
                  ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(
                      MyFlutterApp.arrow_left,
                      color: Color.fromRGBO(15, 148, 71, 1),
                      size: 20,
                    ),
                    label: const Text(" ")
                ),

              ],
            ),
            body: Container(
                child: Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.72,
                    child: FutureBuilder(
                        builder: (context, snapshot) {
                          return SfPdfViewer.asset('lib/assets/pdf/Quran_Hafs_M.pdf',
                              controller: pdfViewerController,
                              scrollDirection: PdfScrollDirection.vertical,
                              canShowScrollHead: false,
                              canShowScrollStatus: false,
                              enableDoubleTapZooming: true,
                              pageSpacing: 0,
                              pageLayoutMode: PdfPageLayoutMode.continuous,

                          );
                        }
                        ),
                  ),
                )
            )
        ),
      ),
    );
  }
}
