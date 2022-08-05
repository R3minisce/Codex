import 'package:codex/presentation/pages/allFilesPage/codex_files.dart';
import 'package:codex/presentation/pages/browsingPage/codex_browsing.dart';
import 'package:codex/presentation/pages/cardPage/codex_card.dart';
import 'package:codex/presentation/pages/editPage/codex_edit.dart';
import 'package:codex/presentation/pages/loginPage/codex_login.dart';
import 'package:codex/presentation/pages/topicCardPage/codex_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/services.dart';

var routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => LoginPage(),
  "/browsing": (BuildContext context) => BrowsingPage(),
  "/card": (BuildContext context) => CardPage(),
  "/topic": (BuildContext context) => TopicCardPage(),
  "/edit": (BuildContext context) => EditPage(),
  "/files": (BuildContext context) => FilesPage(),
};

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Codex',
      theme: ThemeData(
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}
