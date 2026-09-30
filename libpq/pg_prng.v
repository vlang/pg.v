@[translated]
module libpq

@[markused]
pub fn libpq_pg_prng_pg_leftmost_one_pos32(word Uint32) int {
	return 31 - C.c2v___builtin_clz(word)
}

@[markused]
pub fn libpq_pg_prng_pg_leftmost_one_pos64(word Uint64) int {
	return 63 - C.c2v___builtin_clzl(u64(word))
}

@[markused]
pub fn libpq_pg_prng_pg_rightmost_one_pos32(word Uint32) int {
	return C.c2v___builtin_ctz(word)
}

@[markused]
pub fn libpq_pg_prng_pg_rightmost_one_pos64(word Uint64) int {
	return C.c2v___builtin_ctzl(u64(word))
}

@[markused]
pub fn libpq_pg_prng_pg_nextpower2_32(num Uint32) Uint32 {
	if (num & (num - Uint32(1))) == Uint32(0) {
		return num
	}
	return (Uint32(1)) << (libpq_pg_prng_pg_leftmost_one_pos32(num) + 1)
}

@[markused]
pub fn libpq_pg_prng_pg_nextpower2_64(num Uint64) Uint64 {
	if (num & (num - Uint64(1))) == Uint64(0) {
		return num
	}
	return (Uint64(1)) << (libpq_pg_prng_pg_leftmost_one_pos64(num) + 1)
}

@[markused]
pub fn libpq_pg_prng_pg_prevpower2_32(num Uint32) Uint32 {
	return (Uint32(1)) << libpq_pg_prng_pg_leftmost_one_pos32(num)
}

@[markused]
pub fn libpq_pg_prng_pg_prevpower2_64(num Uint64) Uint64 {
	return (Uint64(1)) << libpq_pg_prng_pg_leftmost_one_pos64(num)
}

@[markused]
pub fn libpq_pg_prng_pg_ceil_log2_32(num Uint32) Uint32 {
	if num < Uint32(2) {
		return Uint32(0)
	} else {
		return Uint32(libpq_pg_prng_pg_leftmost_one_pos32(num - Uint32(1)) + 1)
	}
}

@[markused]
pub fn libpq_pg_prng_pg_ceil_log2_64(num Uint64) Uint64 {
	if num < Uint64(2) {
		return Uint64(0)
	} else {
		return Uint64(libpq_pg_prng_pg_leftmost_one_pos64(num - Uint64(1)) + 1)
	}
}

