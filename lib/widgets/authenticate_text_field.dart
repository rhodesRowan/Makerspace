import 'package:makerspace/helpers/app_colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthenticateTextField extends StatelessWidget {
  final String hintText;
  final bool? obscureText;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final int maxLines;
  final double? padding;
  final bool? hasCounter;

  const AuthenticateTextField(
      {required this.hintText,
      required this.controller,
      this.obscureText,
      this.validator,
      this.padding,
      this.hasCounter,
      required this.maxLines})
      : super();

  Widget counter(
    BuildContext context, {
    required int currentLength,
    required int? maxLength,
    required bool isFocused,
  }) {
    currentLength = controller.text.length;
    maxLength = 288;
    return Text(
      '$currentLength of $maxLength characters',
      semanticsLabel: 'character count',
      style: TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: padding ?? 20, vertical: 5),
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Expanded(
          child: TextFormField(
            buildCounter: hasCounter ?? false ? counter : null,
            inputFormatters: [new LengthLimitingTextInputFormatter(288)],
            maxLines: (maxLines == 0) ? null : maxLines,
            controller: controller,
            validator: validator,
            obscureText: obscureText ?? false,
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
            decoration: InputDecoration(
              fillColor: AppColors.secondaryColor,
              hintStyle:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ));
  }
}
