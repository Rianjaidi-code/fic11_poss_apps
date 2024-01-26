// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:fic11_pos_apps/core/extensions/int_ext.dart';

import '../../home/models/order_item.dart';

class OrderModel {
  final int? id;
  final String paymentMethod;
  final int nominalBayar;
  final List<OrderItem> orders;
  final int totalPrice;
  final int totalQuantity;
  final int idKasir;
  final String namaKasir;
  final String transactionTime;
  final bool isSync;

  OrderModel({
    this.id,
    required this.paymentMethod,
    required this.nominalBayar,
    required this.orders,
    required this.totalPrice,
    required this.totalQuantity,
    required this.idKasir,
    required this.namaKasir,
    required this.transactionTime,
    required this.isSync,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paymentMethod': paymentMethod,
      'nominalBayar': nominalBayar,
      'orders': orders.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'totalQuantity': totalQuantity,
      'idKasir': idKasir,
      'namaKasir': namaKasir,
      'isSync': isSync,
    };
  }

  // nominal INTEGER,
  //       payment_method TEXT,
  //       total_item INTEGER,
  //       id_kasir INTEGER,
  //       nama_kasir TEXT,
  //       is_sync INTEGER DEFAULT 0

  Map<String, dynamic> toMapForLocal() {
    return <String, dynamic>{
      'payment_method': paymentMethod,
      'nominal': totalPrice,
      'total_item': totalQuantity,
      'id_kasir': idKasir,
      'nama_kasir': namaKasir,
      'is_sync': isSync ? 1 : 0,
      'transaction_time': transactionTime,
    };
  }

  factory OrderModel.fromLocalMap(Map<String, dynamic> map) {
    return OrderModel(
      paymentMethod: map['payment_method'] as String,
      nominalBayar: map['nominal'] as int,
      orders: [],
      totalPrice: map['nominal'] as int,
      totalQuantity: map['total_item'] as int,
      idKasir: map['id_kasir'] as int,
      isSync: map['is_sync'] == 1 ? true : false,
      namaKasir: map['nama_kasir'] as String,
      id: map['id']?.toInt() ?? 0,
      transactionTime: map['transaction_time'] ?? 0,
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      paymentMethod: map['paymentMethod'] as String,
      nominalBayar: map['nominalBayar'] as int,
      orders: List<OrderItem>.from(
        (map['orders'] as List<int>).map<OrderItem>(
          (x) => OrderItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalPrice: map['totalPrice'] as int,
      totalQuantity: map['totalQuantity'] as int,
      idKasir: map['idKasir'] as int,
      isSync: map['isSync'] as bool,
      namaKasir: map['namaKasir'] as String,
      id: map['id'] as int,
      transactionTime: map['transactionTime'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
