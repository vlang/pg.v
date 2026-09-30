@[translated]
module libpq

pub enum Pg_cryptohash_type {
	pg_md5 = 0
	pg_sha1
	pg_sha224
	pg_sha256
	pg_sha384
	pg_sha512
}

pub union Pg_md5_ctx_md5_st {
pub mut:
	md5_state32 [4]Uint32
	md5_state8  [16]Uint8
}

pub union Pg_md5_ctx_md5_count {
pub mut:
	md5_count64 Uint64
	md5_count8  [8]Uint8
}

pub struct Pg_md5_ctx {
pub mut:
	md5_st    Pg_md5_ctx_md5_st
	md5_count Pg_md5_ctx_md5_count
	md5_i     u32
	md5_buf   [64]Uint8
}

pub union Pg_sha1_ctx_h {
pub mut:
	b8  [20]Uint8
	b32 [5]Uint32
}

pub union Pg_sha1_ctx_c {
pub mut:
	b8  [8]Uint8
	b64 [1]Uint64
}

pub union Pg_sha1_ctx_m {
pub mut:
	b8  [64]Uint8
	b32 [16]Uint32
}

pub struct Pg_sha1_ctx {
pub mut:
	h     Pg_sha1_ctx_h
	c     Pg_sha1_ctx_c
	m     Pg_sha1_ctx_m
	count Uint8
}

pub struct Pg_sha256_ctx {
pub mut:
	state    [8]Uint32
	bitcount Uint64
	buffer   [64]Uint8
}

pub struct Pg_sha512_ctx {
pub mut:
	state    [8]Uint64
	bitcount [2]Uint64
	buffer   [128]Uint8
}

pub type Pg_sha224_ctx = Pg_sha256_ctx

pub type Pg_sha384_ctx = Pg_sha512_ctx

pub enum Pg_cryptohash_errno {
	pg_cryptohash_error_none = 0
	pg_cryptohash_error_dest_len
}

pub union Pg_cryptohash_ctx_data {
pub mut:
	md5    Pg_md5_ctx
	sha1   Pg_sha1_ctx
	sha224 Pg_sha224_ctx
	sha256 Pg_sha256_ctx
	sha384 Pg_sha384_ctx
	sha512 Pg_sha512_ctx
}

pub struct Pg_cryptohash_ctx {
pub mut:
	type_ Pg_cryptohash_type
	error Pg_cryptohash_errno
	data  Pg_cryptohash_ctx_data
}

@[export: 'pg_cryptohash_create']
@[markused]
pub fn pg_cryptohash_create(type_ Pg_cryptohash_type) &Pg_cryptohash_ctx {
	ctx := &Pg_cryptohash_ctx(0)
	ctx = C.c2v_malloc(sizeof(Pg_cryptohash_ctx))
	if usize(ctx) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	C.c2v_memset(voidptr(ctx), 0, sizeof(Pg_cryptohash_ctx))
	ctx.type_ = type_
	ctx.error = Pg_cryptohash_errno.pg_cryptohash_error_none
	return ctx
}

@[export: 'pg_cryptohash_init']
@[markused]
pub fn pg_cryptohash_init(ctx &Pg_cryptohash_ctx) i32 {
	if usize(ctx) == usize((voidptr(0))) {
		return -1
	}
	match ctx.type_ {
		.pg_md5 {
			pg_md5_init(&ctx.data.md5)
		}
		.pg_sha1 {
			pg_sha1_init(&ctx.data.sha1)
		}
		.pg_sha224 {
			pg_sha224_init(&ctx.data.sha224)
		}
		.pg_sha256 {
			pg_sha256_init(&ctx.data.sha256)
		}
		.pg_sha384 {
			pg_sha384_init(&ctx.data.sha384)
		}
		.pg_sha512 {
			pg_sha512_init(&ctx.data.sha512)
		}
		else {}
	}

	return 0
}

@[export: 'pg_cryptohash_update']
@[markused]
pub fn pg_cryptohash_update(ctx &Pg_cryptohash_ctx, data &Uint8, len usize) i32 {
	if usize(ctx) == usize((voidptr(0))) {
		return -1
	}
	match ctx.type_ {
		.pg_md5 {
			pg_md5_update(&ctx.data.md5, data, len)
		}
		.pg_sha1 {
			pg_sha1_update(&ctx.data.sha1, data, len)
		}
		.pg_sha224 {
			pg_sha224_update(&ctx.data.sha224, data, len)
		}
		.pg_sha256 {
			pg_sha256_update(&ctx.data.sha256, data, len)
		}
		.pg_sha384 {
			pg_sha384_update(&ctx.data.sha384, data, len)
		}
		.pg_sha512 {
			pg_sha512_update(&ctx.data.sha512, data, len)
		}
		else {}
	}

	return 0
}

@[export: 'pg_cryptohash_final']
@[markused]
pub fn pg_cryptohash_final(ctx &Pg_cryptohash_ctx, dest &Uint8, len usize) i32 {
	if usize(ctx) == usize((voidptr(0))) {
		return -1
	}
	match ctx.type_ {
		.pg_md5 {
			if len < usize(16) {
				ctx.error = Pg_cryptohash_errno.pg_cryptohash_error_dest_len
				return -1
			}
			pg_md5_final(&ctx.data.md5, dest)
		}
		.pg_sha1 {
			if len < usize(20) {
				ctx.error = Pg_cryptohash_errno.pg_cryptohash_error_dest_len
				return -1
			}
			pg_sha1_final(&ctx.data.sha1, dest)
		}
		.pg_sha224 {
			if len < usize(28) {
				ctx.error = Pg_cryptohash_errno.pg_cryptohash_error_dest_len
				return -1
			}
			pg_sha224_final(&ctx.data.sha224, dest)
		}
		.pg_sha256 {
			if len < usize(32) {
				ctx.error = Pg_cryptohash_errno.pg_cryptohash_error_dest_len
				return -1
			}
			pg_sha256_final(&ctx.data.sha256, dest)
		}
		.pg_sha384 {
			if len < usize(48) {
				ctx.error = Pg_cryptohash_errno.pg_cryptohash_error_dest_len
				return -1
			}
			pg_sha384_final(&ctx.data.sha384, dest)
		}
		.pg_sha512 {
			if len < usize(64) {
				ctx.error = Pg_cryptohash_errno.pg_cryptohash_error_dest_len
				return -1
			}
			pg_sha512_final(&ctx.data.sha512, dest)
		}
		else {}
	}

	return 0
}

@[export: 'pg_cryptohash_free']
@[markused]
pub fn pg_cryptohash_free(ctx &Pg_cryptohash_ctx) {
	if usize(ctx) == usize((voidptr(0))) {
		return
	}
	explicit_bzero(voidptr(ctx), sizeof(Pg_cryptohash_ctx))
	C.c2v_free(voidptr(ctx))
}

@[export: 'pg_cryptohash_error']
@[markused]
pub fn pg_cryptohash_error(ctx &Pg_cryptohash_ctx) &i8 {
	if usize(ctx) == usize((voidptr(0))) {
		return unsafe { &i8(&c'out of memory'[0]) }
	}
	match ctx.error {
		.pg_cryptohash_error_none {
			return unsafe { &i8(&c'success'[0]) }
		}
		.pg_cryptohash_error_dest_len {
			return unsafe { &i8(&c'destination buffer too small'[0]) }
		}
		else {}
	}

	return unsafe { &i8(&c'success'[0]) }
}
