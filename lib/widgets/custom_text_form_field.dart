import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  //const CustomTextFormField({ Key? key }) : super(key: key);
  final TextEditingController? controller;
  final IconData? iconData;
  final String? hintText;
  final TextInputType? textInputType;
  bool? isObsecure;
  bool? enable;
  String? validatorValue;
  List<String>? validatorValueList = [];
  //final Validator validator;
  
  CustomTextFormField({
    this.controller,
    this.iconData,
    this.hintText,
    this.textInputType,
    this.isObsecure,
    this.enable,
    this.validatorValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.all(10),
      //padding: EdgeInsets.all(10),
      //height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        validator: (validatorValue) {
          //int phone = int.parse(validatorValue!);
          if (validatorValue!.length < 5) {
            //return "phone number should be 11 digits";
          }
          if (validatorValue.contains('@')) {
          } else {
            return "does not @ sing";
          }
        },
        keyboardType: textInputType,
        controller: controller,
        enabled: enable,
        obscureText: isObsecure!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            iconData,
            color: Colors.cyan,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
