@[translated]
module libpq

pub fn c2v_address_of(address voidptr) voidptr {
	return address
}

pub enum Pg_saslprep_rc {
	saslprep_success      = 0
	saslprep_oom          = -1
	saslprep_invalid_utf8 = -2
	saslprep_prohibited   = -3
}

@[markused]
pub fn libpq_fe_auth_scram_is_unixsock_path(path &i8) bool {
	return (i32(path[false]) == i8(`/`)) || i32(path[false]) == i8(`@`)
}

pub enum Fe_scram_state_enum {
	fe_scram_init
	fe_scram_nonce_sent
	fe_scram_proof_sent
	fe_scram_finished
}

pub struct Fe_scram_state {
pub mut:
	state                              Fe_scram_state_enum
	conn                               &PGconn
	password                           &i8
	sasl_mechanism                     &i8
	hash_type                          Pg_cryptohash_type
	key_length                         i32
	saltedPassword                     [32]Uint8
	client_nonce                       &i8
	client_first_message_bare          &i8
	client_final_message_without_proof &i8
	server_first_message               &i8
	salt                               &Uint8
	saltlen                            i32
	iterations                         i32
	nonce                              &i8
	server_final_message               &i8
	serverSignature                    [32]Uint8
}

@[markused]
pub fn scram_init(conn &PGconn, password &i8, sasl_mechanism &i8) voidptr {
	c2v_gc_register_thread()
	state := &Fe_scram_state(0)
	prep_password := &i8(0)
	rc := Pg_saslprep_rc{}

	state = &Fe_scram_state(C.c2v_malloc(sizeof(Fe_scram_state)))
	if isnil(state) {
		return unsafe { nil }
	}
	C.c2v_memset(voidptr(state), 0, sizeof(Fe_scram_state))
	state.conn = conn
	state.state = Fe_scram_state_enum.fe_scram_init
	state.key_length = 32
	state.hash_type = Pg_cryptohash_type.pg_sha256
	state.sasl_mechanism = C.c2v_strdup(sasl_mechanism)
	if isnil(state.sasl_mechanism) {
		C.c2v_free(voidptr(state))
		return unsafe { nil }
	}
	if password {
		rc = pg_saslprep(password, &&u8(&&i8(c2v_address_of(&prep_password))))
		if i32(rc) == Pg_saslprep_rc.saslprep_oom {
			C.c2v_free(voidptr(state.sasl_mechanism))
			C.c2v_free(voidptr(state))
			return unsafe { nil }
		}
		if i32(rc) != Pg_saslprep_rc.saslprep_success {
			prep_password = C.c2v_strdup(password)
			if isnil(prep_password) {
				C.c2v_free(voidptr(state.sasl_mechanism))
				C.c2v_free(voidptr(state))
				return unsafe { nil }
			}
		}
		state.password = prep_password
	}
	return state
}

@[markused]
pub fn scram_channel_bound(opaq voidptr) bool {
	c2v_gc_register_thread()
	state := &Fe_scram_state(opaq)
	if usize(state) == usize((voidptr(0))) {
		return false != 0
	}
	if u32(state.state) != u32(Fe_scram_state_enum.fe_scram_finished) {
		return false != 0
	}
	if C.c2v_strcmp(state.sasl_mechanism, c'SCRAM-SHA-256-PLUS') != 0 {
		return false != 0
	}
	return true != 0
}

@[markused]
pub fn scram_free(opaq voidptr) {
	c2v_gc_register_thread()
	state := &Fe_scram_state(opaq)
	C.c2v_free(voidptr(state.password))
	C.c2v_free(voidptr(state.sasl_mechanism))
	C.c2v_free(voidptr(state.client_nonce))
	C.c2v_free(voidptr(state.client_first_message_bare))
	C.c2v_free(voidptr(state.client_final_message_without_proof))
	C.c2v_free(voidptr(state.server_first_message))
	C.c2v_free(voidptr(state.salt))
	C.c2v_free(voidptr(state.nonce))
	C.c2v_free(voidptr(state.server_final_message))
	C.c2v_free(voidptr(state))
}

