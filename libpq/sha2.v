@[translated]
module libpq

@[export: 'pg_sha256_init']
@[markused]
pub fn pg_sha256_init(context &Pg_sha256_ctx) {
	if usize(context) == usize((voidptr(0))) {
		return
	}
	C.c2v_memcpy(context.state, voidptr(unsafe { &libpq_sha2_sha256_initial_hash_value[0] }), u64(32))
	C.c2v_memset(context.buffer, 0, u64(64))
	context.bitcount = Uint64(0)
}

@[markused]
pub fn sha_256_transform(context &Pg_sha256_ctx, data &Uint8) {
	a := Uint32(0)
	b := Uint32(0)
	c := Uint32(0)
	d := Uint32(0)
	e := Uint32(0)
	f := Uint32(0)
	g := Uint32(0)
	h := Uint32(0)
	s0 := Uint32(0)
	s1 := Uint32(0)

	t1 := Uint32(0)
	t2 := Uint32(0)
	w256 := &Uint32(0)

	j := 0
	w256 = &Uint32(voidptr(unsafe { &context.buffer[0] }))
	a = context.state[0]
	b = context.state[1]
	c = context.state[2]
	d = context.state[3]
	e = context.state[4]
	f = context.state[5]
	g = context.state[6]
	h = context.state[7]
	j = 0
	for {
		w256[j] = Uint32(data[3]) | (Uint32(data[2]) << 8) | (Uint32(data[1]) << 16) | (Uint32(data[0]) << 24)
		c2v_pointer_prefix(voidptr(&data), data, isize(4))
		t1 = h + (((e >> 6) | (e << (32 - 6))) ^ ((e >> 11) | (e << (32 - 11))) ^ ((e >> 25) | (e << (32 - 25)))) + ((e & f) ^ ((~e) & g)) + libpq_sha2_k256[j] + w256[j]
		t2 = (((a >> 2) | (a << (32 - 2))) ^ ((a >> 13) | (a << (32 - 13))) ^ ((a >> 22) | (a << (32 - 22)))) + ((a & b) ^ (a & c) ^ (b & c))
		h = g
		g = f
		f = e
		e = d + t1
		d = c
		c = b
		b = a
		a = t1 + t2
		j++
		if !(j < 16) {
			break
		}
	}
	for {
		s0 = w256[(j + 1) & 15]
		s0 = (((s0 >> 7) | (s0 << (32 - 7))) ^ ((s0 >> 18) | (s0 << (32 - 18))) ^ (s0 >> 3))
		s1 = w256[(j + 14) & 15]
		s1 = (((s1 >> 17) | (s1 << (32 - 17))) ^ ((s1 >> 19) | (s1 << (32 - 19))) ^ (s1 >> 10))
		t1 = h + (((e >> 6) | (e << (32 - 6))) ^ ((e >> 11) | (e << (32 - 11))) ^ ((e >> 25) | (e << (32 - 25)))) + ((e & f) ^ ((~e) & g)) + libpq_sha2_k256[j] + c2v_assign[u32](unsafe { &w256[j & 15] }, u32(w256[j & 15] + (s1 + w256[(j + 9) & 15] + s0)))
		t2 = (((a >> 2) | (a << (32 - 2))) ^ ((a >> 13) | (a << (32 - 13))) ^ ((a >> 22) | (a << (32 - 22)))) + ((a & b) ^ (a & c) ^ (b & c))
		h = g
		g = f
		f = e
		e = d + t1
		d = c
		c = b
		b = a
		a = t1 + t2
		j++
		if !(j < 64) {
			break
		}
	}
	context.state[0] += a
	context.state[1] += b
	context.state[2] += c
	context.state[3] += d
	context.state[4] += e
	context.state[5] += f
	context.state[6] += g
	context.state[7] += h
	t2 = Uint32(0)
	t1 = t2
	h = t1
	g = h
	f = g
	e = f
	d = e
	c = d
	b = c
	a = b
}

