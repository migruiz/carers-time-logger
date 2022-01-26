import '../CarerData.dart';
import 'CarersToPayDataModel.dart';

abstract class CarersToPayListState{}
class LoadingState extends CarersToPayListState{}
class LoadedState extends CarersToPayListState{
  final List<CarerToPayDataModel> carers;
  double get totalHours => carers.fold(0, (sum, next) => sum + next.hours);
  LoadedState({required this.carers});
}