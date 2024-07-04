class LoginResult {
  bool isError;
  String error;
  String errorDescription;
  String code;

  LoginResult({
    this.isError = false,
    this.error = '',
    this.errorDescription = '',
    this.code = '',
  });
}