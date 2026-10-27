import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CacheMapa {
  static String? _caminhoCache;

  /// Obtém a pasta privada do aplicativo para armazenar as imagens do mapa em cache
  static Future<String> obterCaminhoCache() async {
    if (_caminhoCache != null) return _caminhoCache!;

    final diretorio = await getApplicationSupportDirectory();
    final pastaMapa = Directory('${diretorio.path}/mapa_cache');

    if (!await pastaMapa.exists()) {
      await pastaMapa.create(recursive: true);
    }

    _caminhoCache = pastaMapa.path;
    return _caminhoCache!;
  }
}
