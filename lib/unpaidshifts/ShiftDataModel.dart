class ShiftDataModel {
  final DateTime start;
  final DateTime end;
  final String id;

  double get hours => double.parse(((end.millisecondsSinceEpoch - start.millisecondsSinceEpoch) / (1000 * 60 * 60)).toStringAsFixed(1));

  ShiftDataModel({required this.id, required this.start,required this.end});
}