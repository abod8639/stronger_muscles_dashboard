import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/repositories/promo_repository.dart';

class GetPromosUseCase {
  final PromoRepository repository;

  GetPromosUseCase(this.repository);

  Future<List<PromoEntity>> call() async {
    return await repository.getPromos();
  }
}

class AddPromoUseCase {
  final PromoRepository repository;

  AddPromoUseCase(this.repository);

  Future<PromoEntity> call(PromoEntity promo) async {
    return await repository.addPromo(promo);
  }
}

class UpdatePromoUseCase {
  final PromoRepository repository;

  UpdatePromoUseCase(this.repository);

  Future<PromoEntity> call(PromoEntity promo) async {
    return await repository.updatePromo(promo);
  }
}

class DeletePromoUseCase {
  final PromoRepository repository;

  DeletePromoUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deletePromo(id);
  }
}

