import 'package:stronger_muscles_dashboard/features/promos/data/datasources/promo_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/models/promo_model.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/repositories/promo_repository.dart';

class PromoRepositoryImpl implements PromoRepository {
  final PromoRemoteDataSource remoteDataSource;

  PromoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PromoEntity>> getPromos() async {
    final models = await remoteDataSource.getPromos();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<PromoEntity> addPromo(PromoEntity promo) async {
    final model = PromoModel.fromEntity(promo);
    final addedModel = await remoteDataSource.addPromo(model.toJson());
    return addedModel.toEntity();
  }

  @override
  Future<PromoEntity> updatePromo(PromoEntity promo) async {
    final model = PromoModel.fromEntity(promo);
    final updatedModel = await remoteDataSource.updatePromo(promo.id, model.toJson());
    return updatedModel.toEntity();
  }

  @override
  Future<void> deletePromo(String id) async {
    await remoteDataSource.deletePromo(id);
  }

  @override
  Future<String> uploadImage(String filePath) async {
    return await remoteDataSource.uploadImage(filePath);
  }
}

