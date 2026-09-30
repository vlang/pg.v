@[translated]
module libpq

@[c: '__builtin_clz']
fn C.c2v___builtin_clz(u32) int

@[c: '__builtin_clzl']
fn C.c2v___builtin_clzl(u64) int

@[c: '__builtin_ctz']
fn C.c2v___builtin_ctz(u32) int

@[c: '__builtin_ctzl']
fn C.c2v___builtin_ctzl(u64) int

@[c: '__builtin_popcount']
fn C.c2v___builtin_popcount(u32) int

@[c: '__builtin_popcountl']
fn C.c2v___builtin_popcountl(u64) int

@[markused]
pub fn pg_leftmost_one_pos32(word Uint32) int {
	return 31 - C.c2v___builtin_clz(word)
}

@[markused]
pub fn pg_leftmost_one_pos64(word Uint64) int {
	return 63 - C.c2v___builtin_clzl(u64(word))
}

@[markused]
pub fn pg_rightmost_one_pos32(word Uint32) int {
	return C.c2v___builtin_ctz(word)
}

@[markused]
pub fn pg_rightmost_one_pos64(word Uint64) int {
	return C.c2v___builtin_ctzl(u64(word))
}

@[markused]
pub fn pg_nextpower2_32(num Uint32) Uint32 {
	if (num & (num - Uint32(1))) == Uint32(0) {
		return num
	}
	return (Uint32(1)) << (pg_leftmost_one_pos32(num) + 1)
}

@[markused]
pub fn pg_nextpower2_64(num Uint64) Uint64 {
	if (num & (num - Uint64(1))) == Uint64(0) {
		return num
	}
	return (Uint64(1)) << (pg_leftmost_one_pos64(num) + 1)
}

@[markused]
pub fn pg_prevpower2_32(num Uint32) Uint32 {
	return (Uint32(1)) << pg_leftmost_one_pos32(num)
}

@[markused]
pub fn pg_prevpower2_64(num Uint64) Uint64 {
	return (Uint64(1)) << pg_leftmost_one_pos64(num)
}

@[markused]
pub fn pg_ceil_log2_32(num Uint32) Uint32 {
	if num < Uint32(2) {
		return Uint32(0)
	} else {
		return Uint32(pg_leftmost_one_pos32(num - Uint32(1)) + 1)
	}
}

@[markused]
pub fn pg_ceil_log2_64(num Uint64) Uint64 {
	if num < Uint64(2) {
		return Uint64(0)
	} else {
		return Uint64(pg_leftmost_one_pos64(num - Uint64(1)) + 1)
	}
}

@[markused]
pub fn pg_popcount(buf &i8, bytes int) Uint64 {
	threshold := 8
	if bytes < threshold {
		popcnt := Uint64(0)
		for bytes-- {
			popcnt += Uint64(pg_number_of_ones[u8((unsafe { *c2v_pointer_postfix(voidptr(&buf), buf, isize(1)) }))])
		}
		return popcnt
	}
	return pg_popcount_optimized(buf, bytes)
}

@[markused]
pub fn pg_popcount_masked(buf &i8, bytes int, mask Bits8) Uint64 {
	threshold := 8
	if bytes < threshold {
		popcnt := Uint64(0)
		for bytes-- {
			popcnt += Uint64(pg_number_of_ones[int(u8((unsafe { *c2v_pointer_postfix(voidptr(&buf), buf, isize(1)) }))) & int(mask)])
		}
		return popcnt
	}
	return pg_popcount_masked_optimized(buf, bytes, mask)
}

@[markused]
pub fn pg_rotate_right32(word Uint32, n int) Uint32 {
	return (word >> n) | (word << (32 - n))
}

@[markused]
pub fn pg_rotate_left32(word Uint32, n int) Uint32 {
	return (word << n) | (word >> (32 - n))
}

@[markused]
pub fn pg_popcount32_slow(word Uint32) int {
	return C.c2v___builtin_popcount(word)
}

@[markused]
pub fn pg_popcount64_slow(word Uint64) int {
	return C.c2v___builtin_popcountl(u64(word))
}

@[markused]
pub fn pg_popcount_slow(buf &i8, bytes int) Uint64 {
	popcnt := Uint64(0)
	if usize(buf) == usize(&i8(((usize(voidptr(buf)) + usize((8 - 1))) & ~(usize((8 - 1)))))) {
		words := &Uint64(voidptr(buf))
		for bytes >= 8 {
			popcnt += Uint64(pg_popcount64_slow((unsafe { *c2v_pointer_postfix(voidptr(&words), words, isize(1)) })))
			bytes -= 8
		}
		buf = &i8(voidptr(words))
	}
	for bytes-- {
		popcnt += Uint64(pg_number_of_ones[u8((unsafe { *c2v_pointer_postfix(voidptr(&buf), buf, isize(1)) }))])
	}
	return popcnt
}

@[markused]
pub fn pg_popcount_masked_slow(buf &i8, bytes int, mask Bits8) Uint64 {
	popcnt := Uint64(0)
	maskv := ~0 / u64(255) * u64(mask)
	if usize(buf) == usize(&i8(((usize(voidptr(buf)) + usize((8 - 1))) & ~(usize((8 - 1)))))) {
		words := &Uint64(voidptr(buf))
		for bytes >= 8 {
			popcnt += Uint64(pg_popcount64_slow((unsafe { *c2v_pointer_postfix(voidptr(&words), words, isize(1)) }) & maskv))
			bytes -= 8
		}
		buf = &i8(voidptr(words))
	}
	for bytes-- {
		popcnt += Uint64(pg_number_of_ones[int(u8((unsafe { *c2v_pointer_postfix(voidptr(&buf), buf, isize(1)) }))) & int(mask)])
	}
	return popcnt
}

@[export: 'pg_popcount32']
@[markused]
pub fn pg_popcount32(word Uint32) int {
	return pg_popcount32_slow(word)
}

@[export: 'pg_popcount64']
@[markused]
pub fn pg_popcount64(word Uint64) int {
	return pg_popcount64_slow(word)
}

@[export: 'pg_popcount_optimized']
@[markused]
pub fn pg_popcount_optimized(buf &i8, bytes int) Uint64 {
	return pg_popcount_slow(buf, bytes)
}

@[export: 'pg_popcount_masked_optimized']
@[markused]
pub fn pg_popcount_masked_optimized(buf &i8, bytes int, mask Bits8) Uint64 {
	return pg_popcount_masked_slow(buf, bytes, mask)
}
