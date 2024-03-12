import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:services/snackbar_service.dart';
import 'package:services/backup_restore_database_service.dart';
import 'package:services/backup_restore_database_service.dart';
import 'package:services/webdav_service.dart';
import 'package:utils/get_default_external_dir.dart';

class OnlineBackupService {
  final AutoBackupService _autoBackupService;
  final WebDAVBackupService _webDAVBackupService;
  final BackupRestoreService _backupRestoreService;

  OnlineBackupService(this._autoBackupService, this._webDAVBackupService, this._backupRestoreService);

  /// 开启自动 WebDAV 备份
  void startAutoWebDAVBackup() {
    _autoBackupService.startAutoBackup(_webDAVBackupService.backup);
  }

  /// 停止自动 WebDAV 备份
  void stopAutoWebDAVBackup() {
    _autoBackupService.stopAutoBackup();
  }

  /// 设置自动 WebDAV 备份开关
  void setAutoWebDAVBackupEnabled(bool enabled) {
    _autoBackupService.setAutoBackupEnabled(enabled);
  }

  /// 获取自动 WebDAV 备份开关状态
  bool isAutoWebDAVBackupEnabled() {
    return _autoBackupService.isAutoBackupEnabled();
  }

  /// 开启自动本地备份
  void startAutoLocalBackup() {
    _autoBackupService.startAutoBackup(_backupRestoreService.backup);
  }

  /// 停止自动本地备份
  void stopAutoLocalBackup() {
    _autoBackupService.stopAutoBackup();
  }

  /// 设置自动本地备份开关
  void setAutoLocalBackupEnabled(bool enabled) {
    _autoBackupService.setAutoBackupEnabled(enabled);
  }

  /// 获取自动本地备份开关状态
  bool isAutoLocalBackupEnabled() {
    return _autoBackupService.isAutoBackupEnabled();
  }

  /// 设置自动本地备份仅保留最新备份开关
  void setAutoLocalBackupKeepOnlyLatest(bool keepOnlyLatest) {
    _backupRestoreService.setAutoLocalBackupKeepOnlyLatest(keepOnlyLatest);
  }

  /// 获取自动本地备份仅保留最新备份开关状态
  bool isAutoLocalBackupKeepOnlyLatest() {
    return _backupRestoreService.isAutoLocalBackupKeepOnlyLatest();
  }

  /// 设置本地备份存储位置
  void setLocalBackupPath(String path) {
    _backupRestoreService.setLocalBackupPath(path);
  }

  /// 获取本地备份存储位置
  String getLocalBackupPath() {
    return _backupRestoreService.getLocalBackupPath();
  }

  /// 设置 WebDAV 备份存储位置
  void setWebDAVBackupPath(String path) {
    _webDAVBackupService.setWebDAVBackupPath(path);
  }

  /// 获取 WebDAV 备份存储位置
  String getWebDAVBackupPath() {
    return _webDAVBackupService.getWebDAVBackupPath();
  }

  /// 执行备份操作
  Future<void> backup() async {
    if (isAutoWebDAVBackupEnabled()) {
      _webDAVBackupService.backup();
    }
    if (isAutoLocalBackupEnabled()) {
      _backupRestoreService.backup();
    }
  }
}

/// 自动备份服务
class AutoBackupService {
  final SharedPreferences _sharedPreferences;

  AutoBackupService(this._sharedPreferences);

  /// 开启自动备份
  void startAutoBackup(Function backupFunction) {
    final lastBackupTime = _sharedPreferences.getInt('lastBackupTime') ?? 0;
    final nextBackupTime = lastBackupTime + (24 * 60 * 60 * 1000); // 每天备份一次
    final timer = Timer(Duration(milliseconds: nextBackupTime - DateTime.now().millisecondsSinceEpoch), () async {
      try {
        backupFunction();
        _sharedPreferences.setInt('lastBackupTime', DateTime.now().millisecondsSinceEpoch);
        startAutoBackup(backupFunction);
      } catch (error) {
        print('