@[export: 'pg_sha256_update']
@[markused]
pub fn pg_sha256_update(context &Pg_sha256_ctx, data &Uint8, len usize) {
	freespace := usize(0)
	usedspace := usize(0)

	if len == usize(0) {
		return
	}
	usedspace = usize((context.bitcount >> 3) % Uint64(64))
	if usedspace > usize(0) {
		freespace = usize(64) - usedspace
		if len >= freespace {
			C.c2v_memcpy(voidptr(unsafe { &context.buffer[0] + usedspace }), voidptr(data), freespace)
			context.bitcount += Uint64(freespace << 3)
			len -= freespace
			c2v_pointer_prefix(voidptr(&data), data, isize(freespace))
			sha_256_transform(context, unsafe { &context.buffer[0] })
		} else {
			C.c2v_memcpy(voidptr(unsafe { &context.buffer[0] + usedspace }), voidptr(data), len)
			context.bitcount += Uint64(len << 3)
			freespace = usize(0)
			usedspace = freespace
			return
		}
	}
	for len >= usize(64) {
		sha_256_transform(context, data)
		context.bitcount += Uint64(64 << 3)
		len -= usize(64)
		c2v_pointer_prefix(voidptr(&data), data, isize(64))
	}
	if len > usize(0) {
		C.c2v_memcpy(context.buffer, voidptr(data), len)
		context.bitcount += Uint64(len << 3)
	}
	freespace = usize(0)
	usedspace = freespace
}

@[markused]
pub fn sha_256_last(context &Pg_sha256_ctx) {
	usedspace := u32(0)
	usedspace = u32((context.bitcount >> 3) % Uint64(64))
	tmp := context.bitcount
	tmp = (tmp >> 32) | (tmp << 32)
	tmp = ((tmp & u64(18374966859414961920)) >> 8) | ((tmp & u64(71777214294589695)) << 8)
	context.bitcount = ((tmp & u64(18446462603027742720)) >> 16) | ((tmp & u64(281470681808895)) << 16)
	if usedspace > u32(0) {
		context.buffer[usedspace++] = Uint8(128)
		if usedspace <= u32((64 - 8)) {
			C.c2v_memset(voidptr(unsafe { &context.buffer[0] + usedspace }), 0, u64(u32((64 - 8)) - usedspace))
		} else {
			if usedspace < u32(64) {
				C.c2v_memset(voidptr(unsafe { &context.buffer[0] + usedspace }), 0, u64(u32(64) - usedspace))
			}
			sha_256_transform(context, unsafe { &context.buffer[0] })
			C.c2v_memset(context.buffer, 0, u64((64 - 8)))
		}
	} else {
		C.c2v_memset(context.buffer, 0, u64((64 - 8)))
		unsafe { *&context.buffer[0] = Uint8(128) }
	}
	mut __c2v_lhs_tmp_0 := unsafe { &Uint64(voidptr(&context.buffer[0] + (64 - 8))) }
	unsafe { *__c2v_lhs_tmp_0 = context.bitcount }
	sha_256_transform(context, unsafe { &context.buffer[0] })
}

@[export: 'pg_sha256_final']
@[markused]
pub fn pg_sha256_final(context &Pg_sha256_ctx, digest &Uint8) {
	if usize(digest) != usize((voidptr(0))) {
		sha_256_last(context)
		j := 0
		for j = 0; j < 8; j++ {
			tmp := context.state[j]
			tmp = (tmp >> 16) | (tmp << 16)
			context.state[j] = Uint32(((u64(tmp) & u64(4278255360)) >> 8) | ((u64(tmp) & 16711935) << 8))
		}
		C.c2v_memcpy(voidptr(digest), context.state, u64(32))
	}
	C.c2v_memset(voidptr(context), 0, sizeof(Pg_sha256_ctx))
}

