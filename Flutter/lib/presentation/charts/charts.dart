import 'package:codex/data/models/FileTopic.dart';
import 'package:codex/data/models/Topic.dart';
import 'package:codex/data/models/Word.dart';
import 'package:codex/data/models/YearFileInfo.dart';
import 'package:codex/presentation/charts/Series.dart';
import 'package:codex/presentation/styles.dart';
import 'package:codex/presentation/widgets/shadowBorder.dart';
import 'package:codex/services.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:intl/intl.dart';

// FUNCTIONS

List<Color> colorTheme = [
  Color(0xff1f77b4),
  Color(0xffff7f0e),
  Color(0xff2ca02c),
  Color(0xffd62728),
  Color(0xff9467bd),
  Color(0xff8c564b),
  Color(0xffe377c2),
  Color(0xff7f7f7f),
  Color(0xffbcbd22),
  Color(0xff17becf),
];

charts.Color getChartColor(Color color) {
  return charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

// TOPICS

class TopicBarChart extends StatelessWidget {
  TopicBarChart({this.data, this.isOpen});

  List<Topic> data;
  bool isOpen;
  @override
  Widget build(BuildContext context) {
    final List<TopicSeries> serie = toSerie(data);

    List<charts.Series<TopicSeries, String>> series = [
      charts.Series(
          id: "Topics",
          data: serie,
          domainFn: (TopicSeries series, _) => series.topic.toString(),
          measureFn: (TopicSeries series, _) => series.weight,
          colorFn: (TopicSeries series, _) => series.barColor,
          labelAccessorFn: (TopicSeries series, _) => '${series.weight}'),
    ];

    return Column(
      children: [
        Expanded(
          child: charts.BarChart(
            series,
            animate: true,
            //barRendererDecorator: new charts.BarLabelDecorator<String>(),
            // domainAxis: new charts.OrdinalAxisSpec(
            //     renderSpec: charts.SmallTickRendererSpec(
            //   //
            //   // Rotation Here,
            //   labelRotation: 45,
            // )),
            domainAxis: new charts.OrdinalAxisSpec(
                // Make sure that we draw the domain axis line.
                showAxisLine: true,
                // But don't draw anything else.
                renderSpec: new charts.NoneRenderSpec()),
          ),
        ),
        SizedBox(height: 8.0),
        if (!isOpen) TopicLegendWidget(topics: data, mode: false),
        SizedBox(height: 16.0),
        Text(
          "Weight by topic",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  List<TopicSeries> toSerie(List<Topic> data) {
    List<TopicSeries> serie = [];
    int i = 0;
    for (var topic in data) {
      var temp = TopicSeries(
        topic: topic.id,
        percent: topic.percent.toInt(),
        weight: topic.weight,
        barColor: getChartColor(colorTheme[i]),
      );
      serie.add(temp);
      i++;
    }

    return serie;
  }
}

class TopicPieChart extends StatelessWidget {
  List<Topic> data;
  bool isOpen;

  TopicPieChart({this.data, this.isOpen});

  @override
  Widget build(BuildContext context) {
    final List<TopicSeries> serie = toSerie(data);

    List<charts.Series<TopicSeries, String>> series = [
      charts.Series(
          id: "Subscribers",
          data: serie,
          domainFn: (TopicSeries series, _) => series.topic.toString(),
          measureFn: (TopicSeries series, _) => series.percent.toInt(),
          colorFn: (TopicSeries series, _) => series.barColor,
          labelAccessorFn: (TopicSeries series, _) => '${series.topic}'),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: charts.PieChart(
            series,
            animate: true,
            defaultRenderer: charts.ArcRendererConfig(
                arcWidth: 50, arcRendererDecorators: []),
          ),
        ),
        SizedBox(height: 8.0),
        if (!isOpen) TopicLegendWidget(topics: data, mode: true),
        SizedBox(height: 16.0),
        Text(
          "Distribution (%) by topic",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  List<TopicSeries> toSerie(List<Topic> data) {
    List<TopicSeries> serie = [];
    int i = 0;
    for (var topic in data) {
      var temp = TopicSeries(
        topic: topic.id,
        percent: topic.percent.toInt(),
        weight: topic.weight,
        barColor: getChartColor(colorTheme[i]),
      );
      serie.add(temp);
      i++;
    }

    return serie;
  }
}

class TopicLegendWidget extends StatelessWidget {
  TopicLegendWidget({
    Key key,
    this.topics,
    this.mode,
  }) : super(key: key);

  List<Topic> topics;
  bool mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getSize(context) ? 2 : 6,
            childAspectRatio: getSize(context) ? 4 : 6),
        itemCount: 10,
        itemBuilder: (context, index) {
          return TopicLegendItem(
              color: colorTheme[index],
              index: index,
              topic: topics[index],
              mode: mode);
        },
      ),
    );
  }
}

class TopicLegendItem extends StatelessWidget {
  TopicLegendItem({
    Key key,
    this.color,
    this.index,
    this.topic,
    this.mode,
  }) : super(key: key);

  var color;
  int index;
  Topic topic;
  bool mode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(topic.id.toString());
        Navigator.pushNamed(context, '/topic', arguments: topic);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "top.${topic.id}",
                  style: TextStyle(color: Colors.white),
                ),
                VerticalDivider(
                  thickness: 1,
                )
              ],
            ),
            Text(
              mode ? "${topic.percent.toInt()}%" : "${topic.weight.toInt()}",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        decoration: ShadowBorder(32, 32, colorTheme[index]),
      ),
    );
  }
}

