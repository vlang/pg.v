@[translated]
module libpq

@[markused]
pub fn bytes_to_hex(b &Uint8, s &i8) {
	static hex := c'0123456789abcdef'
	q := i32(0)
	w := i32(0)

	q = 0
	for w = 0; q < 16; q++ {
		s[w++] = hex[(i32(b[q]) >> 4) & 15]
		s[w++] = hex[i32(b[q]) & 15]
	}
	s[w] = i8(`\0`)
}

@[export: 'pg_md5_hash']
@[markused]
pub fn pg_md5_hash(buff voidptr, len usize, hexsum &i8, errstr &&u8) bool {
	sum := [16]Uint8{}
	ctx := &Pg_cryptohash_ctx(0)
	unsafe { *errstr = (voidptr(0)) }
	ctx = pg_cryptohash_create(Pg_cryptohash_type.pg_md5)
	if usize(ctx) == usize((voidptr(0))) {
		unsafe { *errstr = pg_cryptohash_error((voidptr(0))) }
		return false != 0
	}
	if pg_cryptohash_init(ctx) < 0 || pg_cryptohash_update(ctx, buff, len) < 0 || pg_cryptohash_final(ctx, &sum[0], sizeof([16]Uint8)) < 0 {
		unsafe { *errstr = pg_cryptohash_error(ctx) }
		pg_cryptohash_free(ctx)
		return false != 0
	}
	bytes_to_hex(&sum[0], hexsum)
	pg_cryptohash_free(ctx)
	return true != 0
}

@[export: 'pg_md5_binary']
@[markused]
pub fn pg_md5_binary(buff voidptr, len usize, outbuf &Uint8, errstr &&u8) bool {
	ctx := &Pg_cryptohash_ctx(0)
	unsafe { *errstr = (voidptr(0)) }
	ctx = pg_cryptohash_create(Pg_cryptohash_type.pg_md5)
	if usize(ctx) == usize((voidptr(0))) {
		unsafe { *errstr = pg_cryptohash_error((voidptr(0))) }
		return false != 0
	}
	if pg_cryptohash_init(ctx) < 0 || pg_cryptohash_update(ctx, buff, len) < 0 || pg_cryptohash_final(ctx, outbuf, usize(16)) < 0 {
		unsafe { *errstr = pg_cryptohash_error(ctx) }
		pg_cryptohash_free(ctx)
		return false != 0
	}
	pg_cryptohash_free(ctx)
	return true != 0
}

@[export: 'pg_md5_encrypt']
@[markused]
pub fn pg_md5_encrypt(passwd &i8, salt &Uint8, salt_len usize, buf &i8, errstr &&u8) bool {
	passwd_len := C.c2v_strlen(passwd)
	crypt_buf := &i8(C.c2v_malloc(passwd_len + salt_len + usize(1)))
	ret := false
	if isnil(crypt_buf) {
		unsafe { *errstr = &c'out of memory'[0] }
		return false != 0
	}
	C.c2v_memcpy(voidptr(crypt_buf), voidptr(passwd), passwd_len)
	C.c2v_memcpy(voidptr(crypt_buf + passwd_len), voidptr(salt), salt_len)
	C.c2v_strcpy(buf, c'md5')
	ret = pg_md5_hash(voidptr(crypt_buf), passwd_len + salt_len, buf + 3, errstr)
	C.c2v_free(voidptr(crypt_buf))
	return ret
}
