abstract class RegisterUnpaidShiftEvent {}
class NewShiftEvent extends RegisterUnpaidShiftEvent{}
class SaveEvent extends RegisterUnpaidShiftEvent{}
class StartDateTimeEvent extends RegisterUnpaidShiftEvent{
  final DateTime value;
  StartDateTimeEvent(this.value);
}
class EndDateTimeEvent extends RegisterUnpaidShiftEvent{
  final DateTime value;
  EndDateTimeEvent(this.value);
}