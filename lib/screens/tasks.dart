import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makerspace/helpers/app_colours.dart';
import 'package:makerspace/models/post.dart';
import 'package:makerspace/models/post.dart';
import 'package:makerspace/models/task.dart';
import 'package:makerspace/providers/firestore_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/src/provider.dart';
import 'package:makerspace/screens/main_feed.dart';

class Tasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TasksState();
}

class _TasksState extends State {
  late Widget body;
  late String title;
  late FocusNode focusNode = FocusNode();
  late List<Widget> todos;

  bool isChecked = false;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    body = home();
    title = "Makerspace";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            elevation: 0.0,
            title: Text("Tasks".toUpperCase(),
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900)),
            backgroundColor:
                AppColors.backgroundColor, //Color.fromRGBO(244, 246, 251, 1),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  focusNode.requestFocus();
                },
                icon: Icon(Icons.add),
                iconSize: 24,
              )
            ],
          ),
          body: body,
        ));
  }

  Widget home() {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: context.read<FirestoreProvider>().getTodosStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading...");
            }

            return ListView.separated(
                padding: EdgeInsets.only(top: 16),
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  var item = snapshot.data!.docs.elementAt(index);
                  var todo = item.data() as Map<String, dynamic>;
                  return Tasks_Tile(todo: Task.fromJson(todo, item.id));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: Colors.transparent, height: 0);
                },
                itemCount: snapshot.data!.docs.length);
          },
        ),
        Card(
          elevation: 0.0,
          shadowColor: AppColors.secondaryColor,
          margin: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
          color: AppColors.backgroundColor, //Color.fromRGBO(255, 255, 255, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  CircularCheckbox(
                    value: isChecked,
                    onChanged: (value) {},
                  ),
                  new Expanded(
                    child: new TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        _controller.text = _controller.text.trim();
                        if (_controller.text.isNotEmpty) {
                          print("GOT HERE");
                          context
                              .read<FirestoreProvider>()
                              .addToDo(_controller.text, isChecked);
                          _controller.clear();
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return new AlertDialog(
                                  title: new Text("Oops.."),
                                  content: new Text("Field cannot be blank..."),
                                );
                              });
                        }
                      },
                      focusNode: focusNode,
                      maxLines: null,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white38),
                        hintText: "Add A New Task Here...",
                        fillColor: Colors.white,
                      ),
                    ),
                  )
                ],
              )),
        )
      ],
    );
  }
}

class Tasks_Tile extends StatefulWidget {
  const Tasks_Tile({
    Key? key,
    required Task todo,
  })  : _todo = todo,
        super(key: key);

  final Task _todo;

  @override
  State createState() => _Tasks_State();
}

class _Tasks_State extends State<Tasks_Tile> {
  bool isChecked = false;
  TextEditingController _controller = new TextEditingController();
  late FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget._todo.text;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Card(
          elevation: 0.0,
          shadowColor: AppColors.secondaryColor,
          margin: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
          color: AppColors.backgroundColor, //Color.fromRGBO(255, 255, 255, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  CircularCheckbox(
                      value: widget._todo.isDone,
                      onChanged: (bool? value) async {
                        setState(() {
                          widget._todo.isDone = value!;
                        });
                        await Future.delayed(Duration(seconds: 2));
                        context
                            .read<FirestoreProvider>()
                            .markToDoAsDone(widget._todo);
                      }),
                  new Expanded(
                    child: new TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        if (_controller.text.isNotEmpty) {
                          print("GOT HERE");
                          context.read<FirestoreProvider>().updateToDoText(
                              _controller.text, widget._todo.id);
                          focusNode.unfocus();
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return new AlertDialog(
                                  title: new Text("Oops.."),
                                  content: new Text("Field cannot be blank..."),
                                );
                              });
                        }
                      },
                      focusNode: focusNode,
                      maxLines: null,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white38),
                        hintText: "Add A New Task Here...",
                        fillColor: Colors.white,
                      ),
                    ),
                  )
                  // Expanded(
                  //     child: Text(
                  //       widget._todo.text,
                  //         style: TextStyle(
                  //             fontSize: 16,
                  //             color: Colors.white,
                  //             height: 1.4,
                  //             fontWeight: FontWeight.normal)
                  //     )
                  // )
                ],
              ))),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            label: 'Delete',
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (BuildContext context) {
              context.read<FirestoreProvider>().removeToDo(widget._todo.id);
            },
          )
        ],
      ),
    );
  }
}

class CircularCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  const CircularCheckbox(
      {Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.3,
      child: Checkbox(
        checkColor: Colors.green,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
