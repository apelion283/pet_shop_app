import 'package:flutter_pet_shop_app/data/repository/device_repository.dart';

class DeviceUsecase {
  final DeviceRepositoryImpl deviceRepositoryImpl;
  const DeviceUsecase({required this.deviceRepositoryImpl});

  Future<void> putDeviceToken(
      {required String deviceId,
      required String userId,
      required String token}) async {
    await deviceRepositoryImpl.putDeviceToken(
        deviceId: deviceId, userId: userId, token: token);
  }
}
