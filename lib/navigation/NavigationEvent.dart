abstract class NavigationEvent{}
class NotFoundRouteEvent extends NavigationEvent{}
class PayShiftsEvent extends NavigationEvent{}
class PayShiftsDetailsEvent extends NavigationEvent{
  final String carerId;

  PayShiftsDetailsEvent(this.carerId);
}