@[markused]
pub fn scram_exchange(opaq voidptr, final bool, input &i8, inputlen i32, output &&u8, outputlen &i32) SASLStatus {
	c2v_gc_register_thread()
	state := &Fe_scram_state(opaq)
	conn := state.conn
	errstr := unsafe { &i8(nil) }
	unsafe { *output = nil }
	unsafe { *outputlen = 0 }
	if u32(state.state) != u32(Fe_scram_state_enum.fe_scram_init) {
		if inputlen == 0 {
			libpq_append_conn_error(conn, c'malformed SCRAM message (empty message)')
			return SASLStatus.sasl_failed
		}
		if u64(inputlen) != C.c2v_strlen(input) {
			libpq_append_conn_error(conn, c'malformed SCRAM message (length mismatch)')
			return SASLStatus.sasl_failed
		}
	}
	match state.state {
		.fe_scram_init {
			unsafe { *output = build_client_first_message(state) }
			if usize((unsafe { *output })) == usize((voidptr(0))) {
				return SASLStatus.sasl_failed
			}
			unsafe { *outputlen = i32(C.c2v_strlen(*output)) }
			state.state = Fe_scram_state_enum.fe_scram_nonce_sent
			return SASLStatus.sasl_continue
		}
		.fe_scram_nonce_sent {
			if !read_server_first_message(state, input) {
				return SASLStatus.sasl_failed
			}
			unsafe { *output = build_client_final_message(state) }
			if usize((unsafe { *output })) == usize((voidptr(0))) {
				return SASLStatus.sasl_failed
			}
			unsafe { *outputlen = i32(C.c2v_strlen(*output)) }
			state.state = Fe_scram_state_enum.fe_scram_proof_sent
			return SASLStatus.sasl_continue
		}
		.fe_scram_proof_sent {
			match_ := false
			if !read_server_final_message(state, input) {
				return SASLStatus.sasl_failed
			}
			if !verify_server_signature(state, &match_, &&u8(&&i8(c2v_address_of(&errstr)))) {
				libpq_append_conn_error(conn, c'could not verify server signature: %s', voidptr(errstr))
				return SASLStatus.sasl_failed
			}
			if !match_ {
				libpq_append_conn_error(conn, c'incorrect server signature')
			}
			state.state = Fe_scram_state_enum.fe_scram_finished
			state.conn.client_finished_auth = (1 != 0)
			return if i32(match_) { SASLStatus.sasl_complete } else { SASLStatus.sasl_failed }
		}
		else {
			libpq_append_conn_error(conn, c'invalid SCRAM exchange state')
		}
	}

	return SASLStatus.sasl_failed
}

@[markused]
pub fn read_attr_value(input &&u8, attr i8, error_message PQExpBuffer) &i8 {
	begin := (unsafe { *input })
	end := &i8(0)
	if i32((unsafe { *begin })) != i32(attr) {
		libpq_append_error(error_message, c'malformed SCRAM message (attribute "%c" expected)', i32(attr))
		return unsafe { nil }
	}
	c2v_pointer_postfix(voidptr(&begin), begin, isize(1))
	if i32((unsafe { *begin })) != i8(`=`) {
		libpq_append_error(error_message, c'malformed SCRAM message (expected character "=" for attribute "%c")', i32(attr))
		return unsafe { nil }
	}
	c2v_pointer_postfix(voidptr(&begin), begin, isize(1))
	end = begin
	for i32((unsafe { *end })) && i32((unsafe { *end })) != i8(`,`) {
		c2v_pointer_postfix(voidptr(&end), end, isize(1))
	}
	if (unsafe { *end }) {
		unsafe { *end = i8(`\0`) }
		unsafe { *input = end + 1 }
	} else {
		unsafe { *input = end }
	}
	return begin
}

