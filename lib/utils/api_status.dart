class Success {
  int? code;
  Object? body;
  Success({this.code, this.body});
}

class Failure {
  int? code;
  String? errorResponse;
  Failure({this.code, this.errorResponse});
}
