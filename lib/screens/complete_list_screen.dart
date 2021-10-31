import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompleteListScreen extends StatelessWidget {
  const CompleteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Complete Todo List"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("todo")
              .where("complete", isEqualTo: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.size > 0
                  ? Container(
                      margin: const EdgeInsets.all(20.0),
                      child: ListView(
                        children: snapshot.data!.docs.map((item) {
                          return ListTile(
                            leading: CircleAvatar(
                                radius: 10.0,
                                backgroundColor: Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)]),
                            title: Text(item["todo"]),
                            subtitle: Text(item["dateTime"]),
                            trailing: IconButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection("todo")
                                      .doc(item.id)
                                      .delete();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Todo is removed!")));
                                },
                                icon: const Icon(Icons.delete)),
                          );
                        }).toList(),
                      ),
                    )
                  : const Center(
                      child: Text("Complete todo is empty!"),
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
    );
  }
}
