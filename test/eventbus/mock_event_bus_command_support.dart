import 'package:fengwuxp_dart_basic/index.dart';
import 'package:fengwuxp_dart_declarative_api/index.dart';

class MockEventBusCommandSupport extends EventBusCommandSupport {
  MockEventBusCommandSupport() : super(toLineResolver);

  EventSubscription receiveUserLogin(EventConsumer<bool> responder);

  void sendUserLogin(bool isLogin);

  EventSubscription receiveExample(EventConsumer<String> responder);

  void sendExample(String text);
}
