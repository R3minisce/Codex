import 'dart:convert';
import 'dart:typed_data';
import 'package:codex/data/models/Corpus.dart';
import 'package:codex/data/models/FileInfo.dart';
import 'package:codex/data/models/FileTopic.dart';
import 'package:codex/data/models/Topic.dart';
import 'package:codex/data/models/File.dart';
import 'package:codex/data/models/Word.dart';
import 'package:codex/data/models/YearFileInfo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

String apiIP = "192.168.0.33";
String apiPort = "5000";

//Corpus Services

List<Corpus> parseCorpuses(Uint8List responseBody) {
  List<Corpus> corpuses = [];

  final parsed = jsonDecode(utf8.decode(responseBody));

  parsed["corpuses"].forEach((corpus) {
    Corpus temp = Corpus();
    temp.fromJson(corpus);
    corpuses.add(temp);
  });
  return corpuses;
}

Future<List<Corpus>> getAllCorpuses() async {
  var uri = new Uri.http("$apiIP:$apiPort", '/corpus');
  final response = await Client().get(uri);
  return parseCorpuses(response.bodyBytes);
}

Future<bool> toogleCorpusSelection(Corpus corpus) async {
  var uri =
      new Uri.http("$apiIP:$apiPort", '/toogleCorpusSelection/${corpus.id}');
  final Response response = await put(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    //body: jsonEncode(corpus),
  );
  if (response.statusCode != 200) throw Exception(response.statusCode);
  return true;
}

Future<bool> deleteCorpus(Corpus corpus) async {
  var uri = new Uri.http("$apiIP:$apiPort", '/corpus/${corpus.id}');
  final Response response = await delete(
    uri,
  );
  if (response.statusCode != 200) throw Exception(response.statusCode);
  return true;
}

Future<bool> createCorpus(String name) async {
  // Récupération des fichiers sélectionnés
  var uri = new Uri.http("$apiIP:$apiPort", '/selectedFiles');
  Response response = await get(uri);
  var files = jsonDecode(response.body)["selected Files"];

  // Création du corpus avec les fichiers
  uri = new Uri.http("$apiIP:$apiPort", '/corpus');
  Map data = {"name": name, "fileIDs": files};
  String body = json.encode(data);

  response = await post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: body,
  );
  var id = jsonDecode(response.body)["id"];

  // Reset des fichiers sélectionnés
  uri = new Uri.http("$apiIP:$apiPort", '/fileSelectionReset');
  response = await get(uri);

  // Analyse du corpus
  uri = new Uri.http("$apiIP:$apiPort", '/analyseCorpus/${id}');
  response = await get(uri);

  return true;
}

Future<bool> updateCorpus(String name, int CorpusID) async {
  // Récupération des fichiers sélectionnés
  var uri = new Uri.http("$apiIP:$apiPort", '/selectedFiles');
  Response response = await get(uri);
  var files = jsonDecode(response.body)["selected Files"];

  // MAJ du corpus avec les fichiers
  uri = new Uri.http("$apiIP:$apiPort", '/corpus');
  Map data = {"id": CorpusID, "name": name, "fileIDs": files};
  String body = json.encode(data);

  response = await put(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: body,
  );
  var id = jsonDecode(response.body)["id"];

  // Reset des fichiers sélectionnés
  uri = new Uri.http("$apiIP:$apiPort", '/fileSelectionReset');
  response = await get(uri);

  // Analyse du corpus
  uri = new Uri.http("$apiIP:$apiPort", '/analyseCorpus/${id}');
  response = await get(uri);

  return true;
}

// Topic services

List<Topic> parseTopics(Uint8List responseBody) {
  List<Topic> topics = [];

  final parsed = jsonDecode(utf8.decode(responseBody));

  parsed["topics by corpus"].forEach((topic) {
    Topic temp = Topic();
    temp.fromJson(topic);
    topics.add(temp);
  });
  return topics;
}

Future<List<Topic>> getTopicByCorpusId(int id) async {
  var uri = new Uri.http("$apiIP:$apiPort", '/topicByCorpus/${id}');
  final response = await Client().get(uri);
  return parseTopics(response.bodyBytes);
}

// Word services

List<Word> parseWords(Uint8List responseBody) {
  List<Word> words = [];

  final parsed = jsonDecode(utf8.decode(responseBody));

  parsed["words by topic"].forEach((word) {
    Word temp = Word();
    temp.fromJson(word);
    words.add(temp);
  });
  return words;
}

Future<List<Word>> getWordByTopicId(int id) async {
  var uri = new Uri.http("$apiIP:$apiPort", '/wordsByTopic/${id}');
  final response = await Client().get(uri);
  return parseWords(response.bodyBytes);
}

