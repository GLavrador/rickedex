# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/2.0.0/).

## [Unreleased]

### Added
- Sidebar: badge com contagem de Favorites, atualizado em tempo real (não mostra quando 0 e mostra “99+” acima de 99).
- **Random Page**: página adicionada com botão para randomizar um personagem e exibir seu card.
- Identificação da página: agora exibida abaixo da AppBar e acima do conteúdo principal em todas as páginas.

### Removed
- Filtro de Characters: opção “Outros” em Species (todas as espécies já estão contempladas).

## [v1.1.1] - 2025-09-07

### Added
- AppBar (telas de detalhe): botão Home ao lado do Voltar para retornar diretamente à página inicial.

- Character Details: rótulo “Drag to enlarge/reduce” ao lado do ícone de expandir na imagem, indicando o gesto de arrastar para ampliar a foto.

- Favoritos: vibração ao adicionar ou remover um personagem dos favoritos.

## [v1.1.0] - 2025-09-03

### Added
- **Location Details**:
  - Lista de residentes rolável exibindo todos os residentes, sem expandir demais o card.
  - Chips de residentes clicáveis que abrem a tela do personagem.
- **Character Details**:
  - Links clicáveis para Last known location e Origin que abrem a tela de Location.
  - Link clicável em First seen in que abre a tela de Episode.
- **Episode Details**:
  - Exibição de todos os personagens como chips roláveis.
  - Chips clicáveis que abrem a tela de Character.
- **Utils**:
  - Helper `id_from_url.dart` para extrair o ID a partir de URLs.

### Changed
- **Location Details**:
  - Carregamento dos residentes passou a usar busca em lote (via getCharactersByIds) para reduzir chamadas à API.
  - Card simplificado para receber residentCharacters e onResidentTap, removendo o uso de residentNames.
- **Character Details / DetailsPage (character)**:
  - CharacterDetailsCard passou a aceitar locationId, originId, firstEpisodeId e callbacks (onLocationTap, onOriginTap, onFirstEpisodeTap) para habilitar a navegação.
  - DetailsPage agora extrai os IDs das URLs e injeta os callbacks no card.
- Demais páginas: mensagens padronizadas para inglês ("An error occurred.").

## [v1.0.0] - 2025-08-30

### Added

#### Funcionalidades Principais
- **Personagens**:
  - Listagem de personagens com paginação.
  - Cards de personagem exibindo nome e imagem.
  - Tela de detalhes completa com informações como espécie, gênero, status, origem e primeira aparição.
  - Imagem do personagem expansível na tela de detalhes com gesto de "puxar para ampliar".
  - Busca por nome de personagem (parcial ou completa).
  - Filtros por gênero, status e espécie.

- **Localidades**:
  - Listagem de localidades com paginação.
  - Cards de localidade exibindo tipo, dimensão e número de residentes.
  - Tela de detalhes com a lista de alguns residentes da localidade.
  - Busca por nome de localidade.

- **Episódios**:
  - Listagem de episódios com paginação.
  - Cards de episódio exibindo nome e código (ex: S01E01).
  - Tela de detalhes com data de exibição e outros metadados.
  - Filtro por temporada.

- **Sistema de Favoritos**:
  - Página dedicada na navegação lateral para listar personagens favoritos.
  - Funcionalidade para marcar e desmarcar personagens como favoritos através de um ícone de coração nos cards.
  - Grid visual para exibição dos personagens favoritados.
  - Botão para remover todos os favoritos na página dedicada.

- **Navegação & UI**
  - Home/Characters, Locations, Episodes, Favorites.
  - Barra de busca.
  - Barra lateral com seções (Pages/Utils) e labels de organização.
  - Tema centralizado (cores, tipografia, imagens) e componentes reutilizáveis (cards, filtros, paginação).

- **Dados & Arquitetura**
  - Integração com **The Rick and Morty API** (`/character`, `/location`, `/episode`).
  - Camada de repositório (HTTP via **Dio**) com suporte a paginação.
  - Modelos de domínio para personagens, episódios e localidades.

- **Build & Distribuição**
  - Build de **APK release** (`flutter build apk --release`).
  - **Ícone personalizado** de aplicativo.
  - Documentação básica no README.