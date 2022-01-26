import '../CarerData.dart';
import 'CarersToPayDataModel.dart';

abstract class CarersToPayListState{}
class LoadingState extends CarersToPayListState{}
class LoadedState extends CarersToPayListState{
  final List<CarerToPayDataModel> carers;

  LoadedState({required this.carers});
}