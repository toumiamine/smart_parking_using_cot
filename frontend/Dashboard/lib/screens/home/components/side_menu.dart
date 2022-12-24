import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.text_color,
    required this.selected_color,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final Color text_color;
  final Color selected_color;
  @override
  Widget build(BuildContext context) {
    return ListTile(

      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: text_color,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: text_color),
      ),
        tileColor : selected_color
    );
  }
}
