import 'package:equatable/equatable.dart';

/// Statuts reels du backend (Domain/Orders/OrderStatus.cs) -- valeurs en
/// snake_case, PAS le cycle Brouillon/Validee/EnProduction/Livree.
class OrderStatus {
  OrderStatus._();

  static const enAttente = 'en_attente';
  static const enCours = 'en_cours';
  static const terminee = 'terminee';
  static const pret = 'pret';
  static const livree = 'livree';
  static const annule = 'annule';
}

/// Tailles reelles du backend (Domain/Orders/OrderSize.cs).
class OrderSize {
  OrderSize._();

  static const m = 'M';
  static const l = 'L';
  static const xl = 'XL';
  static const xxl = 'XXL';

  static const values = [m, l, xl, xxl];
}

/// Modes de retrait reels du backend (Domain/Orders/PickupMode.cs).
class PickupMode {
  PickupMode._();

  static const retraitDirect = 'retrait_direct';
  static const transporteurMemeVille = 'transporteur_meme_ville';
  static const transporteurAutreVille = 'transporteur_autre_ville';
  static const mandataireLocal = 'mandataire_local';

  static const values = [
    retraitDirect,
    transporteurMemeVille,
    transporteurAutreVille,
    mandataireLocal,
  ];

  static String label(String value) {
    switch (value) {
      case retraitDirect:
        return 'Retrait direct';
      case transporteurMemeVille:
        return 'Transporteur (meme ville)';
      case transporteurAutreVille:
        return 'Transporteur (autre ville)';
      case mandataireLocal:
        return 'Mandataire local';
      default:
        return value;
    }
  }
}

/// Miroir de l'entite backend `Order`
/// (ApiTailorManagement/.../Domain/Orders/Order.cs).
class Order extends Equatable {
  final String id;
  final String customerId;
  final String clothingModelId;
  final String fabricId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? clothingModelPhotoUrl;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final String status;
  final String? orderGroupId;
  final String? tailorId;
  final String? size;
  final String? color;
  final int? delayDays;
  final String? pickupMode;
  final double? shippingFee;
  final DateTime? estimatedAvailabilityDate;

  const Order({
    required this.id,
    required this.customerId,
    required this.clothingModelId,
    required this.fabricId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.clothingModelPhotoUrl,
    required this.orderDate,
    required this.deliveryDate,
    required this.status,
    this.orderGroupId,
    this.tailorId,
    this.size,
    this.color,
    this.delayDays,
    this.pickupMode,
    this.shippingFee,
    this.estimatedAvailabilityDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String,
        customerId: json['customerId'] as String,
        clothingModelId: json['clothingModelId'] as String,
        fabricId: json['fabricId'] as String,
        quantity: json['quantity'] as int,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        totalPrice: (json['totalPrice'] as num).toDouble(),
        clothingModelPhotoUrl: json['clothingModelPhotoUrl'] as String?,
        orderDate: DateTime.parse(json['orderDate'] as String),
        deliveryDate: DateTime.parse(json['deliveryDate'] as String),
        status: json['status'] as String,
        orderGroupId: json['orderGroupId'] as String?,
        tailorId: json['tailorId'] as String?,
        size: json['size'] as String?,
        color: json['color'] as String?,
        delayDays: json['delayDays'] as int?,
        pickupMode: json['pickupMode'] as String?,
        shippingFee: (json['shippingFee'] as num?)?.toDouble(),
        estimatedAvailabilityDate: json['estimatedAvailabilityDate'] != null
            ? DateTime.parse(json['estimatedAvailabilityDate'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'clothingModelId': clothingModelId,
        'fabricId': fabricId,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'totalPrice': totalPrice,
        'clothingModelPhotoUrl': clothingModelPhotoUrl,
        'orderDate': orderDate.toIso8601String(),
        'deliveryDate': deliveryDate.toIso8601String(),
        'status': status,
        'orderGroupId': orderGroupId,
        'tailorId': tailorId,
        'size': size,
        'color': color,
        'delayDays': delayDays,
        'pickupMode': pickupMode,
        'shippingFee': shippingFee,
        'estimatedAvailabilityDate': estimatedAvailabilityDate?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        customerId,
        clothingModelId,
        fabricId,
        quantity,
        unitPrice,
        totalPrice,
        clothingModelPhotoUrl,
        orderDate,
        deliveryDate,
        status,
        orderGroupId,
        tailorId,
        size,
        color,
        delayDays,
        pickupMode,
        shippingFee,
        estimatedAvailabilityDate,
      ];
}
