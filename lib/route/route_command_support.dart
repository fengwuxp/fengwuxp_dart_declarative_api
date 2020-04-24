import 'package:fengwuxp_dart_declarative_api/command_support.dart';
import 'package:fengwuxp_dart_basic/src/querystring/query_string_parser.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_boost/flutter_boost.dart';

/// 声明式路由支持
/// 基于flutter_boots和 fluro
class RouteCommandSupport extends CommandSupport {
  @override
  noSuchMethod(Invocation invocation) {
    final namedArguments = invocation.namedArguments;
//    final positionalArguments = invocation.positionalArguments;
    final context = namedArguments[Symbol("context")];
    final url = namedArguments[Symbol("url")];
    final params = namedArguments[Symbol("params")];
    final state = namedArguments[Symbol("state")];
    if (context != null) {
      return _openView(context, this._handleQueryParams(url, params), params, state: state);
    }
    return FlutterBoost.singleton.open(url, urlParams: params, exts: state).then((Map value) {
      print("did recieve first route result");
      print("did recieve first route result $value");
    });
  }

  // 初始化路由
  /// [CommandAppRoute.setRouter]
  void initRoutes();

  Future<T> _openView<T>(BuildContext context, String url, Map<String, dynamic> params,
      {state,
      bool replace = false,
      bool clearStack = false,
      TransitionType transition,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    Router.appRouter.navigateTo(context, url,
        replace: replace,
        clearStack: clearStack,
        transition: transition,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder);
  }

  String _handleQueryParams(String uriTemplate, Map<String, dynamic> queryParams) {
    // 加入查询参数
    var hasQueryString = uriTemplate.contains(QueryStringParser.QUERY_TRING_SEP);
    if (hasQueryString) {
      var urls = uriTemplate.split(QueryStringParser.QUERY_TRING_SEP);
      var map = QueryStringParser.parse(urls[1]);
      map.addAll(queryParams);
      queryParams = map;
      uriTemplate = urls[0];
    }
    var queryString = QueryStringParser.stringify(queryParams);
    StringBuffer url = new StringBuffer();
    if (uriTemplate.endsWith(QueryStringParser.SEP)) {
      // 以 & 结尾
      url.write(uriTemplate);
      url.write(queryString);
    } else {
      if (hasQueryString) {
        url.write(uriTemplate);
        url.write(QueryStringParser.SEP);
        url.write(queryString);
      } else {
        url.write(uriTemplate);
        url.write(QueryStringParser.QUERY_TRING_SEP);
        url.write(queryString);
      }
    }
    return url.toString();
  }
}
