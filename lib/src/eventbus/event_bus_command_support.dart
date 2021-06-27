import 'package:event_bus/event_bus.dart';
import 'package:fengwuxp_dart_basic/index.dart';
import '../command_support.dart';

final _COMMANDS = ["send", "receive"];

/// The function/method signature for the event handler
typedef void EventConsumer<T>(T element);

/// The class manages the subscription to event bus
class EventSubscription {
  Function _destroyConsumer;

  EventSubscription(this._destroyConsumer);

  /// No harm to call more than once.
  void dispose() {
    this._destroyConsumer();
  }
}

class _EventWrapper {
  final String name;

  final dynamic value;

  _EventWrapper(this.name, this.value);
}

class EventBusCommandSupport extends CommandSupport {
  final eventBus = EventBus();

  final Map<String, List<EventConsumer>> _consumerRegistry = {};

  MethodNameCommandResolver _methodNameCommandResolver;

  EventBusCommandSupport(this._methodNameCommandResolver) {
    eventBus.on<_EventWrapper>().listen((event) {
      _getConsumers(event.name).forEach((consumer) {
        consumer(event.value);
      });
    });
  }

  factory () {
    return new EventBusCommandSupport(toLineResolver);
  }

  @override
  noSuchMethod(Invocation invocation) {
    final memberName = parseSymbolName(invocation.memberName);
    final commands = this.tryConverterMethodNameCommandResolver(memberName, _COMMANDS, _COMMANDS[0]);
    var eventName = this._methodNameCommandResolver(commands[1]);
    eventName = eventName.substring(1, eventName.length).toUpperCase();
    final positionalArguments = invocation.positionalArguments;

    switch (commands[0]) {
      case "send":
        return eventBus.fire(_EventWrapper(eventName, positionalArguments.first));
      case "receive":
        return _registerConsumer(eventName, _wrapperConsumer(positionalArguments.first));
    }
  }

  EventConsumer _wrapperConsumer(consumer) {
    return (element) {
      consumer(element);
    };
  }

  EventSubscription _registerConsumer(String eventName, EventConsumer wrapperConsumer) {
    _addEventConsumer(eventName, wrapperConsumer);
    return new EventSubscription(() {
      _disposeConsumer(eventName, wrapperConsumer);
    });
  }

  void _addEventConsumer(String eventName, EventConsumer consumer) {
    List<EventConsumer> consumers = _getConsumers(eventName);
    if (consumers.length == 0) {
      this._consumerRegistry[eventName] = consumers;
    }
    consumers.add(consumer);
  }

  List<EventConsumer> _getConsumers(String eventName) {
    return this._consumerRegistry[eventName] ?? [];
  }

  void _disposeConsumer(String eventName, EventConsumer consumer) {
    _getConsumers(eventName).remove(consumer);
  }
}
