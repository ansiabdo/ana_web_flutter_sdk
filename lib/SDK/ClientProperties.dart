class ClientProperties {
  final String authority;
  final String clientId;
  final String scopes;
  final String channel;
  final String responseType;
  final String redirectUri;
  String? callbackUri;
  String? ConsentMode;

  ClientProperties(
      {required this.authority,
      required this.clientId,
      required this.scopes,
      required this.channel,
      required this.responseType,
      required this.redirectUri,
      this.callbackUri,
      this.ConsentMode});

  String getStartUrl() {
    final Uri uri =
        Uri.parse(authority + '/conn/auth').replace(queryParameters: {
      'response_type': responseType,
      'client_id': clientId,
      'scope': scopes,
      'redirect_uri': redirectUri,
      'channel': channel,
      'consent_mode': ConsentMode
    });
    return uri.toString();
  }

  String getCallbackUrl() {
    final Uri uri = Uri.parse(callbackUri!);
    return uri.toString();
  }
}
