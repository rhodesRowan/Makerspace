import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Compose extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ComposeState();
}

class ComposeState extends State<Compose> {
  var focusNode = FocusNode();
  // Default Radio Button Selected Item When App Starts.
  String radioButtonItem = 'To-Do';

  // Group Value for Radio Button.
  int id = 0;

  @override
  void initState() {
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: Container(
          color: Color.fromRGBO(244, 246, 251, 1),
          padding: EdgeInsets.only(bottom: 8),
          child: Theme(
              data: ThemeData(
                  backgroundColor: Color.fromRGBO(244, 246, 251, 1),
                  toggleableActiveColor: Colors.green,
                  unselectedWidgetColor: Colors.grey),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: 1,
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                        radioButtonItem = 'To-Do';
                        id = 1;
                      });
                    },
                  ),
                  Text(
                    'To-Do',
                    style: new TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  Radio(
                    value: 2,
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                        radioButtonItem = 'Done';
                        id = 2;
                      });
                    },
                  ),
                  Text(
                    'Done',
                    style: new TextStyle(
                        fontSize: 17.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color.fromRGBO(244, 246, 251, 1),
          leading: CloseButton(
            color: Colors.green,
          ),
          actions: [
            Container(
                padding: EdgeInsets.only(right: 8),
                child: IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.green,
                    onPressed: () {}))
          ],
        ),
        backgroundColor: Color.fromRGBO(244, 246, 251, 1),
        body: Container(
          height: double.infinity,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: TextField(
            focusNode: focusNode,
            decoration: InputDecoration(
                hintText: "Share what need to do or what you've done...",
                hintMaxLines: 2,
                border: InputBorder.none),
            maxLines: null,
          ),
        ));
  }
}
