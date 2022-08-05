import 'package:codex/data/models/Corpus.dart';

class EditArguments {
  final Corpus corpus;
  final List<int> fileIDs;

  EditArguments({
    this.corpus,
    this.fileIDs,
  });
}
