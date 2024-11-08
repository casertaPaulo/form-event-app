import 'package:flutter/material.dart';

class ValideDocument extends StatelessWidget {
  const ValideDocument({super.key});

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
            text: 'Para começar,\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: "Valide seu CPF",
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
