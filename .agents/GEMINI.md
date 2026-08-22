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
        │   ├── economy/             # Cenas que compõem um level
        │   └── wave/                # Gerenciamento e orquestração de ondas de inimigos
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

## Arquitetura de Componentes: Padrão Híbrido (Scene-Driven + Inversão de Dependência)

- **Referenciação Interna (Scene-Driven):** Nós que pertencem exclusivamente ao escopo interno do componente são mapeados nativamente via `@onready var = $No`. Isso preserva o uso do Inspector, o ciclo de vida da engine e permite o teste isolado de cada cena (`F6`).
- **Inversão de Dependência (Code-Driven Injection):** O componente **nunca** busca dependências externas por caminhos fixos na árvore (`$"../../GridManager"`). Referências a nós externos ou dados do nível (`LevelConfig`, `GridManager`, `Node2D`) são injetados de fora para dentro através de métodos explícitos de setup (ex: `setup()`, `setup_level()`) executados pelo orquestrador (`main.gd`).
- **Contrato Estrito (Fail-Fast):** Pré-condições de runtime e dependências do Inspector são validadas usando `assert()` durante a inicialização/`_ready()`. Se uma dependência obrigatória for omitida, a execução é interrompida imediatamente no Editor com uma mensagem clara no console.

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
    - `currency_generated`: Disparado quando dinheiro é gerado automaticamente.
    - `enemy_spawned`: Disparado quando um inimigo é instanciado.
    - `enemy_died`: Disparado quando um inimigo é morto.
    - `wave_started`: Disparado quando uma onda de inimigos é iniciada.
    - `wave_completed`: Disparado quando uma onda é concluída com sucesso.
    - `all_waves_completed`: Disparado quando todas as ondas do nível forem finalizadas.

**GameLayers.gd**
- Responsabilidade: Gerenciador Global de Camadas e Regras do Mundo (Singleton).
- Camadas: Possui as Layers de renderização (game, ui, overlay) e as Physics Layers (1, 2, 4, 8).
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

**WaveManager.gd**
- Responsabilidade: Orquestrar o ciclo de vida e a progressão de ondas de inimigos do nível.
- Composição: Coordena o recurso de dados de ondas (`LevelWavesData`), o gerador de orçamento de spawn (`WaveBudgetGenerator`), o spawner por faixas (`LaneSpawner`) e o monitorador de eliminação/tempo (`WaveTracker`).
- Workflow: Recebe o `enemy_container` e `grid_manager` via Inspector e injeta-os no `LaneSpawner` durante o `_ready()`. Controla o temporizador de spawn (`SpawnTimer`) e gerencia a transição de ondas.
- Eventos Relacionados: Conecta-se: `wave_time_expired` e `wave_cleared` (emitidos pelo `WaveTracker`). Emite: `wave_started`, `wave_completed` e `all_waves_completed`.

### Componentes

**HealthComponent.gd**
- Responsabilidade: Gerenciar a vida, dano e cura de uma entidade (torre ou inimigo).
- Encapsulamento: Mantém o estado numérico (`current_health`, `max_health`, `is_dead`) e expõe métodos atômicos como `take_damage()`, `heal()` e `initialize()`.
- Eventos Relacionados: Emite `health_changed` e `died`.

**AttackComponent.gd**
- Responsabilidade: Detectar alvos dentro de um alcance específico e aplicar dano periódico a eles.
- Configuração e Facção: Ajusta dinamicamente `collision_layer` e `collision_mask` com base na facção (`TOWER` ou `ENEMY`), garantindo detecção de alvos corretos via `HurtboxComponent`.
- Workflow: Ao detectar uma hurtbox válida, inicia o timer interno de ataque (`_attack_timer`), executando o dano no intervalo configurado.
- Eventos Relacionados: Emite `attack_started`, `attack_finished`, `target_acquired` e `target_lost`.

**HitboxComponent.gd**
- Responsabilidade: Causar dano direto ao entrar em contato com uma `HurtboxComponent`.
- Abstração: É uma área (`Area2D`) de colisão ativa que armazena a quantidade de dano a ser aplicada e aciona a hurtbox atingida.

**HurtboxComponent.gd**
- Responsabilidade: Atuar como a área de colisão passiva (recebedora de dano) de uma entidade, redirecionando o dano recebido para seu `HealthComponent` associado.
- Facção: Configura suas camadas de colisão físicas de acordo com a facção (`LAYER_TOWER_HURTBOX` ou `LAYER_ENEMY_HURTBOX`).

**LinearMovementComponent.gd**
- Responsabilidade: Mover o nó pai ou um nó alvo (`target_node`) em uma linha reta contínua a uma velocidade constante.
- Controle de Estado: Oferece métodos para pausar (`pause()`), retomar (`resume()`), alterar velocidade e mudar a direção do movimento no eixo 2D.

**CurrencyGeneratorComponent.gd**
- Responsabilidade: Gerar periodicamente coletáveis de moeda e disparar o evento de geração.
- Workflow: Utiliza um `Timer` autostart alimentado por `GeneratorTowerData`, gerando um nó de moeda (`Currency`) na camada overlay com uma animação parabólica procedural (`Tween`) em um ponto aleatório da sua `GeneratorSpawnArea`.
- Eventos Relacionados: Emite `currency_generated`.
