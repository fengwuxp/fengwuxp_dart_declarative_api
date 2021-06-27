import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../built/data_model.dart';
import '../built/serializers.dart';
import 'mcok_shared_command_support.dart';

//@TestOn('vm')

void main() {
  test('shared preferences test', () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');

    await prefs.setInt('counter', counter);
  });

  test('shared command test', () async {
    var test = Chat.serializer;
    var serializerForType = serializers.serializerForType(Chat);
    print(test == serializerForType);
    MockSharedCommandSupport mockSharedCommandSupport = new MockSharedCommandSupport();
    var chat = Chat((b) => b..text = "1");
    var type = serializers.serializerForType(chat.runtimeType);
    mockSharedCommandSupport.setChat(chat);
    await mockSharedCommandSupport.getCount();
//    var chat = Chat((b) => b..text = "");
//    await mockSharedCommandSupport.setChat(chat);
//    chat = await mockSharedCommandSupport.getChat();
//    print("$chat");
  });
}
