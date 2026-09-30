@[translated]
module libpq

@[export: 'scram_SaltedPassword']
@[markused]
pub fn scram_salted_password(password &i8, hash_type Pg_cryptohash_type, key_length i32, salt &Uint8, saltlen i32, iterations i32, result &Uint8, errstr &&u8) i32 {
	password_len := i32(C.c2v_strlen(password))
	one := c2v_builtin_bswap32(u32(1))
	i := i32(0)
	j := i32(0)

	ui := [32]Uint8{}
	ui_prev := [32]Uint8{}
	hmac_ctx := pg_hmac_create(hash_type)
	if usize(hmac_ctx) == usize((voidptr(0))) {
		unsafe { *errstr = pg_hmac_error((voidptr(0))) }
		return -1
	}
	mut __c2v_condition_0 := false
	mut __c2v_condition_1 := false
	__c2v_condition_1 = pg_hmac_init(hmac_ctx, &Uint8(voidptr(password)), usize(password_len)) < 0
	__c2v_condition_0 = __c2v_condition_1
	if !__c2v_condition_0 {
		mut __c2v_condition_2 := false
		__c2v_condition_2 = pg_hmac_update(hmac_ctx, salt, usize(saltlen)) < 0
		__c2v_condition_0 = __c2v_condition_2
	}
	if !__c2v_condition_0 {
		mut __c2v_condition_3 := false
		__c2v_condition_3 = pg_hmac_update(hmac_ctx, &Uint8(c2v_address_of(&one)), sizeof(Uint32)) < 0
		__c2v_condition_0 = __c2v_condition_3
	}
	if !__c2v_condition_0 {
		mut __c2v_condition_4 := false
		__c2v_condition_4 = pg_hmac_final(hmac_ctx, &ui_prev[0], usize(key_length)) < 0
		__c2v_condition_0 = __c2v_condition_4
	}
	if __c2v_condition_0 {
		unsafe { *errstr = pg_hmac_error(hmac_ctx) }
		pg_hmac_free(hmac_ctx)
		return -1
	}
	C.c2v_memcpy(voidptr(result), voidptr(unsafe { &ui_prev[0] }), u64(key_length))
	for i = 1; i < iterations; i++ {
		mut __c2v_condition_5 := false
		mut __c2v_condition_6 := false
		__c2v_condition_6 = pg_hmac_init(hmac_ctx, &Uint8(voidptr(password)), usize(password_len)) < 0
		__c2v_condition_5 = __c2v_condition_6
		if !__c2v_condition_5 {
			mut __c2v_condition_7 := false
			__c2v_condition_7 = pg_hmac_update(hmac_ctx, &Uint8(unsafe { &ui_prev[0] }), usize(key_length)) < 0
			__c2v_condition_5 = __c2v_condition_7
		}
		if !__c2v_condition_5 {
			mut __c2v_condition_8 := false
			__c2v_condition_8 = pg_hmac_final(hmac_ctx, &ui[0], usize(key_length)) < 0
			__c2v_condition_5 = __c2v_condition_8
		}
		if __c2v_condition_5 {
			unsafe { *errstr = pg_hmac_error(hmac_ctx) }
			pg_hmac_free(hmac_ctx)
			return -1
		}
		for j = 0; j < key_length; j++ {
			result[j] ^= i32(ui[j])
		}
		C.c2v_memcpy(voidptr(unsafe { &ui_prev[0] }), voidptr(unsafe { &ui[0] }), u64(key_length))
	}
	pg_hmac_free(hmac_ctx)
	return 0
}

@[export: 'scram_H']
@[markused]
pub fn scram_h(input &Uint8, hash_type Pg_cryptohash_type, key_length i32, result &Uint8, errstr &&u8) i32 {
	ctx := &Pg_cryptohash_ctx(0)
	ctx = pg_cryptohash_create(hash_type)
	if usize(ctx) == usize((voidptr(0))) {
		unsafe { *errstr = pg_cryptohash_error((voidptr(0))) }
		return -1
	}
	if pg_cryptohash_init(ctx) < 0 || pg_cryptohash_update(ctx, input, usize(key_length)) < 0 || pg_cryptohash_final(ctx, result, usize(key_length)) < 0 {
		unsafe { *errstr = pg_cryptohash_error(ctx) }
		pg_cryptohash_free(ctx)
		return -1
	}
	pg_cryptohash_free(ctx)
	return 0
}

@[export: 'scram_ClientKey']
@[markused]
pub fn scram_client_key(salted_password &Uint8, hash_type Pg_cryptohash_type, key_length i32, result &Uint8, errstr &&u8) i32 {
	ctx := pg_hmac_create(hash_type)
	if usize(ctx) == usize((voidptr(0))) {
		unsafe { *errstr = pg_hmac_error((voidptr(0))) }
		return -1
	}
	mut __c2v_condition_9 := false
	mut __c2v_condition_10 := false
	__c2v_condition_10 = pg_hmac_init(ctx, salted_password, usize(key_length)) < 0
	__c2v_condition_9 = __c2v_condition_10
	if !__c2v_condition_9 {
		mut __c2v_condition_11 := false
		__c2v_condition_11 = pg_hmac_update(ctx, &Uint8(voidptr(c'Client Key')), C.c2v_strlen(c'Client Key')) < 0
		__c2v_condition_9 = __c2v_condition_11
	}
	if !__c2v_condition_9 {
		mut __c2v_condition_12 := false
		__c2v_condition_12 = pg_hmac_final(ctx, result, usize(key_length)) < 0
		__c2v_condition_9 = __c2v_condition_12
	}
	if __c2v_condition_9 {
		unsafe { *errstr = pg_hmac_error(ctx) }
		pg_hmac_free(ctx)
		return -1
	}
	pg_hmac_free(ctx)
	return 0
}