@[markused]
pub fn build_client_first_message(state &Fe_scram_state) &i8 {
	conn := state.conn
	raw_nonce := [19]Uint8{}
	result := &i8(0)
	channel_info_len := i32(0)
	encoded_len := i32(0)
	buf := PQExpBufferData{}
	if !pg_strong_random(voidptr(unsafe { &raw_nonce[0] }), usize(18)) {
		libpq_append_conn_error(conn, c'could not generate nonce')
		return unsafe { nil }
	}
	encoded_len = pg_b64_enc_len(18)
	state.client_nonce = &i8(C.c2v_malloc(u64(encoded_len + 1)))
	if usize(state.client_nonce) == usize((voidptr(0))) {
		libpq_append_conn_error(conn, c'out of memory')
		return unsafe { nil }
	}
	encoded_len = pg_b64_encode(unsafe { &raw_nonce[0] }, 18, state.client_nonce, encoded_len)
	if encoded_len < 0 {
		libpq_append_conn_error(conn, c'could not encode nonce')
		return unsafe { nil }
	}
	state.client_nonce[encoded_len] = i8(`\0`)
	init_pq_exp_buffer(&buf)
	if C.c2v_strcmp(state.sasl_mechanism, c'SCRAM-SHA-256-PLUS') == 0 {
		append_pq_exp_buffer_str(&buf, c'p=tls-server-end-point')
	} else {
		append_pq_exp_buffer_char(&buf, i8(`n`))
	}
	if (buf.maxlen == usize(0)) {
		unsafe {
			goto oom_error
		}
	}
	channel_info_len = i32(buf.len)
	append_pq_exp_buffer(&buf, c',,n=,r=%s', voidptr(state.client_nonce))
	if (buf.maxlen == usize(0)) {
		unsafe {
			goto oom_error
		}
	}
	state.client_first_message_bare = C.c2v_strdup(buf.data + channel_info_len + 2)
	if isnil(state.client_first_message_bare) {
		unsafe {
			goto oom_error
		}
	}
	result = C.c2v_strdup(buf.data)
	if usize(result) == usize((voidptr(0))) {
		unsafe {
			goto oom_error
		}
	}
	term_pq_exp_buffer(&buf)
	return result
	oom_error:
	term_pq_exp_buffer(&buf)
	libpq_append_conn_error(conn, c'out of memory')
	return unsafe { nil }
}

@[markused]
pub fn build_client_final_message(state &Fe_scram_state) &i8 {
	buf := PQExpBufferData{}
	conn := state.conn
	client_proof := [32]Uint8{}
	result := &i8(0)
	encoded_len := i32(0)
	errstr := unsafe { &i8(nil) }
	init_pq_exp_buffer(&buf)
	if C.c2v_strcmp(state.sasl_mechanism, c'SCRAM-SHA-256-PLUS') == 0 {
		term_pq_exp_buffer(&buf)
		append_pq_exp_buffer_str(&conn.errorMessage, c'channel binding not supported by this build\n')
		return unsafe { nil }
	} else {
		append_pq_exp_buffer_str(&buf, c'c=biws')
	}
	if (buf.maxlen == usize(0)) {
		unsafe {
			goto oom_error
		}
	}
	append_pq_exp_buffer(&buf, c',r=%s', voidptr(state.nonce))
	if (buf.maxlen == usize(0)) {
		unsafe {
			goto oom_error
		}
	}
	state.client_final_message_without_proof = C.c2v_strdup(buf.data)
	if usize(state.client_final_message_without_proof) == usize((voidptr(0))) {
		unsafe {
			goto oom_error
		}
	}
	if !calculate_client_proof(state, state.client_final_message_without_proof, &client_proof[0], &&u8(&&i8(c2v_address_of(&errstr)))) {
		term_pq_exp_buffer(&buf)
		libpq_append_conn_error(conn, c'could not calculate client proof: %s', voidptr(errstr))
		return unsafe { nil }
	}
	append_pq_exp_buffer_str(&buf, c',p=')
	encoded_len = pg_b64_enc_len(state.key_length)
	if !enlarge_pq_exp_buffer(&buf, usize(encoded_len)) {
		unsafe {
			goto oom_error
		}
	}
	encoded_len = pg_b64_encode(unsafe { &client_proof[0] }, state.key_length, buf.data + buf.len, encoded_len)
	if encoded_len < 0 {
		term_pq_exp_buffer(&buf)
		libpq_append_conn_error(conn, c'could not encode client proof')
		return unsafe { nil }
	}
	buf.len += usize(encoded_len)
	buf.data[buf.len] = i8(`\0`)
	result = C.c2v_strdup(buf.data)
	if usize(result) == usize((voidptr(0))) {
		unsafe {
			goto oom_error
		}
	}
	term_pq_exp_buffer(&buf)
	return result
	oom_error:
	term_pq_exp_buffer(&buf)
	libpq_append_conn_error(conn, c'out of memory')
	return unsafe { nil }
}

