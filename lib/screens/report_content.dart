import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/helpers/report_type.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:makerspace/widgets/authenticate_button.dart';
import 'package:makerspace/widgets/authenticate_text_field.dart';
import 'package:makerspace/helpers/validator.dart';
import 'package:makerspace/widgets/error_dialog.dart';
import 'package:provider/src/provider.dart';

class ReportContent extends StatefulWidget {

  ReportContent({required this.postID});

  String postID;

  @override
  State<StatefulWidget> createState() => ReportState();
}

class ReportState extends State<ReportContent> {
  reportType? _type = reportType.spam;
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text("Report Content".toUpperCase(),
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        ),
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Column(
              children: [
                RadioListTile(value: reportType.spam, title: Text("Spam", style: TextStyle(color: Colors.white)), groupValue: _type, onChanged: (reportType? type) {
                  setState(() {
                    _type = type;
                  });
                }),
                RadioListTile(value: reportType.abusive, title: Text("Abusive", style: TextStyle(color: Colors.white)), groupValue: _type, onChanged: (reportType? type) {
                  setState(() {
                    _type = type;
                  });
                }),
                RadioListTile(value: reportType.adultContent, activeColor: Colors.white, title: Text("Adult Content", style: TextStyle(color: Colors.white)), groupValue: _type, onChanged: (reportType? type) {
                  setState(() {
                    _type = type;
                  });
                }),
                AuthenticateTextField(
                    hintText: "Give us as much description as possible",
                    controller: _descriptionController,
                    obscureText: false,
                    hasCounter: true,
                    maxLines: 6,
                    validator: (value) => value?.isNotEmptyString()),
                AuthenticateButton(
                    text: "Report",
                    onPressed: () async {
                      if (_type != null) {
                        try {
                          context.read<FirestoreProvider>().reportPost(widget.postID, _type!, _descriptionController.text);
                        } catch (exception) {
                          showFailedAuthDialog(context, exception.toString());
                        }
                      }
                    }
                )
              ],
            ),
          ),
        );
  }
}