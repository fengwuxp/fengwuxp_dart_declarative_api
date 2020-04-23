import 'package:built_value/serializer.dart';
import 'package:fengwuxp_dart_basic/src/json/built_json_serializers.dart';
import '../../lib/shared/shared_preferences_command_support.dart';
import 'package:fengwuxp_dart_basic/src/resolve/simple_method_name_command_resolver.dart';
import '../built/data_model.dart';
import '../built/serializers.dart';

class MockSharedCommandSupport extends SharedPreferencesCommandSupport {
  MockSharedCommandSupport() : super(new BuiltJsonSerializers(serializers), toLineResolver);

  Future setCount(int val);

  Future<int> getCount() {
    return this.getInner<int>("getCount", resultType: int);
  }

  Future removeCount();

  Future setChat(Chat chat, {Serializer<Chat> serializer});

  Future<Chat> getChat() {
    return this.getInner<Chat>("getChat", serializer: Chat.serializer);
  }

  Future removeChat();
}