// WORDS

class WordBarChart extends StatelessWidget {
  WordBarChart({this.data, this.isOpen});

  var data;
  bool isOpen;
  @override
  Widget build(BuildContext context) {
    final List<WordSeries> serie = toSerie(data);

    List<charts.Series<WordSeries, String>> series = [
      charts.Series(
          id: "Topics",
          data: serie,
          domainFn: (WordSeries series, _) => series.word,
          measureFn: (WordSeries series, _) => series.percent,
          colorFn: (WordSeries series, _) => series.barColor,
          labelAccessorFn: (WordSeries series, _) => '${series.percent}'),
    ];

    return Column(
      children: [
        Expanded(
          child: charts.BarChart(
            series,
            animate: true,
            animationDuration: Duration(milliseconds: 50),
            domainAxis: new charts.OrdinalAxisSpec(
                // Make sure that we draw the domain axis line.
                showAxisLine: true,
                // But don't draw anything else.
                renderSpec: new charts.NoneRenderSpec()),
            //barRendererDecorator: new charts.BarLabelDecorator<String>(),
          ),
        ),
        SizedBox(height: 8.0),
        if (!isOpen) WordLegendWidget(words: data, mode: false),
        SizedBox(height: 16.0),
        Text(
          "Weight by word",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  List<WordSeries> toSerie(List<Word> data) {
    List<WordSeries> serie = [];
    int i = 0;
    for (var word in data) {
      var temp = WordSeries(
        word: word.word_id.toString(),
        percent: word.percent.toInt(),
        weight: word.weight,
        barColor: getChartColor(colorTheme[i]),
      );
      serie.add(temp);
      i++;
    }

    return serie;
  }
}

class WordPieChart extends StatelessWidget {
  var data;
  bool isOpen;

  WordPieChart({this.data, this.isOpen});

  @override
  Widget build(BuildContext context) {
    final List<WordSeries> serie = toSerie(data);

    List<charts.Series<WordSeries, String>> series = [
      charts.Series(
          id: "Subscribers",
          data: serie,
          domainFn: (WordSeries series, _) => series.word.toString(),
          measureFn: (WordSeries series, _) => series.percent,
          colorFn: (WordSeries series, _) => series.barColor,
          labelAccessorFn: (WordSeries series, _) => '${series.word}'),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: charts.PieChart(
            series,
            animate: true,
            defaultRenderer: charts.ArcRendererConfig(
                arcWidth: 50, arcRendererDecorators: []),
          ),
        ),
        SizedBox(height: 8.0),
        if (!isOpen) WordLegendWidget(words: data, mode: true),
        SizedBox(height: 16.0),
        Text(
          "Distribution (%) by word",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  List<WordSeries> toSerie(List<Word> data) {
    List<WordSeries> serie = [];
    int i = 0;
    for (var word in data) {
      var temp = WordSeries(
        word: word.id.toString(),
        percent: word.percent.toInt(),
        weight: word.weight,
        barColor: getChartColor(colorTheme[i]),
      );
      serie.add(temp);
      i++;
    }

    return serie;
  }
}

class WordLegendWidget extends StatelessWidget {
  WordLegendWidget({
    Key key,
    this.words,
    this.mode,
  }) : super(key: key);

  List<Word> words;
  bool mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getSize(context) ? 2 : 6,
            childAspectRatio: getSize(context) ? 4 : 6),
        itemCount: 10,
        itemBuilder: (context, index) {
          return WordLegendItem(
              color: colorTheme[index],
              index: index,
              word: words[index],
              mode: mode);
        },
      ),
    );
  }
}

class WordLegendItem extends StatelessWidget {
  WordLegendItem({
    Key key,
    this.color,
    this.index,
    this.word,
    this.mode,
  }) : super(key: key);

  var color;
  int index;
  Word word;
  bool mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              word.word,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Text(mode ? "${word.percent.toInt()}%" : "${word.weight.toInt()}",
              style: TextStyle(color: Colors.white)),
        ],
      ),
      decoration: ShadowBorder(32, 32, colorTheme[index]),
    );
  }
}

// FILE TOPICS

class FileView extends StatelessWidget {
  FileView({Key key, this.data}) : super(key: key);

