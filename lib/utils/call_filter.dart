// 新建文件：call_filter.dart

class CallFilter {
  static bool shouldAcceptCall(String phoneNumber) {
    // 新增开关变量
    bool allowAllBlacklistedNumbers = false;

    // 检查号码是否在白名单中
    if (WhitelistService.instance.contains(phoneNumber)) {
      return true;
    }

    // 检查号码是否在黑名单中
    if (BlacklistService.instance.contains(phoneNumber)) {
      // 如果允许所有黑名单号码，则放行
      if (allowAllBlacklistedNumbers) {
        return true;
      }
      return false;
    }

    // 允许所有来电
    return true;
  }
}
