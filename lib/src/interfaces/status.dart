enum StatusType { start, activated, pendingRoute, acceptedRoute, goRoute }

class Status {
  StatusType _type;
  String _description;

  Status(this._type, [String? description])
      : _description = description ?? _getDefaultDescription(_type);

  // Getters
  StatusType get type => _type;
  String get description => _description;

  // Setter for type with automatic description update
  set type(StatusType newType) {
    _type = newType;
    _description = _getDefaultDescription(newType);
  }

  // Method to change state
  void changeState(StatusType newType, [String? newDescription]) {
    _type = newType;
    _description = newDescription ?? _getDefaultDescription(newType);
  }

  // Specific method to change to activated state
  void activate() {
    changeState(StatusType.activated);
  }

  // Static method for default descriptions
  static String _getDefaultDescription(StatusType type) {
    switch (type) {
      case StatusType.start:
        return 'Process has started';
      case StatusType.activated:
        return 'Status has been activated';
      case StatusType.pendingRoute:
        return 'Route is pending';
      case StatusType.acceptedRoute:
        return 'Route has been accepted';
      case StatusType.goRoute:
        return 'Route has been accepted';
    }
  }

  // Get the current state as a string
  String get currentState => _type.toString().split('.').last;

  // Method to get the current state
  String getCurrentState() => currentState;

  @override
  String toString() => '$currentState: $_description';

  // State check methods
  bool isStart() => _type == StatusType.start;
  bool isActivated() => _type == StatusType.activated;
  bool isPendingRoute() => _type == StatusType.pendingRoute;
  bool isAcceptedRoute() => _type == StatusType.acceptedRoute;
  bool isGoRoute() => _type == StatusType.goRoute;

  // Method to compare states
  bool is_(StatusType otherType) => _type == otherType;
}
