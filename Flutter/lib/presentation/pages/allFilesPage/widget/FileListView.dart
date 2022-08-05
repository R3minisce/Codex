import 'package:codex/data/models/FileInfo.dart';
import 'package:codex/data/models/FileTopic.dart';

import 'package:codex/presentation/widgets/shadowBorder.dart';
import 'package:codex/providers.dart';
import 'package:codex/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListViewBuilder extends StatefulWidget {
  ListViewBuilder({
    Key key,
  }) : super(key: key);

  @override
  _ListViewBuilderState createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  List<FileInfo> data;
  List<FileInfo> currentData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFilesInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("[ ERROR : DATA FETCH ]");
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          data = snapshot.data;
          return Consumer(
            builder: (context, watch, _) {
              final search = watch(searchProvider).state.toLowerCase();
              currentData = data
                  .where((file) => file.title.toLowerCase().contains(search))
                  .toList();

              final yearSearch = watch(yearSearchProvider).state.toLowerCase();
              currentData = currentData
                  .where((file) =>
                      file.creationTime.toLowerCase().contains(yearSearch))
                  .toList();

              final wordSearch = watch(wordSearchProvider).state.toLowerCase();
              currentData = currentData
                  .where((file) => file.words.toString().contains(wordSearch))
                  .toList();

              final topicSearch =
                  watch(topicSearchProvider).state.toLowerCase();
              currentData = currentData
                  .where((file) =>
                      file.dominant_topics.toString().contains(topicSearch))
                  .toList();

              final langSearch = watch(langSearchProvider).state.toLowerCase();
              currentData = currentData
                  .where((file) =>
                      file.language.toLowerCase().contains(langSearch))
                  .toList();

              final corpusSearch =
                  watch(corpusSearchProvider).state.toLowerCase();
              currentData = currentData
                  .where(
                      (file) => file.corpuses.toString().contains(corpusSearch))
                  .toList();
              return RefreshIndicator(
                  onRefresh: refresh,
                  child: FileView(
                    data: currentData,
                  ));
            },
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    setState(() {});
  }
}

class FileView extends StatelessWidget {
  FileView({Key key, this.data}) : super(key: key);

  List<FileInfo> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text((data.length == 0)
            ? "${data.length} result"
            : "${data.length} results"),
        SizedBox(height: 4.0),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return FileItem(index: index, file: data[index]);
            },
          ),
        ),
      ],
    );
  }
}

class FileItem extends StatelessWidget {
  FileItem({Key key, this.index, this.file}) : super(key: key);

  final int index;
  final FileInfo file;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.only(bottom: 8.0),
      height: 75,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(16),
      ),
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
                              fontSize: 12, fontWeight: FontWeight.bold))),
                ]),
                Text("${file.creationTime}", style: TextStyle(fontSize: 12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${file.nbPages.toString()} Pages",
                        style: TextStyle(fontSize: 12)),
                    SizedBox(width: 8.0),
                    Text(file.language, style: TextStyle(fontSize: 12)),
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
