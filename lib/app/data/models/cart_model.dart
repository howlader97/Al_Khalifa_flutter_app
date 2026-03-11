class CartItem {
  final int id;
  final int userId;
  final int? productId;
  final Map<String, dynamic>? product;
  final int? variationId;
  final Map<String, dynamic>? variation;
  final int? partyMenuId;
  final Map<String, dynamic>? partyMenu;
  int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartItem({
    required this.id,
    required this.userId,
    this.productId,
    this.product,
    this.variationId,
    this.variation,
    this.partyMenuId,
    this.partyMenu,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'],
    userId: json['user_id'],
    productId: json['product_id'],
    product: json['product'],
    variationId: json['variation_id'],
    variation: json['variation'],
    partyMenuId: json['party_menu_id'],
    partyMenu: json['party_menu'],
    quantity: json['quantity'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}

class CartResponse {
  final List<CartItem> items;
  final double subtotal;
  final double shipping;
  final double total;

  CartResponse({
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
    items: (json['items'] as List).map((i) => CartItem.fromJson(i)).toList(),
    subtotal: (json['subtotal'] as num).toDouble(),
    shipping: (json['shipping'] as num).toDouble(),
    total: (json['total'] as num).toDouble(),
  );
}
