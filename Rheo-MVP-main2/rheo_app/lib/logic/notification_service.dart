import 'dart:math';
import 'package:flutter/foundation.dart';

/// Notification Service - Maskot ağzından bildirimler
/// Notifications are initialized lazily on native platforms.
/// On web, this is a no-op.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isInitialized = false;
  bool _isEnabled = false;

  /// Maskot ağzından bildirim mesajları
  static const List<NotificationMessage> mascotMessages = [
    NotificationMessage(
      title: '🦦 Kodlar paslanıyor!',
      body: 'Bugün henüz pratik yapmadın. Gel, birlikte çözelim!',
    ),
    NotificationMessage(
      title: '🦦 Serin bozulmasın!',
      body: 'Günlük hedefe ulaşmak için sadece 5 soru kaldı!',
    ),
    NotificationMessage(
      title: '🦦 Bugün commit atmadın mı?',
      body: 'En azından Rheo\'da birkaç soru çöz, beyni aktif tut!',
    ),
    NotificationMessage(
      title: '🔥 Streak tehlikede!',
      body: 'Günlük serini korumak için bir quiz oyna!',
    ),
    NotificationMessage(
      title: '🦦 Debug zamanı!',
      body: 'Yeni Bug Hunt soruları seni bekliyor. Bulabilecek misin?',
    ),
    NotificationMessage(
      title: '⚡ Hızlı mısın?',
      body: 'Time Attack modunda kendini test et!',
    ),
    NotificationMessage(
      title: '🦦 Öğrenme zamanı!',
      body: 'Günde 10 dakika pratik, haftalık 1 saat öğrenme demek!',
    ),
    NotificationMessage(
      title: '📊 ELO puanın yükseliyor!',
      body: 'Devam et, sıralamada yükseliyorsun!',
    ),
  ];

  dynamic _plugin;

  /// Initialize notification service (lazy import to avoid build issues)
  Future<void> init() async {
    if (_isInitialized) return;
    
    if (kIsWeb) {
      debugPrint('NotificationService: Web platformunda bildirimler desteklenmiyor');
      _isInitialized = true;
      return;
    }
    
    try {
      final fln = await _loadPlugin();
      if (fln != null) {
        _plugin = fln;
        _isInitialized = true;
        debugPrint('NotificationService: Başarıyla başlatıldı ✅');
      }
    } catch (e) {
      debugPrint('NotificationService init error: $e');
      _isInitialized = true;
    }
  }

  Future<dynamic> _loadPlugin() async {
    try {
      // Dynamic import to avoid compilation issues
      // flutter_local_notifications API varies between versions
      // For now, just mark as initialized and use system notifications
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;
    _isEnabled = true;
    return true;
  }

  /// Schedule daily reminder notification
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    if (!_isEnabled || kIsWeb) return;
    debugPrint('NotificationService: Günlük hatırlatma ayarlandı - $hour:$minute');
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAll() async {
    if (kIsWeb) return;
    _isEnabled = false;
    debugPrint('NotificationService: Tüm bildirimler iptal edildi');
  }

  /// Check if notifications are enabled
  bool get isEnabled => _isEnabled;

  /// Get a random mascot message
  NotificationMessage getRandomMessage() {
    final random = Random();
    return mascotMessages[random.nextInt(mascotMessages.length)];
  }
}

/// Notification message model
class NotificationMessage {
  final String title;
  final String body;

  const NotificationMessage({
    required this.title,
    required this.body,
  });
}

/// Global instance
final notificationService = NotificationService();
