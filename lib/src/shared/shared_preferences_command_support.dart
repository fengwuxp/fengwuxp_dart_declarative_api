import 'package:built_value/serializer.dart';
import 'package:fengwuxp_dart_basic/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../command_support.dart';

final _COMMANDS = ["get", "set", "remove"];

class SharedPreferencesCommandSupport extends CommandSupport {
  MethodNameCommandResolver _methodNameCommandResolver;

  BuiltJsonSerializers _jsonSerializers;

  Serializers _serializers;

  SharedPreferencesCommandSupport(Serializers serializers, MethodNameCommandResolver methodNameCommandResolver) {
    this._serializers = serializers;
    this._jsonSerializers = new BuiltJsonSerializers(_serializers);
    this._methodNameCommandResolver = methodNameCommandResolver;
  }

  factory(Serializers serializers, [MethodNameCommandResolver methodNameCommandResolver]) {
    if (methodNameCommandResolver == null) {
      return new SharedPreferencesCommandSupport(serializers, toLineResolver);
    }
    return new SharedPreferencesCommandSupport(serializers, methodNameCommandResolver);
  }

  @override
  noSuchMethod(Invocation invocation) async {
    final memberName = parseSymbolName(invocation.memberName);
    final commands = this.tryConverterMethodNameCommandResolver(memberName, _COMMANDS, _COMMANDS[0]);
    var key = this._methodNameCommandResolver(commands[1]);
    key = key.substring(1, key.length).toUpperCase();

    final positionalArguments = invocation.positionalArguments;
    switch (commands[0]) {
      case "get":
        return this.get(key, positionalArguments.first);
      case "set":
        return this.set(key, positionalArguments.first);
      case "remove":
        return this.remove(key);
    }
  }

  Future<bool> set(String key, value) async {
    return _storage(value, key);
  }

  Future<T> get<T>(String key, [Type resultType]) async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    if (resultType == int) {
      return Future.value(prefs.getInt(key) as T);
    }
    if (resultType == double) {
      return Future.value(prefs.getDouble(key) as T);
    }
    if (resultType == bool) {
      return Future.value(prefs.getBool(key) as T);
    }
    if (resultType == String) {
      return Future.value(prefs.getString(key) as T);
    }

    var result = prefs.getString(key);
    if (!StringUtils.hasText(result)) {
      return Future.error(null);
    }
    return this._jsonSerializers.parseObject(result, serializer: _serializerForType(resultType)) as Future<T>;
  }

  Future<bool> remove(String key) async {
    return getSharedPreferencesInstance().then((instance) => instance.remove(key));
  }

  Future<Set<String>> keys() async {
    return getSharedPreferencesInstance().then((instance) => instance.getKeys());
  }

  Future<bool> containsKey(String key) async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    return prefs.containsKey(key);
  }

  Future<SharedPreferences> getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }

  Future<bool> _storage(value, String key) async {
    if (value == null) {
      return Future.value(true);
    }
    SharedPreferences prefs = await getSharedPreferencesInstance();
    if (value is int) {
      return prefs.setInt(key, value);
    }
    if (value is double) {
      return prefs.setDouble(key, value);
    }
    if (value is bool) {
      return prefs.setBool(key, value);
    }
    if (value is String) {
      return prefs.setString(key, value);
    }
    if (value is Iterable) {
      return prefs.setString(key, _jsonSerializers.toJson(value));
    }
    return prefs.setString(key, this._jsonSerializers.toJson(value, serializer: _serializerForType(value.runtimeType)));
  }

  Serializer<dynamic> _serializerForType(Type resultType) {
    return _serializers.serializerForType(resultType);
  }
}
