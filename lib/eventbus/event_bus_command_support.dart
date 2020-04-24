import 'package:fengwuxp_dart_basic/src/resolve/simple_method_name_command_resolver.dart';
import 'package:fengwuxp_dart_basic/src/utils/symbol_parser.dart';
import 'package:flutter_event_bus/flutter_event_bus.dart';

import '../command_support.dart';

final _COMMANDS = ["send", "receive"];

class EventBusCommandSupport extends CommandSupport {
  final eventBus = EventBus();

  MethodNameCommandResolver _methodNameCommandResolver;

  EventBusCommandSupport([MethodNameCommandResolver methodNameCommandResolver]) {
    if (methodNameCommandResolver == null) {
      methodNameCommandResolver = toLineResolver;
    }
    this._methodNameCommandResolver = methodNameCommandResolver;
  }

  factory() {
    return new EventBusCommandSupport();
  }

  @override
  noSuchMethod(Invocation invocation) {
    final memberName = parseSymbolName(invocation.memberName);
    final commands = this.tryConverterMethodNameCommandResolver(memberName, _COMMANDS, _COMMANDS[0]);
    var key = this._methodNameCommandResolver(commands[1]);
    key = key.substring(1, key.length).toUpperCase();
    final positionalArguments = invocation.positionalArguments;

    switch (commands[0]) {
      case "send":
        eventBus.publish(positionalArguments?.first);
        break;
      case "receive":
        eventBus.respond((result) {
          var fn = positionalArguments?.first;
          if (fn != null) {
            fn(result);
          }
        });
        break;
    }
  }
}
