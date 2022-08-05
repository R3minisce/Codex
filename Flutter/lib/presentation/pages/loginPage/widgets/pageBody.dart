import 'package:codex/presentation/pages/loginPage/widgets/actionBarColumn.dart';
import 'package:codex/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageBody extends StatelessWidget {
  const PageBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getSize(context)
          ? EdgeInsets.all(16.0)
          : EdgeInsets.symmetric(vertical: 16.0, horizontal: 160.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 32),
          Column(
            children: [
              Text(
                "Codex",
                style: GoogleFonts.montserrat(
                  fontSize: 42,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Image(image: AssetImage('assets/book.png'), height: 140),
            ],
          ),
          ActionBarColumn(),
        ],
      ),
    );
  }
}
