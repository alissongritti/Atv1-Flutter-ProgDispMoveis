import 'package:flutter/material.dart';
import '../../models/localizacao.dart';

class ItemLocalizacao extends StatelessWidget {
  final Localizacao localizacao;
  final VoidCallback? onTap;

  const ItemLocalizacao({
    super.key,
    required this.localizacao,
    this.onTap,
  });

  String _formatarDataHora(DateTime dataHora) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    final dia = '${doisDigitos(dataHora.day)}/${doisDigitos(dataHora.month)}/${dataHora.year}';
    final hora = '${doisDigitos(dataHora.hour)}:${doisDigitos(dataHora.minute)}:${doisDigitos(dataHora.second)}';
    return '$dia $hora';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(
          child: Icon(Icons.location_on),
        ),
        title: Text(
          'Lat: ${localizacao.latitude.toStringAsFixed(6)} | Long: ${localizacao.longitude.toStringAsFixed(6)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Precisão: ${localizacao.precisao.toStringAsFixed(1)} m'),
            Text('Instante: ${_formatarDataHora(localizacao.instante)}'),
          ],
        ),
      ),
    );
  }
}