import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class ServicoLocalizacao {
  Future<bool> verificarEPedirPermissao() async {
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled(); //[cite: 14]
    if (!serviceEnabled) return false;

    LocationPermission permission =
        await Geolocator.checkPermission(); //[cite: 14]
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); //[cite: 14]
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  Stream<Position> obterStreamPosicao() {
    late final LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high, // Alta precisão[cite: 11, 14]
        distanceFilter: 0,
        intervalDuration: const Duration(
          seconds: 20,
        ), // Intervalo de 20s no Android
        forceLocationManager: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high, //[cite: 11, 14]
        distanceFilter: 0,
        timeLimit: Duration(seconds: 20), //[cite: 11, 14]
      );
    }

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  Future<void> abrirConfiguracoes() async {
    await Geolocator.openAppSettings(); //[cite: 14]
  }
}
