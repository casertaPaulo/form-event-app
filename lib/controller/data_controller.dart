import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_event_app/provider/data_provider.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  final dataProvider = DataProvider();
  var isLoading = false.obs;
  var isValid = false.obs;

  Future<bool> validateDocument(String document) async {
    isLoading(true);
    final response = await dataProvider.fetch(document);

    if (response.statusCode != 200) {
      isLoading(false);
      Get.snackbar(
        "Erro!",
        '',
        titleText: const Text(
          "Erro!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        messageText: Text(
          jsonDecode(response.body)['erro'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
      );
      return false;
    }
    isLoading(false);
    return true;
  }
}