  List<FileTopic> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.0),
        Expanded(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return FileItem(
                  index: index, file: data[index], color: colorTheme[index]);
            },
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          "Top ${data.length} files",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class FileItem extends StatelessWidget {
  FileItem({Key key, this.index, this.file, this.color}) : super(key: key);

  final int index;
  final FileTopic file;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      margin: EdgeInsets.only(bottom: 8.0),
      height: 75,
      decoration: ShadowBorder(16, 16, color),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Flexible(
                      child: Text(file.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ))),
                ]),
                Text("${file.creationTime}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${file.nbPages.toString()} Pages",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        )),
                    SizedBox(width: 8.0),
                    Text(file.language,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        )),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// YEARS

class YearChart extends StatelessWidget {
  YearChart({this.data, this.isOpen});

  var data;
  bool isOpen;

  @override
  Widget build(BuildContext context) {
    final List<List<YearSeries>> serie = toSerie(data);
    var formatter = NumberFormat('###000');

    List<charts.Series<YearSeries, int>> series = [
      charts.Series(
        id: "0",
        data: serie[0],
        domainFn: (YearSeries series, _) => series.datetime_int,
        measureFn: (YearSeries series, _) => series.nb_file,
        colorFn: (YearSeries series, _) => series.barColor,
      ),
      charts.Series(
        id: "1",
        data: serie[1],
        domainFn: (YearSeries series, _) => series.datetime_int,
        measureFn: (YearSeries series, _) => series.nb_file,
        colorFn: (YearSeries series, _) => series.barColor,
      ),
      charts.Series(
        id: "2",
        data: serie[2],
        domainFn: (YearSeries series, _) => series.datetime_int,
        measureFn: (YearSeries series, _) => series.nb_file,
        colorFn: (YearSeries series, _) => series.barColor,
      ),
    ];

    int min = 2015;
    int max = 2015;

    for (var item in serie) {
      if (int.parse(item.first.datetime) < min)
        min = int.parse(item.first.datetime);
      if (int.parse(item.last.datetime) > max)
        max = int.parse(item.last.datetime);
    }

    return Column(
      children: [
        Expanded(
          child: charts.LineChart(
            series,
            defaultRenderer: charts.LineRendererConfig(
              includePoints: true,
            ),
            domainAxis: charts.NumericAxisSpec(
              viewport: charts.NumericExtents(min - 2, max + 2),
              tickFormatterSpec:
                  charts.BasicNumericTickFormatterSpec.fromNumberFormat(
                      formatter),
              tickProviderSpec: new charts.BasicNumericTickProviderSpec(
                zeroBound: false,
                dataIsInWholeNumbers: true,
                desiredTickCount: 6,
              ),
            ),
            animate: true,
          ),
        ),
        SizedBox(height: 8.0),
        if (!isOpen) YearLegendWidget(years: data),
        SizedBox(height: 16.0),
        Text(
          " Evolution of dominant topics over time",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  List<List<YearSeries>> toSerie(List<List<YearFileInfo>> data) {
    List<List<YearSeries>> serie = [];

    for (var topic in data) {
      Map<String, YearSeries> temp = {};
      for (var item in topic) {
        if (temp.containsKey(item.datetime)) {
          temp[item.datetime].nb_file++;
        } else {
          temp[item.datetime] = YearSeries(
            datetime_int: int.parse(item.datetime),
            topic_id: item.topic_id,
            datetime: item.datetime,
            nb_file: 1,
            barColor: item.topic_id % 10 - 1 == -1
                ? getChartColor(colorTheme[9])
                : getChartColor(colorTheme[item.topic_id % 10 - 1]),
          );
        }
      }

      List<YearSeries> tempSerie = [];
      for (var item in temp.values) {
        tempSerie.add(item);
      }

      serie.add(tempSerie);
    }

    return serie;
  }
}

class YearLegendWidget extends StatelessWidget {
  YearLegendWidget({
    Key key,
    this.years,
  }) : super(key: key);

  List<List<YearFileInfo>> years;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: getSize(context) ? 2.5 : 10),
        itemCount: 3,
        itemBuilder: (context, index) {
          return YearLegendItem(index: index, topic: years[index][0]);
        },
      ),
    );
  }
}

class YearLegendItem extends StatelessWidget {
  YearLegendItem({
    Key key,
    this.index,
    this.topic,
  }) : super(key: key);

  int index;
  YearFileInfo topic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Topic temp = Topic(
            id: topic.topic_id,
            weight: topic.weight,
            parent_id: topic.parent_id,
            percent: topic.percent);
        Navigator.pushNamed(context, '/topic', arguments: temp);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                "Topic ${topic.topic_id}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        decoration: topic.topic_id % 10 - 1 == -1
            ? ShadowBorder(32, 32, colorTheme[9])
            : ShadowBorder(32, 32, colorTheme[topic.topic_id % 10 - 1]),
      ),
    );
  }
}
