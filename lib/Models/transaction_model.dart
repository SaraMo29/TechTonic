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
    return TransactionModel(
      transactionId: json['transactionId'],
      courseTitle: json['courseTitle'],
      courseCategory: json['courseCategory']['name'],
      courseImage: json['courseImage'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      purchasePhone: json['purchasePhone'],
      coursePriceAmount: double.parse(json['coursePrice']['amount']),
      coursePriceCurrency: json['coursePrice']['currency'],
      transactionPriceAmount: (json['transactionPrice']['amount'] as num).toDouble(),
      transactionPriceCurrency: json['transactionPrice']['currency'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
