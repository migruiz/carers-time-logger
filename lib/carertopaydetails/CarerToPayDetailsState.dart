import 'package:carerstimelogger/carerstopaylist/CarersToPayDataModel.dart';

abstract class CarerToPayDetailsState{}
class LoadingState extends CarerToPayDetailsState{}
class LoadedState extends CarerToPayDetailsState{
  final CarerToPayDataModel carer;
  LoadedState({required this.carer});
}