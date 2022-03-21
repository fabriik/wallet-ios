import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.result,
    this.error,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    result: json['result'],
    error: json['error'],
    data: Data.fromJson(json['data']),
  );

  String result;
  dynamic error;
  Data data;

  Map<String, dynamic> toJson() => {
        'result': result,
        'error': error,
        'data': data.toJson(),
      };
}

class Data {
  Data({
    required this.sessionKey,
    required this.needMfaToken,
    required this.authappEnabled,
    required this.smsEnabled,
    required this.emailEnabled,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sessionKey: json['sessionKey'],
    needMfaToken: json['needMfaToken'],
    authappEnabled: json['authapp_enabled'],
    smsEnabled: json['sms_enabled'],
    emailEnabled: json['email_enabled'],
  );

  String sessionKey;
  bool needMfaToken;
  int authappEnabled;
  int smsEnabled;
  int emailEnabled;

  Map<String, dynamic> toJson() => {
        'sessionKey': sessionKey,
        'needMfaToken': needMfaToken,
        'authapp_enabled': authappEnabled,
        'sms_enabled': smsEnabled,
        'email_enabled': emailEnabled,
      };
}
