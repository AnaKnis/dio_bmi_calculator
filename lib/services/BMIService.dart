import 'package:dio_bmi_calculator/models/BMIModel.dart';
import 'package:hive/hive.dart';

class BMIService {
  static final BMIService _singleton = BMIService._internal();
  late Box<BMIModel> _bmiBox;

  BMIService._internal();

  static BMIService get instance => _singleton;

  Future<void> init() async {
    _bmiBox = await Hive.openBox<BMIModel>('bmiBox');
  }

  List<BMIModel> get bmiList => _bmiBox.values.toList();

  Future<void> addToBMIList(BMIModel bmiModel) async {
    await _bmiBox.add(bmiModel);
  }

  Future<void> clearBMIList() async {
    await _bmiBox.clear();
  }
}

class BMIAdapter extends TypeAdapter<BMIModel> {
  @override
  final int typeId = 0;

  @override
  BMIModel read(BinaryReader reader) {
    return BMIModel(
      height: reader.readDouble(),
      weight: reader.readDouble(),
      bmi: reader.readDouble(),
      classification: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, BMIModel obj) {
    writer.writeDouble(obj.height);
    writer.writeDouble(obj.weight);
    writer.writeDouble(obj.bmi);
    writer.writeString(obj.classification);
  }
}
