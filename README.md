# 🔗 BlockHub

Sistema de repositorios descentralizados basado en blockchain y IPFS que permite la gestión colaborativa de proyectos con sistema de recompensas en ETH.

## 📋 Descripción

Este proyecto implementa un sistema de control de versiones descentralizado donde:
- Los repositorios se almacenan como NFTs (ERC721)
- El contenido se guarda en IPFS mediante CIDs
- Los colaboradores pueden enviar commits que requieren aprobación
- Los dueños pueden recompensar contribuciones con ETH

## 🏗️ Arquitectura

### Contratos Principales

#### Repository.sol
Contrato individual que representa un repositorio descentralizado.

**Características:**
- 📦 Almacena metadatos del repositorio (nombre, dueño, CID de IPFS)
- 📝 Gestiona historial de commits con estados (pending, accepted, rejected)
- 💰 Recibe y distribuye recompensas en ETH
- 🔒 Control de acceso con modificador `onlyRepoOwner`

**Estructura de Commit:**
```solidity
struct Commit {
    string commitMsg;      // Mensaje descriptivo
    uint256 timestamp;     // Timestamp del bloque
    address payable committer; // Dirección del colaborador
    string commitCID;      // IPFS CID del nuevo estado
    uint256 status;        // 0: pending, 1: accepted, 2: rejected
}
```

#### RepositoryFactory.sol
Factory pattern que crea y gestiona múltiples repositorios.

**Características:**
- 🏭 Crea nuevos repositorios como NFTs
- 📊 Lista repositorios por dueño o todos los existentes
- 💸 Maneja depósitos de ETH a repositorios
- ✅ Gestiona aprobaciones y rechazos de commits
- 📡 Emite eventos para tracking off-chain

## 🚀 Funcionalidades

### Para Dueños de Repositorios

1. **Crear Repositorio**
```solidity
createRepository(string _repoName, string _repoCID)
```

2. **Depositar Fondos**
```solidity
depositToRepo(uint256 _tokenId) payable
```

3. **Aprobar Commits**
```solidity
approveCommit(uint256 _tokenId, uint256 commitIndex, uint256 reward)
```

4. **Rechazar Commits**
```solidity
rejectCommit(uint256 _tokenId, uint256 commitIndex)
```

### Para Colaboradores

1. **Enviar Commit**
```solidity
processNewCommit(uint256 _tokenId, string message, string commitCID)
```

2. **Consultar Commits**
```solidity
retrieveCommits(uint256 _tokenId)
```

### Consultas Públicas

- `getAllRepos()` - Lista todos los repositorios
- `getAllReposByOwner()` - Lista repositorios del usuario actual
- `getBalance(uint256 _tokenId)` - Consulta balance de un repositorio

## 📦 Instalación

### Prerrequisitos

```bash
node >= 16.0.0
npm >= 7.0.0
```

### Dependencias

```bash
npm install @openzeppelin/contracts
```

### Compilación

```bash
# Con Hardhat
npx hardhat compile

# Con Truffle
truffle compile

# Con Foundry
forge build
```

## 🔧 Despliegue

### Hardhat

```javascript
const RepositoryFactory = await ethers.getContractFactory("RepositoryFactory");
const factory = await RepositoryFactory.deploy();
await factory.deployed();
console.log("RepositoryFactory deployed to:", factory.address);
```

### Remix IDE

1. Compila `RepositoryFactory.sol`
2. Despliega el contrato
3. Interactúa con las funciones desde la interfaz

## 💡 Ejemplo de Uso

```javascript
// 1. Crear un nuevo repositorio
await factory.createRepository("mi-proyecto", "QmXyz123...");

// 2. Depositar fondos para recompensas
await factory.depositToRepo(1, { value: ethers.utils.parseEther("1.0") });

// 3. Un colaborador envía un commit
await factory.processNewCommit(1, "Añadir feature X", "QmAbc456...");

// 4. El dueño aprueba y recompensa
await factory.approveCommit(1, 0, ethers.utils.parseEther("0.1"));

// 5. Consultar todos los commits
const commits = await factory.retrieveCommits(1);
```

## 📊 Estados de Commit

| Estado | Valor | Descripción |
|--------|-------|-------------|
| Pending | 0 | Commit esperando revisión |
| Accepted | 1 | Commit aprobado y pagado |
| Rejected | 2 | Commit rechazado sin pago |

## 🔐 Seguridad

- ✅ Uso de modificadores para control de acceso
- ✅ Validación de estado antes de procesar commits
- ✅ Verificación de balance antes de pagos
- ✅ Uso de `call` para transferencias ETH seguras
- ✅ Protección contra reentrancy con checks-effects-interactions

## 📡 Eventos

```solidity
event CreatedSuccessfully(uint256 indexed tokenId, address indexed owner, string repoCID);
event processedCommit(uint256 indexed tokenId, address indexed owner, address indexed committer, string repoCID);
event approvedCommit(uint256 indexed tokenId, address indexed owner, string repoCID);
event rejectedCommit(address indexed committer, address indexed rejectedBy, string repoCID);
event depositedETH(uint256 indexed tokenId, address indexed owner, uint256 amount);
```

## 🧪 Testing

```bash
# Hardhat
npx hardhat test

# Truffle
truffle test

# Foundry
forge test
```

## 📝 Licencia

MIT License - ver archivo LICENSE para más detalles

## 👥 Equipo

- **Walther** - Configuración inicial del Smart Contract
- **Alberth** - Implementación de funciones de repositorio y commits
- **Kevin** - Backend e integración con blockchain/IPFS

## 🔗 Enlaces Útiles

- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [IPFS Documentation](https://docs.ipfs.tech/)
- [Solidity Documentation](https://docs.soliditylang.org/)

---

**Nota:** Este es un proyecto educativo/experimental. Asegúrate de realizar auditorías de seguridad antes de usar en producción.
