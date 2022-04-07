import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color? buttonColor;
  final Color? boarderColor;
  final String? text;
  final Color? textColor;
  double? fontSize;
  final VoidCallback? onPressed;
  double? paddingHorizontal;
  double? paddingVertical;

  CustomElevatedButton({Key? key, 
    this.buttonColor,
    this.text,
    this.boarderColor,
    this.onPressed,
    this.textColor,
    this.fontSize,
    this.paddingHorizontal,
    this.paddingVertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
          //onSurface: Colors.red,
          //primary: Colors.red,
          backgroundColor: buttonColor,
          padding:  EdgeInsets.symmetric(horizontal: paddingHorizontal!, vertical: paddingVertical!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            //side: const BorderSide(color: Colors.red),
          ),
          side: BorderSide(
            width: 1,
            color: boarderColor!,
          )),
      child: Text(
        "$text",
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}