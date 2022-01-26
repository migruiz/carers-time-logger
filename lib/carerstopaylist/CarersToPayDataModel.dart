import '../ShiftDataModel.dart';
import 'CarersToPayShiftDataModel.dart';

class CarerToPayDataModel{
  final String nickname;
  final int usualStartHour;
  final String id;
  final double rate;

  final List<CarersToPayShiftDataModel> allUnpaidShifts = List.empty(growable: true);

  double get _totalHours => allUnpaidShifts.fold(0, (sum, next) => sum + next.hours);
  double get hours => double.parse((_totalHours).toStringAsFixed(1));

  double get _totalOverlappedHours => allUnpaidShifts.fold(0, (sum, next) => sum + next.overlappedHours);
  double get overlappedHours => double.parse((_totalOverlappedHours).toStringAsFixed(1));
  bool get isOverlapping => overlappedHours>0;

  double get totalToPay => double.parse((hours * rate).toStringAsFixed(1));


  CarerToPayDataModel({required this.id,
    required this.nickname, required this.usualStartHour, required this.rate });



}