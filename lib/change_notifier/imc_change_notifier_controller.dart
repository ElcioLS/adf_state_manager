import 'dart:math';

import 'package:flutter/material.dart';

class ImcChangeNotifierController extends ChangeNotifier {
  var imc = 0.0;

  // o notifierListeners vai rebuildar todo mundo
  // mesmo que houver outras variáveis
  // tudo será refeito na tela

  Future<void> calcularIMC(
      {required double peso, required double altura}) async {
    imc = 0;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    imc = peso / pow(altura, 2);
    notifyListeners();
  }
}
