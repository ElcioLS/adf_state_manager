import 'dart:async';
import 'dart:math';

import 'package:adf_state_manager/bloc_pattern/imc_state.dart';

class ImcBlocPatternController {
  final _imcStreamController = StreamController<ImcState>.broadcast()
    ..add(ImcState(imc: 0));
  Stream<ImcState> get imcOut => _imcStreamController.stream;

  Future<void> calcularImc(
      {required double peso, required double altura}) async {
    try {
      _imcStreamController.add(ImcStateLoading());
      await Future.delayed(const Duration(seconds: 1));
      final imc = peso / pow(altura, 2);
      // throw Exception(); //Forçar o erro pr ver a mensagem
      _imcStreamController.add(ImcState(imc: imc));
    } on Exception {
      _imcStreamController.add(ImcStateError(message: 'Erro ao calcular IMC'));
    }
  }

  void dispose() {
    _imcStreamController.close;
  }
}

// POSSO TAMBÉM UTILIZAR O SINK MAS NÃO O IDEAL É UTILIZAR  NESSE CASO
// class ImcBlocPatternController {
//   final _imcStreamController = StreamController<ImcState>()
//     ..add(ImcState(imc: 0));
//   Stream<ImcState> get imcOut => _imcStreamController.stream;
//   Sink<ImcState> get imcIn => _imcStreamController.sink;

//   Future<void> calcularImc(
//       {required double peso, required double altura}) async {
//     imcIn.add(ImcState(imc: 0));
//     await Future.delayed(const Duration(seconds: 1));

//     final imc = peso / pow(altura, 2);
//     imcIn.add(ImcState(imc: imc));
//   }

//   void dispose() {
//     _imcStreamController.close;
//   }
// }
