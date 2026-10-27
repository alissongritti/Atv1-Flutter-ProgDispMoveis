import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../models/localizacao.dart';
import '../../data/repositories/repositorio_localizacoes.dart';
import '../widgets/mapa_localizacoes.dart';

class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  final RepositorioLocalizacoes _repositorio = RepositorioLocalizacoes();
  final MapController _mapController = MapController();

  List<Localizacao> _localizacoes = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarPontos();
  }

  Future<void> _carregarPontos() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final lista = await _repositorio.obterUltimas100();
      if (!mounted) return;

      setState(() {
        _localizacoes = lista;
      });

      // Aguarda o widget renderizar na tela antes de acionar o MapController
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _enquadrarPontos();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = 'Erro ao carregar posições do mapa: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  void _enquadrarPontos() {
    if (_localizacoes.isEmpty) return;

    try {
      final pontos = _localizacoes
          .map((loc) => LatLng(loc.latitude, loc.longitude))
          .toList();

      final bounds = LatLngBounds.fromPoints(pontos);
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50.0)),
      );
    } catch (e) {
      debugPrint('MapController aguardando renderização: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Interativo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            tooltip: 'Enquadrar pontos',
            onPressed: _localizacoes.isEmpty ? null : _enquadrarPontos,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
            onPressed: _carregando ? null : _carregarPontos,
          ),
        ],
      ),
      body: _construirCorpo(),
    );
  }

  Widget _construirCorpo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_erro!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _carregarPontos,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_localizacoes.isEmpty) {
      return const Center(
        child: Text('Nenhum registro encontrado para exibir no mapa.'),
      );
    }

    return MapaLocalizacoes(
      localizacoes: _localizacoes,
      mapController: _mapController,
    );
  }
}
