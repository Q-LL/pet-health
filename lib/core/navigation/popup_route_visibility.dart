import 'package:flutter/material.dart';

/// Tracks transient routes across the root and stateful-shell navigators.
///
/// The home recording action is intentionally a root-page action. Dialogs,
/// menus and bottom sheets temporarily suppress it so it does not compete with
/// the foreground task.
class PopupRouteVisibilityController extends ChangeNotifier {
  final Set<Route<dynamic>> _routes = <Route<dynamic>>{};

  bool get hasVisiblePopup => _routes.isNotEmpty;

  void add(Route<dynamic> route) {
    if (_routes.add(route)) notifyListeners();
  }

  void remove(Route<dynamic>? route) {
    if (route != null && _routes.remove(route)) notifyListeners();
  }
}

class PopupRouteVisibilityObserver extends NavigatorObserver {
  PopupRouteVisibilityObserver(this.controller);

  final PopupRouteVisibilityController controller;

  bool _isPopup(Route<dynamic>? route) => route is PopupRoute<dynamic>;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_isPopup(route)) controller.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    controller.remove(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    controller.remove(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    controller.remove(oldRoute);
    if (_isPopup(newRoute)) controller.add(newRoute!);
  }
}
