import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/pages/pages.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pages[0].title),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello')
          ],
        ),
      ),
    );
  }
}
