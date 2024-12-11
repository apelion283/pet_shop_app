import 'package:flutter_pet_shop_app/data/datasource/firebase_data_source.dart';

abstract class DeviceRepository {
  Future<void> putDeviceToken(
      {required String deviceId,
      required String userId,
      required String token});
}

class DeviceRepositoryImpl implements DeviceRepository {
  final FirebaseDataSourceImpl firebaseDataSourceImpl;
  const DeviceRepositoryImpl({required this.firebaseDataSourceImpl});

  @override
  Future<void> putDeviceToken(
      {required String deviceId,
      required String userId,
      required String token}) async {
    await firebaseDataSourceImpl.putDeviceToken(
        deviceId: deviceId, userId: userId, token: token);
  }
}
