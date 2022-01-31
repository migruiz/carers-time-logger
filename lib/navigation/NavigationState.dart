abstract class NavigationState{}
class RouteNotFoundState extends NavigationState{}
class PayShiftsState extends NavigationState{}
class PayShiftsDetailsState extends NavigationState{
  final String carerId;

  PayShiftsDetailsState(this.carerId);

}