abstract class UnpaidShiftsEvent {}
class LoadDataEvent extends UnpaidShiftsEvent{
  final String carerId;

  LoadDataEvent({required this.carerId});
}