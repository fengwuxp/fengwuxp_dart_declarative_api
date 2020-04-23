import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../built/data_model.dart';
import 'mcok_shared_command_support.dart';

//@TestOn('vm')

void main() {
  test('shared preferences test', () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');

    await prefs.setInt('counter', counter);
  });

  test('shared preferences test', () async {
    MockSharedCommandSupport mockSharedCommandSupport = new MockSharedCommandSupport();
    mockSharedCommandSupport.setCount(1);
//    var chat = Chat((b) => b..text = "");
//    await mockSharedCommandSupport.setChat(chat);
//    chat = await mockSharedCommandSupport.getChat();
//    print("$chat");
  });
}
