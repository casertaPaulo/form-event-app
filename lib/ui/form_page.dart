import 'package:flutter/material.dart';
import 'package:form_event_app/controller/data_controller.dart';
import 'package:form_event_app/controller/database_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formCpfKey = GlobalKey<FormState>();
  final _formDados = GlobalKey<FormState>();
  final nameController = TextEditingController().obs;
  final phoneController = MaskedTextController(mask: '(00) 00000-0000').obs;
  final documentController = MaskedTextController(mask: '000.000.000-00').obs;
  final _currentStep = 0.obs;
  var controller = Get.find<DataController>();
  var databaseController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Obx(() {
                return Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: 100,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Vagas",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              databaseController.remain.toString(),
                              style: const TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),

              Obx(() {
                return Stepper(
                  connectorColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary),
                  currentStep: _currentStep.value,
                  onStepContinue: onStepContinue,
                  onStepCancel: onStepCancel,
                  controlsBuilder: controlsBuilder,
                  steps: [
                    // STEP PARA VALIDAR O CPF
                    Step(
                      state: _currentStep.value > 0
                          ? StepState.complete
                          : StepState.indexed,
                      stepStyle: StepStyle(
                        color:
                            _currentStep.value > 0 ? Colors.green[300] : null,
                        indexStyle: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      title: const Text("CPF"),
                      content: Column(
                        children: [
                          const SizedBox(height: 5),
                          Form(
                            key: _formCpfKey,
                            child: TextFormField(
                              controller: documentController.value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Campo vazio";
                                }
                                if (value.length < 14) {
                                  return "Formato de CPF inválido";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              maxLength: 14,
                              buildCounter: (
                                context, {
                                required currentLength,
                                required isFocused,
                                required maxLength,
                              }) {
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.credit_card),
                                labelText: "Número do CPF",
                              ),
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    // STEP PARA ADICIONAR NOME E TELEFONE
                    Step(
                      stepStyle: StepStyle(
                        indexStyle: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      title: const Text("Dados"),
                      content: Form(
                        key: _formDados,
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: nameController.value,
                              validator: (value) {
                                return null;
                              },
                              textCapitalization: TextCapitalization.characters,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                                labelText: "Nome completo",
                              ),
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: phoneController.value,
                              validator: (value) {
                                if (value != null && value.length < 8) {
                                  return "Insira um telefone válido";
                                }
                                return null;
                              },
                              maxLength: 15,
                              buildCounter: (
                                context, {
                                required currentLength,
                                required isFocused,
                                required maxLength,
                              }) {
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.phone),
                                labelText: "Telefone",
                                hintText: "(00)00000-0000",
                              ),
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 30),
              // BOTÃO DE GARANTIR VAGA.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    var documentField = documentController.value.value.text;
                    var nameField = nameController.value.value.text;
                    var phoneField = phoneController.value.value.text;
                    return FilledButton(
                      onPressed: nameField.isEmpty || phoneField.isEmpty
                          ? null
                          : () {
                              if (_formDados.currentState!.validate()) {
                                databaseController.inscription(
                                  documentField,
                                  nameField,
                                  int.parse(phoneField.replaceAll(
                                      RegExp(r'[^0-9]'), '')),
                                );
                                Get.snackbar(
                                  "Sucesso!",
                                  phoneController.value.text
                                      .replaceAll(RegExp(r'[^0-9]'), ''),
                                  backgroundColor: Colors.lightGreenAccent,
                                );
                                resetInputs();
                              }
                            },
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(18)),
                      child: const Text(
                        "GARANTIR VAGA",
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void resetInputs() {
    _currentStep(0);
    documentController.value.text = "";
    nameController.value.text = "";
    phoneController.value.text = "";
  }

  Widget controlsBuilder(BuildContext context, ControlsDetails details) {
    return Row(
      children: [
        if (_currentStep.value != 1)
          Expanded(
            flex: 1,
            child: FilledButton(
              onPressed: details.onStepContinue,
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  return const Text("VALIDAR");
                },
              ),
            ),
          ),
        if (_currentStep.value != 0)
          Expanded(
            child: OutlinedButton(
              onPressed: details.onStepCancel,
              child: const Text("VOLTAR"),
            ),
          ),
      ],
    );
  }

  void onStepContinue() async {
    var document =
        documentController.value.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (_currentStep.value == 0 && _formCpfKey.currentState!.validate()) {
      if (await controller.validateDocument(document)) {
        _currentStep.value++;
      }
    }
  }

  void onStepCancel() {
    if (_currentStep.value > 0) {
      setState(() {
        _currentStep.value -= 1;
      });
    }
  }
}
