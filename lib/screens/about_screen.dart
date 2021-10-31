import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "About Todo List App",
              style: TextStyle(
                  fontSize: 20.0,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Text(
              "Home screen is incomplete todo list. If you want to change it to be complete, then just swap the item to the right/left.",
              style: TextStyle(
                  fontSize: 16.0,
                  letterSpacing: 1.0,
                  color: Colors.grey.shade600),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(
                "Complete screen is complete todo list. You can remove the todo here.",
                style: TextStyle(
                    fontSize: 16.0,
                    letterSpacing: 1.0,
                    color: Colors.grey.shade600))
          ],
        ),
      ),
    );
  }
}
