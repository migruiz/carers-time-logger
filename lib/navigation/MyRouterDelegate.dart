import 'package:carerstimelogger/carerstopaylist/CarersToPayListWidget.dart';
import 'package:carerstimelogger/navigation/NavigationBloc.dart';
import 'package:carerstimelogger/navigation/NavigationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, authenticationState) {
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
  Future<void> setNewRoutePath(configuration) async => null;
}