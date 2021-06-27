import 'package:flutter_test/flutter_test.dart';

import 'mock_event_bus_command_support.dart';

void main() {
  test('shared preferences test', () async {
    MockEventBusCommandSupport mockSharedCommandSupport = new MockEventBusCommandSupport();

    var subscription = mockSharedCommandSupport.receiveUserLogin((result) {
      print("receive is login $result");
    });
    mockSharedCommandSupport.receiveUserLogin((result) {
      print("receive is login 2 $result");
    });
    mockSharedCommandSupport.receiveExample((example) {
      print("receive is example $example");
    });

    mockSharedCommandSupport.sendUserLogin(true);
    mockSharedCommandSupport.sendUserLogin(true);
    mockSharedCommandSupport.sendExample("text");
    await Future.delayed(Duration(milliseconds: 100));
    subscription.dispose();
    mockSharedCommandSupport.sendUserLogin(false);
  });
}
