import 'package:flutter/material.dart';
import 'package:form_event_app/controller/data_controller.dart';
import 'package:form_event_app/controller/formpage_controler.dart';
import 'package:get/get.dart';

class FormPage extends StatelessWidget {
  const FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<FormpageControler>();

    return Scaffold(
      body: Obx(() {
        return Column(
          children: [
            Stepper(
              connectorColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primary,
              ),
              currentStep: controller.currentStep.value,
              onStepContinue: controller.onStepContinue,
              onStepCancel: controller.onStepCancel,
              controlsBuilder: controlsBuilder,
              steps: [
                // STEP PARA VALIDAR O CPF
                Step(
                  state: controller.currentStep.value > 0
                      ? StepState.complete
                      : StepState.indexed,
                  stepStyle: StepStyle(
                    color: controller.currentStep.value > 0
                        ? Colors.green[300]
                        : null,
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
                        key: controller.formCpfKey,
                        child: TextFormField(
                          controller: controller.documentController.value,
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
                  state: controller.currentStep.value > 1
                      ? StepState.complete
                      : StepState.indexed,
                  stepStyle: StepStyle(
                    color: controller.currentStep.value > 1
                        ? Colors.green[300]
                        : null,
                    indexStyle: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  title: const Text("Dados"),
                  content: Form(
                    key: controller.formDados,
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: controller.nameController.value,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Insira o nome";
                            }
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
                          controller: controller.phoneController.value,
                          validator: (value) {
                            value = value?.replaceAll(RegExp(r'[^0-9]'), '');
                            if (value!.isEmpty) {
                              return "Insira o número de telefone";
                            }
                            if (value.length < 11) {
                              return "Insira um número telefone válido";
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
                            hintText: "(00) 00000-0000",
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
                Step(
                  stepStyle: StepStyle(
                    indexStyle: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  title: const Text("Itens"),
                  content: Column(
                    children: <Widget>[
                      RadioListTile<SingingCharacter>(
                        title: const Text('Arroz'),
                        value: SingingCharacter.arroz,
                        groupValue: controller.option.value,
                        onChanged: (SingingCharacter? value) {
                          controller.option.value = value;
                        },
                      ),
                      RadioListTile<SingingCharacter>(
                        title: const Text('Óleo'),
                        value: SingingCharacter.oleo,
                        groupValue: controller.option.value,
                        onChanged: (SingingCharacter? value) {
                          controller.option.value = value;
                        },
                      ),
                      RadioListTile<SingingCharacter>(
                        title: const Text('Enlatados'),
                        value: SingingCharacter.enlatados,
                        groupValue: controller.option.value,
                        onChanged: (SingingCharacter? value) {
                          controller.option.value = value;
                        },
                      ),
                      RadioListTile<SingingCharacter>(
                        title: const Text('Leite'),
                        value: SingingCharacter.leite,
                        groupValue: controller.option.value,
                        onChanged: (SingingCharacter? value) {
                          controller.option.value = value;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: Obx(() {
                      var option = controller.option.value;
                      return FilledButton(
                        onPressed: option != SingingCharacter.none
                            ? controller.handleSubmit
                            : null,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(18),
                        ),
                        child: const Text(
                          "GARANTIR VAGA",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget controlsBuilder(BuildContext context, ControlsDetails details) {
    var dataController = Get.find<DataController>();
    var formController = Get.find<FormpageControler>();
    return Row(
      children: [
        if (formController.currentStep.value != 2)
          Expanded(
            flex: 1,
            child: FilledButton(
              onPressed: details.onStepContinue,
              child: Obx(
                () {
                  if (dataController.isLoading.value) {
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  );
                },
              ),
            ),
          ),
        if (formController.currentStep.value != 0)
          Expanded(
            child: OutlinedButton(
              onPressed: details.onStepCancel,
              child: const Text("VOLTAR"),
            ),
          ),
      ],
    );
  }
}
