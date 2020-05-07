import 'package:built_value/serializer.dart';
import 'package:fengwuxp_dart_basic/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../command_support.dart';

final _COMMANDS = ["get", "set", "remove"];

class SharedPreferencesCommandSupport extends CommandSupport {
  MethodNameCommandResolver _methodNameCommandResolver;

  BuiltJsonSerializers _jsonSerializers;

  SharedPreferencesCommandSupport(BuiltJsonSerializers jsonSerializers,
      MethodNameCommandResolver methodNameCommandResolver) {
    this._jsonSerializers = jsonSerializers;
    this._methodNameCommandResolver = methodNameCommandResolver;
  }

  factory(BuiltJsonSerializers jsonSerializers,
      [MethodNameCommandResolver methodNameCommandResolver]) {
    if (methodNameCommandResolver == null) {
      return new SharedPreferencesCommandSupport(
          jsonSerializers, toLineResolver);
    }
    return new SharedPreferencesCommandSupport(
        jsonSerializers, methodNameCommandResolver);
  }

  @override
  noSuchMethod(Invocation invocation) async {
    final memberName = parseSymbolName(invocation.memberName);
    final commands = this.tryConverterMethodNameCommandResolver(
        memberName, _COMMANDS, _COMMANDS[0]);
    var key = this._methodNameCommandResolver(commands[1]);
    key = key.substring(1, key.length).toUpperCase();
    final positionalArguments = invocation.positionalArguments;
    final namedArguments = invocation.namedArguments;
    final serializer = namedArguments[Symbol("serializer")];
    final typeArguments = invocation.typeArguments;
    switch (commands[0]) {
      case "get":
        return this.get(key, typeArguments?.first, serializer);
      case "set":
        return this.set(key, positionalArguments?.first, serializer);
      case "remove":
        return this.remove(key);
    }
  }

  Future set(String key, value, [Serializer serializer]) async {
    if (value == null) {
      return Future.value(true);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
    return prefs.setString(
        key, this._jsonSerializers.toJson(value, serializer: serializer));
  }

  Future<T> getInner<T>(String methodName,
      {Type resultType, Serializer serializer}) async {
    final commands = this.tryConverterMethodNameCommandResolver(
        methodName, _COMMANDS, _COMMANDS[0]);
    final key = this._methodNameCommandResolver(commands[1]);
    return this.get(key, resultType, serializer);
  }

  Future<T> get<T>(String key, [Type resultType, Serializer serializer]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (resultType == int) {
      return prefs.getInt(key) as Future<T>;
    }
    if (resultType == double) {
      return prefs.getDouble(key) as Future<T>;
    }
    if (resultType == bool) {
      return prefs.getBool(key) as Future<T>;
    }
    if (resultType == String) {
      return prefs.getString(key) as Future<T>;
    }

    var result = await prefs.getString(key);
    if (!StringUtils.hasText(result)) {
      return Future.value(null);
    }
    return this._jsonSerializers.parseObject(result, serializer: serializer)
        as Future<T>;
  }

  Future remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  Future<Set<String>> keys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }

  Future<bool> containsKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
