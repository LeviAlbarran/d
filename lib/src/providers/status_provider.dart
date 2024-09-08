import 'package:cengodelivery/src/interfaces/Status.dart';
import 'package:flutter/material.dart';

class StatusProvider extends ChangeNotifier {
  Status _status = Status(StatusType.start);

  Status get status => _status;

  void setStatus(StatusType newType, [String? newDescription]) {
    _status.changeState(newType, newDescription);
    notifyListeners();
  }

  void activate() {
    _status.activate();
    notifyListeners();
  }

  void setPendingRoute() {
    setStatus(StatusType.pendingRoute);
  }

  void setAcceptedRoute() {
    setStatus(StatusType.acceptedRoute);
  }

  bool isStart() => _status.isStart();
  bool isActivated() => _status.isActivated();
  bool isPendingRoute() => _status.isPendingRoute();
  bool isAcceptedRoute() => _status.isAcceptedRoute();
  bool isGoRoute() => _status.isGoRoute();

  String getCurrentState() => _status.getCurrentState();
  String get currentState => _status.currentState;

  @override
  String toString() => _status.toString();
}
