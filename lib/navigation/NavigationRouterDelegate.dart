import 'package:carerstimelogger/carerstopaylist/CarersToPayListWidget.dart';
import 'package:carerstimelogger/carertopaydetails/CarerToPayDetailsWidget.dart';
import 'package:carerstimelogger/navigation/NavigationBloc.dart';
import 'package:carerstimelogger/navigation/NavigationState.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> _urlHandlerRouterDelegateNavigatorKey =
GlobalKey<NavigatorState>();
class NavigationRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {

  NavigationState? current;
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: getPages(current!),
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        popRoute();
        if (current is PayShiftsDetailsState){
          current = PayShiftsState();
        }
        notifyListeners();
        return true;
      },
    );
  }

  List<Page> getPages(NavigationState state) {
    if (state is PayShiftsDetailsState) {
      return [
        MaterialPage(
          key: ValueKey('PayShifts'),
          child: CarersToPayListWidget(),
        ),
          MaterialPage(
            key: ValueKey('PayShiftsDetails'),
            child: CarerToPayDetailsWidget(carerId: state.carerId),
          )
      ];
    }
    if (state is PayShiftsState){
      return [
        MaterialPage(
          key: ValueKey('PayShifts'),
          child: CarersToPayListWidget(),
        )
      ];
    }
    else{
      return [
        MaterialPage(
          key: ValueKey('Unknown'),
          child: Text("Unknown"),
        )
      ];
    }
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _urlHandlerRouterDelegateNavigatorKey;

  @override
  Future<void> setNewRoutePath(NavigationState navigationState) async{
    current = navigationState;
    notifyListeners();
    return null;
  }

  @override
  NavigationState? get currentConfiguration {
    return current;
  }
}