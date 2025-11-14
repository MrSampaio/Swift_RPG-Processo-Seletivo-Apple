import Foundation

// (Error Handling) -> erros possiveis
enum TransactionError: Error {
    case insufficientCredits
    case itemUnavailable
}

// possiveis ameacas no espaco
enum ThreatType: String {
    case drone = "Drone de Sucata"
    case pirate = "Caça Pirata"
    case frigate = "Fragata Imperial"
    case anomaly = "Anomalia Cósmica"
}


var shieldIntegrity = 100 // vida do escudo
var maxShields = 100
var galacticCredits = 50 // quantidade de ouro inicial
var cargoHold: [String] = ["Laser de Mineração Básico"] // array (Inventário)
var alienDatabase: Set<String> = [] // Set (Inimigos únicos encontrados) para ser usado como um mini banco de dados
var isSystemOnline = true // Controle do Loop

// dict com modulo e preco
let stationMarket: [String: Int] = [
    "NANOBOTS DE REPARO": 25,
    "ARMA DE PLASMA": 100,
    "GERADOR DE CAMPO DE ELETRICO": 150
]

// funcão com retorno de Tupla nomeada
func scanSector() -> (name: String, damage: Int, scrapValue: Int) {
    let type: ThreatType
    let roll = Int.random(in: 1...100)
    
    // probabilidade de encontrar diferentes ameaças
    if roll < 50 { type = .drone }
    else if roll < 80 { type = .pirate }
    else if roll < 95 { type = .frigate }
    else { type = .anomaly }
    
    // registra informacao no alianDatabase
    alienDatabase.insert(type.rawValue)
    
    // atributos das ameacas
    switch type {
    case .drone: return (type.rawValue, 5, 10)
    case .pirate: return (type.rawValue, 10, 20)
    case .frigate: return (type.rawValue, 25, 50)
    case .anomaly: return (type.rawValue, 50, 200)
    }
}

// funcao de compra com tratamento de erro (throws)
func install(_ module: String) throws {

    // verifica a disponibilidade e devolve caso nao esteja
    guard let price = stationMarket[module.uppercased()] else {
        throw TransactionError.itemUnavailable
    }
    
    // verificacao de quantidade de creditos
    if galacticCredits < price {
        throw TransactionError.insufficientCredits
    }
    
    // operacao de compra, subtrai o preco do credito atual
    galacticCredits -= price
    cargoHold.append(module.uppercased())
    
    // logica de reparacao da nave
    if module == "NANOBOTS DE REPARO" {
        shieldIntegrity = min(shieldIntegrity + 50, maxShields)
        print("\n🔧 Nanobots ativados. Integridade do casco restaurada!")
    } else {
        print("\n🚀 Módulo instalado: \(module)!")
    }
}

// funcao que mostra o painel de controle, assim, o usuario tem maior controle das informacoes atuais
func displayHUD() {
    print("\n========================================")
    print("🛸 NAVE VANGUARD | 🛡️ Escudos: \(shieldIntegrity)% | 💳 Créditos: \(galacticCredits)")
    print("📦 Carga: \(cargoHold.joined(separator: ", "))")
    print("💾 Banco de Dados (Ameaças Catalogadas): \(alienDatabase.count)")
    print("========================================\n")
}

// logicas de navegacao
func dockAtStation() {
    print("\n🛰️ --- ATRACADO NA ESTAÇÃO ESPACIAL ---")
    print("Módulos disponíveis para instalação:")
    
    // loop que exibe item e preco da loja
    for (item, price) in stationMarket {
        print("- \(item): 💳 \(price)")
    }
    print("Digite o nome do módulo para instalar ou 'sair':")
    
    // verificacao da acao do usuario com validacoes de erro
    if let input = readLine(), input != "sair" {
        do {
            try install(input.uppercased())
            print("✅ Transação aceita pelo sistema.")
        } catch TransactionError.insufficientCredits {
            print("❌ Erro: Saldo de créditos insuficiente.")
        } catch TransactionError.itemUnavailable {
            print("❌ Erro: Módulo não encontrado no inventário da estação.")
        } catch {
            print("❌ Erro crítico no sistema de comércio.")
        }
    } else {
        print("Desacoplando da estação...")
    }
}

// caso escolha explorar, funcao que atira a mensagem com o inimigo proximo e as escolhas
func engageSector() {
    let threat = scanSector()
    
    print("\n⚠️⚠️⚠️ ALERTA DE PROXIMIDADE: \(threat.name) DETECTADO ⚠️⚠️⚠️")
    print("Potencial de Dano ao Casco: \(threat.damage)")
    
    print("1. Engajar em Combate")
    print("2. Executar Manobra Evasiva")
    
    // caso escolha combate, recebe dano e joga mensagens
    if let choice = readLine() {
        if choice == "1" {
            print("🔥 Disparando lasers contra \(threat.name)!")
            
            print("Ameaça neutralizada. Escudos absorveram impacto.")
            shieldIntegrity -= threat.damage
            
            // caso o escudo nao tenha sido quebrado, recebe creditos
            if shieldIntegrity > 0 {
                print("💎 Destroços recuperados. Valor: \(threat.scrapValue) créditos.")
                galacticCredits += threat.scrapValue
            }
            
        // caso tenha escolhido manobra evasiva
        } else {
            print("💨 Motores em potência máxima. Você escapou, mas superaqueceu os escudos (-5%).")
            shieldIntegrity -= 5
        }
    }
}

// funcao de inicio do jogo
func initiateLaunchSequence() {
    print("🌌 Iniciando Protocolo Estelar... Motores Online. 🌌")
    
    while isSystemOnline {
        // verifica se a nave foi destruida, joga mensagem e sai do laco
        if shieldIntegrity <= 0 {
            print("\n💥 ALERTA CRÍTICO: Falha catastrófica nos escudos. Nave destruída.")
            isSystemOnline = false
            break
        }
        
        // retorna as escolhas
        displayHUD()
        print("Aguardando comando, Comandante:")
        print("[1] Escanear Setor (Explorar)")
        print("[2] Atracar na Estação (Loja)")
        print("[3] Encerrar Missão (Sair)")
        print("Comando: ", terminator: "")
        
        // testa qual foi a escolha e direciona para a determinada funcao
        if let command = readLine() {
            switch command {
            case "1":
                engageSector()
            case "2":
                dockAtStation()
            case "3":
                print("Desligando sistemas principais...")
                isSystemOnline = false
            default:
                print("Comando não reconhecido pela IA.")
            }
        }
    }
}

// --- CONTEXTO INICIAL ---
    print("\n========================================================")
    print("🚀BEM-VINDO, COMANDANTE DA NAVE VANGUARD🚀")
    print("========================================================")
    print("\n 🎯 Sua missão: sobreviver e prosperar no traiçoeiro 'Setor Perigoso'.")
    print("⚠️ Esta região é notória por sua instabilidade, patrulhada por")
    print("Drones de Sucata, Caças Piratas e a temida Fragata Imperial.")
    print("\n Relatos recentes mencionam Anomalias Cósmicas... tenha cuidado.")
    print("\n 💳 Gerencie seus Créditos Galácticos, mantenha os escudos operacionais")
    print("e use a Estação Espacial para instalar módulos vitais.")
    print("\nO destino da VANGUARD está em suas mãos.")
    print("========================================================")

// funcao que inicia o jogo
initiateLaunchSequence()
