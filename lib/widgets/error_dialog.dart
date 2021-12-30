import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/helpers/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ErrorDialog extends StatefulWidget {
  final String title, errorMessage;

  ErrorDialog({required this.title, required this.errorMessage});

  State createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.errorMessage,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close"),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(size.width * 0.4, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))))
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
              backgroundColor: AppColors.backgroundColor,
              radius: Constants.avatarRadius,
              child: Icon(Icons.error_outline, color: Colors.red, size: 80)),
        ),
      ],
    );
  }
}

void showFailedAuthDialog(BuildContext context, String? message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(
          title: "Oops...",
          errorMessage: message ?? "An error occurred",
        );
      });
}
