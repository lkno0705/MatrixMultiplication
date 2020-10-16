const std = @import("std");

const ArrayList = std.ArrayList;

fn random_matrix(allocator: *std.mem.Allocator, m: usize, n: usize) !ArrayList(f32) {
    var out = ArrayList(f32).init(allocator);

    var rand = std.rand.DefaultPrng.init(0);
    var i: usize = 0;
    while (i < m) : (i += 1) {
        var j: usize = 0;
        while (j < n) : (j+=1) {
            try out.append(rand.random.float(f32));
        }
    }

    return out;
}

fn empty_matrix(allocator: *std.mem.Allocator, m: usize, n: usize) !ArrayList(f32) {
    var out = ArrayList(f32).init(allocator);

    var rand = std.rand.DefaultPrng.init(0);
    var i: usize = 0;
    while (i < m) : (i += 1) {
        var j: usize = 0;
        while (j < n) : (j+=1) {
            try out.append(0.0);
        }
    }

    return out;
}

fn matmul(a: *ArrayList(f32), b: *ArrayList(f32), c: *ArrayList(f32), size: usize) void {
    const m = size;
    const n = m;
    const p = m;
    
    var i: usize = 0;
    while (i < m) : (i += 1) {
        var k: usize = 0;
        while (k < p) : (k += 1) {
            var j: usize = 0;
            var sum: f32 = 0.0;
            while (j < n) : (j += 1) {
                sum +=  a.items[i * n + j] * b.items[j * p + k];
            }
            c.items[i * p + k] = sum;
        }
    }
}

const ThreadParameters = struct {
    a: *ArrayList(f32),
    b: *ArrayList(f32),
    c: *ArrayList(f32),
    size: usize,
    from: usize,
    to: usize
};

fn par_matmul_inner(context: ThreadParameters) void {//(a: *ArrayList(f32), b: *ArrayList(f32), c: *ArrayList(f32), size: usize, from: usize, to: usize) void {
    const a = context.a;
    const b = context.b;
    const c = context.c;
    
    const m = context.size;
    const n = m;
    const p = m;
    
    var i: usize = context.from;
    while (i < context.to) : (i += 1) {
        var k: usize = 0;
        while (k < p) : (k += 1) {
            var j: usize = 0;
            var sum: f32 = 0.0;
            while (j < n) : (j += 1) {
                sum +=  a.items[i * n + j] * b.items[j * p + k];
            }
            c.items[i * p + k] = sum;
        }
    }
}

fn par_matmul(allocator: *std.mem.Allocator, a: *ArrayList(f32), b: *ArrayList(f32), c: *ArrayList(f32), size: usize) !void {
    const thread_count = try std.Thread.cpuCount();
    const step: usize = size / thread_count;

    var i: usize = 0;
    var threads = ArrayList(*std.Thread).init(allocator);
    while(i < thread_count) : (i += 1) {
        const from = i*step;
        var to = i*step + step;
        if (i == thread_count - 1) {
            to = size;
        }
        const params = ThreadParameters {
            .a = a,
            .b = b,
            .c = c,
            .size = size,
            .from = from,
            .to = to,
        };
        var thread = try std.Thread.spawn(params, par_matmul_inner);
        try threads.append(thread);
    }
    for (threads.items) |thread| {
        thread.wait();
    }
}

pub fn main() !void {
    const size = 1440;

    const m = size;
    const n = size;
    const p = size;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;
    const stdout = std.io.getStdOut().writer();

    var a = try random_matrix(allocator, m, n);
    var b = try random_matrix(allocator, n, p);
    var c = try empty_matrix(allocator, m, p);


    const before = std.time.milliTimestamp();
    matmul(&a, &b, &c, size);
    const after = std.time.milliTimestamp();
    try stdout.print("Single took {}ms\n", .{after - before});

    const before_par = std.time.milliTimestamp();
    try par_matmul(allocator, &a, &b, &c, size);
    const after_par = std.time.milliTimestamp();
    try stdout.print("Multi took {}ms\n", .{after_par - before_par});
}