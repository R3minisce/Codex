import 'package:codex/data/models/Corpus.dart';
import 'package:codex/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:codex/presentation/styles.dart';
import 'package:codex/presentation/widgets/Balls.dart';
import 'package:codex/providers.dart';

class BodyGridView extends StatefulWidget {
  BodyGridView({
    Key key,
    this.isEdit,
  }) : super(key: key);

  final bool isEdit;

  @override
  _BodyGridViewState createState() => _BodyGridViewState();
}

class _BodyGridViewState extends State<BodyGridView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Corpuses"),
            Divider(
              color: lightBlack,
              thickness: 0.5,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Container(
                  width: double.maxFinite,
                  color: Colors.white,
                  child: DataGridView(isEdit: widget.isEdit),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataGridView extends StatefulWidget {
  DataGridView({
    Key key,
    this.isEdit,
  }) : super(key: key);

  final bool isEdit;

  @override
  _DataGridViewState createState() => _DataGridViewState();
}

class _DataGridViewState extends State<DataGridView> {
  List<Corpus> currentCorpus;
  List<Corpus> allCorpus;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Corpus>>(
      future: getAllCorpuses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("[ ERROR : CORPUS FETCH ]");
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          allCorpus = snapshot.data;
          return Consumer(
            builder: (context, watch, _) {
              final search = watch(searchProvider).state.toLowerCase();
              currentCorpus = allCorpus
                  .where((corpus) => corpus.name.toLowerCase().contains(search))
                  .toList();

              return RefreshIndicator(
                onRefresh: refresh,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getSize(context) ? 3 : 10,
                      childAspectRatio: 0.9),
                  itemCount: currentCorpus.length,
                  itemBuilder: (context, index) {
                    return CorpusItem(
                        isEdit: widget.isEdit,
                        index: index,
                        corpus: currentCorpus[index]);
                  },
                ),
              );
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

class CorpusItem extends StatefulWidget {
  const CorpusItem({
    Key key,
    this.isEdit,
    this.index,
    this.corpus,
  }) : super(key: key);

  final bool isEdit;
  final int index;
  final Corpus corpus;

  @override
  _CorpusItemState createState() => _CorpusItemState();
}

class _CorpusItemState extends State<CorpusItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.corpus.best_topic != 0)
          if (widget.isEdit)
            Row(
              children: [
                Balls(
                    ballColor: widget.corpus.is_selected
                        ? lightBlack
                        : Colors.white60),
              ],
            ),
        if (widget.corpus.best_topic != 0)
          InkWell(
            onTap: () {
              if (widget.isEdit)
                setState(() {
                  widget.corpus.is_selected = !widget.corpus.is_selected;
                  toogleCorpusSelection(widget.corpus);
                });
              else {
                Navigator.pushNamed(context, '/card', arguments: widget.corpus);
              }
            },
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image(
                        image: AssetImage('assets/repo.png'),
                        height: 60,
                        width: 60),
                    Container(
                      margin: EdgeInsets.only(top: 12.0),
                      child: Text(
                        widget.corpus.id.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.corpus.name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
      ],
    );
  }
}
