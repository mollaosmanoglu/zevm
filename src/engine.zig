const std = @import("std");
const StackError = error{ StackOverflow, EmptyStack, IndexOutOfRange };

pub const EVM = struct {
    code: []const u8,
    stack: Stack,
    pc: usize,
    gas: u64,

    // interpreter
    pub fn run(self: *EVM) !void {
        const opcode: u8 = self.code[self.pc];

        switch (opcode) {
            // 0x00 range
            0x00 => return, // STOP
            0x01 => return, // ADD
            0x02 => return, // MUL
            0x03 => return, // SUB
            0x04 => return, // DIV
            0x05 => return, // SDIV
            0x06 => return, // MOD
            0x07 => return, // SMOD
            0x08 => return, // ADDMOD
            0x09 => return, // MULMOD
            0x0a => return, // EXP
            0x0b => return, // SIGNEXTEND

            // 0x10 range: comparison & bitwise
            0x10 => return, // LT
            0x11 => return, // GT
            0x12 => return, // SLT
            0x13 => return, // SGT
            0x14 => return, // EQ
            0x15 => return, // ISZERO
            0x16 => return, // AND
            0x17 => return, // OR
            0x18 => return, // XOR
            0x19 => return, // NOT
            0x1a => return, // BYTE
            0x1b => return, // SHL
            0x1c => return, // SHR
            0x1d => return, // SAR

            // 0x20 range: crypto
            0x20 => return, // KECCAK256

            // 0x30 range: environmental information
            0x30 => return, // ADDRESS
            0x31 => return, // BALANCE
            0x32 => return, // ORIGIN
            0x33 => return, // CALLER
            0x34 => return, // CALLVALUE
            0x35 => return, // CALLDATALOAD
            0x36 => return, // CALLDATASIZE
            0x37 => return, // CALLDATACOPY
            0x38 => return, // CODESIZE
            0x39 => return, // CODECOPY
            0x3a => return, // GASPRICE
            0x3b => return, // EXTCODESIZE
            0x3c => return, // EXTCODECOPY
            0x3d => return, // RETURNDATASIZE
            0x3e => return, // RETURNDATACOPY
            0x3f => return, // EXTCODEHASH

            // 0x40 range: block information
            0x40 => return, // BLOCKHASH
            0x41 => return, // COINBASE
            0x42 => return, // TIMESTAMP
            0x43 => return, // NUMBER
            0x44 => return, // DIFFICULTY / PREVRANDAO
            0x45 => return, // GASLIMIT
            0x46 => return, // CHAINID
            0x47 => return, // SELFBALANCE
            0x48 => return, // BASEFEE
            0x49 => return, // BLOBHASH
            0x4a => return, // BLOBBASEFEE

            // 0x50 range: stack, memory, storage, and flow
            0x50 => return, // POP
            0x51 => return, // MLOAD
            0x52 => return, // MSTORE
            0x53 => return, // MSTORE8
            0x54 => return, // SLOAD
            0x55 => return, // SSTORE
            0x56 => return, // JUMP
            0x57 => return, // JUMPI
            0x58 => return, // PC
            0x59 => return, // MSIZE
            0x5a => return, // GAS
            0x5b => return, // JUMPDEST
            0x5c => return, // TLOAD
            0x5d => return, // TSTORE
            0x5e => return, // MCOPY
            0x5f => return, // PUSH0

            // 0x60–0x7f: PUSH1–PUSH32
            0x60 => return, // PUSH1
            0x61 => return, // PUSH2
            0x62 => return, // PUSH3
            0x63 => return, // PUSH4
            0x64 => return, // PUSH5
            0x65 => return, // PUSH6
            0x66 => return, // PUSH7
            0x67 => return, // PUSH8
            0x68 => return, // PUSH9
            0x69 => return, // PUSH10
            0x6a => return, // PUSH11
            0x6b => return, // PUSH12
            0x6c => return, // PUSH13
            0x6d => return, // PUSH14
            0x6e => return, // PUSH15
            0x6f => return, // PUSH16
            0x70 => return, // PUSH17
            0x71 => return, // PUSH18
            0x72 => return, // PUSH19
            0x73 => return, // PUSH20
            0x74 => return, // PUSH21
            0x75 => return, // PUSH22
            0x76 => return, // PUSH23
            0x77 => return, // PUSH24
            0x78 => return, // PUSH25
            0x79 => return, // PUSH26
            0x7a => return, // PUSH27
            0x7b => return, // PUSH28
            0x7c => return, // PUSH29
            0x7d => return, // PUSH30
            0x7e => return, // PUSH31
            0x7f => return, // PUSH32

            // 0x80–0x8f: DUP1–DUP16
            0x80 => return, // DUP1
            0x81 => return, // DUP2
            0x82 => return, // DUP3
            0x83 => return, // DUP4
            0x84 => return, // DUP5
            0x85 => return, // DUP6
            0x86 => return, // DUP7
            0x87 => return, // DUP8
            0x88 => return, // DUP9
            0x89 => return, // DUP10
            0x8a => return, // DUP11
            0x8b => return, // DUP12
            0x8c => return, // DUP13
            0x8d => return, // DUP14
            0x8e => return, // DUP15
            0x8f => return, // DUP16

            // 0x90–0x9f: SWAP1–SWAP16
            0x90 => return, // SWAP1
            0x91 => return, // SWAP2
            0x92 => return, // SWAP3
            0x93 => return, // SWAP4
            0x94 => return, // SWAP5
            0x95 => return, // SWAP6
            0x96 => return, // SWAP7
            0x97 => return, // SWAP8
            0x98 => return, // SWAP9
            0x99 => return, // SWAP10
            0x9a => return, // SWAP11
            0x9b => return, // SWAP12
            0x9c => return, // SWAP13
            0x9d => return, // SWAP14
            0x9e => return, // SWAP15
            0x9f => return, // SWAP16

            // 0xa0–0xa4: LOG0–LOG4
            0xa0 => return, // LOG0
            0xa1 => return, // LOG1
            0xa2 => return, // LOG2
            0xa3 => return, // LOG3
            0xa4 => return, // LOG4

            // 0xf0 range: system operations
            0xf0 => return, // CREATE
            0xf1 => return, // CALL
            0xf2 => return, // CALLCODE
            0xf3 => return, // RETURN
            0xf4 => return, // DELEGATECALL
            0xf5 => return, // CREATE2
            0xfa => return, // STATICCALL
            0xfd => return, // REVERT
            0xfe => return, // INVALID
            0xff => return, // SELFDESTRUCT

            // undefined / reserved opcodes
            else => return,
        }
    }
    pub fn step(self: *EVM) !void {}
};

