import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatabaseController extends GetxController {
  late StreamSubscription<DatabaseEvent> remainSubscription;

  var remain = 0.obs;

  @override
  void onInit() {
    super.onInit();

    initializeData();
  }

  inscription() async {
    var ref = FirebaseDatabase.instance.ref('restante');
    await ref.set(remain.value - 1);
  }

  initializeData() async {
    var ref = FirebaseDatabase.instance.ref('restante');
    try {
      final snapshot = await ref.get();
      remain(snapshot.value as int);
    } catch (e) {
      debugPrint(e.toString());
    }

    remainSubscription = ref.onValue.listen(
      (event) {
        remain((event.snapshot.value ?? 0) as int);
      },
    );
  }
}
