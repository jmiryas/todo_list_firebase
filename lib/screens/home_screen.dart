import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController todoController = TextEditingController();
    String dateTime = "";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Todo List App"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("todo")
              .where("complete", isEqualTo: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.size > 0
                  ? Container(
                      margin: const EdgeInsets.all(20.0),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: snapshot.data!.docs.map((item) {
                          return Dismissible(
                              key: Key(item.id),
                              onDismissed: (direction) async {
                                FirebaseFirestore firestore =
                                    FirebaseFirestore.instance;
                                CollectionReference todoCollection =
                                    firestore.collection("todo");

                                await todoCollection.doc(item.id).update({
                                  "complete": true,
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Todo is complete!")));
                              },
                              background: Container(
                                color: Colors.red.shade300,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 10.0,
                                  backgroundColor: Colors.primaries[Random()
                                      .nextInt(Colors.primaries.length)],
                                ),
                                title: Text(item["todo"]),
                                subtitle: Text(item["dateTime"]),
                                trailing: IconButton(
                                    onPressed: () {
                                      todoController.text = item["todo"];
                                      dateTime = item["dateTime"];

                                      Alert(
                                        context: context,
                                        title: "Update Todo",
                                        content: Container(
                                          margin:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller: todoController,
                                                decoration: const InputDecoration(
                                                    hintText: "Enter todo ...",
                                                    prefixIcon:
                                                        Icon(Icons.description),
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              DateTimePicker(
                                                initialValue: dateTime,
                                                type:
                                                    DateTimePickerType.dateTime,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                                dateLabelText: 'Date',
                                                onChanged: (val) {
                                                  dateTime = val;
                                                },
                                                validator: (val) {
                                                  return null;
                                                },
                                                onSaved: (val) {},
                                                decoration: const InputDecoration(
                                                    prefixIcon:
                                                        Icon(Icons.timer),
                                                    hintText:
                                                        "Select date and time ...",
                                                    border:
                                                        OutlineInputBorder()),
                                              )
                                            ],
                                          ),
                                        ),
                                        buttons: [
                                          DialogButton(
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            width: 120,
                                          ),
                                          DialogButton(
                                            color: Colors.green,
                                            child: const Text(
                                              "Save",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () async {
                                              FirebaseFirestore firestore =
                                                  FirebaseFirestore.instance;
                                              CollectionReference
                                                  todoCollection =
                                                  firestore.collection("todo");

                                              await todoCollection
                                                  .doc(item.id)
                                                  .update({
                                                "todo": todoController.text,
                                                "dateTime": dateTime
                                              });

                                              Navigator.pop(context);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Todo is updated!")));

                                              todoController.text = "";
                                              dateTime = "";
                                            },
                                            width: 120,
                                          )
                                        ],
                                      ).show();
                                    },
                                    icon: const Icon(Icons.edit)),
                              ));
                        }).toList(),
                      ),
                    )
                  : const Center(
                      child: Text("Todo is empty!"),
                    );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error!"),
              );
            } else {
              return const Center(
                child: Text("Loading ..."),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Alert(
            context: context,
            title: "Add New Todo",
            content: Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: [
                  TextField(
                    controller: todoController,
                    decoration: const InputDecoration(
                        hintText: "Enter todo ...",
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  DateTimePicker(
                    initialValue: '',
                    type: DateTimePickerType.dateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date',
                    onChanged: (val) {
                      dateTime = val;
                    },
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) {},
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.timer),
                        hintText: "Select date and time ...",
                        border: OutlineInputBorder()),
                  )
                ],
              ),
            ),
            buttons: [
              DialogButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              ),
              DialogButton(
                color: Colors.green,
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  FirebaseFirestore firestore = FirebaseFirestore.instance;
                  CollectionReference todoCollection =
                      firestore.collection("todo");

                  await todoCollection.add({
                    "todo": todoController.text,
                    "dateTime": dateTime,
                    "complete": false
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Todo is created!")));
                },
                width: 120,
              )
            ],
          ).show();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
