class BMIController {
  double calculateBMI({required double height, required double weight}) {
    return weight / (height * height);
  }

  String getBMIResult(double bmi) {
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

  bool isValid({required String height, required String weight}) {
    if (height.isEmpty || weight.isEmpty) {
      return false;
    }

    double parsedHeight = double.tryParse(height.replaceFirst(',', '.')) ?? 0;
    double parsedWeight = double.tryParse(weight.replaceFirst(',', '.')) ?? 0;

    if (parsedHeight <= 0 || parsedWeight <= 0) {
      return false;
    }

    if (parsedHeight > 2.5 || parsedWeight > 300) {
      return false;
    }

    return true;
  }

  String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um valor de peso.';
    }
    double weight = double.tryParse(value.replaceFirst(',', '.')) ?? 0;

    if (weight > 300) {
      return 'O peso não pode ser maior que 300.';
    }

    return null;
  }

  String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um valor de altura.';
    }

    double height = double.tryParse(value.replaceFirst(',', '.')) ?? 0;

    if (height > 2.5) {
      return 'A altura não pode ser maior que 2.5 metros.';
    }

    return null;
  }
}
