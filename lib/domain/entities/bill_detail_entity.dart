import 'package:equatable/equatable.dart';

class BillDetailEntity extends Equatable {
  final String id;
  final String merchandiseItemId;
  final String billId;
  final DateTime createdDate;
  final int quantity;
  final double subTotal;

  const BillDetailEntity(
      {required this.id,
      required this.merchandiseItemId,
      required this.billId,
      required this.createdDate,
      required this.quantity,
      required this.subTotal});

  @override
  List<Object?> get props => [id, merchandiseItemId];
}