@[markused]
pub fn read_server_first_message(state &Fe_scram_state, input_param &i8) bool {
	mut input := input_param
	conn := state.conn
	iterations_str := &i8(0)
	endptr := &i8(0)
	encoded_salt := &i8(0)
	nonce := &i8(0)
	decoded_salt_len := i32(0)
	state.server_first_message = C.c2v_strdup(input)
	if usize(state.server_first_message) == usize((voidptr(0))) {
		libpq_append_conn_error(conn, c'out of memory')
		return false != 0
	}
	nonce = read_attr_value(&&u8(&&i8(c2v_address_of(&input))), i8(`r`), &conn.errorMessage)
	if usize(nonce) == usize((voidptr(0))) {
		return false != 0
	}
	if C.c2v_strlen(nonce) < C.c2v_strlen(state.client_nonce) || C.c2v_timingsafe_bcmp(voidptr(nonce), voidptr(state.client_nonce), C.c2v_strlen(state.client_nonce)) != 0 {
		libpq_append_conn_error(conn, c'invalid SCRAM response (nonce mismatch)')
		return false != 0
	}
	state.nonce = C.c2v_strdup(nonce)
	if usize(state.nonce) == usize((voidptr(0))) {
		libpq_append_conn_error(conn, c'out of memory')
		return false != 0
	}
	encoded_salt = read_attr_value(&&u8(&&i8(c2v_address_of(&input))), i8(`s`), &conn.errorMessage)
	if usize(encoded_salt) == usize((voidptr(0))) {
		return false != 0
	}
	decoded_salt_len = pg_b64_dec_len(i32(C.c2v_strlen(encoded_salt)))
	state.salt = C.c2v_malloc(u64(decoded_salt_len))
	if usize(state.salt) == usize((voidptr(0))) {
		libpq_append_conn_error(conn, c'out of memory')
		return false != 0
	}
	state.saltlen = pg_b64_decode(encoded_salt, i32(C.c2v_strlen(encoded_salt)), state.salt, decoded_salt_len)
	if state.saltlen < 0 {
		libpq_append_conn_error(conn, c'malformed SCRAM message (invalid salt)')
		return false != 0
	}
	iterations_str = read_attr_value(&&u8(&&i8(c2v_address_of(&input))), i8(`i`), &conn.errorMessage)
	if usize(iterations_str) == usize((voidptr(0))) {
		return false != 0
	}
	state.iterations = i32(C.c2v_strtol(iterations_str, &&u8(&&i8(c2v_address_of(&endptr))), 10))
	if i32((unsafe { *endptr })) != i8(`\0`) || state.iterations < 1 {
		libpq_append_conn_error(conn, c'malformed SCRAM message (invalid iteration count)')
		return false != 0
	}
	if i32((unsafe { *input })) != i8(`\0`) {
		libpq_append_conn_error(conn, c'malformed SCRAM message (garbage at end of server-first-message)')
	}
	return true != 0
}

@[markused]
pub fn read_server_final_message(state &Fe_scram_state, input_param &i8) bool {
	mut input := input_param
	conn := state.conn
	encoded_server_signature := &i8(0)
	decoded_server_signature := &Uint8(0)
	server_signature_len := i32(0)
	state.server_final_message = C.c2v_strdup(input)
	if isnil(state.server_final_message) {
		libpq_append_conn_error(conn, c'out of memory')
		return false != 0
	}
	if i32((unsafe { *input })) == i8(`e`) {
		errmsg := read_attr_value(&&u8(&&i8(c2v_address_of(&input))), i8(`e`), &conn.errorMessage)
		if usize(errmsg) == usize((voidptr(0))) {
			return false != 0
		}
		libpq_append_conn_error(conn, c'error received from server in SCRAM exchange: %s', voidptr(errmsg))
		return false != 0
	}
	encoded_server_signature = read_attr_value(&&u8(&&i8(c2v_address_of(&input))), i8(`v`), &conn.errorMessage)
	if usize(encoded_server_signature) == usize((voidptr(0))) {
		return false != 0
	}
	if i32((unsafe { *input })) != i8(`\0`) {
		libpq_append_conn_error(conn, c'malformed SCRAM message (garbage at end of server-final-message)')
	}
	server_signature_len = pg_b64_dec_len(i32(C.c2v_strlen(encoded_server_signature)))
	decoded_server_signature = C.c2v_malloc(u64(server_signature_len))
	if isnil(decoded_server_signature) {
		libpq_append_conn_error(conn, c'out of memory')
		return false != 0
	}
	server_signature_len = pg_b64_decode(encoded_server_signature, i32(C.c2v_strlen(encoded_server_signature)), decoded_server_signature, server_signature_len)
	if server_signature_len != state.key_length {
		C.c2v_free(voidptr(decoded_server_signature))
		libpq_append_conn_error(conn, c'malformed SCRAM message (invalid server signature)')
		return false != 0
	}
	C.c2v_memcpy(state.serverSignature, voidptr(decoded_server_signature), u64(state.key_length))
	C.c2v_free(voidptr(decoded_server_signature))
	return true != 0
}

