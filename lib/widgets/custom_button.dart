import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData? icon;
  final String? lebel;
  final Color? buttonColor;
  final VoidCallback? onTap;
  final String? text;
  final Color? boxShadowColorTop;
  final Color? boxShadowColorDown;
  final Color? texColor;

  const CustomButton({
    Key? key,
    this.icon,
    this.lebel,
    this.buttonColor,
    this.onTap,
    this.text,
    this.boxShadowColorTop,
    this.boxShadowColorDown,
    this.texColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 33,
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: boxShadowColorTop!,
              offset: Offset(-2, -2),
              blurRadius: 2,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: boxShadowColorDown!,
              offset: Offset(2, 2),
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            "$text",
            style: TextStyle(
              fontSize: 18,
              color: texColor,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
