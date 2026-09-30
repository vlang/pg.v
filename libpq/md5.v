@[translated]
module libpq

@[markused]
pub fn md5_calc(b64 &Uint8, ctx &Pg_md5_ctx) {
	a := ctx.md5_st.md5_state32[0]
	b := ctx.md5_st.md5_state32[1]
	c := ctx.md5_st.md5_state32[2]
	d := ctx.md5_st.md5_state32[3]
	x := &Uint32(voidptr(b64))
	for {
		a = a + ((b & c) | ((~b) & d)) + x[0] + libpq_md5_t[1]
		a = ((a << 7) | (a >> (32 - 7)))
		a = b + a
		break
	}
	for {
		d = d + ((a & b) | ((~a) & c)) + x[1] + libpq_md5_t[2]
		d = ((d << 12) | (d >> (32 - 12)))
		d = a + d
		break
	}
	for {
		c = c + ((d & a) | ((~d) & b)) + x[2] + libpq_md5_t[3]
		c = ((c << 17) | (c >> (32 - 17)))
		c = d + c
		break
	}
	for {
		b = b + ((c & d) | ((~c) & a)) + x[3] + libpq_md5_t[4]
		b = ((b << 22) | (b >> (32 - 22)))
		b = c + b
		break
	}
	for {
		a = a + ((b & c) | ((~b) & d)) + x[4] + libpq_md5_t[5]
		a = ((a << 7) | (a >> (32 - 7)))
		a = b + a
		break
	}
	for {
		d = d + ((a & b) | ((~a) & c)) + x[5] + libpq_md5_t[6]
		d = ((d << 12) | (d >> (32 - 12)))
		d = a + d
		break
	}
	for {
		c = c + ((d & a) | ((~d) & b)) + x[6] + libpq_md5_t[7]
		c = ((c << 17) | (c >> (32 - 17)))
		c = d + c
		break
	}
	for {
		b = b + ((c & d) | ((~c) & a)) + x[7] + libpq_md5_t[8]
		b = ((b << 22) | (b >> (32 - 22)))
		b = c + b
		break
	}
	for {
		a = a + ((b & c) | ((~b) & d)) + x[8] + libpq_md5_t[9]
		a = ((a << 7) | (a >> (32 - 7)))
		a = b + a
		break
	}
	for {
		d = d + ((a & b) | ((~a) & c)) + x[9] + libpq_md5_t[10]
		d = ((d << 12) | (d >> (32 - 12)))
		d = a + d
		break
	}
	for {
		c = c + ((d & a) | ((~d) & b)) + x[10] + libpq_md5_t[11]
		c = ((c << 17) | (c >> (32 - 17)))
		c = d + c
		break
	}
	for {
		b = b + ((c & d) | ((~c) & a)) + x[11] + libpq_md5_t[12]
		b = ((b << 22) | (b >> (32 - 22)))
		b = c + b
		break
	}
	for {
		a = a + ((b & c) | ((~b) & d)) + x[12] + libpq_md5_t[13]
		a = ((a << 7) | (a >> (32 - 7)))
		a = b + a
		break
	}
	for {
		d = d + ((a & b) | ((~a) & c)) + x[13] + libpq_md5_t[14]
		d = ((d << 12) | (d >> (32 - 12)))
		d = a + d
		break
	}
	for {
		c = c + ((d & a) | ((~d) & b)) + x[14] + libpq_md5_t[15]
		c = ((c << 17) | (c >> (32 - 17)))
		c = d + c
		break
	}
	for {
		b = b + ((c & d) | ((~c) & a)) + x[15] + libpq_md5_t[16]
		b = ((b << 22) | (b >> (32 - 22)))
		b = c + b
		break
	}
	for {
		a = a + ((b & d) | (c & (~d))) + x[1] + libpq_md5_t[17]
		a = ((a << 5) | (a >> (32 - 5)))
		a = b + a
		break
	}
	for {
		d = d + ((a & c) | (b & (~c))) + x[6] + libpq_md5_t[18]
		d = ((d << 9) | (d >> (32 - 9)))
		d = a + d
		break
	}
	for {
		c = c + ((d & b) | (a & (~b))) + x[11] + libpq_md5_t[19]
		c = ((c << 14) | (c >> (32 - 14)))
		c = d + c
		break
	}
	for {
		b = b + ((c & a) | (d & (~a))) + x[0] + libpq_md5_t[20]
		b = ((b << 20) | (b >> (32 - 20)))
		b = c + b
		break
	}
	for {
		a = a + ((b & d) | (c & (~d))) + x[5] + libpq_md5_t[21]
		a = ((a << 5) | (a >> (32 - 5)))
		a = b + a
		break
	}
	for {
		d = d + ((a & c) | (b & (~c))) + x[10] + libpq_md5_t[22]
		d = ((d << 9) | (d >> (32 - 9)))
		d = a + d
		break
	}
	for {
		c = c + ((d & b) | (a & (~b))) + x[15] + libpq_md5_t[23]
		c = ((c << 14) | (c >> (32 - 14)))
		c = d + c
		break
	}
	for {
		b = b + ((c & a) | (d & (~a))) + x[4] + libpq_md5_t[24]
		b = ((b << 20) | (b >> (32 - 20)))
		b = c + b
		break
	}
	for {
		a = a + ((b & d) | (c & (~d))) + x[9] + libpq_md5_t[25]
		a = ((a << 5) | (a >> (32 - 5)))
		a = b + a
		break
	}
	for {
		d = d + ((a & c) | (b & (~c))) + x[14] + libpq_md5_t[26]
		d = ((d << 9) | (d >> (32 - 9)))
		d = a + d
		break
	}
	for {
		c = c + ((d & b) | (a & (~b))) + x[3] + libpq_md5_t[27]
		c = ((c << 14) | (c >> (32 - 14)))
		c = d + c
		break
	}
	for {
		b = b + ((c & a) | (d & (~a))) + x[8] + libpq_md5_t[28]
		b = ((b << 20) | (b >> (32 - 20)))
		b = c + b
		break
	}
	for {
		a = a + ((b & d) | (c & (~d))) + x[13] + libpq_md5_t[29]
		a = ((a << 5) | (a >> (32 - 5)))
		a = b + a
		break
	}
	for {
		d = d + ((a & c) | (b & (~c))) + x[2] + libpq_md5_t[30]
		d = ((d << 9) | (d >> (32 - 9)))
		d = a + d
		break
	}
	for {
		c = c + ((d & b) | (a & (~b))) + x[7] + libpq_md5_t[31]
		c = ((c << 14) | (c >> (32 - 14)))
		c = d + c
		break
	}
	for {
		b = b + ((c & a) | (d & (~a))) + x[12] + libpq_md5_t[32]
		b = ((b << 20) | (b >> (32 - 20)))
		b = c + b
		break
	}
	for {
		a = a + (b ^ c ^ d) + x[5] + libpq_md5_t[33]
		a = ((a << 4) | (a >> (32 - 4)))
		a = b + a
		break
	}
	for {
		d = d + (a ^ b ^ c) + x[8] + libpq_md5_t[34]
		d = ((d << 11) | (d >> (32 - 11)))
		d = a + d
		break
	}
	for {
		c = c + (d ^ a ^ b) + x[11] + libpq_md5_t[35]
		c = ((c << 16) | (c >> (32 - 16)))
		c = d + c
		break
	}
	for {
		b = b + (c ^ d ^ a) + x[14] + libpq_md5_t[36]
		b = ((b << 23) | (b >> (32 - 23)))
		b = c + b
		break
	}
	for {
		a = a + (b ^ c ^ d) + x[1] + libpq_md5_t[37]
		a = ((a << 4) | (a >> (32 - 4)))
		a = b + a
		break
	}
	for {
		d = d + (a ^ b ^ c) + x[4] + libpq_md5_t[38]
		d = ((d << 11) | (d >> (32 - 11)))
		d = a + d
		break
	}
	for {
		c = c + (d ^ a ^ b) + x[7] + libpq_md5_t[39]
		c = ((c << 16) | (c >> (32 - 16)))
		c = d + c
		break
	}
	for {
		b = b + (c ^ d ^ a) + x[10] + libpq_md5_t[40]
		b = ((b << 23) | (b >> (32 - 23)))
		b = c + b
		break
	}
	for {
		a = a + (b ^ c ^ d) + x[13] + libpq_md5_t[41]
		a = ((a << 4) | (a >> (32 - 4)))
		a = b + a
		break
	}
	for {
		d = d + (a ^ b ^ c) + x[0] + libpq_md5_t[42]
		d = ((d << 11) | (d >> (32 - 11)))
		d = a + d
		break
	}
	for {
		c = c + (d ^ a ^ b) + x[3] + libpq_md5_t[43]
		c = ((c << 16) | (c >> (32 - 16)))
		c = d + c
		break
	}
	for {
		b = b + (c ^ d ^ a) + x[6] + libpq_md5_t[44]
		b = ((b << 23) | (b >> (32 - 23)))
		b = c + b
		break
	}
	for {
		a = a + (b ^ c ^ d) + x[9] + libpq_md5_t[45]
		a = ((a << 4) | (a >> (32 - 4)))
		a = b + a
		break
	}
	for {
		d = d + (a ^ b ^ c) + x[12] + libpq_md5_t[46]
		d = ((d << 11) | (d >> (32 - 11)))
		d = a + d
		break
	}
	for {
		c = c + (d ^ a ^ b) + x[15] + libpq_md5_t[47]
		c = ((c << 16) | (c >> (32 - 16)))
		c = d + c
		break
	}
	for {
		b = b + (c ^ d ^ a) + x[2] + libpq_md5_t[48]
		b = ((b << 23) | (b >> (32 - 23)))
		b = c + b
		break
	}
	for {
		a = a + (c ^ (b | (~d))) + x[0] + libpq_md5_t[49]
		a = ((a << 6) | (a >> (32 - 6)))
		a = b + a
		break
	}
	for {
		d = d + (b ^ (a | (~c))) + x[7] + libpq_md5_t[50]
		d = ((d << 10) | (d >> (32 - 10)))
		d = a + d
		break
	}
	for {
		c = c + (a ^ (d | (~b))) + x[14] + libpq_md5_t[51]
		c = ((c << 15) | (c >> (32 - 15)))
		c = d + c
		break
	}
	for {
		b = b + (d ^ (c | (~a))) + x[5] + libpq_md5_t[52]
		b = ((b << 21) | (b >> (32 - 21)))
		b = c + b
		break
	}
	for {
		a = a + (c ^ (b | (~d))) + x[12] + libpq_md5_t[53]
		a = ((a << 6) | (a >> (32 - 6)))
		a = b + a
		break
	}
	for {
		d = d + (b ^ (a | (~c))) + x[3] + libpq_md5_t[54]
		d = ((d << 10) | (d >> (32 - 10)))
		d = a + d
		break
	}
	for {
		c = c + (a ^ (d | (~b))) + x[10] + libpq_md5_t[55]
		c = ((c << 15) | (c >> (32 - 15)))
		c = d + c
		break
	}
	for {
		b = b + (d ^ (c | (~a))) + x[1] + libpq_md5_t[56]
		b = ((b << 21) | (b >> (32 - 21)))
		b = c + b
		break
	}
	for {
		a = a + (c ^ (b | (~d))) + x[8] + libpq_md5_t[57]
		a = ((a << 6) | (a >> (32 - 6)))
		a = b + a
		break
	}
	for {
		d = d + (b ^ (a | (~c))) + x[15] + libpq_md5_t[58]
		d = ((d << 10) | (d >> (32 - 10)))
		d = a + d
		break
	}
	for {
		c = c + (a ^ (d | (~b))) + x[6] + libpq_md5_t[59]
		c = ((c << 15) | (c >> (32 - 15)))
		c = d + c
		break
	}
	for {
		b = b + (d ^ (c | (~a))) + x[13] + libpq_md5_t[60]
		b = ((b << 21) | (b >> (32 - 21)))
		b = c + b
		break
	}
	for {
		a = a + (c ^ (b | (~d))) + x[4] + libpq_md5_t[61]
		a = ((a << 6) | (a >> (32 - 6)))
		a = b + a
		break
	}
	for {
		d = d + (b ^ (a | (~c))) + x[11] + libpq_md5_t[62]
		d = ((d << 10) | (d >> (32 - 10)))
		d = a + d
		break
	}
	for {
		c = c + (a ^ (d | (~b))) + x[2] + libpq_md5_t[63]
		c = ((c << 15) | (c >> (32 - 15)))
		c = d + c
		break
	}
	for {
		b = b + (d ^ (c | (~a))) + x[9] + libpq_md5_t[64]
		b = ((b << 21) | (b >> (32 - 21)))
		b = c + b
		break
	}
	ctx.md5_st.md5_state32[0] += a
	ctx.md5_st.md5_state32[1] += b
	ctx.md5_st.md5_state32[2] += c
	ctx.md5_st.md5_state32[3] += d
}

