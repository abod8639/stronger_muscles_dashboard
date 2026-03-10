import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum V1AuthUpdateProfilePost$RequestBodyPreferredLanguage {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ar')
  ar('ar'),
  @JsonValue('en')
  en('en');

  final String? value;

  const V1AuthUpdateProfilePost$RequestBodyPreferredLanguage(this.value);
}

enum V1AdminOrdersIdPatch$RequestBodyStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('pending')
  pending('pending'),
  @JsonValue('processing')
  processing('processing'),
  @JsonValue('shipped')
  shipped('shipped'),
  @JsonValue('delivered')
  delivered('delivered'),
  @JsonValue('cancelled')
  cancelled('cancelled');

  final String? value;

  const V1AdminOrdersIdPatch$RequestBodyStatus(this.value);
}

enum V1CustomerOrdersPost$RequestBodyPaymentMethod {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('cash')
  cash('cash'),
  @JsonValue('card')
  card('card'),
  @JsonValue('paypal')
  paypal('paypal'),
  @JsonValue('stripe')
  stripe('stripe');

  final String? value;

  const V1CustomerOrdersPost$RequestBodyPaymentMethod(this.value);
}
