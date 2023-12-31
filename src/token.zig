const std = @import("std");
const assert = std.debug.assert;

const Location = @import("common.zig").Location;

pub const TokenType = union(enum) {
    //tokens with data
    Identifier: []const u8,
    String: []const u8,
    Integer: i64,
    Float: f64,

    //keywords
    KEYWORD_COUNT_BEGIN, // used to assert that the keywords map is exhaustive
    Fn,
    Record,
    True,
    False,
    If,
    Else,
    For,
    While,
    KEYWORD_COUNT_END, // used to assert that the keywords map is exhaustive

    // Binary operators
    Plus,
    Dash,
    SlashForward,
    Asterisk,
    DoubleEqual,
    LessThan,
    LessThanEqual,
    GreaterThan,
    GreaterThanEqual,
    NotEqual,
    Equal,

    //unary operators
    Hat,
    ExclamationMark,
    Ampersand,

    //punctuation
    Dot,
    Comma,
    Semicolon,
    Colon,
    Lparen,
    Rparen,
    Lbrace,
    Rbrace,
    Lbracket,
    Rbracket,

    //misc / control
    EOF,

    pub const Keywords = std.ComptimeStringMap(TokenType, .{
        .{ "fn", .Fn },
        .{ "record", .Record },
        .{ "false", .False },
        .{ "true", .True },
        .{ "if", .If },
        .{ "else", .Else },
        .{ "for", .For },
        .{ "while", .While },
    });

    pub const Repr = std.ComptimeStringMap([]const u8, .{
        .{ @tagName(TokenType.Fn), "fn" },
        .{ @tagName(TokenType.Record), "record" },
        .{ @tagName(TokenType.True), "true" },
        .{ @tagName(TokenType.False), "false" },
        .{ @tagName(TokenType.If), "if" },
        .{ @tagName(TokenType.Else), "else" },
        .{ @tagName(TokenType.For), "for" },
        .{ @tagName(TokenType.While), "while" },
        .{ @tagName(TokenType.Plus), "+" },
        .{ @tagName(TokenType.Dash), "-" },
        .{ @tagName(TokenType.SlashForward), "/" },
        .{ @tagName(TokenType.Asterisk), "*" },
        .{ @tagName(TokenType.DoubleEqual), "==" },
        .{ @tagName(TokenType.LessThan), "<" },
        .{ @tagName(TokenType.LessThanEqual), "<=" },
        .{ @tagName(TokenType.GreaterThan), ">" },
        .{ @tagName(TokenType.GreaterThanEqual), ">=" },
        .{ @tagName(TokenType.NotEqual), "!=" },
        .{ @tagName(TokenType.Hat), "^" },
        .{ @tagName(TokenType.ExclamationMark), "!" },
        .{ @tagName(TokenType.Ampersand), "&" },
        .{ @tagName(TokenType.Dot), "." },
        .{ @tagName(TokenType.Comma), "," },
        .{ @tagName(TokenType.Semicolon), ";" },
        .{ @tagName(TokenType.Colon), ":" },
        .{ @tagName(TokenType.Lparen), "(" },
        .{ @tagName(TokenType.Rparen), ")" },
        .{ @tagName(TokenType.Lbrace), "{" },
        .{ @tagName(TokenType.Rbrace), "}" },
        .{ @tagName(TokenType.Lbracket), "[" },
        .{ @tagName(TokenType.Rbracket), "]" },
        .{ @tagName(TokenType.EOF), "End of File" },
        .{ @tagName(TokenType.Equal), "=" },
    });
};

pub const Token = struct {
    loc: Location,
    tag: TokenType,
    tagRepr: ?[]const u8, //for tokens with no data payload (most of them)

    pub fn format(self: Token, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = fmt;
        _ = options;

        if (self.tagRepr) |repr| {
            try writer.print("{s}", .{repr});
        } else {
            try writer.print("{s} ", .{@tagName(self.tag)});
            _ = switch (self.tag) {
                .Identifier, .String => |val| try writer.print("'{s}'", .{val}),
                .Integer => |val| try writer.print("'{d}'", .{val}),
                .Float => |val| try writer.print("'{d}'", .{val}),
                else => null,
            };
        }

        try writer.print(" {s}", .{self.loc});
    }
};

//assert keyword map is exhaustive
comptime {
    const keyword_begin = @intFromEnum(TokenType.KEYWORD_COUNT_BEGIN);
    const keyword_end = @intFromEnum(TokenType.KEYWORD_COUNT_END);
    assert((keyword_end - keyword_begin) - 1 == TokenType.Keywords.kvs.len);
}
