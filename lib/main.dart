import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculadora de IMC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double result = 0;
  String errorMessage = '';
  String classification = '';

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final FocusNode _heightFocus = FocusNode();
  final FocusNode _weightFocus = FocusNode();

  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um valor de peso.';
    }
    double weight = double.tryParse(value.replaceFirst(',', '.')) ?? 0;

    if (weight > 300) {
      return 'O peso não pode ser maior que 300.';
    }

    return null;
  }

  String? _validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um valor de altura.';
    }

    double height = double.tryParse(value.replaceFirst(',', '.')) ?? 0;

    if (height > 2.5) {
      return 'A altura não pode ser maior que 2.5 metros.';
    }

    return null;
  }

  double _calculateBMI({required String height, required String weight}) {
    result = 0;
    final double parsedHeight = double.parse(height);
    final double parsedWeight = double.parse(weight);

    final double bmi = parsedWeight / (parsedHeight * parsedHeight);

    final String currentClassification = _getBMIResult(bmi);

    setState(() {
      result = double.parse(bmi.toStringAsFixed(2));
      classification = currentClassification;
    });

    return bmi;
  }

  String _getBMIResult(double bmi) {
    if (bmi < 16) {
      return 'Magreza grave';
    } else if (bmi >= 16 && bmi <= 17) {
      return 'Magreza moderada';
    } else if (bmi >= 17 && bmi <= 18.5) {
      return 'Magreza leve';
    } else if (bmi >= 18.5 && bmi <= 25) {
      return 'Saudável';
    } else if (bmi >= 25 && bmi <= 30) {
      return 'Sobrepeso';
    } else if (bmi >= 30 && bmi <= 35) {
      return 'Obesidade grau 1';
    } else if (bmi >= 35 && bmi <= 40) {
      return 'Obesidade grau 2';
    } else if (bmi > 40) {
      return 'Obesidade grau 3';
    } else {
      return 'Erro';
    }
  }

  bool _isValid() {
    if (_heightController.text.isEmpty || _weightController.text.isEmpty) {
      return false;
    }

    if (_validateHeight(_heightController.text) != null ||
        _validateWeight(_weightController.text) != null) {
      return false;
    }

    return true;
  }

  void _showErrorMessage() {
    setState(() {
      if (_validateHeight(_heightController.text) != null) {
        errorMessage = _validateHeight(_heightController.text) ?? '';
      } else {
        errorMessage = _validateWeight(_weightController.text) ?? '';
      }
    });
  }

  void _clearFields() {
    _heightController.clear();
    _weightController.clear();
    _heightFocus.unfocus();
    _weightFocus.unfocus();
    setState(() {
      result = 0;
      errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  readOnly: result > 0 || errorMessage.isNotEmpty,
                  controller: _heightController,
                  focusNode: _heightFocus,
                  decoration: const InputDecoration(
                    labelText: 'Altura',
                    hintText: 'Ex: 1.75',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                    LengthLimitingTextInputFormatter(5),
                    MaskTextInputFormatter(
                      mask: '#.##',
                      filter: {'#': RegExp(r'[0-9]')},
                    ),
                  ],
                  validator: _validateHeight,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  readOnly: result > 0 || errorMessage.isNotEmpty,
                  controller: _weightController,
                  focusNode: _weightFocus,
                  decoration: const InputDecoration(
                    labelText: 'Peso',
                    hintText: 'Ex: 75.0',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,1}$')),
                    LengthLimitingTextInputFormatter(5),
                    MaskTextInputFormatter(
                      mask: '###.#',
                      filter: {'#': RegExp(r'[0-9]')},
                    ),
                  ],
                  validator: _validateWeight,
                ),
                const SizedBox(height: 30),
                if (result == 0 && errorMessage.isEmpty)
                  ElevatedButton(
                    onPressed: _isValid()
                        ? () => _calculateBMI(
                            height: _heightController.text,
                            weight: _weightController.text)
                        : _showErrorMessage,
                    child: const Text('Calcular'),
                  ),
                if (result > 0 || errorMessage.isNotEmpty)
                  ElevatedButton(
                    onPressed: _clearFields,
                    child: const Text('Limpar'),
                  ),
                const SizedBox(height: 30),
                if (result > 0)
                  Column(
                    children: [
                      Text(
                        'Resultado: $result',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Classificação: $classification',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
