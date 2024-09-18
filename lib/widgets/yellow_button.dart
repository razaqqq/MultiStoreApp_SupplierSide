





import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final double widthPercentage;
  final String label;
  final Function() onPressed;
  const YellowButton({
    super.key,
    required this.widthPercentage,
    required this.label,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * widthPercentage ?? widthPercentage,
      decoration: BoxDecoration(
          color: Colors.yellow, borderRadius: BorderRadius.circular(25)),
      child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            label,
          )),
    );
  }
}

