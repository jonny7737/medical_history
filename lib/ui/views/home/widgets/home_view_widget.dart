import 'package:flutter/material.dart';
import 'package:medical_history/ui/views/home/widgets/app_bar_w.dart';

class HomeViewWidget extends StatelessWidget {
  const HomeViewWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: HomeAppBar(),
        body: Center(
          child: Text(
            'Hello World',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
        ),
      ),
    );
  }
}