@[markused]
pub fn calculate_client_proof(state &Fe_scram_state, client_final_message_without_proof &i8, result &Uint8, errstr &&u8) bool {
	stored_key := [32]Uint8{}
	client_key := [32]Uint8{}
	client_signature := [32]Uint8{}
	i := i32(0)
	ctx := &Pg_hmac_ctx(0)
	ctx = pg_hmac_create(state.hash_type)
	if usize(ctx) == usize((voidptr(0))) {
		unsafe { *errstr = pg_hmac_error((voidptr(0))) }
		return false != 0
	}
	if state.conn.scram_client_key_binary {
		C.c2v_memcpy(voidptr(unsafe { &client_key[0] }), voidptr(state.conn.scram_client_key_binary), u64(32))
	} else {
		mut __c2v_condition_0 := false
		mut __c2v_condition_1 := false
		__c2v_condition_1 = scram_salted_password(state.password, state.hash_type, state.key_length, state.salt, state.saltlen, state.iterations, &state.saltedPassword[0], errstr) < 0
		__c2v_condition_0 = __c2v_condition_1
		if !__c2v_condition_0 {
			mut __c2v_condition_2 := false
			__c2v_condition_2 = scram_client_key(unsafe { &state.saltedPassword[0] }, state.hash_type, state.key_length, &client_key[0], errstr) < 0
			__c2v_condition_0 = __c2v_condition_2
		}
		if __c2v_condition_0 {
			pg_hmac_free(ctx)
			return false != 0
		}
	}
	if scram_h(unsafe { &client_key[0] }, state.hash_type, state.key_length, &stored_key[0], errstr) < 0 {
		pg_hmac_free(ctx)
		return false != 0
	}
	mut __c2v_condition_3 := false
	mut __c2v_condition_4 := false
	__c2v_condition_4 = pg_hmac_init(ctx, unsafe { &stored_key[0] }, usize(state.key_length)) < 0
	__c2v_condition_3 = __c2v_condition_4
	if !__c2v_condition_3 {
		mut __c2v_condition_5 := false
		__c2v_condition_5 = pg_hmac_update(ctx, &Uint8(voidptr(state.client_first_message_bare)), C.c2v_strlen(state.client_first_message_bare)) < 0
		__c2v_condition_3 = __c2v_condition_5
	}
	if !__c2v_condition_3 {
		mut __c2v_condition_6 := false
		__c2v_condition_6 = pg_hmac_update(ctx, &Uint8(voidptr(c',')), usize(1)) < 0
		__c2v_condition_3 = __c2v_condition_6
	}
	if !__c2v_condition_3 {
		mut __c2v_condition_7 := false
		__c2v_condition_7 = pg_hmac_update(ctx, &Uint8(voidptr(state.server_first_message)), C.c2v_strlen(state.server_first_message)) < 0
		__c2v_condition_3 = __c2v_condition_7
	}
	if !__c2v_condition_3 {
		mut __c2v_condition_8 := false
		__c2v_condition_8 = pg_hmac_update(ctx, &Uint8(voidptr(c',')), usize(1)) < 0
		__c2v_condition_3 = __c2v_condition_8
	}
	if !__c2v_condition_3 {
		mut __c2v_condition_9 := false
		__c2v_condition_9 = pg_hmac_update(ctx, &Uint8(voidptr(client_final_message_without_proof)), C.c2v_strlen(client_final_message_without_proof)) < 0
		__c2v_condition_3 = __c2v_condition_9
	}
	if !__c2v_condition_3 {
		mut __c2v_condition_10 := false
		__c2v_condition_10 = pg_hmac_final(ctx, &client_signature[0], usize(state.key_length)) < 0
		__c2v_condition_3 = __c2v_condition_10
	}
	if __c2v_condition_3 {
		unsafe { *errstr = pg_hmac_error(ctx) }
		pg_hmac_free(ctx)
		return false != 0
	}
	for i = 0; i < state.key_length; i++ {
		result[i] = Uint8(i32(client_key[i]) ^ i32(client_signature[i]))
	}
	pg_hmac_free(ctx)
	return true != 0
}

