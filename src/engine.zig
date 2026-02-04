pub const EVM = struct {
    code: []const u8,
    stack: Stack,
    stack_height: usize,
    pc: usize,
    gas: u64,

    pub fn name() !void {}
};

const Stack: [1024]u256 = struct {
    // stack operations
    pub fn _push() !void {}
    pub fn _pop() !void {}
    pub fn _dup() !void {}
    pub fn _swap() !void {}
    //basic arithmetic
    pub fn _add() !void {}
    pub fn _sub() !void {}
    pub fn _mul() !void {}
    pub fn _div() !void {}
    //comparison
    pub fn _lt() !void {}
    pub fn _gt() !void {}
    pub fn _eq() !void {}
    //bitwise operations
    pub fn _and() !void {}
    pub fn _or() !void {}
    pub fn _xor() !void {}
    pub fn _not() !void {}
};
