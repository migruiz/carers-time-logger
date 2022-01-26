import '../ShiftDataModel.dart';
import 'CarersToPayShiftDataModel.dart';

class CarerToPayDataModel{
  final String nickname;
  final int usualStartHour;
  final String id;

  final List<CarersToPayShiftDataModel> allUnpaidShifts = List.empty(growable: true);

  bool get isOverlapping => overlappedShifts.isNotEmpty;
  double get totalOverlappedHours => overlappedShifts.values.fold(0, (sum, next) => sum + next);

  final Map<ShiftDataModel,double> overlappedShifts = Map();

  CarerToPayDataModel({required this.id,
    required this.nickname, required this.usualStartHour});
}