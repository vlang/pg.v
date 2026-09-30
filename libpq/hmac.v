@[translated]
module libpq

pub enum Pg_hmac_errno {
	pg_hmac_error_none = 0
	pg_hmac_error_oom
	pg_hmac_error_internal
}

pub struct Pg_hmac_ctx {
pub mut:
	hash        &Pg_cryptohash_ctx
	type_       Pg_cryptohash_type
	error       Pg_hmac_errno
	errreason   &i8
	block_size  int
	digest_size int
	k_ipad      [128]Uint8
	k_opad      [128]Uint8
}

@[export: 'pg_hmac_create']
@[markused]
pub fn pg_hmac_create(type_ Pg_cryptohash_type) &Pg_hmac_ctx {
	ctx := &Pg_hmac_ctx(0)
	ctx = C.c2v_malloc(sizeof(Pg_hmac_ctx))
	if usize(ctx) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	C.c2v_memset(voidptr(ctx), 0, sizeof(Pg_hmac_ctx))
	ctx.type_ = type_
	ctx.error = Pg_hmac_errno.pg_hmac_error_none
	ctx.errreason = (voidptr(0))
	match type_ {
		.pg_md5 {
			ctx.digest_size = 16
			ctx.block_size = 64
		}
		.pg_sha1 {
			ctx.digest_size = 20
			ctx.block_size = 64
		}
		.pg_sha224 {
			ctx.digest_size = 28
			ctx.block_size = 64
		}
		.pg_sha256 {
			ctx.digest_size = 32
			ctx.block_size = 64
		}
		.pg_sha384 {
			ctx.digest_size = 48
			ctx.block_size = 128
		}
		.pg_sha512 {
			ctx.digest_size = 64
			ctx.block_size = 128
		}
		else {}
	}

	ctx.hash = pg_cryptohash_create(type_)
	if usize(ctx.hash) == usize((voidptr(0))) {
		explicit_bzero(voidptr(ctx), sizeof(Pg_hmac_ctx))
		C.c2v_free(voidptr(ctx))
		return unsafe { nil }
	}
	return ctx
}

@[export: 'pg_hmac_init']
@[markused]
pub fn pg_hmac_init(ctx &Pg_hmac_ctx, key &Uint8, len usize) int {
	i := 0
	digest_size := 0
	block_size := 0
	shrinkbuf := unsafe { &Uint8(nil) }
	if usize(ctx) == usize((voidptr(0))) {
		return -1
	}
	digest_size = ctx.digest_size
	block_size = ctx.block_size
	C.c2v_memset(ctx.k_opad, 92, u64(ctx.block_size))
	C.c2v_memset(ctx.k_ipad, 54, u64(ctx.block_size))
	if len > usize(block_size) {
		hash_ctx := &Pg_cryptohash_ctx(0)
		shrinkbuf = C.c2v_malloc(u64(digest_size))
		if usize(shrinkbuf) == usize((voidptr(0))) {
			ctx.error = Pg_hmac_errno.pg_hmac_error_oom
			return -1
		}
		C.c2v_memset(voidptr(shrinkbuf), 0, u64(digest_size))
		hash_ctx = pg_cryptohash_create(ctx.type_)
		if usize(hash_ctx) == usize((voidptr(0))) {
			ctx.error = Pg_hmac_errno.pg_hmac_error_oom
			C.c2v_free(voidptr(shrinkbuf))
			return -1
		}
		if pg_cryptohash_init(hash_ctx) < 0 || pg_cryptohash_update(hash_ctx, key, len) < 0 || pg_cryptohash_final(hash_ctx, shrinkbuf, usize(digest_size)) < 0 {
			ctx.error = Pg_hmac_errno.pg_hmac_error_internal
			ctx.errreason = pg_cryptohash_error(hash_ctx)
			pg_cryptohash_free(hash_ctx)
			C.c2v_free(voidptr(shrinkbuf))
			return -1
		}
		key = shrinkbuf
		len = usize(digest_size)
		pg_cryptohash_free(hash_ctx)
	}
	for i = 0; usize(i) < len; i++ {
		ctx.k_ipad[i] ^= int(key[i])
		ctx.k_opad[i] ^= int(key[i])
	}
	if pg_cryptohash_init(ctx.hash) < 0 || pg_cryptohash_update(ctx.hash, unsafe { &ctx.k_ipad[0] }, usize(ctx.block_size)) < 0 {
		ctx.error = Pg_hmac_errno.pg_hmac_error_internal
		ctx.errreason = pg_cryptohash_error(ctx.hash)
		if shrinkbuf {
			C.c2v_free(voidptr(shrinkbuf))
		}
		return -1
	}
	if shrinkbuf {
		C.c2v_free(voidptr(shrinkbuf))
	}
	return 0
}

