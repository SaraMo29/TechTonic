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
  print('Transaction JSON: $json');

  const baseUrl = 'https://your-domain.com'; 

  try {
    final rawImage = json['courseId']?['thumbnail'];
    final fullImage = (rawImage != null && rawImage.startsWith('http'))
        ? rawImage
        : '$baseUrl$rawImage';

    return TransactionModel(
      transactionId: json['_id'] ?? '',
      courseTitle: json['courseId']?['title'] ?? 'Unknown Course',
      courseCategory: json['courseId']?['category']?['name'] ?? 'Uncategorized',
      courseImage: fullImage,
      userName: json['user']?['name'] ?? 'Unknown User',
      userEmail: json['user']?['email'] ?? 'unknown@example.com',
      purchasePhone: json['phoneNumber'] ?? '',
      coursePriceAmount: double.tryParse(json['courseId']?['price']?['amount']?.toString() ?? '0') ?? 0.0,
      coursePriceCurrency: json['courseId']?['price']?['currency'] ?? 'USD',
      transactionPriceAmount: double.tryParse(json['transactionPrice']?['amount']?.toString() ?? '0') ?? 0.0,
      transactionPriceCurrency: json['transactionPrice']?['currency'] ?? 'USD',
      status: json['status'] ?? 'Unknown',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  } catch (e) {
    print('Error parsing transaction: $e');
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
