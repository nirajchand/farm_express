import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

final shakeDatasourceProvider = Provider<ShakeDatasource>(
  (_) => ShakeDatasourceImpl(),
);

abstract class ShakeDatasource {
  Stream<void> get onShake;
}

class ShakeDatasourceImpl implements ShakeDatasource {
  static const double _shakeThreshold = 15.0;
  static const int _shakeSlop = 500;

  int _lastShakeTime = 0;

  late final Stream<void> _shakeStream = accelerometerEventStream()
      .where((event) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final magnitude = sqrt(
          event.x * event.x + event.y * event.y + event.z * event.z,
        );

        if (magnitude > _shakeThreshold &&
            (now - _lastShakeTime) > _shakeSlop) {
          _lastShakeTime = now;
          return true;
        }
        return false;
      })
      .map((_) => null)
      .asBroadcastStream(); 

  @override
  Stream<void> get onShake => _shakeStream;
}