@[export: 'pg_sha512_init']
@[markused]
pub fn pg_sha512_init(context &Pg_sha512_ctx) {
	if usize(context) == usize((voidptr(0))) {
		return
	}
	C.c2v_memcpy(context.state, voidptr(unsafe { &libpq_sha2_sha512_initial_hash_value[0] }), u64(64))
	C.c2v_memset(context.buffer, 0, u64(128))
	context.bitcount[1] = Uint64(0)
	context.bitcount[0] = context.bitcount[1]
}

@[markused]
pub fn sha_512_transform(context &Pg_sha512_ctx, data &Uint8) {
	a := Uint64(0)
	b := Uint64(0)
	c := Uint64(0)
	d := Uint64(0)
	e := Uint64(0)
	f := Uint64(0)
	g := Uint64(0)
	h := Uint64(0)
	s0 := Uint64(0)
	s1 := Uint64(0)

	t1 := Uint64(0)
	t2 := Uint64(0)
	w512 := unsafe { &Uint64(&context.buffer[0]) }

	j := 0
	a = context.state[0]
	b = context.state[1]
	c = context.state[2]
	d = context.state[3]
	e = context.state[4]
	f = context.state[5]
	g = context.state[6]
	h = context.state[7]
	j = 0
	for {
		w512[j] = Uint64(data[7]) | (Uint64(data[6]) << 8) | (Uint64(data[5]) << 16) | (Uint64(data[4]) << 24) | (Uint64(data[3]) << 32) | (Uint64(data[2]) << 40) | (Uint64(data[1]) << 48) | (Uint64(data[0]) << 56)
		c2v_pointer_prefix(voidptr(&data), data, isize(8))
		t1 = h + (((e >> 14) | (e << (64 - 14))) ^ ((e >> 18) | (e << (64 - 18))) ^ ((e >> 41) | (e << (64 - 41)))) + ((e & f) ^ ((~e) & g)) + libpq_sha2_k512[j] + w512[j]
		t2 = (((a >> 28) | (a << (64 - 28))) ^ ((a >> 34) | (a << (64 - 34))) ^ ((a >> 39) | (a << (64 - 39)))) + ((a & b) ^ (a & c) ^ (b & c))
		h = g
		g = f
		f = e
		e = d + t1
		d = c
		c = b
		b = a
		a = t1 + t2
		j++
		if !(j < 16) {
			break
		}
	}
	for {
		s0 = w512[(j + 1) & 15]
		s0 = (((s0 >> 1) | (s0 << (64 - 1))) ^ ((s0 >> 8) | (s0 << (64 - 8))) ^ (s0 >> 7))
		s1 = w512[(j + 14) & 15]
		s1 = (((s1 >> 19) | (s1 << (64 - 19))) ^ ((s1 >> 61) | (s1 << (64 - 61))) ^ (s1 >> 6))
		t1 = h + (((e >> 14) | (e << (64 - 14))) ^ ((e >> 18) | (e << (64 - 18))) ^ ((e >> 41) | (e << (64 - 41)))) + ((e & f) ^ ((~e) & g)) + libpq_sha2_k512[j] + c2v_assign[u64](unsafe { &w512[j & 15] }, u64(w512[j & 15] + (s1 + w512[(j + 9) & 15] + s0)))
		t2 = (((a >> 28) | (a << (64 - 28))) ^ ((a >> 34) | (a << (64 - 34))) ^ ((a >> 39) | (a << (64 - 39)))) + ((a & b) ^ (a & c) ^ (b & c))
		h = g
		g = f
		f = e
		e = d + t1
		d = c
		c = b
		b = a
		a = t1 + t2
		j++
		if !(j < 80) {
			break
		}
	}
	context.state[0] += a
	context.state[1] += b
	context.state[2] += c
	context.state[3] += d
	context.state[4] += e
	context.state[5] += f
	context.state[6] += g
	context.state[7] += h
	t2 = Uint64(0)
	t1 = t2
	h = t1
	g = h
	f = g
	e = f
	d = e
	c = d
	b = c
	a = b
}

