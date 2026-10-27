import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/localizacao.dart';
import '../../data/repositories/repositorio_localizacoes.dart';
import '../../services/servico_localizacao.dart';
import 'tela_localizacoes.dart';
import 'tela_mapa.dart';

class TelaColeta extends StatefulWidget {
  const TelaColeta({super.key});

  @override
  State<TelaColeta> createState() => _TelaColetaState();
}

class _TelaColetaState extends State<TelaColeta> {
  final ServicoLocalizacao _servicoLocalizacao = ServicoLocalizacao();
  final RepositorioLocalizacoes _repositorio = RepositorioLocalizacoes();

  StreamSubscription<Position>? _subscription;
  bool _coletando = false;
  String _statusMensagem = 'Pronto para iniciar a coleta de localização.';
  Localizacao? _ultimaLocalizacao;
  DateTime? _ultimoMomentoGravado;

  @override
  void initState() {
    super.initState();
    _carregarUltimaPosicao();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _carregarUltimaPosicao() async {
    try {
      final historico = await _repositorio.obterUltimas100();
      if (historico.isNotEmpty && mounted) {
        setState(() {
          _ultimaLocalizacao = historico.first;
          _ultimoMomentoGravado = historico.first.instante;
        });
      } else if (historico.isEmpty && mounted) {
        setState(() {
          _ultimaLocalizacao = null;
          _ultimoMomentoGravado = null;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar posição inicial: $e');
    }
  }

  Future<void> _iniciarColeta() async {
    if (_coletando) return;

    final possuiPermissao = await _servicoLocalizacao
        .verificarEPedirPermissao();
    if (!mounted) return;

    if (!possuiPermissao) {
      setState(() {
        _statusMensagem = 'Permissão negada ou serviço de GPS desativado. Verifique as configurações.';
      });
      return;
    }

    setState(() {
      _coletando = true;
      _statusMensagem = 'Coletando localizações a cada 20 segundos...';
    });

    await _subscription?.cancel();

    // UTILIZA O STREAM DE LOCALIZAÇÃO CONFORME EXIGIDO PELO DOCUMENTO
    _subscription = _servicoLocalizacao.obterStreamPosicao().listen(
      (Position position) async {
        final agora = DateTime.now();

        // Filtra eventos emitidos pelo sensor em intervalo menor que 20 segundos
        if (_ultimoMomentoGravado != null) {
          final diferencaEmSegundos = agora
              .difference(_ultimoMomentoGravado!)
              .inSeconds;
          if (diferencaEmSegundos < 20) {
            return;
          }
        }

        _ultimoMomentoGravado = agora;

        final novaLocalizacao = Localizacao(
          latitude: position.latitude,
          longitude: position.longitude,
          precisao: position.accuracy,
          instante: agora,
        );

        await _repositorio.inserir(novaLocalizacao);

        if (!mounted) return;
        setState(() {
          _ultimaLocalizacao = novaLocalizacao;
          _statusMensagem = 'Última posição gravada com sucesso!';
        });
      },
      onError: (erro) {
        if (!mounted) return;
        setState(() {
          _statusMensagem = 'Erro durante a coleta: $erro';
        });
      },
    );
  }

  Future<void> _pararColeta() async {
    await _subscription?.cancel();
    _subscription = null;

    if (!mounted) return;
    setState(() {
      _coletando = false;
      _statusMensagem = 'Coleta de localização interrompida.';
    });
  }

  Future<void> _abrirTelaHistorico() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const TelaLocalizacoes()));
    _carregarUltimaPosicao();
  }

  Future<void> _abrirTelaMapa() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const TelaMapa()));
    _carregarUltimaPosicao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coleta de Localização'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _coletando ? Icons.gps_fixed : Icons.gps_off,
                      size: 48,
                      color: _coletando ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _statusMensagem,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (_ultimaLocalizacao != null) ...[
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Última Posição Registrada:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Lat: ${_ultimaLocalizacao!.latitude.toStringAsFixed(6)}',
                      ),
                      Text(
                        'Long: ${_ultimaLocalizacao!.longitude.toStringAsFixed(6)}',
                      ),
                      Text(
                        'Precisão: ${_ultimaLocalizacao!.precisao.toStringAsFixed(1)} m',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            ElevatedButton.icon(
              onPressed: _coletando ? null : _iniciarColeta,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar coleta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _coletando ? _pararColeta : null,
              icon: const Icon(Icons.stop),
              label: const Text('Parar coleta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            OutlinedButton.icon(
              onPressed: _abrirTelaHistorico,
              icon: const Icon(Icons.list),
              label: const Text('Consultar histórico'),
            ),
            const SizedBox(height: 8),

            OutlinedButton.icon(
              onPressed: _abrirTelaMapa,
              icon: const Icon(Icons.map),
              label: const Text('Ver mapa'),
            ),
            const SizedBox(height: 8),

            TextButton.icon(
              onPressed: () => _servicoLocalizacao.abrirConfiguracoes(),
              icon: const Icon(Icons.settings),
              label: const Text('Configurações de permissão'),
            ),
          ],
        ),
      ),
    );
  }
}
