# Atividade 1 — Coleta e Visualização de Localizações

Projeto desenvolvido para a disciplina de **Programação para Dispositivos Móveis II** na FATEC.

## 👤 Autor
* **Nome:** Alisson Franco Gritti
* **Nome:** João Pedro Souza dos Anjos

---

## 📱 Sobre o Aplicativo
O aplicativo realiza o monitoramento e armazenamento de coordenadas geográficas (GPS) em tempo real, gravando o histórico em um banco de dados local SQLite e exibindo as rotas em um mapa interativo do OpenStreetMap.

### 🛠️ Funcionalidades
- **Coleta Contínua de GPS:** Leitura periódica das coordenadas geográficas sem travamento da interface (`StreamSubscription`).
- **Filtro de Tempo:** Gravação no banco ajustada para intervalos de 20 segundos.
- **Armazenamento Local:** Gravação em banco SQLite (`sqflite`) contendo latitude, longitude, precisão e data/hora.
- **Histórico (Até 100 registros):** Apresentação das últimas 100 posições coletadas com opção de exclusão/limpeza total.
- **Mapa Interativo (`flutter_map`):** Visualização dos 100 pontos mais recentes no mapa OpenStreetMap, destacando a última posição em vermelho e as anteriores em azul.
- **Cache Local de Mapa:** Gerenciamento do armazenamento local de imagens do mapa via `path_provider`.
- **Ícone Personalizado:** Ícone exclusivo gerado para a aplicação Android (`flutter_launcher_icons`).

---

## 🏗️ Estrutura do Projeto (Clean Architecture)

```text
lib/
├── app.dart
├── main.dart
└── features/
    └── localizacoes/
        ├── data/
        │   ├── datasources/
        │   │   └── banco_localizacoes.dart
        │   └── repositories/
        │       └── repositorio_localizacoes.dart
        ├── models/
        │   └── localizacao.dart
        ├── presentation/
        │   ├── screens/
        │   │   ├── tela_coleta.dart
        │   │   ├── tela_localizacoes.dart
        │   │   └── tela_mapa.dart
        │   └── widgets/
        │       ├── item_localizacao.dart
        │       └── mapa_localizacoes.dart
        └── services/
            ├── cache_mapa.dart
            └── servico_localizacao.dart
```

### 🚀 Tecnologias Utilizadas
- Flutter SDK
- Dart
- Geolocator (geolocator)
- SQLite (sqflite + path)
- Flutter Map (flutter_map + latlong2)
- Path Provider (path_provider)
- Flutter Launcher Icons (flutter_launcher_icons)