@[export: 'pg_sha512_update']
@[markused]
pub fn pg_sha512_update(context &Pg_sha512_ctx, data &Uint8, len usize) {
	freespace := usize(0)
	usedspace := usize(0)

	if len == usize(0) {
		return
	}
	usedspace = usize((context.bitcount[0] >> 3) % Uint64(128))
	if usedspace > usize(0) {
		freespace = usize(128) - usedspace
		if len >= freespace {
			C.c2v_memcpy(voidptr(unsafe { &context.buffer[0] + usedspace }), voidptr(data), freespace)
			context.bitcount[0] += Uint64((freespace << 3))
			if context.bitcount[0] < Uint64((freespace << 3)) {
				context.bitcount[1]++
			}
			len -= freespace
			c2v_pointer_prefix(voidptr(&data), data, isize(freespace))
			sha_512_transform(context, unsafe { &context.buffer[0] })
		} else {
			C.c2v_memcpy(voidptr(unsafe { &context.buffer[0] + usedspace }), voidptr(data), len)
			context.bitcount[0] += Uint64((len << 3))
			if context.bitcount[0] < Uint64((len << 3)) {
				context.bitcount[1]++
			}
			freespace = usize(0)
			usedspace = freespace
			return
		}
	}
	for len >= usize(128) {
		sha_512_transform(context, data)
		context.bitcount[0] += Uint64((128 << 3))
		if context.bitcount[0] < Uint64((128 << 3)) {
			context.bitcount[1]++
		}
		len -= usize(128)
		c2v_pointer_prefix(voidptr(&data), data, isize(128))
	}
	if len > usize(0) {
		C.c2v_memcpy(context.buffer, voidptr(data), len)
		context.bitcount[0] += Uint64((len << 3))
		if context.bitcount[0] < Uint64((len << 3)) {
			context.bitcount[1]++
		}
	}
	freespace = usize(0)
	usedspace = freespace
}

@[markused]
pub fn sha_512_last(context &Pg_sha512_ctx) {
	usedspace := u32(0)
	usedspace = u32((context.bitcount[0] >> 3) % Uint64(128))
	tmp := context.bitcount[0]
	tmp = (tmp >> 32) | (tmp << 32)
	tmp = ((tmp & u64(18374966859414961920)) >> 8) | ((tmp & u64(71777214294589695)) << 8)
	context.bitcount[0] = ((tmp & u64(18446462603027742720)) >> 16) | ((tmp & u64(281470681808895)) << 16)
	tmp_2 := context.bitcount[1]
	tmp_2 = (tmp_2 >> 32) | (tmp_2 << 32)
	tmp_2 = ((tmp_2 & u64(18374966859414961920)) >> 8) | ((tmp_2 & u64(71777214294589695)) << 8)
	context.bitcount[1] = ((tmp_2 & u64(18446462603027742720)) >> 16) | ((tmp_2 & u64(281470681808895)) << 16)
	if usedspace > u32(0) {
		context.buffer[usedspace++] = Uint8(128)
		if usedspace <= u32((128 - 16)) {
			C.c2v_memset(voidptr(unsafe { &context.buffer[0] + usedspace }), 0, u64(u32((128 - 16)) - usedspace))
		} else {
			if usedspace < u32(128) {
				C.c2v_memset(voidptr(unsafe { &context.buffer[0] + usedspace }), 0, u64(u32(128) - usedspace))
			}
			sha_512_transform(context, unsafe { &context.buffer[0] })
			C.c2v_memset(context.buffer, 0, u64(128 - 2))
		}
	} else {
		C.c2v_memset(context.buffer, 0, u64((128 - 16)))
		unsafe { *&context.buffer[0] = Uint8(128) }
	}
	mut __c2v_lhs_tmp_1 := unsafe { &Uint64(voidptr(&context.buffer[0] + (128 - 16))) }
	unsafe { *__c2v_lhs_tmp_1 = context.bitcount[1] }
	mut __c2v_lhs_tmp_2 := unsafe { &Uint64(voidptr(&context.buffer[0] + ((128 - 16) + 8))) }
	unsafe { *__c2v_lhs_tmp_2 = context.bitcount[0] }
	sha_512_transform(context, unsafe { &context.buffer[0] })
}

