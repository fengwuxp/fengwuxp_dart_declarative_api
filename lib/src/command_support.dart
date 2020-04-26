abstract class CommandSupport {
  /// 尝试转换 方法上的前缀指令参数
  /// [methodName] 方法名称
  /// [commands]   指令集合
  /// [defaultCommand] 默认指令
  /// return [command, key]
  List<String> tryConverterMethodNameCommandResolver(String methodName, List<String> commands, String defaultCommand) {
    var result = commands.map((item) {
      return methodName.startsWith(item) ? [item, item.length] : [item, -1];
    }).reduce((prev, current) {
      return prev[1] as num >= current[1] ? prev : current;
    });

    var command = result[1] as num < 0 ? defaultCommand : result[0];
    return [command, methodName.replaceFirst(command, "")];
  }
}
