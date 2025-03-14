import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pet_shop_app/domain/entities/bill.dart';

class BillModel extends Bill {
  const BillModel(
      {required super.id,
      required super.createdDate,
      required super.totalAmount,
      required super.accountId,
      super.orderMessage});

  Map<String, dynamic> toJson() {
    return {
      "createDate": Timestamp.fromDate(createdDate),
      "totalAmount": totalAmount,
      "accountId": accountId,
      "orderMessage": orderMessage
    };
  }
}
