import 'package:flutter/services.dart';

const platform = MethodChannel('kyc-platform-channels');

Future<String?> getSessionKey() async {
  try {
    final key = await platform.invokeMethod<dynamic>('getSessionKey');
    return key as String;
  } catch (e) {
    print(e);
    return null;
  }
}
