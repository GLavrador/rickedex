# Rickedex (Rick and Morty Pokédex)

Um app Flutter que funciona como uma Pokédex do universo de Rick and Morty: é possível pesquisar, filtrar e descobrir personagens, episódios e localidades consumindo a The Rick and Morty API.

> **Stack**: Flutter + Dart

![Flutter](https://camo.githubusercontent.com/031659092e85df76a0ab830ef77631a750b67d379b29c24f7969ccbc2829743a/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f466c75747465722d3032353639423f7374796c653d666f722d7468652d6261646765266c6f676f3d666c7574746572266c6f676f436f6c6f723d7768697465)
![Made with Dio](https://img.shields.io/badge/HTTP-Dio-informational)

---

## Índice
- [Funcionalidades](#funcionalidades)
  - [Personagens](#personagens)
  - [Localidades](#localidades)
  - [Episódios](#episódios)
  - [APK](#apk)
- [Navegação principal](#navegação-principal)
- [Componentes & Arquitetura](#componentes--arquitetura)
  - [Estrutura do Projeto](#estrutura-do-projeto)
  - [Padrões adotados](#padrões-adotados)
- [Busca & Filtros](#busca--filtros)
- [Como rodar](#como-rodar)
- [Build de APK (Android)](#build-de-apk-android)
  - [Ícone do APK (personalizado)](#ícone-do-apk-personalizado)
- [API](#api)

---

## Funcionalidades

### Personagens
- **Listagem** (scroll + paginação)
- **Cards**: nome, imagem
- **Detalhes**: 
  - nome, imagem, espécie, gênero, status, origem, última localização, primeira aparição (episódio)
  - imagem com gesto de puxar para expandir
- **Busca** por nome (parcial ou completo)
- **Filtros**: gênero, status, espécie
- **Navegação**: de listagem → para detalhes
<p>
  <a href="docs/screens/characters_list.jpeg">
    <img src="docs/screens/characters_list.jpeg" width="260" alt="Lista de personagens">
  </a>
  <a href="docs/screens/character_detailed.jpeg">
    <img src="docs/screens/character_detailed.jpeg" width="260" alt="Detalhes do personagem">
  </a>
  <a href="docs/screens/character_search.jpeg">
    <img src="docs/screens/character_search.jpeg" width="260" alt="Busca por personagem">
  </a>
  <a href="docs/screens/character_filter.jpeg">
    <img src="docs/screens/character_filter.jpeg" width="260" alt="Filtros de personagem">
  </a>
</p>

### Localidades
- **Listagem** (scroll + paginação)
- **Cards**: tipo, dimensão, número de residentes
- **Detalhes**: alguns moradores da localidade
- **Navegação**: de listagem → para detalhes
<p>
  <a href="docs/screens/locations_list.jpeg">
    <img src="docs/screens/locations_list.jpeg" width="260" alt="Lista de localidades">
  </a>
  <a href="docs/screens/location_detailed.jpeg">
    <img src="docs/screens/location_detailed.jpeg" width="260" alt="Detalhes da localidade">
  </a>
  <a href="docs/screens/location_search.jpeg">
    <img src="docs/screens/location_search.jpeg" width="260" alt="Busca de localidade">
  </a>
</p>

### Episódios
- **Listagem** (scroll + paginação)
- **Cards**: nome, código
- **Detalhes**: data de exibição
- **Filtro**: temporada
- **Navegação**: de listagem → para detalhes
<p>
  <a href="docs/screens/episodes_list.jpeg">
    <img src="docs/screens/episodes_list.jpeg" width="260" alt="Lista de localidades">
  </a>
  <a href="docs/screens/episode_filter.jpeg">
    <img src="docs/screens/episode_filter.jpeg" width="260" alt="Detalhes da localidade">
  </a>
  <a href="docs/screens/episode_detailed.jpeg">
    <img src="docs/screens/episode_detailed.jpeg" width="260" alt="Busca de localidade">
  </a>
</p>

### APK
- **Ícone personalizado** no APK
<p>
<a href="docs/screens/apk_icon.jpeg">
    <img src="docs/screens/apk_icon.jpeg" width="260" alt="Busca de localidade">
  </a>
</p>

> Todas as funcionalidades acima estão implementadas e integradas à UI.

---

## Navegação principal

- **Home/Characters**: listagem de personagens + barra de busca + filtro (ícone de funil ao lado da busca)
- **Detalhes do Personagem**: card expandido com metadados completos e imagem expansível
- **Locations**: listagem de localidades + barra de busca
- **Detalhes de Localidades**: card expandido com metadados completos
- **Episodes**: listagem de episódios + barra de busca + filtro (ícone de funil ao lado da busca)
- **Detalhes do Episódios**: card expandido com metadados completos

---
## Componentes & Arquitetura

### Estrutura do Projeto

```text
.
├── android/                                           # projeto Android nativo
├── ios/                                               # projeto iOS nativo
├── assets/                                            # recursos estáticos do app
│   └── images/                                        # imagens do app
├── lib/                                               # código-fonte principal (Flutter/Dart)
│   ├── components/                                    # componentes reutilizáveis de UI
│   │   ├── app_bar/
│   │   │   └── app_bar_component.dart                 # app bar customizada
│   │   ├── cards/
│   │   │   ├── character_card.dart                    # card da listagem de personagens (nome + imagem)
│   │   │   ├── episode_card.dart                      # card da listagem de episódios (nome, código, data)
│   │   │   └── location_card.dart                     # card da listagem de localidades (nome, tipo, dimensão)
│   │   ├── detailed_cards/
│   │   │   ├── detailed_character_card.dart           # card completo do personagem 
│   │   │   ├── detailed_episode_card.dart             # card completo do episódio (número de personagens)
│   │   │   └── detailed_location_card.dart            # card completo da localidade (moradores)
│   │   ├── filters/
│   │   │   ├── filter_character_component.dart        # filtro por gênero/status/espécie (UI + callbacks)
│   │   │   └── filter_episode_component.dart          # filtro por temporada (UI + callbacks)
│   │   └── navigation/
│   │       ├── pagination_bar.dart                    # barra de paginação (próxima/anterior/atual)
│   │       ├── search_bar_component.dart              # busca por nome (parcial/total)
│   │       └── side_bar_component.dart                # navegação lateral (acesso rápido às seções)
│   ├── data/
│   │   └── repository.dart                            # camada de acesso à API (HTTP, queries, paginação)
│   ├── models/                                        # modelos de domínio + respostas paginadas
│   │   ├── character.dart                             # modelo Character (id, name, status, gender, origin, etc.)
│   │   ├── episode.dart                               # modelo Episode (id, name, episode, air_date, etc.)
│   │   ├── location.dart                              # modelo Location (id, name, type, dimension, residents)
│   │   ├── paginated_characters.dart                  # paginação para /character
│   │   ├── paginated_episodes.dart                    # paginação para /episode
│   │   └── paginated_locations.dart                   # paginação para /location
│   ├── pages/                                         # telas
│   │   ├── home_page.dart                             # listagem de personagens + busca + filtros + paginação
│   │   ├── details_page.dart                          # detalhes do personagem (inclui pull-to-expand da imagem)
│   │   ├── episodes_page.dart                         # listagem de episódios + paginação + filtro por temporada
│   │   ├── episode_details_page.dart                  # detalhes do episódio (elenco do episódio)
│   │   ├── locations_page.dart                        # listagem de localidades + paginação
│   │   └── location_details_page.dart                 # detalhes da localidade (moradores/residentes)
│   ├── theme/
│   │   ├── app_colors.dart                            # paleta de cores centralizada
│   │   ├── app_images.dart                            # paths/refs de imagens
│   │   └── app_typography.dart                        # estilos de texto (TextStyles)
│   └── main.dart                                      # bootstrap do app, MaterialApp, rotas e tema
├── test/                                              # testes (não utilizado no momento)
├── .dart_tool/                                        # artefatos internos do Dart/Flutter (gerado)
├── build/                                             # saídas de build (gerado)
├── .flutter-plugins                                   # plugins do Flutter (gerado)
├── .flutter-plugins-dependencies                      # dependências dos plugins (gerado)
├── .idea/                                             # metadados de IDE (Android Studio)
├── .metadata                                          # metadados do projeto Flutter (gerado)
├── analysis_options.yaml                              # regras de lint/análise estática
├── pubspec.yaml                                       # dependências, assets e config do app
├── pubspec.lock                                       # lockfile de versões (gerado)
├── README.md                                          # documentação do projeto
└── rick_morty_app.iml                                 # arquivo de projeto da IDE
```

### Padrões adotados
- **Repository Pattern** para isolar chamadas **HTTP** (via **Dio**) aos endpoints `/character`, `/location`, `/episode`
- **Paginação** baseada em parâmetros da API
- **Componentização** de UI (cards, filtros, barras, etc.)
- **Tema centralizado** (cores, tipografia, imagens)

---

## Busca & Filtros

- **Busca por nome**: aceita trechos/parciais (ex: `ric`, `mort`)
- **Filtros de personagem**:
  - **Gênero**: Male, Female, Genderless, Unknown
  - **Status**: Alive, Dead, Unknown
  - **Espécie**: Human, Alien, Humanoid, Robot, Mythological Creature, Cronenberg, Poopybutthole, Disease, Unknown, Outros
- **Filtro por temporada (Episódios)**: por número da temporada

---

## Compatibilidade
- Android (testado em emulador e dispositivo físico)
- iOS (build não configurado/testado)

---

## Como rodar

Pré‑requisitos:
- Flutter instalado (canal **stable**)
- Android SDK / Emulador ou dispositivo físico (modo desenvolvedor)

Instalação e execução:

```
flutter pub get
flutter run
```

---

## Build de APK (Android)

Gerar APK **release**:
```
flutter build apk --release
```

Se aparecer um aviso de **NDK** (ex: algum plugin exige versão maior), ajuste a versão no arquivo `android/app/build.gradle.kts`:

```kts
android {
    ndkVersion = "27.0.12077973"
}
```

O APK final ficará em:
```
build/app/outputs/flutter-apk/app-release.apk
```

### Ícone do APK (personalizado)
O app já inclui um ícone customizado. Para trocar rapidamente:
1. Substitua o arquivo **icon.png** (ícone) em **assets/images** e rode ```dart run flutter_launcher_icons:main```
2. Ajuste o **nome do app** (opcional) em `android/app/src/main/AndroidManifest.xml` (`android:label`)

---

## API

- Base: `https://rickandmortyapi.com/api`
- Recursos utilizados: /character, /location, /episode
- Parâmetros comuns: page, id, name, status, gender, species 

---

- Dados por **The Rick and Morty API**
  - [https://rickandmortyapi.com/](https://rickandmortyapi.com/)
