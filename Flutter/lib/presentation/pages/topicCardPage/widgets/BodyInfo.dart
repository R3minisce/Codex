import 'package:codex/data/models/Topic.dart';
import 'package:codex/data/models/Word.dart';
import 'package:codex/presentation/blocs/LegendCubit.dart';
import 'package:codex/presentation/charts/charts.dart';
import 'package:codex/presentation/styles.dart';
import 'package:codex/presentation/widgets/shadowBorder.dart';
import 'package:codex/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BodyInfo extends StatelessWidget {
  BodyInfo({
    Key key,
    this.topic,
  }) : super(key: key);

  Topic topic;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    double fontSize = getSize(context) ? 12 : 16;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Topic ${topic.id}",
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  " (corpus ${topic.parent_id})",
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Container(
            //     height: getSize(context) ? 80 : 100,
            //     width: double.maxFinite,
            //     decoration: ShadowBorder(16.0, 16.0, lightBlack),
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 16.0),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           // TODO TOPIC INFO
            //           // Text("Best topic : ${corpus.best_topic}",
            //           //     style:
            //           //         TextStyle(color: Colors.white, fontSize: fontSize)),
            //           // Text("${corpus.nbFile} Files",
            //           //     style:
            //           //         TextStyle(color: Colors.white, fontSize: fontSize)),
            //           // Text("Last process : 14 July 2021",
            //           //     style:
            //           //         TextStyle(color: Colors.white, fontSize: fontSize)),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getSize(context) ? 0.0 : 10.0),
                child: PageView(
                  controller: pageController,
                  children: [
                    GraphViewBuilder(
                      id: topic.id,
                      func: getWordByTopicId(topic.id),
                      child: 1,
                    ),
                    GraphViewBuilder(
                      id: topic.id,
                      func: getWordByTopicId(topic.id),
                      child: 2,
                    ),
                    GraphViewBuilder(
                      id: topic.id,
                      func: getFilesByTopicId(topic.id),
                      child: 3,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
                  effect: WormEffect(
                      activeDotColor: Colors.red, dotHeight: 6, dotWidth: 24),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class GraphViewBuilder extends StatelessWidget {
  GraphViewBuilder({
    Key key,
    this.id,
    this.func,
    this.child,
  }) : super(key: key);

  int id;
  var func;
  var data;
  var child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: func,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("[ ERROR : DATA FETCH ]");
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          data = snapshot.data;
          switch (child) {
            case 1:
              return BlocBuilder<LegendCubit, bool>(builder: (context, isOpen) {
                return WordBarChart(data: data, isOpen: isOpen);
              });
              break;
            case 2:
              return BlocBuilder<LegendCubit, bool>(builder: (context, isOpen) {
                return WordPieChart(data: data, isOpen: isOpen);
              });
              break;
            case 3:
              return FileView(
                data: data,
              );
              break;

            default:
              return Container();
          }
        }
      },
    );
  }
}
