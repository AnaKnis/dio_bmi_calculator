import 'package:dio_bmi_calculator/controllers/BMIController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class BMIForm extends StatefulWidget {
  final BMIController bmiController;
  final Function(
          double height, double weight, double bmi, String classification)
      onSaveToHistory;

  const BMIForm({
    Key? key,
    required this.bmiController,
    required this.onSaveToHistory,
  }) : super(key: key);

  @override
  State<BMIForm> createState() => _BMIFormState();
}

class _BMIFormState extends State<BMIForm> {
  double result = 0;
  String errorMessage = '';
  String classification = '';

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final FocusNode _heightFocus = FocusNode();
  final FocusNode _weightFocus = FocusNode();

  void _calculateBMI() {
    if (widget.bmiController.isValid(
        height: _heightController.text, weight: _weightController.text)) {
      double parsedHeight =
          double.tryParse(_heightController.text.replaceFirst(',', '.')) ?? 0;
      double parsedWeight =
          double.tryParse(_weightController.text.replaceFirst(',', '.')) ?? 0;

      double bmi = widget.bmiController.calculateBMI(
        height: parsedHeight,
        weight: parsedWeight,
      );

      String currentClassification = widget.bmiController.getBMIResult(bmi);

      widget.onSaveToHistory(
          parsedHeight, parsedWeight, bmi, currentClassification);

      setState(() {
        result = double.parse(bmi.toStringAsFixed(2));
        classification = currentClassification;
      });
    } else {
      _showErrorMessage();
    }
  }

  void _showErrorMessage() {
    setState(() {
      errorMessage = 'Por favor, insira valores válidos para altura e peso.';
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
    return Column(
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
          validator: widget.bmiController.validateHeight,
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
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}$')),
            LengthLimitingTextInputFormatter(5),
            MaskTextInputFormatter(
              mask: '###.#',
              filter: {'#': RegExp(r'[0-9]')},
            ),
          ],
          validator: widget.bmiController.validateWeight,
        ),
        const SizedBox(height: 30),
        if (result == 0 && errorMessage.isEmpty)
          ElevatedButton(
            onPressed: _calculateBMI,
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
    );
  }
}
