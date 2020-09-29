import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/ui/views/home/widgets/app_bar_w.dart';
import 'package:medical_history/ui/views/home/widgets/error_msg_w.dart';

import 'package:medical_history/ui/views/home/riverpods.dart';

class HomeViewWidget extends HookWidget {
  const HomeViewWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = useProvider(homeViewModel);

    return SafeArea(
      child: Scaffold(
        appBar: HomeAppBar(),
        body: Stack(
          children: <Widget>[
            Center(
              child: Text(
                'Hello ${_model.userName}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
            ),
            const ErrorMsgWidget(),
          ],
        ),
      ),
    );
  }
}
