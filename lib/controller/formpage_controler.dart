import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:form_event_app/controller/data_controller.dart';
import 'package:form_event_app/controller/database_controller.dart';
import 'package:get/get.dart';

enum SingingCharacter { arroz, oleo, leite, enlatados, none }

class FormpageControler extends GetxController {
  late final DataController dataController;
  late final DatabaseController databaseController;

  @override
  void onInit() {
    dataController = Get.find();
    databaseController = Get.find();
    super.onInit();
  }

  var currentStep = 0.obs;
  var isLoading = false.obs;
  Rx<SingingCharacter?> option = SingingCharacter.none.obs;
  var documentController = MaskedTextController(mask: '000.000.000-00').obs;
  var nameController = TextEditingController().obs;
  var phoneController = MaskedTextController(mask: '(00) 00000-0000').obs;

  // Form keys
  final GlobalKey<FormState> formCpfKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formDados = GlobalKey<FormState>();

  handleSubmit() {
    if (formDados.currentState!.validate()) {
      String document = _cleanText(documentController.value.value.text);
      String name = nameController.value.value.text;
      int phone = int.parse(_cleanText(phoneController.value.value.text));
      String item = option.value!.name;

      databaseController.doInscription(document, name, phone, item);
      Get.snackbar(
        "",
        "",
        titleText: const Text(
          "Sucesso!",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        messageText: const Text(
          "Vaga garantida com sucesso!",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        backgroundColor: Colors.green[500],
      );
      _resetInputs();
    }
  }

  void _resetInputs() {
    currentStep(0);
    documentController.value.text = "";
    nameController.value.text = "";
    phoneController.value.text = "";
    option(SingingCharacter.none);
  }

  String _cleanText(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Stepper methods
  void onStepContinue() async {
    var document = documentController.value.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    if (currentStep.value == 0 && formCpfKey.currentState!.validate()) {
      if (await dataController.validateDocument(document)) {
        currentStep.value++;
      }
    } else if (currentStep.value == 1 && formDados.currentState!.validate()) {
      currentStep++;
    }
  }

  void onStepCancel() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }
}
