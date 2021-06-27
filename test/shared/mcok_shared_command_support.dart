import 'package:fengwuxp_dart_basic/src/resolve/simple_method_name_command_resolver.dart';
import 'package:fengwuxp_dart_declarative_api/index.dart';

import '../built/data_model.dart';
import '../built/serializers.dart';

class MockSharedCommandSupport extends SharedPreferencesCommandSupport {
  MockSharedCommandSupport() : super(serializers, toLineResolver);

  Future setCount(int val);

  Future<int> getCount([Type resultType = int]);

  Future removeCount();

  Future setChat(Chat chat);

  Future<Chat> getChat([Type resultType = Chat]);

  Future removeChat();
}
