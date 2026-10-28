import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/mappers/promo_mapper.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/models/promo_model.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';

void main() {
  group('PromoEntity Tests', () {
    test('value equality, hashCode, and copyWith contract', () {
      final now = DateTime(2026, 1, 1);
      final p1 = PromoEntity(
        id: 'promo-1',
        title: const {'ar': 'عرض الصيف', 'en': 'Summer Offer'},
        subtitle: const {'ar': 'خصم 20%', 'en': '20% Off'},
        buttonText: const {'ar': 'تسوق الآن', 'en': 'Shop Now'},
        imageUrl: 'https://example.com/banner.jpg',
        backgroundColor: '#FF0000',
        targetType: 'product',
        targetId: 'prod-123',
        isActive: true,
        createdAt: now,
      );

      final p2 = PromoEntity(
        id: 'promo-1',
        title: const {'ar': 'عرض الصيف', 'en': 'Summer Offer'},
        subtitle: const {'ar': 'خصم 20%', 'en': '20% Off'},
        buttonText: const {'ar': 'تسوق الآن', 'en': 'Shop Now'},
        imageUrl: 'https://example.com/banner.jpg',
        backgroundColor: '#FF0000',
        targetType: 'product',
        targetId: 'prod-123',
        isActive: true,
        createdAt: now,
      );

      final p3 = p1.copyWith(targetType: 'brand', targetId: 'brand-456');

      expect(p1, equals(p2));
      expect(p1.hashCode, equals(p2.hashCode));
      expect(p1, isNot(equals(p3)));
      expect(p3.targetType, 'brand');
      expect(p3.targetId, 'brand-456');
    });

    test('computed getters display localized text and target formatting correctly', () {
      const p = PromoEntity(
        id: 'promo-1',
        title: {'ar': 'بانر تجريبي', 'en': 'Demo Banner'},
        subtitle: {'ar': 'وصف فرعي', 'en': 'Demo Subtitle'},
        buttonText: {'ar': 'اضغط هنا', 'en': 'Click Here'},
        imageUrl: 'https://example.com/img.png',
        backgroundColor: '#FFFFFF',
        targetType: 'product',
        targetId: '101',
        isActive: true,
      );

      expect(p.displayTitle, 'بانر تجريبي');
      expect(p.displaySubtitle, 'وصف فرعي');
      expect(p.displayButtonText, 'اضغط هنا');
      expect(p.displayTarget, 'منتج: 101');

      const brandPromo = PromoEntity(
        id: 'promo-2',
        imageUrl: '',
        backgroundColor: '#000000',
        targetType: 'brand',
        targetId: '55',
        isActive: false,
      );
      expect(brandPromo.displayTarget, 'ماركة: 55');

      const nonePromo = PromoEntity(
        id: 'promo-3',
        imageUrl: '',
        backgroundColor: '#000000',
        targetType: 'none',
        isActive: false,
      );
      expect(nonePromo.displayTarget, 'بدون توجيه');
    });
  });

  group('PromoModel & Mapper Tests', () {
    test('PromoModel.fromJson & toJson serialization', () {
      final json = {
        'id': 'promo-10',
        'title': {'ar': 'عرض خاص', 'en': 'Special Deal'},
        'subtitle': {'ar': 'لفترة محدودة', 'en': 'Limited Time'},
        'button_text': {'ar': 'احصل عليه', 'en': 'Get It'},
        'image_url': 'https://example.com/special.jpg',
        'background_color': '#112233',
        'target_type': 'product',
        'target_id': '99',
        'is_active': 1,
        'created_at': '2026-05-01T12:00:00.000',
      };

      final model = PromoModel.fromJson(json);

      expect(model.id, 'promo-10');
      expect(model.title?['ar'], 'عرض خاص');
      expect(model.isActive, isTrue);
      expect(model.imageUrl, 'https://example.com/special.jpg');
      expect(model.backgroundColor, '#112233');

      final serialized = model.toJson();
      expect(serialized['id'], 'promo-10');
      expect(serialized['target_type'], 'product');
      expect(serialized['target_id'], '99');
      expect(serialized['is_active'], isTrue);
    });

    test('PromoModelMapper and PromoEntityMapper bidirectional conversion', () {
      const entity = PromoEntity(
        id: 'promo-m',
        title: {'ar': 'تخفيضات', 'en': 'Discounts'},
        subtitle: {'ar': 'حتى 50%', 'en': 'Up to 50%'},
        buttonText: {'ar': 'اطلب الآن', 'en': 'Order Now'},
        imageUrl: 'https://example.com/m.jpg',
        backgroundColor: '#334455',
        targetType: 'none',
        isActive: true,
      );

      final model = entity.toModel();
      expect(model.id, entity.id);
      expect(model.title, entity.title);
      expect(model.subtitle, entity.subtitle);
      expect(model.imageUrl, entity.imageUrl);
      expect(model.backgroundColor, entity.backgroundColor);

      final mappedEntity = model.toEntity();
      expect(mappedEntity, equals(entity));
    });

    test('parsePromoListCompute & parsePromoCompute handle unexpected data formats gracefully', () {
      final list = parsePromoListCompute([
        {
          'id': '1',
          'image_url': 'https://example.com/1.png',
          'background_color': '#FFFFFF',
          'is_active': true,
        }
      ]);
      expect(list.length, 1);
      expect(list.first.id, '1');

      final empty = parsePromoListCompute(null);
      expect(empty, isEmpty);

      final single = parsePromoCompute({
        'data': {
          'id': '2',
          'image_url': 'https://example.com/2.png',
          'background_color': '#000000',
          'is_active': false,
        }
      });
      expect(single.id, '2');
      expect(single.isActive, isFalse);
    });
  });
}
