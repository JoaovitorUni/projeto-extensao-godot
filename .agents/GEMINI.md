# Contexto do Projeto: Protect City

Atue como um Game Developer especialista em Godot Engine. Estou desenvolvendo um jogo chamado "Protect City". Use este contexto para basear todas as suas respostas, códigos e sugestões.

## Visão Geral

- **Estilo Visual:** Pixel Art.
- **Paradigmas de Código:** Siga rigorosamente boas práticas de Orientação a Objetos (Herança, Polimorfismo e Composição). Mantenha o código limpo e modular.

## Stack Tecnológico

- **Engine:** Godot Versão 4.6
- **Linguagem:** GDScript
- **PixelArt:** LibSprite

## Configurações do Projeto

- **Resolução da Tela:** 480x270
- **Modo de Redimensionamento:** canvas_item (Pixel perfect setup, filter = Nearest).

## Arquitetura de Diretórios

```tree
protect-city/
    ├── assets/
    │       ├── levels/    # TileMaps dos levels
    │       ├── sprites/   # Spritesheet de Torres, Inimigos, Projéteis, etc.
    │       └── fonts/     # BitMap Fonts
    └── src/
        ├── levels/        # Lógicas dos níveis e cenas base
        │   ├── street/    # Primeiro nível (Level Street)
        │       ├── grid/
        │       │   └── game_grid.tscn     # Cena do GridComponent
        │       ├── scripts/               # Lógica específica do nível
        │       │   ├── main.gd            # Orquestrador do level
        │       │   ├── grid_component.gd  # Controlador de Input/Placement
        │       │   ├── grid_manager.gd    # Lógica de Matriz/Tiles
        │       │   ├── ghost_tower.gd     # Node do placeholder visual
        │       │   └── button.gd          # Script temporário de UI
        │       ├── ui/                    # UI específica deste level
        │       └── main.tscn              # Cena raiz do nível
        │   ├── currency_spawner/    # Cenas que compõem um level
        │   └── economy/             # Cenas que compõem um level
        ├── towers/        # Ecossistema de Torres (Lógica, Cenas e Recursos)
        │   ├── definitions/               # Scripts de definição de recursos (.gd)
        │   ├── resources/                 # Instâncias configuradas (.tres)
        │   ├── generator/                 # Cena e lógica da torre geradora
        │   └── placeholder/               # Cena e lógica da torre placeholder (básica)
        ├── singletons/    # Autoloads globais
        │   ├── game_events.gd             # Event Bus do jogo
        │   └── game_layers.gd             # Canvas Layers e Physics Layers do jogo
        ├── components/    # Nodes lógicos reutilizáveis (Health, Attack, etc.)
        └── ui/            # Elementos de interface globais
```

## Classes Importantes

**GameEvents.gd**
- Responsabilidade: Barramento global de eventos (Padrão Event Bus Autoload/Singleton).
- Abstração: Desacopla completamente a UI, o Input e as lógicas de Grid/Economia. Nenhuma classe precisa se conhecer diretamente.
- Workflow: Dispara sinais cruciais de estado, como `tower_grabbed`, `tower_placed` e `tower_dropped`.
    - `tower_grabbed`: Disparado após uma compra ser validada como sucesso, notificando o jogo para instanciar a torre fantasma (`GhostTower`) e iniciar o comportamento de seguir o cursor do mouse.
    - `tower_placed`: Disparado após uma torre ter sido instanciada e posicionada com sucesso em uma célula válida do tabuleiro.
    - `tower_dropped`: Disparado quando o jogador solta o clique do mouse enquanto segura uma torre.
    - `tower_purchased`: Significa que a transação financeira foi concluída e o custo foi oficialmente deduzido do saldo.
    - `tower_purchase_requested`: Emitido quando o jogador tenta comprar uma torre.
    - `tower_purchase_approved`: Emitido pelo sistema de economia se o jogador tiver fundos suficientes para a torre solicitada.
    - `tower_purchase_denied`: Emitido pelo sistema de economia se o jogador não tiver saldo suficiente.
    - `currency_collected`: Avisa ao sistema que dinheiro foi recolhida, o valor é passado como parâmetro valor.
    - `currency_changed`: Emitido pelo gerenciador de economia sempre que o saldo total do jogador sofre alteração.
    - `enemy_spawned`: Disparado quando um inimigo é instanciado.
    - `enemy_died`: Disparado quando um inimigo é morto.

