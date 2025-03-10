class QRDataModel {
  QRDataModel({
    required this.destinatary,
    required this.isDynamic,
    required this.amount,
  });

  final String destinatary;
  final bool isDynamic;
  final int amount;

  factory QRDataModel.fromJson(Map<String, dynamic> json) {
    return QRDataModel(
      destinatary: json['destinatary'] ?? '',
      isDynamic: json['dynamic'] == 'true' || json['dynamic'] == true,
      amount: int.tryParse(json['amount']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'destinatary': destinatary,
    'dynamic': isDynamic,
    'amount': amount,
  };
}
