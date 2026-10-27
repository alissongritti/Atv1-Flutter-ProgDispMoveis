import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../models/localizacao.dart';

class MapaLocalizacoes extends StatelessWidget {
  final List<Localizacao> localizacoes;
  final MapController mapController;

  const MapaLocalizacoes({
    super.key,
    required this.localizacoes,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    if (localizacoes.isEmpty) {
      return const Center(child: Text('Sem coordenadas para exibir no mapa.'));
    }

    // A primeira posição é a mais recente
    final ultima = localizacoes.first;
    final centroInicial = LatLng(ultima.latitude, ultima.longitude);

    // Mapeia os marcadores
    final marcadores = localizacoes.map((loc) {
      final ehUltima = loc.id == ultima.id;
      return Marker(
        point: LatLng(loc.latitude, loc.longitude),
        width: 40,
        height: 40,
        child: Icon(
          Icons.location_on,
          color: ehUltima
              ? Colors.red
              : Colors.blue, // Vermelho para a mais recente
          size: ehUltima ? 40 : 30,
        ),
      );
    }).toList();

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(initialCenter: centroInicial, initialZoom: 15.0),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'br.gov.sp.fatec.atv01',
        ),
        MarkerLayer(markers: marcadores),
      ],
    );
  }
}
