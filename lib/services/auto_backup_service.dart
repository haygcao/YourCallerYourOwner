import 'package:services/backup_restore_database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoBackupService {
  final BackupRestoreService _backupRestoreService;
  final SharedPreferences _sharedPreferences;

  AutoBackupService(this._backupRestoreService, this._sharedPreferences);

  /// 开启自动备份
  void startAutoBackup() async {
    // 获取上次备份时间
    final lastBackupTime = await _getLastBackupTime();

    // 计算下次备份时间
    final nextBackupTime = lastBackupTime + (24 * 60 * 60 * 1000); // 每天备份一次

    // 获取自动备份开关
    final autoBackupEnabled = _sharedPreferences.getBool('autoBackupEnabled') ?? true;

    // 如果自动备份开关关闭，则返回
    if (!autoBackupEnabled) {
      return;
    }

    // 创建计时器
    final timer = Timer(Duration(milliseconds: nextBackupTime - DateTime.now().millisecondsSinceEpoch), () async {
      try {
        // 执行备份操作
        await _backupRestoreService.backup();
      } catch (error) {
        // Handle backup error
        print('Error backing up data: $error');
      }

      // 更新上次备份时间
      await _setLastBackupTime(DateTime.now().millisecondsSinceEpoch);

      // 重新启动计时器
      startAutoBackup();
    });

    // 销毁计时器
    timer.dispose();
  }

  /// 停止自动备份
  void stopAutoBackup() {
    // ...
  }

  /// 设置自动备份开关
  void setAutoBackupEnabled(bool enabled) {
    _sharedPreferences.setBool('autoBackupEnabled', enabled);
  }

  /// 获取自动备份开关状态
  bool isAutoBackupEnabled() {
    return _sharedPreferences.getBool('autoBackupEnabled') ?? true;
  }

  Future<int> _getLastBackupTime() async {
    return _sharedPreferences.getInt('lastBackupTime') ?? 0;
  }

  Future<void> _setLastBackupTime(int lastBackupTime) async {
    _sharedPreferences.setInt('lastBackupTime', lastBackupTime);
  }
}
