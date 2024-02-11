import 'package:dio_bmi_calculator/controllers/BMIController.dart';
import 'package:dio_bmi_calculator/models/BMIModel.dart';
import 'package:dio_bmi_calculator/screens/history_page.dart';
import 'package:dio_bmi_calculator/services/BMIService.dart';
import 'package:dio_bmi_calculator/widgets/BMIForm.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bmiController = BMIController();
  final _bmiService = BMIService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  BMIForm(
                    bmiController: _bmiController,
                    onSaveToHistory: (double height, double weight, double bmi,
                        String classification) {
                      saveBMI(
                        height: height,
                        weight: weight,
                        bmi: bmi,
                        classification: classification,
                      );
                    },
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        await BMIService.instance.init();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HistoryPage(
                                bmiHistory: BMIService.instance.bmiList,
                              );
                            },
                          ),
                        );
                      },
                      child: const Text('Histórico'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveBMI(
      {required double height,
      required double weight,
      required double bmi,
      required String classification}) {
    final bmiModel = BMIModel(
      height: height,
      weight: weight,
      bmi: bmi,
      classification: classification,
    );
    _bmiService.addToBMIList(bmiModel);
  }

  void clearBMIList() {
    _bmiService.clearBMIList();
  }
}