@[export: 'scram_ServerKey']
@[markused]
pub fn scram_server_key(salted_password &Uint8, hash_type Pg_cryptohash_type, key_length i32, result &Uint8, errstr &&u8) i32 {
	ctx := pg_hmac_create(hash_type)
	if usize(ctx) == usize((voidptr(0))) {
		unsafe { *errstr = pg_hmac_error((voidptr(0))) }
		return -1
	}
	mut __c2v_condition_13 := false
	mut __c2v_condition_14 := false
	__c2v_condition_14 = pg_hmac_init(ctx, salted_password, usize(key_length)) < 0
	__c2v_condition_13 = __c2v_condition_14
	if !__c2v_condition_13 {
		mut __c2v_condition_15 := false
		__c2v_condition_15 = pg_hmac_update(ctx, &Uint8(voidptr(c'Server Key')), C.c2v_strlen(c'Server Key')) < 0
		__c2v_condition_13 = __c2v_condition_15
	}
	if !__c2v_condition_13 {
		mut __c2v_condition_16 := false
		__c2v_condition_16 = pg_hmac_final(ctx, result, usize(key_length)) < 0
		__c2v_condition_13 = __c2v_condition_16
	}
	if __c2v_condition_13 {
		unsafe { *errstr = pg_hmac_error(ctx) }
		pg_hmac_free(ctx)
		return -1
	}
	pg_hmac_free(ctx)
	return 0
}

@[export: 'scram_build_secret']
@[markused]
pub fn scram_build_secret(hash_type Pg_cryptohash_type, key_length i32, salt &Uint8, saltlen i32, iterations i32, password &i8, errstr &&u8) &i8 {
	salted_password := [32]Uint8{}
	stored_key := [32]Uint8{}
	server_key := [32]Uint8{}
	result := &i8(0)
	p := &i8(0)
	maxlen := i32(0)
	encoded_salt_len := i32(0)
	encoded_stored_len := i32(0)
	encoded_server_len := i32(0)
	encoded_result := i32(0)

	mut __c2v_condition_17 := false
	mut __c2v_condition_18 := false
	__c2v_condition_18 = scram_salted_password(password, hash_type, key_length, salt, saltlen, iterations, &salted_password[0], errstr) < 0
	__c2v_condition_17 = __c2v_condition_18
	if !__c2v_condition_17 {
		mut __c2v_condition_19 := false
		__c2v_condition_19 = scram_client_key(unsafe { &salted_password[0] }, hash_type, key_length, &stored_key[0], errstr) < 0
		__c2v_condition_17 = __c2v_condition_19
	}
	if !__c2v_condition_17 {
		mut __c2v_condition_20 := false
		__c2v_condition_20 = scram_h(unsafe { &stored_key[0] }, hash_type, key_length, &stored_key[0], errstr) < 0
		__c2v_condition_17 = __c2v_condition_20
	}
	if !__c2v_condition_17 {
		mut __c2v_condition_21 := false
		__c2v_condition_21 = scram_server_key(unsafe { &salted_password[0] }, hash_type, key_length, &server_key[0], errstr) < 0
		__c2v_condition_17 = __c2v_condition_21
	}
	if __c2v_condition_17 {
		return unsafe { nil }
	}
	encoded_salt_len = pg_b64_enc_len(saltlen)
	encoded_stored_len = pg_b64_enc_len(key_length)
	encoded_server_len = pg_b64_enc_len(key_length)
	maxlen = i32(C.c2v_strlen(c'SCRAM-SHA-256') + u64(1) + u64(10) + u64(1) + u64(encoded_salt_len) + u64(1) + u64(encoded_stored_len) + u64(1) + u64(encoded_server_len) + u64(1))
	result = &i8(C.c2v_malloc(u64(maxlen)))
	if isnil(result) {
		unsafe { *errstr = &c'out of memory'[0] }
		return unsafe { nil }
	}
	p = result + pg_sprintf(result, c'SCRAM-SHA-256$%d:', iterations)
	encoded_result = pg_b64_encode(salt, saltlen, p, encoded_salt_len)
	if encoded_result < 0 {
		unsafe { *errstr = &c'could not encode salt'[0] }
		C.c2v_free(voidptr(result))
		return unsafe { nil }
	}
	c2v_pointer_prefix(voidptr(&p), p, isize(encoded_result))
	mut __c2v_lhs_tmp_0 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
	unsafe { *__c2v_lhs_tmp_0 = i8(`$`) }
	encoded_result = pg_b64_encode(unsafe { &stored_key[0] }, key_length, p, encoded_stored_len)
	if encoded_result < 0 {
		unsafe { *errstr = &c'could not encode stored key'[0] }
		C.c2v_free(voidptr(result))
		return unsafe { nil }
	}
	c2v_pointer_prefix(voidptr(&p), p, isize(encoded_result))
	mut __c2v_lhs_tmp_1 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
	unsafe { *__c2v_lhs_tmp_1 = i8(`:`) }
	encoded_result = pg_b64_encode(unsafe { &server_key[0] }, key_length, p, encoded_server_len)
	if encoded_result < 0 {
		unsafe { *errstr = &c'could not encode server key'[0] }
		C.c2v_free(voidptr(result))
		return unsafe { nil }
	}
	c2v_pointer_prefix(voidptr(&p), p, isize(encoded_result))
	mut __c2v_lhs_tmp_2 := unsafe { c2v_pointer_postfix(voidptr(&p), p, isize(1)) }
	unsafe { *__c2v_lhs_tmp_2 = i8(`\0`) }

	return result
}
