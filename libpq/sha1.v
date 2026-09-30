@[translated]
module libpq

@[markused]
pub fn sha1_step(ctx &Pg_sha1_ctx) {
	a := Uint32(0)
	b := Uint32(0)
	c := Uint32(0)
	d := Uint32(0)
	e := Uint32(0)

	t := usize(0)
	s := usize(0)

	tmp := Uint32(0)
	tctx := Pg_sha1_ctx{}
	C.c2v_memmove(voidptr(unsafe { &tctx.m.b8[0] + 0 }), voidptr(unsafe { &ctx.m.b8[0] + 0 }), u64(64))
	ctx.m.b8[0] = tctx.m.b8[3]
	ctx.m.b8[1] = tctx.m.b8[2]
	ctx.m.b8[2] = tctx.m.b8[1]
	ctx.m.b8[3] = tctx.m.b8[0]
	ctx.m.b8[4] = tctx.m.b8[7]
	ctx.m.b8[5] = tctx.m.b8[6]
	ctx.m.b8[6] = tctx.m.b8[5]
	ctx.m.b8[7] = tctx.m.b8[4]
	ctx.m.b8[8] = tctx.m.b8[11]
	ctx.m.b8[9] = tctx.m.b8[10]
	ctx.m.b8[10] = tctx.m.b8[9]
	ctx.m.b8[11] = tctx.m.b8[8]
	ctx.m.b8[12] = tctx.m.b8[15]
	ctx.m.b8[13] = tctx.m.b8[14]
	ctx.m.b8[14] = tctx.m.b8[13]
	ctx.m.b8[15] = tctx.m.b8[12]
	ctx.m.b8[16] = tctx.m.b8[19]
	ctx.m.b8[17] = tctx.m.b8[18]
	ctx.m.b8[18] = tctx.m.b8[17]
	ctx.m.b8[19] = tctx.m.b8[16]
	ctx.m.b8[20] = tctx.m.b8[23]
	ctx.m.b8[21] = tctx.m.b8[22]
	ctx.m.b8[22] = tctx.m.b8[21]
	ctx.m.b8[23] = tctx.m.b8[20]
	ctx.m.b8[24] = tctx.m.b8[27]
	ctx.m.b8[25] = tctx.m.b8[26]
	ctx.m.b8[26] = tctx.m.b8[25]
	ctx.m.b8[27] = tctx.m.b8[24]
	ctx.m.b8[28] = tctx.m.b8[31]
	ctx.m.b8[29] = tctx.m.b8[30]
	ctx.m.b8[30] = tctx.m.b8[29]
	ctx.m.b8[31] = tctx.m.b8[28]
	ctx.m.b8[32] = tctx.m.b8[35]
	ctx.m.b8[33] = tctx.m.b8[34]
	ctx.m.b8[34] = tctx.m.b8[33]
	ctx.m.b8[35] = tctx.m.b8[32]
	ctx.m.b8[36] = tctx.m.b8[39]
	ctx.m.b8[37] = tctx.m.b8[38]
	ctx.m.b8[38] = tctx.m.b8[37]
	ctx.m.b8[39] = tctx.m.b8[36]
	ctx.m.b8[40] = tctx.m.b8[43]
	ctx.m.b8[41] = tctx.m.b8[42]
	ctx.m.b8[42] = tctx.m.b8[41]
	ctx.m.b8[43] = tctx.m.b8[40]
	ctx.m.b8[44] = tctx.m.b8[47]
	ctx.m.b8[45] = tctx.m.b8[46]
	ctx.m.b8[46] = tctx.m.b8[45]
	ctx.m.b8[47] = tctx.m.b8[44]
	ctx.m.b8[48] = tctx.m.b8[51]
	ctx.m.b8[49] = tctx.m.b8[50]
	ctx.m.b8[50] = tctx.m.b8[49]
	ctx.m.b8[51] = tctx.m.b8[48]
	ctx.m.b8[52] = tctx.m.b8[55]
	ctx.m.b8[53] = tctx.m.b8[54]
	ctx.m.b8[54] = tctx.m.b8[53]
	ctx.m.b8[55] = tctx.m.b8[52]
	ctx.m.b8[56] = tctx.m.b8[59]
	ctx.m.b8[57] = tctx.m.b8[58]
	ctx.m.b8[58] = tctx.m.b8[57]
	ctx.m.b8[59] = tctx.m.b8[56]
	ctx.m.b8[60] = tctx.m.b8[63]
	ctx.m.b8[61] = tctx.m.b8[62]
	ctx.m.b8[62] = tctx.m.b8[61]
	ctx.m.b8[63] = tctx.m.b8[60]
	a = ctx.h.b32[0]
	b = ctx.h.b32[1]
	c = ctx.h.b32[2]
	d = ctx.h.b32[3]
	e = ctx.h.b32[4]
	for t = usize(0); t < usize(20); t++ {
		s = t & usize(15)
		if t >= usize(16) {
			ctx.m.b32[s] = (((ctx.m.b32[((s + usize(13)) & usize(15))] ^ ctx.m.b32[((s + usize(8)) & usize(15))] ^ ctx.m.b32[((s + usize(2)) & usize(15))] ^ ctx.m.b32[s]) << 1) | ((ctx.m.b32[((s + usize(13)) & usize(15))] ^ ctx.m.b32[((s + usize(8)) & usize(15))] ^ ctx.m.b32[((s + usize(2)) & usize(15))] ^ ctx.m.b32[s]) >> (32 - 1)))
		}
		tmp = ((a << 5) | (a >> (32 - 5))) + ((b & c) | ((~b) & d)) + e + ctx.m.b32[s] + libpq_sha1__k[t / usize(20)]
		e = d
		d = c
		c = ((b << 30) | (b >> (32 - 30)))
		b = a
		a = tmp
	}
	for t = usize(20); t < usize(40); t++ {
		s = t & usize(15)
		ctx.m.b32[s] = (((ctx.m.b32[((s + usize(13)) & usize(15))] ^ ctx.m.b32[((s + usize(8)) & usize(15))] ^ ctx.m.b32[((s + usize(2)) & usize(15))] ^ ctx.m.b32[s]) << 1) | ((ctx.m.b32[((s + usize(13)) & usize(15))] ^ ctx.m.b32[((s + usize(8)) & usize(15))] ^ ctx.m.b32[((s + usize(2)) & usize(15))] ^ ctx.m.b32[s]) >> (32 - 1)))
		tmp = ((a << 5) | (a >> (32 - 5))) + ((b ^ c) ^ d) + e + ctx.m.b32[s] + libpq_sha1__k[t / usize(20)]
		e = d
		d = c
		c = ((b << 30) | (b >> (32 - 30)))
		b = a
		a = tmp
	}
	for t = usize(40); t < usize(60); t++ {
		s = t & usize(15)
		ctx.m.b32[s] = (((ctx.m.b32[((s + usize(13)) & usize(15))] ^ ctx.m.b32[((s + usize(8)) & usize(15))] ^ ctx.m.b32[((s + usize(2)) & usize(15))] ^ ctx.m.b32[s]) << 1) | ((ctx.m.b32[((s + usize(13)) & usize(15))] ^ ctx.m.b32[((s + usize(8)) & usize(15))] ^ ctx.m.b32[((s + usize(2)) & usize(15))] ^ ctx.m.b32[s]) >> (32 - 1)))
		tmp = ((a << 5) | (a >> (32 - 5))) + ((b & c) | (b & d) | (c & d)) + e + ctx.m.b32[s] + libpq_sha1__k[t / usize(20)]
		e = d
		d = c
		c = ((b << 30) | (b >> (32 - 30)))
		b = a
		a = tmp
	}
	for t = usize(60); t < usize(80); t++ {
		s = t & usize(15)
		ctx.m.b32[s] = (((ctx.m.b32[((s + usize(13)) & usize(15))] ^ ctx.m.b32[((s + usize(8)) & usize(15))] ^ ctx.m.b32[((s + usize(2)) & usize(15))] ^ ctx.m.b32[s]) << 1) | ((ctx.m.b32[((s + usize(13)) & usize(15))] ^ ctx.m.b32[((s + usize(8)) & usize(15))] ^ ctx.m.b32[((s + usize(2)) & usize(15))] ^ ctx.m.b32[s]) >> (32 - 1)))
		tmp = ((a << 5) | (a >> (32 - 5))) + ((b ^ c) ^ d) + e + ctx.m.b32[s] + libpq_sha1__k[t / usize(20)]
		e = d
		d = c
		c = ((b << 30) | (b >> (32 - 30)))
		b = a
		a = tmp
	}
	ctx.h.b32[0] = ctx.h.b32[0] + a
	ctx.h.b32[1] = ctx.h.b32[1] + b
	ctx.h.b32[2] = ctx.h.b32[2] + c
	ctx.h.b32[3] = ctx.h.b32[3] + d
	ctx.h.b32[4] = ctx.h.b32[4] + e
	C.c2v_memset(voidptr(unsafe { &ctx.m.b8[0] + 0 }), 0, u64(64))
}

