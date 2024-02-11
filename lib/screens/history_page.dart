import 'package:dio_bmi_calculator/models/BMIModel.dart';
import 'package:dio_bmi_calculator/services/BMIService.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final List<BMIModel> bmiHistory;
  final _bmiService = BMIService.instance;

  HistoryPage({
    super.key,
    required this.bmiHistory,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Histórico'),
        centerTitle: true,
      ),
      body: widget.bmiHistory.isEmpty
          ? const Center(child: Text('Você não possui nenhum registro.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.bmiHistory.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              'Altura: ${widget.bmiHistory[index].height}m\n'
                              'Peso: ${widget.bmiHistory[index].weight}kg\n'
                              'IMC: ${widget.bmiHistory[index].bmi}\n'
                              'Classificação: ${widget.bmiHistory[index].classification}',
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget._bmiService.clearBMIList();
                      });
                    },
                    child: const Text('Limpar'),
                  ),
                ),
              ],
            ),
    );
  }
}
