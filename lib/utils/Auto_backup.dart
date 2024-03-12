import 'package:services/backup_restore_database_service.dart';

class AutoBackupService {
  final BackupRestoreService backupRestoreService;

  AutoBackupService(this.backupRestoreService);

  void startAutoBackup() async {
    // 获取上次备份时间
    final lastBackupTime = await _getLastBackupTime();

    // 计算下次备份时间
    final nextBackupTime = lastBackupTime + (24 * 60 * 60 * 1000); // 每天备份一次

    // 创建计时器
    final timer = Timer(Duration(milliseconds: nextBackupTime - DateTime.now().millisecondsSinceEpoch), () async {
      try {
        // 执行备份操作
        await backupRestoreService.backup();
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

  Future<int> _getLastBackupTime() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt('lastBackupTime') ?? 0;
  }

  Future<void> _setLastBackupTime(int lastBackupTime) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('lastBackupTime', lastBackupTime);
  }
}
