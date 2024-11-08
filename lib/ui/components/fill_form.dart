import 'package:flutter/material.dart';

class FillForm extends StatelessWidget {
  const FillForm({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 18,
        ),
        children: const [
          TextSpan(
            text: 'Agora,\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: "Preencha os dados\n",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: "E garanta sua vaga!",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
