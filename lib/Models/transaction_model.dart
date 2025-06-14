import 'dart:math' as math;

class TransactionModel {
  final String transactionId;
  final String courseTitle;
  final String courseCategory;
  final String courseImage;
  final String userName;
  final String userEmail;
  final String purchasePhone;
  final double coursePriceAmount;
  final String coursePriceCurrency;
  final String transactionPriceCurrency;
  final double transactionPriceAmount;
  final String status;
  final DateTime createdAt;

  TransactionModel({
    required this.transactionId,
    required this.courseTitle,
    required this.courseCategory,
    required this.courseImage,
    required this.userName,
    required this.userEmail,
    required this.purchasePhone,
    required this.coursePriceAmount,
    required this.coursePriceCurrency,
    required this.transactionPriceAmount,
    required this.transactionPriceCurrency,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    // Print the JSON to debug
    print('Transaction JSON: $json');
    
    try {
      return TransactionModel(
        transactionId: json['_id'] ?? '',
        courseTitle: json['course']?['title'] ?? 'Unknown Course',
        courseCategory: json['course']?['category']?['name'] ?? 'Uncategorized',
        courseImage: json['course']?['thumbnail'] ?? 'https://via.placeholder.com/150',
        userName: json['user']?['name'] ?? 'Unknown User',
        userEmail: json['user']?['email'] ?? 'unknown@example.com',
        purchasePhone: json['phoneNumber'] ?? '',
        coursePriceAmount: double.tryParse(json['course']?['price']?['amount']?.toString() ?? '0') ?? 0.0,
        coursePriceCurrency: json['course']?['price']?['currency'] ?? 'USD',
        transactionPriceAmount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
        transactionPriceCurrency: json['currency'] ?? 'USD',
        status: json['status'] ?? 'Unknown',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );
    } catch (e) {
      print('Error parsing transaction: $e');
      // Return a fallback model with error information
      return TransactionModel(
        transactionId: 'error-${DateTime.now().millisecondsSinceEpoch}',
        courseTitle: 'Error Loading Course',
        courseCategory: 'Error',
        courseImage: 'https://via.placeholder.com/150',
        userName: 'Error',
        userEmail: 'error@example.com',
        purchasePhone: '',
        coursePriceAmount: 0.0,
        coursePriceCurrency: 'USD',
        transactionPriceAmount: 0.0,
        transactionPriceCurrency: 'USD',
        status: 'Error: ${e.toString().substring(0, math.min(e.toString().length, 50))}',
        createdAt: DateTime.now(),
      );
    }
  }
}
