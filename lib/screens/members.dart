import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Members extends StatelessWidget {
  var items = List.generate(100, (index) => "item ${index}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MEMBERS"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
            );
          }),
      );
  }
}