const Stack = struct {
    words: [1024]u256,
    height: usize,
    // stack operations
    fn _push(self: *Stack, word: u256) !StackError {
        if (self.height >= self.words.len) {
            return error.StackOverflow;
        }
        self.words[self.height] = word;
        self.height += 1;
    }
    fn _pop(self: *Stack) !void {
        if (self.height == 0) {
            return error.EmptyStack;
        }
        self.words[self.height - 1] = undefined;
        self.height -= 1;
    }
    fn _dup(self: *Stack) !StackError {
        if (self.height == 0) {
            return error.EmptyStack;
        }
        const dup: u256 = self.words[self.height - 1];
        try self._push(dup);
    }
    fn _swap(self: *Stack, a: usize, b: usize) !void {
        if (a >= self.height or b >= self.height) {
            return error.IndexOutOfRange;
        }
        const temp: u256 = self.words[a];
        self.words[a] = self.words[b];
        self.words[b] = temp;
    }
    //basic arithmetic
    fn _add(self: *Stack, a: u256, b: u256) !void {
        return try self._push(a + b);
    }
    fn _sub(self: *Stack, a: u256, b: u256) !void {
        return try self._push(a - b);
    }
    fn _mul(self: *Stack, a: u256, b: u256) !void {
        return try self._push(a * b);
    }
    fn _div(self: *Stack, a: u256, b: u256) !void {
        if (b == 0) {
            return try self._push(0);
        }
        return try self._push(a / b);
    }
    fn _mod(self: *Stack, a: u256, b: u256) !void {
        if (b == 0) {
            return try self._push(0);
        }
        return try self._push(a % b);
    }
    //comparison
    fn _lt(self: *Stack, a: u256, b: u256) !void {
        if (a < b) {
            try self._push(1);
        } else {
            try self._push(0);
        }
    }
    fn _gt(self: *Stack, a: u256, b: u256) !void {
        if (a > b) {
            try self._push(1);
        } else {
            try self._push(0);
        }
    }
    fn _eq(self: *Stack, a: u256, b: u256) !void {
        if (a == b) {
            try self._push(1);
        } else {
            try self._push(0);
        }
    }
    //bitwise operations
    fn _and(self: *Stack, a: u256, b: u256) !void {
        return try self._push(a & b);
    }
    fn _or(self: *Stack, a: u256, b: u256) !void {
        return try self._push(a | b);
    }
    fn _xor(self: *Stack, a: u256, b: u256) !void {
        return try self._push(a ^ b);
    }
    fn _not(self: *Stack, a: u256) !void {
        return try self._push(~a);
    }
};
