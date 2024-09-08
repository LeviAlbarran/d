import 'dart:io';

import 'package:flutter/material.dart';

class Order {
  final int id;
  final String orderNumber;
  final String address;
  final String client;
  final String timeWindow;
  final String status;
  final double latitude;
  final double longitude;
  final int packages;
  final bool isPrime;
  final bool hasFrozen;
  final bool hasCigarettes;
  final bool hasAlcohol;
  final List<String>? pickupImages; // Nuevo campo para imágenes retiradas
  final List<String>? deliveryImages; // Nuevo campo para imágenes entregadas
  final List<File>? pickupImagesFiles; // Nuevo campo para imágenes retiradas
  final List<File>? deliveryImagesFiles; // Nuevo campo para imágenes entregadas

  Order({
    required this.id,
    required this.orderNumber,
    required this.address,
    required this.client,
    required this.timeWindow,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.packages,
    required this.isPrime,
    required this.hasFrozen,
    required this.hasCigarettes,
    required this.hasAlcohol,
    this.pickupImages,
    this.deliveryImages,
    this.pickupImagesFiles,
    this.deliveryImagesFiles,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNumber: json['orderNumber'],
      address: json['address'],
      client: json['client'],
      timeWindow: json['timeWindow'],
      status: json['status'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      packages: json['packages'],
      isPrime: json['isPrime'],
      hasFrozen: json['hasFrozen'],
      hasCigarettes: json['hasCigarettes'],
      hasAlcohol: json['hasAlcohol'],
      pickupImages: json['pickupImages'] != null
          ? List<String>.from(json['pickupImages'])
          : null,
      deliveryImages: json['deliveryImages'] != null
          ? List<String>.from(json['deliveryImages'])
          : null,
    );
  }
}