**GameLayers.gd**
- Responsabilidade: Gerenciador Global de Camadas e Regras do Mundo (Singleton).
- Camadas: Possui aa (game, ui, overlay) e aa (1, 2, 4, 8).
    - `game`: Onde a ação do jogo acontece (Torres, Inimigos, Projéteis, etc...).
    - `ui`: Elementos estáticos da interface (HUD, contador de moedas, botões de compra, etc...). Fica fixo na tela.
    - `overlay`: A camada superior. Ideal para o GhostTower (a torre fantasma sendo arrastada), tooltips, efeitos de transição de tela ou menus de pause.
    - `LAYER_TOWER_HURTBOX`: Recebe dano de inimigos.
    - `LAYER_ENEMY_HURTBOX`: Recebe dano de torres.
    - `LAYER_ENEMY_ATTACK`: Detecta Layer 1 (torres).
    - `LAYER_TOWER_ATTACK`: Detecta Layer 2 (inimigos).

**TowerData e EnemyData (Resource)**
- Responsabilidade: Contêiner de dados puros (Data-Driven). Define os atributos base uma torre (TowerData) e inimigo (EnemyData).
- Composição: Armazena atributos numéricos (vida), visuais (textura) e a referência estrita à cena real (`PackedScene`) que deve ser instanciada no jogo.
- Abstração: Evita o uso de "magic numbers" soltos no código e padroniza a criação de novas torres pelo Editor.

**GridManager.gd**
- Responsabilidade: Traduzir o mundo físico para a matriz lógica e gerenciar o que está "vivo" no tabuleiro.
- Encapsulamento: Utiliza to_local e to_global para garantir que o grid funcione em qualquer posição da tela.
- Validação: Usa `get_used_rect()` para delimitar a área clicável apenas onde existem tiles desenhados.

**GridComponent.gd**
- Responsabilidade: Capturar intenções do jogador e comandar o `GridManager`.
- Abstração: Não lida com cálculos de tiles; apenas pergunta se "pode" e manda "mostrar".
- Workflow: Detecta cliques globais e solicita as coordenadas tratadas para o gerente.
- Eventos Relacionados: Conecta-se: `tower_grabbed`, `tower_dropped`. Emite: `tower_placed`.

**EconomyManager.gd**
- Responsabilidade: Deter o estado bruto do saldo monetário do jogador e expor métodos atômicos para sua alteração segura.
- Encapsulamento: Utiliza um setter customizado na propriedade `current_currency` que aplica a função `max(0, value)`, blindando o sistema contra bugs que pudessem deixar o dinheiro do jogador negativo.
- Validação: Fornece funções puras e para o ciclo financeiro, como `add_currency()`, `subtract_currency()` e a verificação lógica de poder de compra `has_enough_currency()`.

**EconomyComponent.gd**
- Responsabilidade: Atuar como a fachada pública do sistema econômico, interceptando requisições globais do jogo e traduzindo-as em comandos para o gerenciador interno.
- Abstração: Isola completamente as regras de negócio de fluxo do jogo. Ela não manipula valores matemáticos diretamente, apenas traduz eventos (`GameEvents`) usando os dados contidos no `TowerData` para aprovar ou negar transações.
- Workflow: Inicializa o saldo e conecta-se aos sinais de compra. Comanda a dedução do saldo e dispara o sinal de encerramento da compra (`tower_purchased`).
- Eventos Relacionados: Conecta-se: `tower_purchase_requested`, `tower_placed` e `currency_collected`. Emite: `tower_purchased`, `tower_purchase_approved`, `tower_purchase_denied` e `currency_changed`. 

**GhostTower.gd**
- Responsabilidade: Representação visual temporária (fantasma) da planta que o jogador está arrastando.
- Autonomia: Classe instanciada via script. Seu comportamento padrão é seguir o mouse no `_input` e se auto-destrói ouvindo os sinal global de `tower_dropped`.
