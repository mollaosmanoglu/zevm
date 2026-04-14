# Ethereum Virtual Machine (EVM) Project - Context for AI

## Developer Background
- **Primary Language**: Python
- **Zig Experience**: Learning Zig through building projects
- **Learning Style**: Hands-on, learning by doing
- **Needs**: Back-and-forth guidance, hints and tips rather than complete solutions
- **EVM Knowledge**: Understanding EVM architecture and opcodes

## Project Goal
Build an Ethereum Virtual Machine implementation from scratch to:
1. Learn EVM architecture and execution model
2. Apply knowledge in Zig's minimalist environment
3. Create a working bytecode interpreter
4. Eventually support full smart contract execution

## Available Resources
1. **Ethereum Yellow Paper** - Formal EVM spec — [github.com/ethereum/yellowpaper](https://github.com/ethereum/yellowpaper) · [PDF](https://ethereum.github.io/yellowpaper/paper.pdf) *(spec up to Shanghai; for latest use execution-specs)*
2. **EVM Opcodes** - Interactive reference — [evm.codes](https://evm.codes) · [github.com/duneanalytics/evm.codes](https://github.com/duneanalytics/evm.codes)
3. **Zig Documentation** - Language reference
4. **EVM implementations (reference)** — [revm](https://github.com/bluealloy/revm) (Rust), [evmone](https://github.com/ethereum/evmone) (C++), [py-evm](https://github.com/ethereum/py-evm), [go-ethereum](https://github.com/ethereum/go-ethereum) (EVM in `core/vm`, `evm` CLI for bytecode debug)
5. **Tests & spec** — [ethereum/execution-spec-tests](https://github.com/ethereum/execution-spec-tests) (fixtures), [ethereum/execution-specs](https://github.com/ethereum/execution-specs) (current spec)

## Development Philosophy
- Code by hand, understand every line
- No premature optimizations
- Focus on correctness and learning over performance
- Iterative development with testing at each phase
- Embrace Zig's minimalism and explicit nature

## Project Phases

### Phase 1: Stack Machine & Interpreter (PLANNED)
- Implement 256-bit word stack (max depth: 1024)
- Stack operations: PUSH, POP, DUP, SWAP
- Basic arithmetic opcodes: ADD, SUB, MUL, DIV, MOD
- Comparison operations: LT, GT, EQ
- Bitwise operations: AND, OR, XOR, NOT
- Minimal interpreter loop: `run`/`step` on `EVM` that:
  - reads opcodes from `code` using `pc`
  - dispatches to stack/arith/bitwise helpers
  - advances `pc` and (later) charges gas

### Phase 2: Memory Management (PLANNED)
- Transient memory (word-addressed byte array)
- Memory operations: MLOAD, MSTORE, MSTORE8, MSIZE
- Memory expansion and gas calculation

### Phase 3: Storage (PLANNED)
- Persistent storage (key-value store)
- Storage operations: SLOAD, SSTORE
- Transient storage: TLOAD, TSTORE

### Phase 4: Execution Context (PLANNED)
- Program counter (PC)
- Gas metering
- Execution environment (caller, value, calldata)
- Environmental opcodes: ADDRESS, BALANCE, CALLER, CALLVALUE

### Phase 5: Control Flow (PLANNED)
- Jumps: JUMP, JUMPI, JUMPDEST
- Program counter manipulation
- Halting: STOP, RETURN, REVERT

### Phase 6: External Interactions (PLANNED)
- Call operations: CALL, STATICCALL, DELEGATECALL
- Contract creation: CREATE, CREATE2
- Block/transaction context

### Phase 7: Testing & Validation (PLANNED)
- Ethereum test suite integration
- Bytecode execution tests
- Gas calculation verification

## EVM Architecture Notes
- **Stack Machine**: 256-bit word stack, max depth 1024
- **Memory Model**: Byte-addressable volatile memory, expandable
- **Storage Model**: 256-bit key-value persistent storage
- **State Transition**: Pure function S' = Y(S, T)
- **Gas System**: Every operation costs gas

## How Claude Should Help
- **Guide, don't implement** - provide hints and explanations, not full solutions
- **Keep it concise** - brief, focused responses
- **Point out pitfalls** - especially allocators, comptime, and error handling
- **Relate to Python** - when helpful for understanding
- **Reference Yellow Paper** - for formal specification questions

## Development History
(To be updated as phases complete)

## Current Status
- Current Phase: **Phase 1 (Stack Machine & Interpreter)** (IN PROGRESS)
- Next Steps: Wire a minimal interpreter loop (`run`/`step`) that executes a small subset of opcodes using the stack helpers
