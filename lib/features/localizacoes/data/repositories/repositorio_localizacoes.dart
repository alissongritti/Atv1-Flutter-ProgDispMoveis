import '../datasources/banco_localizacoes.dart';
import '../../models/localizacao.dart';

class RepositorioLocalizacoes {
  Future<void> inserir(Localizacao localizacao) async {
    final db = await BancoLocalizacoes.instance;
    await db.insert('localizacoes', localizacao.toMap());
  }

  Future<List<Localizacao>> obterUltimas100() async {
    final db = await BancoLocalizacoes.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'localizacoes',
      orderBy: 'id DESC',
      limit: 100, // Traz apenas as últimas 100
    );
    return maps.map((map) => Localizacao.fromMap(map)).toList();
  }

  Future<void> excluirTodos() async {
    final db = await BancoLocalizacoes.instance;
    await db.delete('localizacoes'); // Limpa os registros mantendo a estrutura
  }
}