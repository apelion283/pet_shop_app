import 'package:flutter_pet_shop_app/data/repository/device_repository.dart';

class DeviceUsecase {
  final DeviceRepositoryImpl deviceRepositoryImpl;
  const DeviceUsecase({required this.deviceRepositoryImpl});

  Future<void> putDeviceToken(String deviceId, String token) async {
    await deviceRepositoryImpl.putDeviceToken(deviceId, token);
  }
}
