import 'package:android_intent/android_intent.dart';
final intent = AndroidIntent(action: 'android.intent.action.PHONE_STATE');
final result = await intent.startActivityForResult();

if (result.resultCode == ActivityResultCode.ok) {
  final callerId = result.data.getStringExtra('android.intent.extra.PHONE_NUMBER');
  print('Caller ID: $callerId');
}

