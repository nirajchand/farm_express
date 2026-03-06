
import 'package:farm_express/features/product/data/respositories/shake_repo.dart';
import 'package:farm_express/features/product/domain/repositories/product_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listenToShakeUseCaseProvider = Provider(
  (ref) => ListenToShakeUseCase(ref.read(shakeRepositoryProvider)),
);



class ListenToShakeUseCase {
  final ShakeRepository repository;
  ListenToShakeUseCase(this.repository);

  Stream<void> call() => repository.onShake;
}


