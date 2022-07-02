import 'package:adf_state_manager/bloc_pattern/imc_bloc_pattern_controller.dart';
import 'package:adf_state_manager/bloc_pattern/imc_state.dart';
import 'package:adf_state_manager/widgets/imc_gauge.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImcBlocPatternPage extends StatefulWidget {
  const ImcBlocPatternPage({Key? key}) : super(key: key);

  @override
  State<ImcBlocPatternPage> createState() => _ImcBlocPatternPageState();
}

class _ImcBlocPatternPageState extends State<ImcBlocPatternPage> {
  final controller = ImcBlocPatternController();
  final pesoEC = TextEditingController();
  final alturaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pesoEC.dispose();
    alturaEC.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMC Bloc Pattern'),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder<ImcState>(
                stream: controller.imcOut,
                builder: (context, snapshot) {
                  var imc = snapshot.data?.imc ?? 0;
                  return ImcGauge(imc: imc);
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder<ImcState>(
                stream: controller.imcOut,
                builder: (context, snapshot) {
                  final dataValue = snapshot.data;
                  if (snapshot is ImcStateLoading) {
                    return Visibility(
                      visible: dataValue is ImcStateLoading,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (dataValue is ImcStateError) {
                    return Text(dataValue.message);
                  }
                  return const SizedBox.shrink();
                },
              ),
              TextFormField(
                controller: pesoEC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Peso'),
                inputFormatters: [
                  CurrencyTextInputFormatter(
                    locale: 'pt_BR',
                    symbol: '',
                    turnOffGrouping: true,
                    decimalDigits: 2,
                  ),
                ],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Peso obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: alturaEC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Altura'),
                inputFormatters: [
                  CurrencyTextInputFormatter(
                    locale: 'pt_BR',
                    symbol: '',
                    turnOffGrouping: true,
                    decimalDigits: 2,
                  ),
                ],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Altura obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  var formValid = formKey.currentState?.validate() ?? false;

                  if (formValid) {
                    var formatter = NumberFormat.simpleCurrency(
                      locale: 'pt_BR',
                      decimalDigits: 2,
                    );

                    double peso = formatter.parse(pesoEC.text) as double;
                    double altura = formatter.parse(alturaEC.text) as double;

                    controller.calcularImc(peso: peso, altura: altura);
                  }
                },
                child: const Text(
                  'Calcular IMC',
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
