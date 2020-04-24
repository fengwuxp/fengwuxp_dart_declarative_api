import 'package:fengwuxp_dart_declarative_api/command_support.dart';
import 'package:fengwuxp_dart_basic/src/querystring/query_string_parser.dart';
import 'package:fengwuxp_dart_basic/src/resolve/simple_method_name_command_resolver.dart';
import 'package:fengwuxp_dart_basic/src/utils/symbol_parser.dart';
import 'package:fengwuxp_dart_basic/src/utils/string_utils.dart';
import 'package:fenguwxp_fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_boost/flutter_boost.dart';
import './route_command.dart';

final _COMMANDS = [
  RouteCommand.push.toString(),
  RouteCommand.pop.toString(),
  RouteCommand.popAndPush.toString(),
  RouteCommand.popToTop.toString(),
  RouteCommand.reLaunch.toString(),
  RouteCommand.replace.toString(),
  RouteCommand.switchTab.toString(),
];

// 跳转原生 Activity
const String NATIVE_ROUTE_SCHEMA = "native://";

// 通过打开新Activity方式打开flutter页面
const String FLUTTER_ROUTE_SCHEMA = "flutter://";

/// 声明式路由支持
/// 基于flutter_boots和 fluro
/// 通过noSuchMethod 代理跳转
/// 方法定义
///    如果是 flutter内的跳转，通过识别，第一个参数是否为 [BuildContext]
class RouteCommandSupport extends CommandSupport {
  MethodNameCommandResolver _methodNameCommandResolver;

  @override
  noSuchMethod(Invocation invocation) {
    final namedArguments = invocation.namedArguments;
    final positionalArguments = invocation.positionalArguments;
    final context = positionalArguments.first;
    final memberName = parseSymbolName(invocation.memberName);
    final commands = this.tryConverterMethodNameCommandResolver(memberName, _COMMANDS, _COMMANDS[0]);

    String pathname = namedArguments[Symbol("pathname")];
    if (!StringUtils.hasText(pathname)) {
      pathname = commands[1];
      pathname = initialLowercase(pathname);
      pathname = this._methodNameCommandResolver(pathname);
    }
    if (context is BuildContext) {
      var command = namedArguments[Symbol("command")];
      if (command == null) {
        command = commands[0];
      } else {
        command.toString();
      }

      return _navigateToFlutterView(context, pathname, positionalArguments, namedArguments, command);
    }

    final isNative = namedArguments[Symbol("isNative")];
    if (isNative == null || isNative == false) {
      // 默认是通过原生打开flutter页面
      pathname = "$FLUTTER_ROUTE_SCHEMA$pathname";
    } else {
      // 默认是打开原生的页面
      pathname = "$NATIVE_ROUTE_SCHEMA$pathname";
    }
    final state = namedArguments[Symbol("state")];
    final params = namedArguments[Symbol("params")];
    return FlutterBoost.singleton.open(pathname, urlParams: params, exts: state).then((Map value) {
      print("did recieve first route result");
      print("did recieve first route result $value");
    });
  }

  // 返回上一页
  void goBack(BuildContext context) {
    Router.appRouter.pop(context);
  }

  Future<T> _navigateToFlutterView<T>(
      BuildContext context, String url, List<dynamic> parameters, Map<Symbol, dynamic> namedArguments, command) {
    var replace = false;
    var clearStack = false;

//    RouteCommand.push.toString(),
//    RouteCommand.pop.toString(),
//    RouteCommand.popAndPush.toString(),
//    RouteCommand.popToTop.toString(),
//    RouteCommand.reLaunch.toString(),
//    RouteCommand.replace.toString(),
//    RouteCommand.switchTab.toString(),
    switch (command) {
      case "push":
        break;
      case "popAndPush":
      case "replace":
        replace = true;
        break;
      case "popToTop":
      case "reLaunch":
        clearStack = true;
        break;
    }

    return Router.appRouter.navigateTo(context, url,
        parameters: parameters,
        replace: replace,
        clearStack: clearStack,
        transition: namedArguments[Symbol("transition")],
        transitionDuration: namedArguments[Symbol("transitionDuration")],
        transitionBuilder: namedArguments[Symbol("transitionBuilder")]);
  }

//  String _handleQueryParams(String uriTemplate, Map<String, dynamic> queryParams) {
//    // 加入查询参数
//    var hasQueryString = uriTemplate.contains(QueryStringParser.QUERY_TRING_SEP);
//    if (hasQueryString) {
//      var urls = uriTemplate.split(QueryStringParser.QUERY_TRING_SEP);
//      var map = QueryStringParser.parse(urls[1]);
//      map.addAll(queryParams);
//      queryParams = map;
//      uriTemplate = urls[0];
//    }
//    var queryString = QueryStringParser.stringify(queryParams);
//    StringBuffer url = new StringBuffer();
//    if (uriTemplate.endsWith(QueryStringParser.SEP)) {
//      // 以 & 结尾
//      url.write(uriTemplate);
//      url.write(queryString);
//    } else {
//      if (hasQueryString) {
//        url.write(uriTemplate);
//        url.write(QueryStringParser.SEP);
//        url.write(queryString);
//      } else {
//        url.write(uriTemplate);
//        url.write(QueryStringParser.QUERY_TRING_SEP);
//        url.write(queryString);
//      }
//    }
//    return url.toString();
//  }
}
