import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entry.dart';

enum LogToastKind { logged, walkStarted, walkFinished }

/// 记录后浮在底栏上方的提示条。
@immutable
class LogToast {
  const LogToast(this.kind, this.entry);

  final LogToastKind kind;
  final Entry entry;

  /// 结束遛狗不提供撤销：撤销会把整次遛狗删掉。
  bool get undoable => kind != LogToastKind.walkFinished;
}

/// 整个 App 共用一个提示条：从哪个页面记录都在同一个位置出现，切换页面也不丢。
final logToastProvider = NotifierProvider<LogToastController, LogToast?>(
  LogToastController.new,
);

class LogToastController extends Notifier<LogToast?> {
  static const duration = Duration(seconds: 6);

  Timer? _timer;

  @override
  LogToast? build() {
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  /// 显示提示条，几秒后自动收起。
  void show(LogToast toast) {
    _timer?.cancel();
    state = toast;
    _timer = Timer(duration, hide);
  }

  void hide() {
    _timer?.cancel();
    _timer = null;
    state = null;
  }
}
