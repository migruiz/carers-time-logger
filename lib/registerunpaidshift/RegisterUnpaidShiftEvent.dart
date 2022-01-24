abstract class RegisterUnpaidShiftEvent {}
class NewShiftEvent extends RegisterUnpaidShiftEvent{
  final String carerId;
  NewShiftEvent({required this.carerId});
}
class EditShiftEvent extends RegisterUnpaidShiftEvent{
  final String shiftId;
  final String carerId;
  EditShiftEvent({required this.carerId, required this.shiftId});
}
class SaveEvent extends RegisterUnpaidShiftEvent{}
class DeleteEvent extends RegisterUnpaidShiftEvent{}
class StartDateTimeEvent extends RegisterUnpaidShiftEvent{
  final DateTime value;
  StartDateTimeEvent(this.value);
}
class EndDateTimeEvent extends RegisterUnpaidShiftEvent{
  final DateTime value;
  EndDateTimeEvent(this.value);
}