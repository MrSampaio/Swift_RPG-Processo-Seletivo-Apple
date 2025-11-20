
---

# 🚀 Vanguard: Aventura Espacial em Swift (Console)

"**Vanguard**" é um jogo de aventura espacial em modo texto, baseado em console, escrito inteiramente em **Swift**.
Você assume o papel de comandante da nave Vanguard, com a missão de sobreviver e prosperar no traiçoeiro **Setor Perigoso**.

O jogo é um loop de gerenciamento de recursos, exploração e combate por turnos — projetado para demonstrar vários conceitos fundamentais da linguagem Swift em um pacote divertido.

---

## 🎮 Demonstração de Jogo (Saída do Console)

```text
🌌 Iniciando Protocolo Estelar... Motores Online. 🌌

========================================================
        BEM-VINDO, COMANDANTE DA NAVE VANGUARD
========================================================
... (Contexto da missão) ...

(Pressione Enter para iniciar sua patrulha...)

========================================
🛸 NAVE VANGUARD | 🛡️ Escudos: 100% | 💳 Créditos: 50
📦 Carga: Laser de Mineração Básico
💾 Banco de Dados (Ameaças Catalogadas): 0
========================================

Aguardando comando, Comandante:
[1] Escanear Setor (Explorar)
[2] Atracar na Estação (Loja)
[3] Encerrar Missão (Sair)

Comando: 1

⚠️⚠️⚠️ ALERTA DE PROXIMIDADE: Drone de Sucata DETECTADO ⚠️⚠️⚠️
Potencial de Dano ao Casco: 5

1. Engajar em Combate
2. Executar Manobra Evasiva
```

---

## ⚙️ Como Funciona

O jogo opera em um loop principal (`while isSystemOnline`) controlado pela função `initiateLaunchSequence()`.
A cada turno, o jogador recebe seu painel (`displayHUD()`) e escolhe uma ação:

---

### **1. Escanear Setor (Explorar)**

* Gera um encontro aleatório via `scanSector()`.
* Cada ameaça vem de um `ThreatType`, com dano e recompensa próprios.
* O jogador pode escolher:

  * **Lutar** → arriscar dano e ganhar créditos.
  * **Fugir** → sofre pouco dano, mas evita a luta.
* Se os escudos chegarem a **0**, a missão termina.

---

### **2. Atracar na Estação (Loja)**

* A loja usa o dicionário `stationMarket`.
* Compras são validadas pela função `install()`, que utiliza **tratamento de erros** (`throws`).
* É possível comprar:

  * Módulos
  * Armas
  * **Nanobots de Reparo** (restauram escudos)

---

### **3. Encerrar Missão**

* Finaliza o loop principal e encerra o jogo.

---

## ✨ Principais Conceitos de Swift Aplicados

### ✅ **Enums**

* `ThreatType`: define tipos de inimigos com segurança de tipo.
* `TransactionError`: enum que implementa o protocolo `Error`.

---

### ✅ **Tratamento de Erros (`do` / `try` / `catch`)**

* A função `install()` lança erros customizados:

  * `.insufficientCredits`
  * `.itemUnavailable`
* `dockAtStation()` captura e exibe mensagens amigáveis ao jogador.

---

### ✅ **Coleções**

* **Array `[String]`** → inventário (`cargoHold`)
* **Dictionary `[String: Int]`** → loja (`stationMarket`)
* **Set `<String>`** → ameaças catalogadas (`alienDatabase`)
  (sem duplicatas)

---

### ✅ **Tuplas**

* `scanSector()` retorna:

  ```swift
  (name: String, damage: Int, scrapValue: Int)
  ```

  Tornando o retorno múltiplo claro e simples.

---

### ✅ **Controle de Fluxo**

* Loop `while`
* `switch` para comandos
* Probabilidades usando `Int.random(in: 1...100)`

---

### ✅ **Opcionais**

* Entrada do usuário via:

  ```swift
  if let command = readLine()
  ```

---

## 🚀 Como Executar

### 🔧 Terminal (macOS/Linux)

1. Salve o projeto como **main.swift**
2. No terminal, execute:

```bash
swift main.swift
```

---

### 🧰 Usando o Xcode

1. Crie um projeto:
   **macOS → Command Line Tool**
2. Substitua o conteúdo de `main.swift` pelo código do jogo.
3. Pressione **Run (⌘ + R)**.

---

