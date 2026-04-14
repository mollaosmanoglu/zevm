// TO-DO: create small test,  and move to phase 2.

const std = @import("std");
pub const EVMError = error{ StopToken, InvalidOpcode, StackOverflow, StackUnderflow, IndexOutOfRange };

pub const EVM = struct {
    code: []const u8,
    stack: Stack,
    pc: usize,
    gas: u64,

    // interpreter
    pub fn step(self: *EVM) EVMError!void {
        if (self.pc >= self.code.len - 1) {
            return error.InvalidOpcode;
        }
        const opcode: u8 = self.code[self.pc];
        var pc_changed: bool = false;

        switch (opcode) {
            // 0x00 range
            0x00 => return error.StopToken, // STOP
            0x01 => try self.stack._add(), // ADD
            0x02 => try self.stack._mul(), // MUL
            0x03 => try self.stack._sub(), // SUB
            0x04 => try self.stack._div(), // DIV
            0x05 => return, // SDIV
            0x06 => try self.stack._mod(), // MOD
            0x07 => return, // SMOD
            0x08 => return, // ADDMOD
            0x09 => return, // MULMOD
            0x0a => return, // EXP
            0x0b => return, // SIGNEXTEND

            // 0x10 range: comparison & bitwise
            0x10 => try self.stack._lt(), // LT
            0x11 => try self.stack._gt(), // GT
            0x12 => return, // SLT
            0x13 => return, // SGT
            0x14 => try self.stack._eq(), // EQ
            0x15 => return, // ISZERO
            0x16 => try self.stack._and(), // AND
            0x17 => try self.stack._or(), // OR
            0x18 => try self.stack._xor(), // XOR
            0x19 => try self.stack._not(), // NOT
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
            0x50 => try self.stack._pop(), // POP
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
            0x5f => try self.stack._push(0), // PUSH0

            // 0x60–0x7f: PUSH1–PUSH32
            0x60...0x7f => {
                const n: usize = opcode - 0x60 + 1;
                if (self.pc + 1 + n > self.code.len) {
                    return error.IndexOutOfRange;
                }
                const slice: []const u8 = self.code[(self.pc + 1)..(self.pc + n + 1)];
                var value: u256 = 0;
                for (slice) |b| {
                    value = (value << 8) + @as(u256, b);
                }
                try self.stack._push(value);
                self.pc = self.pc + n + 1;
                pc_changed = true;
            },

            // 0x80–0x8f: DUP1–DUP16
            0x80...0x8f => {
                const n: usize = opcode - 0x80 + 1;
                try self.stack._dup(n);
            },

            // 0x90–0x9f: SWAP1–SWAP16
            0x90...0x9f => {
                const n: usize = opcode - 0x90 + 1;
                try self.stack._swap(n);
            },
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
            else => return error.InvalidOpcode,
        }
        if (pc_changed == false) {
            self.pc += 1;
        }
    }
    pub fn run(self: *EVM) EVMError!void {
        while (true) {
            self.step() catch |err| {
                if (err == error.StopToken) {
                    break;
                } else {
                    return err;
                }
            };
        }
    }
};

const Stack = struct {
    words: [1024]u256,
    height: usize,
    // stack operations
    fn _push(self: *Stack, word: u256) EVMError!void {
        if (self.height >= self.words.len) {
            return error.StackOverflow;
        }
        self.words[self.height] = word;
        self.height += 1;
    }
    fn _pop(self: *Stack) EVMError!u256 {
        if (self.height == 0) {
            return error.StackUnderflow;
        }
        const ret: u256 = self.words[self.height - 1];
        self.words[self.height - 1] = undefined;
        self.height -= 1;
        return ret;
    }
    fn _dup(self: *Stack, n: usize) EVMError!void {
        if (self.height == 0 or self.height < n) {
            return error.StackUnderflow;
        }
        const dup: u256 = self.words[self.height - n];
        try self._push(dup);
    }
    fn _swap(self: *Stack, n: usize) EVMError!void {
        if (self.height <= n) {
            return error.IndexOutOfRange;
        }
        const temp: u256 = self.words[self.height - 1 - n];
        self.words[self.height - 1 - n] = self.words[self.height - 1];
        self.words[self.height - 1] = temp;
    }
    //basic arithmetic
    fn _add(self: *Stack) !void {
        const b = try self._pop();
        const a = try self._pop();
        return try self._push(a + b);
    }
    fn _sub(self: *Stack) !void {
        const b = try self._pop();
        const a = try self._pop();
        return try self._push(a - b);
    }
    fn _mul(self: *Stack) !void {
        const b = try self._pop();
        const a = try self._pop();
        return try self._push(a * b);
    }
    fn _div(self: *Stack) !void {
        const b = try self._pop();
        const a = try self._pop();
        if (b == 0) {
            return try self._push(0);
        }
        return try self._push(a / b);
    }
    fn _mod(self: *Stack) !void {
        const b = try self._pop();
        const a = try self._pop();
        if (b == 0) {
            return try self._push(0);
        }
        return try self._push(a % b);
    }
    //comparison
    fn _lt(self: *Stack) !void {
        const b = try self._pop();
        const a = try self._pop();
        if (a < b) {
            try self._push(1);
        } else {
            try self._push(0);
        }
    }
    fn _gt(self: *Stack) !void {
        const b = try self._pop();
        const a = try self._pop();
        if (a > b) {
            try self._push(1);
        } else {
            try self._push(0);
        }
    }
    fn _eq(self: *Stack) !void {
        const b = try self._pop();
        const a = try self._pop();
        if (a == b) {
            try self._push(1);
        } else {
            try self._push(0);
        }
    }
    //bitwise operations
    fn _and(self: *Stack) !void {
        const b = try self._pop();
        const a = try self._pop();
        return try self._push(a & b);
    }
    fn _or(self: *Stack) !void {
        const b = try self._pop();
        const a = try self._pop();
        return try self._push(a | b);
    }
    fn _xor(self: *Stack) !void {
        const b = try self._pop();
        const a = try self._pop();
        return try self._push(a ^ b);
    }
    fn _not(self: *Stack) !void {
        const a = try self._pop();
        return try self._push(~a);
    }
};

test "run" {}
