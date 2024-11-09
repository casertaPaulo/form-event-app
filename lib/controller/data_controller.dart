import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_event_app/controller/database_controller.dart';
import 'package:form_event_app/provider/data_provider.dart';
import 'package:get/get.dart';

class DataController extends GetxController with WidgetsBindingObserver {
  var isLoading = false.obs;
  var isValid = false.obs;
  final dataProvider = DataProvider();
  var databaseController = Get.find<DatabaseController>();

  Future<bool> documentIsValid(String doc) async {
    final response = await dataProvider.fetch(doc);

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

  Future<bool> validateDocument(String doc) async {
    isLoading(true);
    if (await documentIsValid(doc) == false ||
        await databaseController.documentAlreadyExists(doc) == true) {
      isLoading(false);
      return false;
    }
    isLoading(false);
    return true;
  }
}
