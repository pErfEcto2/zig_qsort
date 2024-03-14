const std = @import("std");
const print = std.debug.print;
const rnd_gen = std.Random.DefaultPrng;

fn swap(a: *i32, b: *i32) void {
    const tmp: i32 = a.*;
    a.* = b.*;
    b.* = tmp;
}

fn qsort(arr: *[]i32, low: u32, high: u32) !void {
    if (low >= high) return;

    const mid: u32 = (high + low) / 2;
    var i = low;

    swap(&arr.*[mid], &arr.*[high]);

    for (low..high) |j| {
        if (arr.*[j] < arr.*[high]) {
            swap(&arr.*[i], &arr.*[j]);
            i += 1;
        }
    }

    swap(&arr.*[i], &arr.*[high]);

    try qsort(arr, low, i);
    try qsort(arr, i + 1, high);
}

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    var rand = rnd_gen.init(@as(u64, @intCast(std.time.microTimestamp())));
    var arr = std.ArrayList(i32).init(alloc);
    defer arr.deinit();

    for (0..30) |_| {
        try arr.append(@mod(rand.random().int(i32), 101));
    }

    print("before sorting\n{any}\n", .{arr.items});
    try qsort(&arr.items, 0, @as(u32, @intCast(arr.items.len - 1)));
    print("\nafter sorting\n{any}\n", .{arr.items});
}
