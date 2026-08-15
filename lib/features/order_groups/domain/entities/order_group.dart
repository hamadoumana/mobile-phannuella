import 'package:equatable/equatable.dart';

import '../../../orders/domain/entities/order.dart';

/// Miroir de l'entite backend `OrderGroup`
/// (ApiTailorManagement/.../Domain/OrderGroups/OrderGroup.cs) --
/// regroupe plusieurs Orders (sous-commandes) sous une commande globale.
/// `subOrders` n'est peuple que par `GET /order-groups/{id}` (pas par la liste).
class OrderGroup extends Equatable {
  final String id;
  final String customerId;
  final String orderNumber;
  final double totalAmount;
  final double advancePayment;
  final double balance;
  final String status;
  final List<Order>? subOrders;

  const OrderGroup({
    required this.id,
    required this.customerId,
    required this.orderNumber,
    required this.totalAmount,
    required this.advancePayment,
    required this.balance,
    required this.status,
    this.subOrders,
  });

  factory OrderGroup.fromJson(Map<String, dynamic> json) => OrderGroup(
        id: json['id'] as String,
        customerId: json['customerId'] as String,
        orderNumber: json['orderNumber'] as String,
        totalAmount: (json['totalAmount'] as num).toDouble(),
        advancePayment: (json['advancePayment'] as num).toDouble(),
        balance: (json['balance'] as num).toDouble(),
        status: json['status'] as String,
        subOrders: json['subOrders'] != null
            ? (json['subOrders'] as List)
                .map((o) => Order.fromJson(o as Map<String, dynamic>))
                .toList()
            : null,
      );

  @override
  List<Object?> get props =>
      [id, customerId, orderNumber, totalAmount, advancePayment, balance, status, subOrders];
}
