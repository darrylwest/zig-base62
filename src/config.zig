const std = @import("std");
const errors = @import("errors.zig");

pub const DEFAULT_ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

pub const Base62Config = struct {
    alphabet: []const u8 = DEFAULT_ALPHABET,
    lookup_table: [256]?u8 = undefined,

    pub fn init(alphabet: []const u8) errors.Base62Error!Base62Config {
        var config = Base62Config{ .alphabet = alphabet };
        try config.validate();
        config.buildLookupTable();
        return config;
    }

    pub fn default() Base62Config {
        var config = Base62Config{};
        config.buildLookupTable();
        return config;
    }

    pub fn validate(self: Base62Config) errors.Base62Error!void {
        if (self.alphabet.len != 62) {
            return errors.Base62Error.InvalidAlphabet;
        }

        // Check for duplicate characters
        var seen = [_]bool{false} ** 256;
        for (self.alphabet) |char| {
            if (seen[char]) {
                return errors.Base62Error.InvalidAlphabet;
            }
            seen[char] = true;
        }
    }

    fn buildLookupTable(self: *Base62Config) void {
        // Initialize all entries to null (invalid)
        for (&self.lookup_table) |*entry| {
            entry.* = null;
        }

        // Map each character to its index
        for (self.alphabet, 0..) |char, index| {
            self.lookup_table[char] = @intCast(index);
        }
    }

    pub fn charToValue(self: Base62Config, char: u8) errors.Base62Error!u8 {
        return self.lookup_table[char] orelse errors.Base62Error.InvalidCharacter;
    }

    pub fn valueToChar(self: Base62Config, value: u8) u8 {
        return self.alphabet[value];
    }
};