@[export: 'pg_hmac_update']
@[markused]
pub fn pg_hmac_update(ctx &Pg_hmac_ctx, data &Uint8, len usize) int {
	if usize(ctx) == usize((voidptr(0))) {
		return -1
	}
	if pg_cryptohash_update(ctx.hash, data, len) < 0 {
		ctx.error = Pg_hmac_errno.pg_hmac_error_internal
		ctx.errreason = pg_cryptohash_error(ctx.hash)
		return -1
	}
	return 0
}

@[export: 'pg_hmac_final']
@[markused]
pub fn pg_hmac_final(ctx &Pg_hmac_ctx, dest &Uint8, len usize) int {
	h := &Uint8(0)
	if usize(ctx) == usize((voidptr(0))) {
		return -1
	}
	h = C.c2v_malloc(u64(ctx.digest_size))
	if usize(h) == usize((voidptr(0))) {
		ctx.error = Pg_hmac_errno.pg_hmac_error_oom
		return -1
	}
	C.c2v_memset(voidptr(h), 0, u64(ctx.digest_size))
	if pg_cryptohash_final(ctx.hash, h, usize(ctx.digest_size)) < 0 {
		ctx.error = Pg_hmac_errno.pg_hmac_error_internal
		ctx.errreason = pg_cryptohash_error(ctx.hash)
		C.c2v_free(voidptr(h))
		return -1
	}
	mut __c2v_condition_0 := false
	mut __c2v_condition_1 := false
	__c2v_condition_1 = pg_cryptohash_init(ctx.hash) < 0
	__c2v_condition_0 = __c2v_condition_1
	if !__c2v_condition_0 {
		mut __c2v_condition_2 := false
		__c2v_condition_2 = pg_cryptohash_update(ctx.hash, unsafe { &ctx.k_opad[0] }, usize(ctx.block_size)) < 0
		__c2v_condition_0 = __c2v_condition_2
	}
	if !__c2v_condition_0 {
		mut __c2v_condition_3 := false
		__c2v_condition_3 = pg_cryptohash_update(ctx.hash, h, usize(ctx.digest_size)) < 0
		__c2v_condition_0 = __c2v_condition_3
	}
	if !__c2v_condition_0 {
		mut __c2v_condition_4 := false
		__c2v_condition_4 = pg_cryptohash_final(ctx.hash, dest, len) < 0
		__c2v_condition_0 = __c2v_condition_4
	}
	if __c2v_condition_0 {
		ctx.error = Pg_hmac_errno.pg_hmac_error_internal
		ctx.errreason = pg_cryptohash_error(ctx.hash)
		C.c2v_free(voidptr(h))
		return -1
	}
	C.c2v_free(voidptr(h))
	return 0
}

@[export: 'pg_hmac_free']
@[markused]
pub fn pg_hmac_free(ctx &Pg_hmac_ctx) {
	if usize(ctx) == usize((voidptr(0))) {
		return
	}
	pg_cryptohash_free(ctx.hash)
	explicit_bzero(voidptr(ctx), sizeof(Pg_hmac_ctx))
	C.c2v_free(voidptr(ctx))
}

@[export: 'pg_hmac_error']
@[markused]
pub fn pg_hmac_error(ctx &Pg_hmac_ctx) &i8 {
	if usize(ctx) == usize((voidptr(0))) {
		return unsafe { &i8(&c'out of memory'[0]) }
	}
	if ctx.errreason {
		return ctx.errreason
	}
	match ctx.error {
		.pg_hmac_error_none {
			return unsafe { &i8(&c'success'[0]) }
		}
		.pg_hmac_error_internal {
			return unsafe { &i8(&c'internal error'[0]) }
		}
		.pg_hmac_error_oom {
			return unsafe { &i8(&c'out of memory'[0]) }
		}
		else {}
	}

	return unsafe { &i8(&c'success'[0]) }
}
