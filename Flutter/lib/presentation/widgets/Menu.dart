import 'package:codex/presentation/blocs/MenuCubit.dart';
import 'package:codex/presentation/widgets/shadowBorder.dart';
import 'package:codex/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Menu extends StatelessWidget {
  const Menu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 180,
      decoration: ShadowBorder(0, 32, Colors.grey.shade900),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: EdgeInsets.symmetric(vertical: getSize(context) ? 8.0 : 240.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MenuHeader(),
          MenuBody(),
          MenuFooter(),
        ],
      ),
    );
  }
}

class MenuHeader extends StatelessWidget {
  const MenuHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (getSize(context))
          IconButton(
            onPressed: () => context.read<MenuCubit>().toogle(),
            icon: Icon(Icons.close),
            color: Colors.red,
            iconSize: 30,
          ),
        SizedBox(height: 16.0),
        //Divider(color: Colors.white.withOpacity(0.15), thickness: 1),
        SizedBox(height: 8.0),
      ],
    );
  }
}

class MenuBody extends StatelessWidget {
  const MenuBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MenuItem(label: "Corpuses", route: "/browsing"),
              MenuItem(label: "All Files", route: "/files"),
            ],
          ),
          MenuItem(label: "Logout", route: "/"),
        ],
      ),
    );
  }
}

class MenuFooter extends StatelessWidget {
  const MenuFooter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: Colors.white.withOpacity(0.15), thickness: 1),
        Container(
          height: 30,
          width: double.maxFinite,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Codex",
              style: GoogleFonts.robotoSlab(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key key,
    this.label,
    this.route,
  }) : super(key: key);

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
