import 'package:carerstimelogger/Extensions.dart';
import 'package:intl/intl.dart';

import '../ShiftDataModel.dart';
import 'CarersToPayShiftDataModel.dart';

class CarerToPayDataModel{
  final String nickname;
  final int usualStartHour;
  final String id;
  final double rate;

  final List<CarersToPayShiftDataModel> allUnpaidShifts = List.empty(growable: true);

  DateTime get earliestStart => allUnpaidShifts.fold(DateTime(2900), (min, e) => e.start.millisecondsSinceEpoch < min.millisecondsSinceEpoch ? e.start : min);
  DateTime get latestEnd => allUnpaidShifts.fold(DateTime(1900), (max, e) => e.end.millisecondsSinceEpoch > max.millisecondsSinceEpoch ? e.end : max);

  double get _totalHours => allUnpaidShifts.fold(0, (sum, next) => sum + next.hours);
  double get hours => double.parse((_totalHours).toStringAsFixed(1));

  double get _totalOverlappedHours => allUnpaidShifts.fold(0, (sum, next) => sum + next.overlappedHours);
  double get overlappedHours => double.parse((_totalOverlappedHours).toStringAsFixed(1));
  bool get isOverlapping => overlappedHours>0;

  double get totalToPay => double.parse((hours * rate).toStringAsFixed(1));


  String getTextToShare(){
    final buffer = StringBuffer();

    buffer.write("PAGO TURNOS ${nickname.toUpperCase()}\r\n");
    buffer.write("${earliestStart.fromLocalToColombianTime().formatDateTime().toCapitalized()} -> ${latestEnd.fromLocalToColombianTime().formatDateTime().toCapitalized()}\r\n");
    buffer.write("\r\n");
    buffer.write("${allUnpaidShifts.length} TURNOS:\r\n");
    for(final shift in allUnpaidShifts){
      buffer.write("* ${shift.start.fromLocalToColombianTime().formatDateTime().toCapitalized()} -> ${shift.end.fromLocalToColombianTime().formatDateTime().toCapitalized()} = ${shift.hours}h\r\n");
    }
    buffer.write("\r\n");
    buffer.write("Total Horas: ${hours}h\r\n");
    buffer.write("Total a Pagar : ${hours}h x ${NumberFormat.currency(symbol: '\$',decimalDigits: 0).format(rate)}\r\n");
    buffer.write("\r\n");
    buffer.write("Total a Pagar : ${NumberFormat.currency(symbol: '\$',decimalDigits: 0).format(totalToPay)}\r\n");
    final encodee = Uri.encodeFull(buffer.toString());
    return encodee;

  }


  CarerToPayDataModel({required this.id,
    required this.nickname, required this.usualStartHour, required this.rate });



}