@[markused]
pub fn md5_pad(ctx &Pg_md5_ctx) {
	gap := u32(0)
	gap = u32(64) - ctx.md5_i
	if gap > u32(8) {
		C.c2v_memmove(voidptr(unsafe { &ctx.md5_buf[0] } + ctx.md5_i), voidptr(unsafe { &libpq_md5_md5_paddat[0] }), u64(gap) - sizeof(Uint64))
	} else {
		C.c2v_memmove(voidptr(unsafe { &ctx.md5_buf[0] } + ctx.md5_i), voidptr(unsafe { &libpq_md5_md5_paddat[0] }), u64(gap))
		md5_calc(unsafe { &ctx.md5_buf[0] }, ctx)
		C.c2v_memmove(ctx.md5_buf, voidptr(unsafe { &libpq_md5_md5_paddat[0] } + gap), u64(64) - sizeof(Uint64))
	}
	C.c2v_memmove(voidptr(unsafe { &ctx.md5_buf[0] + 56 }), voidptr(unsafe { &ctx.md5_count.md5_count8[0] + 0 }), u64(8))
	md5_calc(unsafe { &ctx.md5_buf[0] }, ctx)
}

@[markused]
pub fn md5_result(digest &Uint8, ctx &Pg_md5_ctx) {
	C.c2v_memmove(voidptr(digest), voidptr(unsafe { &ctx.md5_st.md5_state8[0] + 0 }), u64(16))
}

