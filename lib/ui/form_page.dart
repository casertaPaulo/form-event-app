import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  int _currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stepper(
                connectorColor: const WidgetStatePropertyAll(Colors.black),
                currentStep: _currentStep,
                onStepContinue: () {
                  _currentStep > 0
                      ? null
                      : setState(() {
                          _currentStep += 1;
                        });
                },
                onStepCancel: () {
                  _currentStep > 0
                      ? setState(() {
                          _currentStep -= 1;
                        })
                      : null;
                },
                controlsBuilder: (context, details) {
                  return Row(
                    children: [
                      OutlinedButton(
                        onPressed: details.onStepContinue,
                        child: const Text("VALIDAR"),
                      ),
                      const SizedBox(width: 10),
                      if (_currentStep != 0)
                        OutlinedButton(
                          onPressed: details.onStepCancel,
                          child: const Text("VOLTAR"),
                        ),
                    ],
                  );
                },
                steps: [
                  Step(
                    title: const Text("CPF"),
                    content: Column(
                      children: [
                        const SizedBox(height: 5),
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.credit_card),
                            labelText: "Número do CPF",
                          ),
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text("Dados"),
                    content: Column(
                      children: [
                        const SizedBox(height: 5),
                        TextField(
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
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                            labelText: "Telefone",
                          ),
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(18)),
                  child: const Text(
                    "GARANTIR VAGA",
                  ),
                ),
              )
              // Form(
              //   child: Column(
              //     children: [
              //       TextField(
              //         decoration: const InputDecoration(
              //           border: OutlineInputBorder(),
              //           prefixIcon: Icon(Icons.credit_card),
              //           labelText: "Número do CPF",
              //         ),
              //         onTapOutside: (event) {
              //           FocusScope.of(context).unfocus();
              //         },
              //       ),
              //       const SizedBox(height: 25),
              //       TextField(
              //         decoration: const InputDecoration(
              //           border: OutlineInputBorder(),
              //           prefixIcon: Icon(Icons.person),
              //           labelText: "Nome completo",
              //         ),
              //         onTapOutside: (event) {
              //           FocusScope.of(context).unfocus();
              //         },
              //       ),
              //       const SizedBox(height: 25),
              //       TextField(
              //         decoration: const InputDecoration(
              //           border: OutlineInputBorder(),
              //           prefixIcon: Icon(Icons.phone),
              //           labelText: "Telefone",
              //         ),
              //         onTapOutside: (event) {
              //           FocusScope.of(context).unfocus();
              //         },
              //       ),
              //       const SizedBox(height: 25),
              //       SizedBox(
              //         width: double.infinity,
              //         child: OutlinedButton(
              //           onPressed: () {},
              //           style: OutlinedButton.styleFrom(
              //               padding: const EdgeInsets.all(18)),
              //           child: const Text(
              //             "GARANTIR VAGA",
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
