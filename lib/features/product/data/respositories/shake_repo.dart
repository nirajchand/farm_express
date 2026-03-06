import 'package:farm_express/features/product/data/datasources/shake_datasource.dart';
import 'package:farm_express/features/product/domain/repositories/product_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shakeRepositoryProvider = Provider(
  (ref) => ShakeRepositoryImpl(ref.read(shakeDatasourceProvider)),
);
class ShakeRepositoryImpl implements ShakeRepository {
  final ShakeDatasource datasource;
  ShakeRepositoryImpl(this.datasource);

  @override
  Stream<void> get onShake => datasource.onShake;
}