@[export: 'pg_sha512_final']
@[markused]
pub fn pg_sha512_final(context &Pg_sha512_ctx, digest &Uint8) {
	if usize(digest) != usize((voidptr(0))) {
		sha_512_last(context)
		j := 0
		for j = 0; j < 8; j++ {
			tmp := context.state[j]
			tmp = (tmp >> 32) | (tmp << 32)
			tmp = ((tmp & u64(18374966859414961920)) >> 8) | ((tmp & u64(71777214294589695)) << 8)
			context.state[j] = ((tmp & u64(18446462603027742720)) >> 16) | ((tmp & u64(281470681808895)) << 16)
		}
		C.c2v_memcpy(voidptr(digest), context.state, u64(64))
	}
	C.c2v_memset(voidptr(context), 0, sizeof(Pg_sha512_ctx))
}

@[export: 'pg_sha384_init']
@[markused]
pub fn pg_sha384_init(context &Pg_sha384_ctx) {
	if usize(context) == usize((voidptr(0))) {
		return
	}
	C.c2v_memcpy(context.state, voidptr(unsafe { &libpq_sha2_sha384_initial_hash_value[0] }), u64(64))
	C.c2v_memset(context.buffer, 0, u64(128))
	context.bitcount[1] = Uint64(0)
	context.bitcount[0] = context.bitcount[1]
}

@[export: 'pg_sha384_update']
@[markused]
pub fn pg_sha384_update(context &Pg_sha384_ctx, data &Uint8, len usize) {
	pg_sha512_update(&Pg_sha512_ctx(context), data, len)
}

@[export: 'pg_sha384_final']
@[markused]
pub fn pg_sha384_final(context &Pg_sha384_ctx, digest &Uint8) {
	if usize(digest) != usize((voidptr(0))) {
		sha_512_last(&Pg_sha512_ctx(context))
		j := 0
		for j = 0; j < 6; j++ {
			tmp := context.state[j]
			tmp = (tmp >> 32) | (tmp << 32)
			tmp = ((tmp & u64(18374966859414961920)) >> 8) | ((tmp & u64(71777214294589695)) << 8)
			context.state[j] = ((tmp & u64(18446462603027742720)) >> 16) | ((tmp & u64(281470681808895)) << 16)
		}
		C.c2v_memcpy(voidptr(digest), context.state, u64(48))
	}
	C.c2v_memset(voidptr(context), 0, sizeof(Pg_sha384_ctx))
}

@[export: 'pg_sha224_init']
@[markused]
pub fn pg_sha224_init(context &Pg_sha224_ctx) {
	if usize(context) == usize((voidptr(0))) {
		return
	}
	C.c2v_memcpy(context.state, voidptr(unsafe { &libpq_sha2_sha224_initial_hash_value[0] }), u64(32))
	C.c2v_memset(context.buffer, 0, u64(64))
	context.bitcount = Uint64(0)
}

@[export: 'pg_sha224_update']
@[markused]
pub fn pg_sha224_update(context &Pg_sha224_ctx, data &Uint8, len usize) {
	pg_sha256_update(&Pg_sha256_ctx(context), data, len)
}

@[export: 'pg_sha224_final']
@[markused]
pub fn pg_sha224_final(context &Pg_sha224_ctx, digest &Uint8) {
	if usize(digest) != usize((voidptr(0))) {
		sha_256_last(unsafe { &Pg_sha256_ctx(context) })
		j := 0
		for j = 0; j < 8; j++ {
			tmp := context.state[j]
			tmp = (tmp >> 16) | (tmp << 16)
			context.state[j] = Uint32(((u64(tmp) & u64(4278255360)) >> 8) | ((u64(tmp) & 16711935) << 8))
		}
		C.c2v_memcpy(voidptr(digest), context.state, u64(28))
	}
	C.c2v_memset(voidptr(context), 0, sizeof(Pg_sha224_ctx))
}
