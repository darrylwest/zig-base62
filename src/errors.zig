const std = @import("std");

pub const Base62Error = error{
    InvalidCharacter,
    InvalidAlphabet,
    Overflow,
    OutOfMemory,
};