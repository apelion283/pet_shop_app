import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pet_shop_app/domain/entities/bill_detail_entity.dart';

class BillDetailModel extends BillDetailEntity {
  const BillDetailModel({
    required super.id,
    required super.merchandiseItemId,
    required super.billId,
    required super.createdDate,
    required super.quantity,
    required super.subTotal,
  });

  Map<String, dynamic> toJson() {
    return {
      "merchandiseItemId": merchandiseItemId,
      "billId": billId,
      "createDate": Timestamp.fromDate(createdDate),
      "quantity": quantity
    };
  }
}
