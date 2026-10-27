import 'package:flutter/material.dart';

import '../../models/localizacao.dart';
import '../../data/repositories/repositorio_localizacoes.dart';
import '../widgets/item_localizacao.dart';

class TelaLocalizacoes extends StatefulWidget {
  const TelaLocalizacoes({super.key});

  @override
  State<TelaLocalizacoes> createState() => _TelaLocalizacoesState();
}

class _TelaLocalizacoesState extends State<TelaLocalizacoes> {
  final RepositorioLocalizacoes _repositorio = RepositorioLocalizacoes();
  List<Localizacao> _localizacoes = [];
  bool _carregando = true;
  String? _mensagemErro;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final lista = await _repositorio.obterUltimas100();
      if (!mounted) return;
      setState(() {
        _localizacoes = lista;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mensagemErro = 'Falha ao carregar o histórico: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  Future<void> _confirmarExclusao() async {
    final seConfirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar histórico'),
        content: const Text(
          'Esta operação é permanente e removerá todos os registros. '
          'Se a coleta estiver ativa, novos registros continuarão sendo salvos.\n\nDeseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Limpar histórico',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (seConfirmou == true) {
      try {
        await _repositorio.excluirTodos();
        await _carregarHistorico();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Histórico limpo com sucesso!')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao limpar histórico: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Localizações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
            onPressed: _carregando ? null : _carregarHistorico,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Limpar histórico',
            onPressed: _carregando ? null : _confirmarExclusao,
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

    if (_mensagemErro != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_mensagemErro!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _carregarHistorico,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_localizacoes.isEmpty) {
      return const Center(
        child: Text('Nenhuma localização registrada até o momento.'),
      );
    }

    return ListView.builder(
      itemCount: _localizacoes.length,
      itemBuilder: (context, index) {
        return ItemLocalizacao(localizacao: _localizacoes[index]);
      },
    );
  }
}
