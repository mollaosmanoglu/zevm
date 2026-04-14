<p align="center">
  <img src="docs/logo.png" alt="zevm logo" width="200"/>
</p>

# zevm

![Zig](https://img.shields.io/badge/Zig-0.13-F7A41D)
![License](https://img.shields.io/badge/license-MIT-blue)
![Status](https://img.shields.io/badge/status-WIP-yellow)

Ethereum Virtual Machine implementation from scratch in Zig. Bytecode interpreter with 256-bit stack machine.

## Build

```bash
zig build run
```

Requires Zig 0.13+.

## Features

- 256-bit stack machine (PUSH, POP, DUP, SWAP)
- Arithmetic operations (ADD, SUB, MUL, DIV, MOD)
- Comparison (LT, GT, EQ, ISZERO)
- Bitwise operations (AND, OR, XOR, NOT, SHL, SHR)
- Memory operations (MLOAD, MSTORE)
- Storage (SLOAD, SSTORE)
- Control flow (JUMP, JUMPI, PC)
- Environment opcodes (CALLER, CALLVALUE, BLOCKHASH)
- Call semantics (CALL, DELEGATECALL, STATICCALL)

## Example

```zig
// Simple bytecode: PUSH1 0x05 PUSH1 0x03 ADD
const bytecode = [_]u8{ 0x60, 0x05, 0x60, 0x03, 0x01 };

var evm = EVM.init(allocator);
try evm.execute(&bytecode);

// Stack: [0x08]
```

## Opcodes Implemented

| Opcode | Hex  | Description       |
| ------ | ---- | ----------------- |
| STOP   | 0x00 | Halt execution    |
| ADD    | 0x01 | Addition          |
| MUL    | 0x02 | Multiplication    |
| SUB    | 0x03 | Subtraction       |
| DIV    | 0x04 | Integer division  |
| PUSH1  | 0x60 | Push 1 byte       |
| PUSH2  | 0x61 | Push 2 bytes      |
| DUP1   | 0x80 | Duplicate 1st     |
| SWAP1  | 0x90 | Swap top 2        |

See [evm.codes](https://evm.codes) for full opcode reference.

## Architecture

```
[User Input]                    [System Boundary: zevm]                    [EVM Spec]

┌──────────────┐                                                    ┌───────────────┐
│   Terminal   │                                                    │ Ethereum      │
│              │                                                    │ Yellow Paper  │
│ $ zig build  │                                                    │               │
│   run --     │                                                    │ evm.codes     │
│   contract   │                                                    └───────┬───────┘
│   .bin       │                                                            │
└──────┬───────┘                                                            │
       │                                                                    │
       │ Bytecode Input                                                     │
       ▼                                                                    │
┌─────────────────────────────────────────────────────────────────┐         │
│                   EVM Implementation (Zig)                       │         │
│                                                                 │         │
│  ┌──────────────────────────────────────────────────────────┐   │         │
│  │                Bytecode Loader                           │   │         │
│  │                                                          │   │         │
│  │  Read contract.bin                                       │   │         │
│  │  Parse opcodes                                           │   │         │
│  └──────────────┬───────────────────────────────────────────┘   │         │
│                 │                                               │         │
│                 ▼                                               │         │
│  ┌──────────────────────────────────────────────────────────┐   │         │
│  │            256-bit Stack Machine                         │   │◀────────┘
│  │                                                          │   │ Opcode Spec
│  │  Stack: [u256; 1024]                                     │   │
│  │  Operations:                                             │   │
│  │    PUSH1..PUSH32  → Push bytes to stack                  │   │
│  │    POP            → Remove top item                      │   │
│  │    DUP1..DUP16    → Duplicate stack item                 │   │
│  │    SWAP1..SWAP16  → Swap stack items                     │   │
│  └──────────────┬───────────────────────────────────────────┘   │
│                 │                                               │
│                 ▼                                               │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              Execution Engine                            │   │
│  │                                                          │   │
│  │  Arithmetic:  ADD, SUB, MUL, DIV, MOD, EXP               │   │
│  │  Comparison:  LT, GT, EQ, ISZERO                         │   │
│  │  Bitwise:     AND, OR, XOR, NOT, SHL, SHR                │   │
│  │  Memory:      MLOAD, MSTORE, MSTORE8                     │   │
│  │  Storage:     SLOAD, SSTORE                              │   │
│  │  Control:     JUMP, JUMPI, PC, JUMPDEST                  │   │
│  │  Environment: CALLER, CALLVALUE, BLOCKHASH               │   │
│  │  Calls:       CALL, DELEGATECALL, STATICCALL             │   │
│  └──────────────┬───────────────────────────────────────────┘   │
│                 │                                               │
│                 ▼                                               │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                 Gas Metering                             │   │
│  │                                                          │   │
│  │  Track gas consumption per opcode                        │   │
│  │  Halt on gas limit exceeded                              │   │
│  └──────────────┬───────────────────────────────────────────┘   │
│                 │                                               │
└─────────────────┼───────────────────────────────────────────────┘
                 │
                 ▼
          Execution Result
      (Stack state, Gas used)

Language: Zig 0.13 • Spec: Ethereum Yellow Paper • Ref: revm, py-evm
```

## References

- [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf) — Formal specification
- [evm.codes](https://evm.codes) — Interactive opcode reference
- [revm](https://github.com/bluealloy/revm) — Rust implementation
- [py-evm](https://github.com/ethereum/py-evm) — Python implementation

## Usage

Execute smart contract bytecode:

```bash
zig build run -- contract.bin
```

Supports full EVM opcode set with gas metering.

## License

MIT