@[markused]
pub fn verify_server_signature(state &Fe_scram_state, match_ &bool, errstr &&u8) bool {
	expected_server_signature := [32]Uint8{}
	server_key := [32]Uint8{}
	ctx := &Pg_hmac_ctx(0)
	ctx = pg_hmac_create(state.hash_type)
	if usize(ctx) == usize((voidptr(0))) {
		unsafe { *errstr = pg_hmac_error((voidptr(0))) }
		return false != 0
	}
	if state.conn.scram_server_key_binary {
		C.c2v_memcpy(voidptr(unsafe { &server_key[0] }), voidptr(state.conn.scram_server_key_binary), u64(32))
	} else {
		if scram_server_key(unsafe { &state.saltedPassword[0] }, state.hash_type, state.key_length, &server_key[0], errstr) < 0 {
			pg_hmac_free(ctx)
			return false != 0
		}
	}
	mut __c2v_condition_11 := false
	mut __c2v_condition_12 := false
	__c2v_condition_12 = pg_hmac_init(ctx, unsafe { &server_key[0] }, usize(state.key_length)) < 0
	__c2v_condition_11 = __c2v_condition_12
	if !__c2v_condition_11 {
		mut __c2v_condition_13 := false
		__c2v_condition_13 = pg_hmac_update(ctx, &Uint8(voidptr(state.client_first_message_bare)), C.c2v_strlen(state.client_first_message_bare)) < 0
		__c2v_condition_11 = __c2v_condition_13
	}
	if !__c2v_condition_11 {
		mut __c2v_condition_14 := false
		__c2v_condition_14 = pg_hmac_update(ctx, &Uint8(voidptr(c',')), usize(1)) < 0
		__c2v_condition_11 = __c2v_condition_14
	}
	if !__c2v_condition_11 {
		mut __c2v_condition_15 := false
		__c2v_condition_15 = pg_hmac_update(ctx, &Uint8(voidptr(state.server_first_message)), C.c2v_strlen(state.server_first_message)) < 0
		__c2v_condition_11 = __c2v_condition_15
	}
	if !__c2v_condition_11 {
		mut __c2v_condition_16 := false
		__c2v_condition_16 = pg_hmac_update(ctx, &Uint8(voidptr(c',')), usize(1)) < 0
		__c2v_condition_11 = __c2v_condition_16
	}
	if !__c2v_condition_11 {
		mut __c2v_condition_17 := false
		__c2v_condition_17 = pg_hmac_update(ctx, &Uint8(voidptr(state.client_final_message_without_proof)), C.c2v_strlen(state.client_final_message_without_proof)) < 0
		__c2v_condition_11 = __c2v_condition_17
	}
	if !__c2v_condition_11 {
		mut __c2v_condition_18 := false
		__c2v_condition_18 = pg_hmac_final(ctx, &expected_server_signature[0], usize(state.key_length)) < 0
		__c2v_condition_11 = __c2v_condition_18
	}
	if __c2v_condition_11 {
		unsafe { *errstr = pg_hmac_error(ctx) }
		pg_hmac_free(ctx)
		return false != 0
	}
	pg_hmac_free(ctx)
	if C.c2v_timingsafe_bcmp(voidptr(unsafe { &expected_server_signature[0] }), state.serverSignature, usize(state.key_length)) != 0 {
		unsafe { *match_ = (0 != 0) }
	} else {
		unsafe { *match_ = (1 != 0) }
	}
	return true != 0
}

@[export: 'pg_fe_scram_build_secret']
@[markused]
pub fn pg_fe_scram_build_secret(password &i8, iterations i32, errstr &&u8) &i8 {
	prep_password := &i8(0)
	rc := Pg_saslprep_rc{}
	saltbuf := [16]Uint8{}
	result := &i8(0)
	rc = pg_saslprep(password, &&u8(&&i8(c2v_address_of(&prep_password))))
	if i32(rc) == Pg_saslprep_rc.saslprep_oom {
		unsafe { *errstr = &c'out of memory'[0] }
		return unsafe { nil }
	}
	if i32(rc) == Pg_saslprep_rc.saslprep_success {
		password = &i8(prep_password)
	}
	if !pg_strong_random(voidptr(unsafe { &saltbuf[0] }), usize(16)) {
		unsafe { *errstr = &c'could not generate random salt'[0] }
		C.c2v_free(voidptr(prep_password))
		return unsafe { nil }
	}
	result = scram_build_secret(Pg_cryptohash_type.pg_sha256, 32, unsafe { &saltbuf[0] }, 16, iterations, password, errstr)
	C.c2v_free(voidptr(prep_password))
	return result
}
