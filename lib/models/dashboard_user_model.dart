
class DashboardResponse {
  final int totalUsers;
  final List<DashboardUser> users;

  DashboardResponse({
    required this.totalUsers,
    required this.users
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      totalUsers: json['total_users'] ?? 0,
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => DashboardUser.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DashboardUser {
  final int id;
  final String name;
  final String? photoUrl;
  final bool hasOrdered;
  final int ordersCount;
  final List<DashboardOrder> orders;

  DashboardUser({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.hasOrdered,
    required this.ordersCount,
    required this.orders,
  });

  factory DashboardUser.fromJson(Map<String, dynamic> json) {
    return DashboardUser(
      id: json['id'],
      name: json['name'] ?? '',
      photoUrl: json['photo_url'],
      hasOrdered: json['has_ordered'] ?? false,
      ordersCount: json['orders_count'] ?? 0,
      orders: (json['orders'] as List<dynamic>?)
              ?.map((e) => DashboardOrder.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DashboardOrder {
  final int id;
  final String status;
  final double totalAmount;
  final List<DashboardOrderItem> items;

  DashboardOrder({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.items,
  });

  factory DashboardOrder.fromJson(Map<String, dynamic> json) {
    return DashboardOrder(
      id: json['id'],
      status: json['status'] ?? 'unknown',
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => DashboardOrderItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DashboardOrderItem {
  final String productName;
  final int quantity;
  final String? imageUrl;

  DashboardOrderItem({
    required this.productName,
    required this.quantity,
    this.imageUrl,
  });

  factory DashboardOrderItem.fromJson(Map<String, dynamic> json) {
    return DashboardOrderItem(
      productName: json['product_name'] ?? 'Unknown Product',
      quantity: json['quantity'] ?? 0,
      imageUrl: json['image_url'],
    );
  }
}