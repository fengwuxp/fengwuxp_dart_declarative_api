import 'package:flutter_test/flutter_test.dart';

import 'mock_event_bus_command_support.dart';

void main() {
  test('shared preferences test', () async {
    MockEventBusCommandSupport mockSharedCommandSupport = new MockEventBusCommandSupport();

    var subscription = mockSharedCommandSupport.receiveUserLogin((result) {
      print("receive $result");
    });

    mockSharedCommandSupport.sendUserLogin(true);
    subscription.dispose();
    mockSharedCommandSupport.sendUserLogin(true);
  });
}
