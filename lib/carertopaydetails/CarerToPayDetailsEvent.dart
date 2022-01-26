import 'package:carerstimelogger/carerstopaylist/CarersToPayDataModel.dart';

abstract class CarerToPayDetailsEvent{}
class LoadDataEvent extends CarerToPayDetailsEvent{
  final String carerId;
  LoadDataEvent({ required this.carerId});
}
class PayEvent extends CarerToPayDetailsEvent{}