@[markused]
pub fn sha1_pad(ctx &Pg_sha1_ctx) {
	padlen := usize(0)
	padstart := usize(0)
	for {
		ctx.m.b8[(i32(ctx.count) % 64)] = Uint8(128)
		ctx.count++
		ctx.count %= 64
		if i32(ctx.count) % 64 == 0 {
			sha1_step(ctx)
		}
		break
	}
	padstart = usize(i32(ctx.count) % 64)
	padlen = usize(64) - padstart
	if padlen < usize(8) {
		C.c2v_memset(voidptr(unsafe { &ctx.m.b8[0] + padstart }), 0, padlen)
		ctx.count += padlen
		ctx.count %= 64
		sha1_step(ctx)
		padstart = usize(i32(ctx.count) % 64)
		padlen = usize(64) - padstart
	}
	C.c2v_memset(voidptr(unsafe { &ctx.m.b8[0] + padstart }), 0, padlen - usize(8))
	ctx.count += (padlen - usize(8))
	ctx.count %= 64
	for {
		ctx.m.b8[(i32(ctx.count) % 64)] = ctx.c.b8[7]
		ctx.count++
		ctx.count %= 64
		if i32(ctx.count) % 64 == 0 {
			sha1_step(ctx)
		}
		break
	}
	for {
		ctx.m.b8[(i32(ctx.count) % 64)] = ctx.c.b8[6]
		ctx.count++
		ctx.count %= 64
		if i32(ctx.count) % 64 == 0 {
			sha1_step(ctx)
		}
		break
	}
	for {
		ctx.m.b8[(i32(ctx.count) % 64)] = ctx.c.b8[5]
		ctx.count++
		ctx.count %= 64
		if i32(ctx.count) % 64 == 0 {
			sha1_step(ctx)
		}
		break
	}
	for {
		ctx.m.b8[(i32(ctx.count) % 64)] = ctx.c.b8[4]
		ctx.count++
		ctx.count %= 64
		if i32(ctx.count) % 64 == 0 {
			sha1_step(ctx)
		}
		break
	}
	for {
		ctx.m.b8[(i32(ctx.count) % 64)] = ctx.c.b8[3]
		ctx.count++
		ctx.count %= 64
		if i32(ctx.count) % 64 == 0 {
			sha1_step(ctx)
		}
		break
	}
	for {
		ctx.m.b8[(i32(ctx.count) % 64)] = ctx.c.b8[2]
		ctx.count++
		ctx.count %= 64
		if i32(ctx.count) % 64 == 0 {
			sha1_step(ctx)
		}
		break
	}
	for {
		ctx.m.b8[(i32(ctx.count) % 64)] = ctx.c.b8[1]
		ctx.count++
		ctx.count %= 64
		if i32(ctx.count) % 64 == 0 {
			sha1_step(ctx)
		}
		break
	}
	for {
		ctx.m.b8[(i32(ctx.count) % 64)] = ctx.c.b8[0]
		ctx.count++
		ctx.count %= 64
		if i32(ctx.count) % 64 == 0 {
			sha1_step(ctx)
		}
		break
	}
}

