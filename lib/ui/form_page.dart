import 'package:flutter/material.dart';
import 'package:form_event_app/controller/data_controller.dart';
import 'package:form_event_app/controller/database_controller.dart';
import 'package:form_event_app/ui/components/fill_form.dart';
import 'package:form_event_app/ui/components/valide_document.dart';
import 'package:form_event_app/util/util.dart';
import 'package:get/get.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> with WidgetsBindingObserver {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    height: Util.height(context) * .15,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      children: const [
                        TextSpan(
                          text: 'IPI,\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "SÃO\n",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "MANUEL",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Util.height(context) * .02),
              SizedBox(
                width: double.infinity,
                height: Util.height(context) * .15,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          return AnimatedCrossFade(
                            sizeCurve: Curves.easeIn,
                            firstChild: const ValideDocument(),
                            secondChild: const FillForm(),
                            crossFadeState: _currentStep.value == 0
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 800),
                          );
                        }),
                        Obx(() {
                          int remainPlaces = databaseController.remain.value;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                "Vagas\nRestantes",
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 800),
                                child: Text(
                                  key:
                                      ValueKey<String>(remainPlaces.toString()),
                                  remainPlaces.toString(),
                                  style: TextStyle(
                                      fontSize: 22,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w900),
                                ),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() {
                return Expanded(
                  child: Stepper(
                    controller: ScrollController(),
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
                                textCapitalization:
                                    TextCapitalization.characters,
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
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    bool formFilled =
                        nameController.value.value.text.isNotEmpty &&
                            phoneController.value.value.text.isNotEmpty;

                    return FilledButton(
                      onPressed: formFilled ? _handleSubmit : null,
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(18)),
                      child: const Text(
                        "GARANTIR VAGA",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 15),
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

  _handleSubmit() {
    if (_formDados.currentState!.validate()) {
      String document = _cleanText(documentController.value.value.text);
      String name = nameController.value.value.text;
      int phone = int.parse(_cleanText(phoneController.value.value.text));

      databaseController.doInscription(document, name, phone);
      _resetInputs();
    }
  }

  String _cleanText(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }

  void _resetInputs() {
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
                  return const Text(
                    "VALIDAR",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                  );
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
    var document = documentController.value.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
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