// TOPICFILES services

List<FileTopic> parseFilesTopics(Uint8List responseBody) {
  List<FileTopic> items = [];

  final parsed = jsonDecode(utf8.decode(responseBody));

  parsed["fileTopics"].forEach((filetopic) {
    FileTopic temp = FileTopic();
    temp.fromJson(filetopic);
    items.add(temp);
  });
  return items;
}

Future<List<FileTopic>> getFilesByTopicId(int id) async {
  var uri = new Uri.http("$apiIP:$apiPort", '/fileTopicByTopic/${id}');
  final response = await Client().get(uri);
  return parseFilesTopics(response.bodyBytes);
}

// YearCHart servies

List<List<YearFileInfo>> parseYearCharts(Uint8List responseBody) {
  List<List<YearFileInfo>> items = [];

  final parsed = jsonDecode(utf8.decode(responseBody));
  for (var yearchart in parsed.values) {
    List<YearFileInfo> tempList = [];

    yearchart.forEach((item) {
      YearFileInfo temp = YearFileInfo();
      temp.fromJson(item);
      tempList.add(temp);
    });
    items.add(tempList);
  }

  return items;
}

Future<List<List<YearFileInfo>>> getYearChartByCorpusID(int id) async {
  var uri = new Uri.http("$apiIP:$apiPort", '/dominantTopicByFile/${id}');
  final response = await Client().get(
    uri,
    headers: <String, String>{'Keep-Alive': 'timeout=5, max=1000'},
  );
  return parseYearCharts(response.bodyBytes);
}

// File Info services

List<FileInfo> parseFilesInfo(Uint8List responseBody) {
  List<FileInfo> items = [];

  final parsed = jsonDecode(utf8.decode(responseBody));

  parsed["files"].forEach((file) {
    FileInfo temp = FileInfo();
    temp.fromJson(file);
    items.add(temp);
  });
  return items;
}

Future<List<FileInfo>> getFilesInfo() async {
  var uri = new Uri.http("$apiIP:$apiPort", '/allFilesInfo');
  final response = await Client().get(uri);
  return parseFilesInfo(response.bodyBytes);
}

// Analyse

Future<bool> analyseCorpus(int id) async {
  var uri = new Uri.http("$apiIP:$apiPort", '/analyseCorpus/${id}');
  final response = await Client().get(uri);
  return true;
}

// Files

List<File> parseFiles(Uint8List responseBody) {
  List<File> files = [];

  final parsed = jsonDecode(utf8.decode(responseBody));

  parsed["files"].forEach((file) {
    File temp = File(
        id: 0,
        title: "",
        language: "",
        nbPages: 0,
        body: "",
        is_selected: false,
        creationTime: null,
        fileType: "");
    temp.fromJson(file);
    files.add(temp);
  });
  return files;
}

Future<List<File>> getAllFiles() async {
  var uri = new Uri.http("$apiIP:$apiPort", '/file');
  final response = await Client().get(uri);
  return parseFiles(response.bodyBytes);
}

Future<bool> toogleFileSelection(int id) async {
  var uri = new Uri.http("$apiIP:$apiPort", '/toogleFileSelection/${id}');
  final Response response = await get(
    uri,
  );
  if (response.statusCode != 200) throw Exception(response.statusCode);
  return true;
}

Future<bool> toogleAllFileSelection(List<int> list) async {
  var uri = new Uri.http("$apiIP:$apiPort", '/listSelectionReset');

  Map data = {"files": list};
  String body = json.encode(data);

  final Response response = await put(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
  if (response.statusCode != 200) throw Exception(response.statusCode);
  return true;
}

Map<String, dynamic> toJson(List<int> list) {
  return {'files': list};
}

Future<bool> restFileSelection() async {
  var uri = new Uri.http("$apiIP:$apiPort", '/fileSelectionReset');
  final Response response = await get(uri);
  if (response.statusCode != 200) throw Exception(response.statusCode);
  return true;
}

// CorpusFile associations

List<int> parseCorpusFilesAssoc(Uint8List responseBody) {
  List<int> files = [];

  final parsed = jsonDecode(utf8.decode(responseBody));

  parsed["filesByCorpus"].forEach((file) {
    files.add(file);
  });

  return files;
}

Future<List<int>> getCorpusFilesByCorpus(Corpus corpus) async {
  var uri = new Uri.http("$apiIP:$apiPort", '/filesByCorpus/${corpus.id}');
  final response = await Client().get(uri);
  return parseCorpusFilesAssoc(response.bodyBytes);
}

// OTHER

bool getSize(context) {
  double width = MediaQuery.of(context).size.width;
  bool isMobile = width <= 800;
  return isMobile;
}
