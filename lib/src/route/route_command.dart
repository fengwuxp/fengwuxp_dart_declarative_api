abstract class RouteCommand {
  // 在堆栈顶部添加路由，然后向前导航到该路径
  static const PUSH = "push";

  // 导航回以前的路线
  static const POP = "pop";

  // 导航到堆栈的顶部路径，解除所有其他路径
  static const POP_TO_TOP = "popToTop";

  // 移除当前路径，并跳转新路径
  static const POP_AND_PUSH = "popAndPush";

  //用新状态替换当前状态

  static const RE_LAUNCH = "reLaunch";

  //用另一条路线替换给定键的路线
  static const REPLACE = "replace";

// 跳转到tab页面的的某个页面
//  static const SWITCH_TAB = "switchTab";
}
