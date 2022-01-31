import 'package:carerstimelogger/navigation/NavigationState.dart';
import 'package:flutter/material.dart';


class NavigationRouteInformationParser extends RouteInformationParser<NavigationState> {
  ///get a location (path) from the system and build your route wrapping object
  @override
  Future<NavigationState> parseRouteInformation(RouteInformation routeInformation) async {
    final String path = routeInformation.location ?? '';
    final uri = Uri.parse(path);
    if (uri.pathSegments.length==1){
      final first = uri.pathSegments[0].toLowerCase();
      if (first=="payshifts"){
        return PayShiftsState();
      }
    }
    else  if (uri.pathSegments.length==2){
      final first = uri.pathSegments[0].toLowerCase();
      final second = uri.pathSegments[1].toLowerCase();
      if (first=="payshifts"){
        return PayShiftsDetailsState(second);
      }
    }
    return RouteNotFoundState();
  }

  ///update the URL bar with the latest URL from the app
  @override
  RouteInformation? restoreRouteInformation(NavigationState state) {
    if (state is PayShiftsState) {
      return RouteInformation(location: '/payshifts');
    }
    else if (state is PayShiftsDetailsState) {
      return RouteInformation(location: '/payshifts/${state.carerId}');
    }
    return RouteInformation(location: '/404');
  }
}