@[export: 'pg_md5_init']
@[markused]
pub fn pg_md5_init(ctx &Pg_md5_ctx) {
	ctx.md5_count.md5_count64 = Uint64(0)
	ctx.md5_i = u32(0)
	ctx.md5_st.md5_state32[0] = Uint32(1732584193)
	ctx.md5_st.md5_state32[1] = u32(4023233417)
	ctx.md5_st.md5_state32[2] = u32(2562383102)
	ctx.md5_st.md5_state32[3] = Uint32(271733878)
	C.c2v_memset(ctx.md5_buf, 0, sizeof([64]Uint8))
}

@[export: 'pg_md5_update']
@[markused]
pub fn pg_md5_update(ctx &Pg_md5_ctx, data &Uint8, len usize) {
	gap := u32(0)
	i := u32(0)

	ctx.md5_count.md5_count64 += Uint64(len * usize(8))
	gap = u32(64) - ctx.md5_i
	if len >= usize(gap) {
		C.c2v_memmove(voidptr(unsafe { &ctx.md5_buf[0] } + ctx.md5_i), voidptr(data), u64(gap))
		md5_calc(unsafe { &ctx.md5_buf[0] }, ctx)
		for i = gap; usize(i + u32(64)) <= len; i += u32(64) {
			md5_calc(data + i, ctx)
		}
		ctx.md5_i = u32(len - usize(i))
		C.c2v_memmove(ctx.md5_buf, voidptr(data + i), u64(ctx.md5_i))
	} else {
		C.c2v_memmove(voidptr(unsafe { &ctx.md5_buf[0] } + ctx.md5_i), voidptr(data), len)
		ctx.md5_i += len
	}
}

@[export: 'pg_md5_final']
@[markused]
pub fn pg_md5_final(ctx &Pg_md5_ctx, dest &Uint8) {
	md5_pad(ctx)
	md5_result(dest, ctx)
}
