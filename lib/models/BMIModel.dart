class BMIModel {
  final double height;
  final double weight;
  final double bmi;
  final String classification;

  BMIModel({
    required this.height,
    required this.weight,
    required this.bmi,
    required this.classification,
  });

  factory BMIModel.fromJson(Map<String, dynamic> json) {
    return BMIModel(
      height: json['height'],
      weight: json['weight'],
      bmi: json['bmi'],
      classification: json['classification'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'classification': classification,
    };
  }
}
