const std = @import("std");

const Token = @import("token.zig").Token;
const TokenType = @import("token.zig").TokenType;

pub const Expression = union(enum) {
    BinaryExprNode: *BinaryExpression,
    UnaryExprNode: *UnaryExpression,
    LiteralInt: Token,
    LiteralFloat: Token,
    LiteralBool: Token,
    LiteralString: Token,
    IdentifierUsage: Token,
    FuncCall: Token,

    pub fn format(self: Expression, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        switch (self) {
            .LiteralBool, .LiteralFloat, .LiteralString, .LiteralInt, .IdentifierUsage => |tk| try writer.print("{s}", .{tk}),
            .BinaryExprNode => |expr| {
                try writer.print("\n-----------------\n", .{});
                try expr.lhs.format(fmt, options, writer);
                try writer.print("\n {s} \n", .{expr.op.tagRepr.?});
                try expr.rhs.format(fmt, options, writer);
                try writer.print("\n-----------------\n", .{});
            },
            .UnaryExprNode => |expr| {
                try writer.print("{s}\n", .{expr.op.tagRepr.?});
                try expr.expr.format(fmt, options, writer);
            },
            else => @panic("Not Implemeneted"),
        }
    }
};

pub const BinaryExpression = struct {
    lhs: Expression,
    rhs: Expression,
    op: Token,
};

pub const UnaryExpression = struct {
    op: Token,
    expr: Expression,
};