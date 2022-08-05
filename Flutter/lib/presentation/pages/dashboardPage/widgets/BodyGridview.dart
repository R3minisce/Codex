import 'package:codex/presentation/styles.dart';
import 'package:codex/presentation/widgets/Balls.dart';
import 'package:flutter/material.dart';

class BodyGridView extends StatelessWidget {
  BodyGridView({
    Key key,
  }) : super(key: key);

  // TODO implémenter CubitSelect
  final bool isEdit = true;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(" Files"),
            Divider(
              color: lightBlack,
              thickness: 0.5,
            ),
            Expanded(
              child: Container(
                width: double.maxFinite,
                color: Colors.white,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: .0,
                      mainAxisSpacing: 1.0),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          isSelected = !isSelected; // TODO
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Colors.blueGrey,
                            border: Border.all(color: lightBlack),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
