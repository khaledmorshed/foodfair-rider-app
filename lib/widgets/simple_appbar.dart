import 'package:flutter/material.dart';

import 'container_decoration.dart';

class SimpleAppbar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  final PreferredSizeWidget? bottom;
  SimpleAppbar({
    Key? key,
    this.title,
    this.bottom,
  }) : super(key: key);

  @override
  Size get preferredSize => bottom == null
      ? Size(double.infinity, AppBar().preferredSize.height)
      : Size(double.infinity, AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:  Text(title!),
      flexibleSpace: Container(
        decoration: const ContainerDecoration().decoaration(),
      ),
    );
  }
}
