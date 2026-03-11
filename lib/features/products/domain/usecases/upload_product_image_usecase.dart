import '../repositories/product_repository.dart';

class UploadProductImageUseCase {
  final ProductRepository repository;

  UploadProductImageUseCase(this.repository);

  Future<String> call(String filePath) async {
    return await repository.uploadImage(filePath);
  }
}
