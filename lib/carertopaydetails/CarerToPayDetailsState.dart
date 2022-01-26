import 'package:carerstimelogger/carerstopaylist/CarersToPayDataModel.dart';

abstract class CarerToPayDetailsState{}
class LoadingState extends CarerToPayDetailsState{}
class SavedState extends CarerToPayDetailsState{}
class LoadedState extends CarerToPayDetailsState{
  final CarerToPayDataModel carer;
  final bool saving;
  bool get canPay  => carer.allUnpaidShifts.isNotEmpty;
  LoadedState({required this.carer, required this.saving});
}