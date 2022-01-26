import '../CarerData.dart';

abstract class CarersListState{}
class LoadingState extends CarersListState{}
class LoadedState extends CarersListState{
  final List<CarerData> carers;

  LoadedState({required this.carers});
}