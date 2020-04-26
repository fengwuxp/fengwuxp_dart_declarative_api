
import 'package:fengwuxp_dart_declarative_api/index.dart';
import 'package:flutter_event_bus/flutter_event_bus.dart';

class MockEventBusCommandSupport extends EventBusCommandSupport {

  Subscription receiveUserLogin(Responder<bool> responder);

  void sendUserLogin(bool isLogin);
}
