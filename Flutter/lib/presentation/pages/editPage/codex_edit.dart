import 'package:codex/presentation/pages/editPage/widgets/PageBody.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ProviderScope(child: PageBody()),
          ],
        ),
      ),
    );
  }
}
