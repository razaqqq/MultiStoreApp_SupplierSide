




import 'package:flutter/material.dart';

class AppBarBackButton extends StatelessWidget {
  final Color color;
  const AppBarBackButton({
    super.key, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: color,
        ),
        onPressed: () {
          Navigator.pop(context);
        });
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
    required this.title,
    required this.color
  });

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontFamily: 'Acme', color: color, fontSize: 28),);
  }
}
