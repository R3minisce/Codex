import 'package:codex/data/models/File.dart';
import 'package:codex/data/models/FileInfo.dart';
import 'package:codex/presentation/blocs/FilterCubit.dart';
import 'package:codex/presentation/pages/allFilesPage/widget/FilterBox.dart';
import 'package:codex/presentation/styles.dart';
import 'package:codex/presentation/widgets/Balls.dart';
import 'package:codex/presentation/widgets/SearchBar.dart';
import 'package:codex/providers.dart';
import 'package:codex/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BodyGridView extends StatefulWidget {
  BodyGridView({
    Key key,
  }) : super(key: key);

  @override
  _BodyGridViewState createState() => _BodyGridViewState();
}

class _BodyGridViewState extends State<BodyGridView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(" Files"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(
              color: lightBlack,
              thickness: 0.5,
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SearchBar(
                color: lightBlack,
                hintLabel: "search",
                textColor: Colors.white),
          ),
          SizedBox(height: 8.0),
          BlocBuilder<FilterCubit, bool>(builder: (context, opened) {
            if (opened) return FilterBox();
            return Container();
          }),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              width: double.maxFinite,
              color: Colors.white,
              child: DataListView(),
            ),
          ),
        ],
      ),
    );
  }
}

class DataListView extends StatefulWidget {
  DataListView({
    Key key,
  }) : super(key: key);

  @override
  _DataListViewState createState() => _DataListViewState();
}

class _DataListViewState extends State<DataListView> {
  List<FileInfo> currentFiles = [];
  List<FileInfo> allFiles = [];
  bool toogleSelect = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileInfo>>(
      future: getFilesInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("[ ERROR : FILES FETCH ]");
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          allFiles = snapshot.data;
          return Consumer(
            builder: (context, watch, _) {
              final search = watch(searchProvider).state.toLowerCase();
              currentFiles = allFiles
                  .where(
                      (corpus) => corpus.title.toLowerCase().contains(search))
                  .toList();

              final yearSearch = watch(yearSearchProvider).state.toLowerCase();
              currentFiles = currentFiles
                  .where((file) =>
                      file.creationTime.toLowerCase().contains(yearSearch))
                  .toList();

              final wordSearch = watch(wordSearchProvider).state.toLowerCase();
              currentFiles = currentFiles
                  .where((file) => file.words.toString().contains(wordSearch))
                  .toList();

              final topicSearch =
                  watch(topicSearchProvider).state.toLowerCase();
              currentFiles = currentFiles
                  .where((file) =>
                      file.dominant_topics.toString().contains(topicSearch))
                  .toList();

              final langSearch = watch(langSearchProvider).state.toLowerCase();
              currentFiles = currentFiles
                  .where((file) =>
                      file.language.toLowerCase().contains(langSearch))
                  .toList();

              final corpusSearch =
                  watch(corpusSearchProvider).state.toLowerCase();
              currentFiles = currentFiles
                  .where(
                      (file) => file.corpuses.toString().contains(corpusSearch))
                  .toList();

              return RefreshIndicator(
                  onRefresh: refresh,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(currentFiles.length == 0
                              ? "${currentFiles.length} result"
                              : "${currentFiles.length} results"),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  restFileSelection();
                                },
                                icon: Icon(Icons.delete_sweep),
                                iconSize: 24,
                              ),
                              IconButton(
                                onPressed: () async {
                                  try {
                                    reset(); // No unawaited error here
                                  } catch (e) {
                                    print("caught $e");
                                  }
                                },
                                icon: Icon(Icons.playlist_add_check),
                                iconSize: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: currentFiles.length,
                          itemBuilder: (context, index) {
                            return FileItem(
                                index: index, file: currentFiles[index]);
                          },
                        ),
                      ),
                    ],
                  ));
            },
          );
        }
      },
    );
  }

  Future<void> reset() async {
    List<int> list = [];
    for (var file in currentFiles) {
      list.add(file.id);
    }
    await toogleAllFileSelection(list);
  }

  Future<void> refresh() async {
    setState(() {});
  }
}

class FileItem extends StatefulWidget {
  FileItem({
    Key key,
    this.index,
    this.file,
  }) : super(key: key);

  final int index;
  final FileInfo file;

  @override
  _FileItemState createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            widget.file.is_selected = !widget.file.is_selected;
            toogleFileSelection(widget.file.id);
          });
        },
        child: Container(
          height: 90,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.black12,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Balls(
                  ballColor: widget.file.is_selected // ICI
                      ? lightBlack
                      : Colors.white60,
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(
                            child: Text(widget.file.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold))),
                      ]),
                      Text("${widget.file.creationTime}",
                          style: TextStyle(fontSize: 12)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("${widget.file.nbPages} Pages",
                              style: TextStyle(fontSize: 12)),
                          SizedBox(width: 8.0),
                          Text(widget.file.language,
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
