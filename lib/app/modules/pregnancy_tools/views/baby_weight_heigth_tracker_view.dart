import 'package:flutter/material.dart';

import 'package:get/get.dart';

class BabyWeightHeigthTrackerView extends GetView {
  const BabyWeightHeigthTrackerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BabyWeightHeigthTrackerView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BabyWeightHeigthTrackerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