@[markused]
pub fn sha1_result(digest0 &Uint8, ctx &Pg_sha1_ctx) {
	digest := &Uint8(0)
	digest = &Uint8(digest0)
	digest[0] = ctx.h.b8[3]
	digest[1] = ctx.h.b8[2]
	digest[2] = ctx.h.b8[1]
	digest[3] = ctx.h.b8[0]
	digest[4] = ctx.h.b8[7]
	digest[5] = ctx.h.b8[6]
	digest[6] = ctx.h.b8[5]
	digest[7] = ctx.h.b8[4]
	digest[8] = ctx.h.b8[11]
	digest[9] = ctx.h.b8[10]
	digest[10] = ctx.h.b8[9]
	digest[11] = ctx.h.b8[8]
	digest[12] = ctx.h.b8[15]
	digest[13] = ctx.h.b8[14]
	digest[14] = ctx.h.b8[13]
	digest[15] = ctx.h.b8[12]
	digest[16] = ctx.h.b8[19]
	digest[17] = ctx.h.b8[18]
	digest[18] = ctx.h.b8[17]
	digest[19] = ctx.h.b8[16]
}

@[export: 'pg_sha1_init']
@[markused]
pub fn pg_sha1_init(ctx &Pg_sha1_ctx) {
	C.c2v_memset(voidptr(ctx), 0, sizeof(Pg_sha1_ctx))
	ctx.h.b32[0] = Uint32(1732584193)
	ctx.h.b32[1] = u32(4023233417)
	ctx.h.b32[2] = u32(2562383102)
	ctx.h.b32[3] = Uint32(271733878)
	ctx.h.b32[4] = u32(3285377520)
}

@[export: 'pg_sha1_update']
@[markused]
pub fn pg_sha1_update(ctx &Pg_sha1_ctx, data &Uint8, len usize) {
	input := &Uint8(0)
	gaplen := usize(0)
	gapstart := usize(0)
	off := usize(0)
	copysiz := usize(0)
	input = &Uint8(data)
	off = usize(0)
	for off < len {
		gapstart = usize(i32(ctx.count) % 64)
		gaplen = usize(64) - gapstart
		copysiz = if (gaplen < len - off) { gaplen } else { len - off }
		C.c2v_memmove(voidptr(unsafe { &ctx.m.b8[0] + gapstart }), voidptr(unsafe { input + off }), copysiz)
		ctx.count += copysiz
		ctx.count %= 64
		ctx.c.b64[0] += Uint64(copysiz * usize(8))
		if i32(ctx.count) % 64 == 0 {
			sha1_step(ctx)
		}
		off += copysiz
	}
}

@[export: 'pg_sha1_final']
@[markused]
pub fn pg_sha1_final(ctx &Pg_sha1_ctx, dest &Uint8) {
	sha1_pad(ctx)
	sha1_result(dest, ctx)
}
