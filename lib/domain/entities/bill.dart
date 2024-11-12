import 'package:equatable/equatable.dart';

class Bill extends Equatable {
  final String id;
  final DateTime createdDate;
  final double totalAmount;
  final String accountId;
  final String? orderMessage;
  const Bill(
      {required this.id,
      required this.createdDate,
      required this.totalAmount,
      required this.accountId,
      this.orderMessage});
  @override
  List<Object?> get props =>
      [id, createdDate, totalAmount, accountId, orderMessage];
}
