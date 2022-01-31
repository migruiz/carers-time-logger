import 'package:carerstimelogger/navigation/NavigationState.dart';
import 'package:flutter/material.dart';


class NavigationRouteInformationParser extends RouteInformationParser<NavigationState> {
  ///get a location (path) from the system and build your route wrapping object
  @override
  Future<NavigationState> parseRouteInformation(RouteInformation routeInformation) async {
    final String path = routeInformation.location ?? '';
    return PayShiftsState();
  }

  ///update the URL bar with the latest URL from the app
  @override
  RouteInformation? restoreRouteInformation(NavigationState configuration) {
    return RouteInformation(location: '/payshifts');
  }
}