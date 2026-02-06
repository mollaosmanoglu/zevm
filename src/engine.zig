const std = @import("std");
const StackError = error{ StackOverflow, EmptyStack, IndexOutOfRange };

pub const EVM = struct {
    code: []const u8,
    stack: Stack,
    pc: usize,
    gas: u64,

    pub fn name() !void {}
};

const Stack = struct {
    words: [1024]u256,
    height: usize,
    // stack operations
    pub fn push_(self: *Stack, word: u256) !StackError {
        if (self.height >= self.words.len) {
            return error.StackOverflow;
        }
        self.words[self.height] = word;
        self.height += 1;
    }
    pub fn pop_(self: *Stack) !void {
        if (self.height == 0) {
            return error.EmptyStack;
        }
        self.words[self.height - 1] = undefined;
        self.height -= 1;
    }
    pub fn dup_(self: *Stack) !StackError {
        if (self.height == 0) {
            return error.EmptyStack;
        }
        const dup: u256 = self.words[self.height - 1];
        try self.push_(dup);
    }
    pub fn swap_(self: *Stack, a: usize, b: usize) !void {
        if (a >= self.height or b >= self.height) {
            return error.IndexOutOfRange;
        }
        const temp: u256 = self.words[a];
        self.words[a] = self.words[b];
        self.words[b] = temp;
    }
    //basic arithmetic
    pub fn add_(self: *Stack, a: u256, b: u256) !void {
        return try self.push_(a + b);
    }
    pub fn sub_(self: *Stack, a: u256, b: u256) !void {
        return try self.push_(a - b);
    }
    pub fn mul_(self: *Stack, a: u256, b: u256) !void {
        return try self.push_(a * b);
    }
    pub fn div_(self: *Stack, a: u256, b: u256) !void {
        if (b == 0) {
            return try self.push_(0);
        }
        return try self.push_(a / b);
    }
    pub fn mod_(self: *Stack, a: u256, b: u256) !void {
        if (b == 0) {
            return try self.push_(0);
        }
        return try self.push_(a % b);
    }
    //comparison
    pub fn lt_(self: *Stack, a: u256, b: u256) !void {
        if (a < b) {
            try self.push_(1);
        } else {
            try self.push_(0);
        }
    }
    pub fn gt_(self: *Stack, a: u256, b: u256) !void {
        if (a > b) {
            try self.push_(1);
        } else {
            try self.push_(0);
        }
    }
    pub fn eq_(self: *Stack, a: u256, b: u256) !void {
        if (a == b) {
            try self.push_(1);
        } else {
            try self.push_(0);
        }
    }
    //bitwise operations
    pub fn and_(self: *Stack, a: u256, b: u256) !void {
        return try self.push_(a & b);
    }
    pub fn or_(self: *Stack, a: u256, b: u256) !void {
        return try self.push_(a | b);
    }
    pub fn xor_(self: *Stack, a: u256, b: u256) !void {
        return try self.push_(a ^ b);
    }
    pub fn not_(self: *Stack, a: u256) !void {
        return try self.push_(~a);
    }
};