@[markused]
pub fn libpq_pg_prng_pg_popcount(buf &i8, bytes int) Uint64 {
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
pub fn libpq_pg_prng_pg_popcount_masked(buf &i8, bytes int, mask Bits8) Uint64 {
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
pub fn libpq_pg_prng_pg_rotate_right32(word Uint32, n int) Uint32 {
	return (word >> n) | (word << (32 - n))
}

@[markused]
pub fn libpq_pg_prng_pg_rotate_left32(word Uint32, n int) Uint32 {
	return (word << n) | (word >> (32 - n))
}

@[markused]
pub fn rotl(x Uint64, bits int) Uint64 {
	return (x << bits) | (x >> (64 - bits))
}

@[markused]
pub fn xoroshiro128ss(state &Pg_prng_state) Uint64 {
	s0 := state.s0
	sx := state.s1 ^ s0
	val := rotl(s0 * Uint64(5), 7) * Uint64(9)

	state.s0 = rotl(s0, 24) ^ sx ^ (sx << 16)
	state.s1 = rotl(sx, 37)
	return val
}

@[markused]
pub fn splitmix64(state &Uint64) Uint64 {
	val := c2v_assign[u64](state, u64((unsafe { *state }) + (u64(11400714819323198485))))
	val = (val ^ (val >> 30)) * u64(13787848793156543929)
	val = (val ^ (val >> 27)) * u64(10723151780598845931)
	return val ^ (val >> 31)
}

@[export: 'pg_prng_seed']
@[markused]
pub fn pg_prng_seed(state &Pg_prng_state, seed Uint64) {
	state.s0 = splitmix64(&seed)
	state.s1 = splitmix64(&seed)
	pg_prng_seed_check(state)
}

@[export: 'pg_prng_fseed']
@[markused]
pub fn pg_prng_fseed(state &Pg_prng_state, fseed f64) {
	seed := Int64((f64(((1 << 52) - u64(1)))) * fseed)
	pg_prng_seed(state, Uint64(seed))
}

@[export: 'pg_prng_seed_check']
@[markused]
pub fn pg_prng_seed_check(state &Pg_prng_state) bool {
	if (i64((state.s0 == Uint64(0) && state.s1 == Uint64(0)) != 0)) {
		state.s0 = u64(6364136223846793005)
		state.s1 = u64(1442695040888963407)
	}
	return true != 0
}

@[export: 'pg_prng_uint64']
@[markused]
pub fn pg_prng_uint64(state &Pg_prng_state) Uint64 {
	return xoroshiro128ss(state)
}

@[export: 'pg_prng_uint64_range']
@[markused]
pub fn pg_prng_uint64_range(state &Pg_prng_state, rmin Uint64, rmax Uint64) Uint64 {
	val := Uint64(0)
	if (i64((rmax > rmin) != 0)) {
		range := rmax - rmin
		rshift := Uint32(63 - libpq_pg_prng_pg_leftmost_one_pos64(range))
		for {
			val = xoroshiro128ss(state) >> u32(rshift)
			if !(val > range) {
				break
			}
		}
	} else {
		val = Uint64(0)
	}
	return rmin + val
}

@[export: 'pg_prng_int64']
@[markused]
pub fn pg_prng_int64(state &Pg_prng_state) Int64 {
	return Int64(xoroshiro128ss(state))
}

@[export: 'pg_prng_int64p']
@[markused]
pub fn pg_prng_int64p(state &Pg_prng_state) Int64 {
	return Int64((xoroshiro128ss(state) & u64(9223372036854775807)))
}

@[export: 'pg_prng_int64_range']
@[markused]
pub fn pg_prng_int64_range(state &Pg_prng_state, rmin Int64, rmax Int64) Int64 {
	val := Int64(0)
	if (i64((rmax > rmin) != 0)) {
		uval := Uint64(0)
		uval = Uint64(rmin) + pg_prng_uint64_range(state, Uint64(0), Uint64(rmax) - Uint64(rmin))
		if uval > Uint64(9223372036854775807) {
			val = Int64((uval - Uint64((-9223372036854775807 - i64(1))))) + (-9223372036854775807 - i64(1))
		} else {
			val = Int64(uval)
		}
	} else {
		val = rmin
	}
	return val
}

@[export: 'pg_prng_uint32']
@[markused]
pub fn pg_prng_uint32(state &Pg_prng_state) Uint32 {
	v := xoroshiro128ss(state)
	return Uint32((v >> 32))
}

@[export: 'pg_prng_int32']
@[markused]
pub fn pg_prng_int32(state &Pg_prng_state) Int32 {
	v := xoroshiro128ss(state)
	return Int32((v >> 32))
}

@[export: 'pg_prng_int32p']
@[markused]
pub fn pg_prng_int32p(state &Pg_prng_state) Int32 {
	v := xoroshiro128ss(state)
	return Int32((v >> 33))
}

@[export: 'pg_prng_double']
@[markused]
pub fn pg_prng_double(state &Pg_prng_state) f64 {
	v := xoroshiro128ss(state)
	return C.c2v_ldexp(f64((v >> (64 - 52))), -52)
}

@[export: 'pg_prng_double_normal']
@[markused]
pub fn pg_prng_double_normal(state &Pg_prng_state) f64 {
	u1 := 0.0
	u2 := 0.0
	z0 := 0.0

	u1 = 1.0 - pg_prng_double(state)
	u2 = 1.0 - pg_prng_double(state)
	z0 = C.c2v_sqrt(-2.0 * C.c2v_log(u1)) * C.c2v_sin(2.0 * 3.1415926535897931 * u2)
	return z0
}

@[export: 'pg_prng_bool']
@[markused]
pub fn pg_prng_bool(state &Pg_prng_state) bool {
	v := xoroshiro128ss(state)
	return bool((v >> 63))
}
