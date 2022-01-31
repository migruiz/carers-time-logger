import 'package:carerstimelogger/carerstopaylist/CarersToPayListWidget.dart';
import 'package:carerstimelogger/navigation/NavigationBloc.dart';
import 'package:carerstimelogger/navigation/NavigationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> _urlHandlerRouterDelegateNavigatorKey =
GlobalKey<NavigatorState>();
class NavigationRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {

  NavigationState? current;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        current = state;
        notifyListeners();
        return Navigator(
          key: navigatorKey,
          pages: [
            MaterialPage(
              key: ValueKey('PayShifts'),
              child: CarersToPayListWidget(),
            ),
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) return false;
            return true;
          },
        );
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _urlHandlerRouterDelegateNavigatorKey;

  @override
  Future<void> setNewRoutePath(NavigationState navigationState) async{
    notifyListeners();
    return null;
  }

  @override
  NavigationState get currentConfiguration {
    return current??PayShiftsState();
  }
}