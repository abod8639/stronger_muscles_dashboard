import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';

abstract class PromoRepository {
  Future<List<PromoEntity>> getPromos();
  Future<PromoEntity> addPromo(PromoEntity promo);
  Future<PromoEntity> updatePromo(PromoEntity promo);
  Future<void> deletePromo(String id);
  Future<String> uploadImage(String filePath);
}

