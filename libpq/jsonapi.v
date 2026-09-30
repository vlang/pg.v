@[translated]
module libpq

pub struct JsonLexContext_jsonapi {
pub mut:
	input                 &i8
	input_length          usize
	input_encoding        int
	token_start           &i8
	token_terminator      &i8
	prev_token_terminator &i8
	incremental           bool
	token_type            JsonTokenType
	lex_level             int
	flags                 Bits32
	line_number           int
	line_start            &i8
	pstack                &JsonParserStack
	inc_state             &JsonIncrementalState
	need_escapes          bool
	strval                &PQExpBufferData
	errormsg              &PQExpBufferData
}

@[markused]
pub fn libpq_jsonapi_is_valid_unicode_codepoint(c Pg_wchar) bool {
	return (c > Pg_wchar(false) && c <= Pg_wchar(1114111)) != 0
}

@[markused]
pub fn libpq_jsonapi_is_utf16_surrogate_first(c Pg_wchar) bool {
	return (c >= Pg_wchar(55296) && c <= Pg_wchar(56319)) != 0
}

@[markused]
pub fn libpq_jsonapi_is_utf16_surrogate_second(c Pg_wchar) bool {
	return (c >= Pg_wchar(56320) && c <= Pg_wchar(57343)) != 0
}

@[markused]
pub fn libpq_jsonapi_surrogate_pair_to_codepoint(first Pg_wchar, second Pg_wchar) Pg_wchar {
	return ((first & Pg_wchar(1023)) << 10) + Pg_wchar(65536) + (second & Pg_wchar(1023))
}

@[markused]
pub fn libpq_jsonapi_utf8_to_unicode(c &u8) Pg_wchar {
	if (int((unsafe { *c })) & 128) == 0 {
		return Pg_wchar(c[0])
	} else if (int((unsafe { *c })) & 224) == 192 {
		return Pg_wchar((((int(c[0]) & 31) << 6) | (int(c[1]) & 63)))
	} else if (int((unsafe { *c })) & 240) == 224 {
		return Pg_wchar((((int(c[0]) & 15) << 12) | ((int(c[1]) & 63) << 6) | (int(c[2]) & 63)))
	} else if (int((unsafe { *c })) & 248) == 240 {
		return Pg_wchar((((int(c[0]) & 7) << 18) | ((int(c[1]) & 63) << 12) | ((int(c[2]) & 63) << 6) | (int(c[3]) & 63)))
	} else {
		return u32(4294967295)
	}
}

@[markused]
pub fn libpq_jsonapi_unicode_to_utf8(c Pg_wchar, utf8string &u8) &u8 {
	if c <= Pg_wchar(127) {
		utf8string[0] = u8(c)
	} else if c <= Pg_wchar(2047) {
		utf8string[0] = u8(Pg_wchar(192) | ((c >> 6) & Pg_wchar(31)))
		utf8string[1] = u8(Pg_wchar(128) | (c & Pg_wchar(63)))
	} else if c <= Pg_wchar(65535) {
		utf8string[0] = u8(Pg_wchar(224) | ((c >> 12) & Pg_wchar(15)))
		utf8string[1] = u8(Pg_wchar(128) | ((c >> 6) & Pg_wchar(63)))
		utf8string[2] = u8(Pg_wchar(128) | (c & Pg_wchar(63)))
	} else {
		utf8string[0] = u8(Pg_wchar(240) | ((c >> 18) & Pg_wchar(7)))
		utf8string[1] = u8(Pg_wchar(128) | ((c >> 12) & Pg_wchar(63)))
		utf8string[2] = u8(Pg_wchar(128) | ((c >> 6) & Pg_wchar(63)))
		utf8string[3] = u8(Pg_wchar(128) | (c & Pg_wchar(63)))
	}
	return utf8string
}

@[markused]
pub fn libpq_jsonapi_unicode_utf8len(c Pg_wchar) int {
	if c <= Pg_wchar(127) {
		return 1
	} else if c <= Pg_wchar(2047) {
		return 2
	} else if c <= Pg_wchar(65535) {
		return 3
	} else {
		return 4
	}
}

pub type Vector8 = u64

@[markused]
pub fn vector8_load(v &Vector8, s &Uint8) {
	C.c2v_memcpy(voidptr(v), voidptr(s), sizeof(Vector8))
}

@[markused]
pub fn vector8_broadcast(c Uint8) Vector8 {
	return ~0 / u64(255) * u64(c)
}

@[markused]
pub fn vector8_has(v Vector8, c Uint8) bool {
	result := false
	result = vector8_has_zero(v ^ vector8_broadcast(c))

	return result
}

@[markused]
pub fn vector8_has_zero(v Vector8) bool {
	return vector8_has_le(v, Uint8(0))
}

@[markused]
pub fn vector8_has_le(v Vector8, c Uint8) bool {
	result := (0 != 0)
	if Int64(v) >= Int64(0) && int(c) < 128 {
		result = ((v - vector8_broadcast(Uint8(int(c) + 1))) & ~v & vector8_broadcast(Uint8(128)) != 0)
	} else {
		for i := Size(0); i < sizeof(Vector8); i++ {
			if int((&Uint8(c2v_address_of(&v)))[i]) <= int(c) {
				result = (1 != 0)
				break
			}
		}
	}

	return result
}

@[markused]
pub fn vector8_is_highbit_set(v Vector8) bool {
	return v & vector8_broadcast(Uint8(128)) != 0
}

@[markused]
pub fn vector8_or(v1 Vector8, v2 Vector8) Vector8 {
	return v1 | v2
}

@[markused]
pub fn pg_lfind8(key Uint8, base &Uint8, nelem Uint32) bool {
	i := Uint32(0)
	tail_idx := Uint32(u64(nelem) & ~(sizeof(Vector8) - u64(1)))
	chunk := Vector8(0)
	for i = Uint32(0); i < tail_idx; i += sizeof(Vector8) {
		vector8_load(&chunk, unsafe { base + i })
		if vector8_has(chunk, key) {
			return true != 0
		}
	}
	for ; i < nelem; i++ {
		if int(key) == int(base[i]) {
			return true != 0
		}
	}
	return false != 0
}

@[markused]
pub fn pg_lfind8_le(key Uint8, base &Uint8, nelem Uint32) bool {
	i := Uint32(0)
	tail_idx := Uint32(u64(nelem) & ~(sizeof(Vector8) - u64(1)))
	chunk := Vector8(0)
	for i = Uint32(0); i < tail_idx; i += sizeof(Vector8) {
		vector8_load(&chunk, unsafe { base + i })
		if vector8_has_le(chunk, key) {
			return true != 0
		}
	}
	for ; i < nelem; i++ {
		if int(base[i]) <= int(key) {
			return true != 0
		}
	}
	return false != 0
}

@[markused]
pub fn pg_lfind32_one_by_one_helper(key Uint32, base &Uint32, nelem Uint32) bool {
	for i := Uint32(0); i < nelem; i++ {
		if key == base[i] {
			return true != 0
		}
	}
	return false != 0
}

@[markused]
pub fn pg_lfind32(key Uint32, base &Uint32, nelem Uint32) bool {
	return pg_lfind32_one_by_one_helper(key, base, nelem)
}

pub enum JsonParseContext {
	json_parse_value
	json_parse_string
	json_parse_array_start
	json_parse_array_next
	json_parse_object_start
	json_parse_object_label
	json_parse_object_next
	json_parse_object_comma
	json_parse_end
}

pub enum JsonNonTerminal {
	json_nt_json = 32
	json_nt_array_elements
	json_nt_more_array_elements
	json_nt_key_pairs
	json_nt_more_key_pairs
}

pub enum JsonParserSem {
	json_sem_ostart = 64
	json_sem_oend
	json_sem_astart
	json_sem_aend
	json_sem_ofield_init
	json_sem_ofield_start
	json_sem_ofield_end
	json_sem_aelem_start
	json_sem_aelem_end
	json_sem_scalar_init
	json_sem_scalar_call
}

pub struct JsonParserStack {
pub mut:
	stack_size int
	prediction &i8
	pred_index usize
	fnames     &&u8
	fnull      &bool
	scalar_tok JsonTokenType
	scalar_val &i8
}

pub struct JsonIncrementalState {
pub mut:
	started           bool
	is_last_chunk     bool
	partial_completed bool
	partial_token     PQExpBufferData
}

pub struct Td_entry {
pub mut:
	len  usize
	prod &i8
}

@[markused]
pub fn lex_peek(lex &JsonLexContext_jsonapi) JsonTokenType {
	return lex.token_type
}

@[markused]
pub fn lex_expect(ctx JsonParseContext, lex &JsonLexContext_jsonapi, token JsonTokenType) JsonParseErrorType {
	if u32(lex_peek(voidptr(lex))) == u32(token) {
		return json_lex(voidptr(lex))
	} else {
		return report_parse_error(ctx, voidptr(lex))
	}
}

@[export: 'IsValidJsonNumber']
@[markused]
pub fn is_valid_json_number(str &i8, len usize) bool {
	numeric_error := false
	total_len := usize(0)
	dummy_lex := JsonLexContext_jsonapi{}

	if len <= usize(0) {
		return false != 0
	}
	if int((unsafe { *str })) == i8(`-`) {
		dummy_lex.input = str + 1
		dummy_lex.input_length = len - usize(1)
	} else {
		dummy_lex.input = str
		dummy_lex.input_length = len
	}
	dummy_lex.token_start = dummy_lex.input
	json_lex_number(voidptr(&dummy_lex), dummy_lex.input, &numeric_error, &total_len)
	return (!numeric_error) && (total_len == dummy_lex.input_length)
}

@[export: 'makeJsonLexContextCstringLen']
@[markused]
pub fn make_json_lex_context_cstring_len(lex_param &JsonLexContext, json &i8, len usize, encoding int, need_escapes bool) &JsonLexContext {
	mut lex := unsafe { &JsonLexContext_jsonapi(voidptr(lex_param)) }
	if usize(lex) == usize((voidptr(0))) {
		lex = C.c2v_calloc(u64(1), sizeof(JsonLexContext_jsonapi))
		if isnil(lex) {
			return unsafe { &JsonLexContext(voidptr(&libpq_jsonapi_failed_oom)) }
		}
		lex.flags |= Bits32((1 << 0))
	} else {
		C.c2v_memset(voidptr(lex), 0, sizeof(JsonLexContext_jsonapi))
	}
	lex.errormsg = (voidptr(0))
	lex.line_start = json
	lex.token_terminator = lex.line_start
	lex.input = lex.token_terminator
	lex.line_number = 1
	lex.input_length = len
	lex.input_encoding = encoding
	lex.need_escapes = need_escapes
	if need_escapes {
		lex.strval = create_pq_exp_buffer()
		lex.flags |= Bits32((1 << 1))
	}
	return unsafe { &JsonLexContext(voidptr(lex)) }
}

@[markused]
pub fn allocate_incremental_state(lex &JsonLexContext_jsonapi) bool {
	pstack := &voidptr(0)
	prediction := &voidptr(0)
	fnames := &voidptr(0)
	fnull := &voidptr(0)

	lex.inc_state = C.c2v_calloc(u64(1), sizeof(JsonIncrementalState))
	pstack = C.c2v_calloc(u64(1), sizeof(JsonParserStack))
	prediction = C.c2v_malloc(u64(64 * 10))
	fnames = C.c2v_malloc(u64(64) * sizeof(voidptr))
	fnull = C.c2v_malloc(u64(64) * sizeof(bool))
	if isnil(lex.inc_state) || isnil(pstack) || isnil(prediction) || isnil(fnames) || isnil(fnull) {
		C.c2v_free(voidptr(lex.inc_state))
		C.c2v_free(voidptr(pstack))
		C.c2v_free(voidptr(prediction))
		C.c2v_free(voidptr(fnames))
		C.c2v_free(voidptr(fnull))
		lex.inc_state = &libpq_jsonapi_failed_inc_oom
		return false != 0
	}
	init_pq_exp_buffer(&lex.inc_state.partial_token)
	lex.pstack = pstack
	lex.pstack.stack_size = 64
	lex.pstack.prediction = &i8(prediction)
	lex.pstack.fnames = fnames
	lex.pstack.fnull = fnull

	lex.pstack.fnames[0] = (voidptr(0))
	lex.incremental = (1 != 0)
	return true != 0
}

@[export: 'makeJsonLexContextIncremental']
@[markused]
pub fn make_json_lex_context_incremental(lex_param &JsonLexContext, encoding int, need_escapes bool) &JsonLexContext {
	mut lex := unsafe { &JsonLexContext_jsonapi(voidptr(lex_param)) }
	if usize(lex) == usize((voidptr(0))) {
		lex = C.c2v_calloc(u64(1), sizeof(JsonLexContext_jsonapi))
		if isnil(lex) {
			return unsafe { &JsonLexContext(voidptr(&libpq_jsonapi_failed_oom)) }
		}
		lex.flags |= Bits32((1 << 0))
	} else {
		C.c2v_memset(voidptr(lex), 0, sizeof(JsonLexContext_jsonapi))
	}
	lex.line_number = 1
	lex.input_encoding = encoding
	if !allocate_incremental_state(voidptr(lex)) {
		if lex.flags & Bits32((1 << 0)) {
			C.c2v_free(voidptr(lex))
			return unsafe { &JsonLexContext(voidptr(&libpq_jsonapi_failed_oom)) }
		}
		return unsafe { &JsonLexContext(voidptr(lex)) }
	}
	lex.need_escapes = need_escapes
	if need_escapes {
		lex.strval = create_pq_exp_buffer()
		lex.flags |= Bits32((1 << 1))
	}
	return unsafe { &JsonLexContext(voidptr(lex)) }
}

@[export: 'setJsonLexContextOwnsTokens']
@[markused]
pub fn set_json_lex_context_owns_tokens(lex_param &JsonLexContext, owned_by_context bool) {
	mut lex := unsafe { &JsonLexContext_jsonapi(voidptr(lex_param)) }
	if int(lex.incremental) && int(lex.inc_state.started) {
		return
	}
	if owned_by_context {
		lex.flags |= Bits32((1 << 2))
	} else {
		lex.flags &= Bits32(~(1 << 2))
	}
}

@[markused]
pub fn inc_lex_level(lex &JsonLexContext_jsonapi) bool {
	if int(lex.incremental) && (lex.lex_level + 1) >= lex.pstack.stack_size {
		new_stack_size := usize(0)
		new_prediction := &i8(0)
		new_fnames := &&u8(0)
		new_fnull := &bool(0)
		new_stack_size = usize(lex.pstack.stack_size + 64)
		new_prediction = &i8(C.c2v_realloc(voidptr(lex.pstack.prediction), new_stack_size * usize(10)))
		if isnil(new_prediction) {
			return false != 0
		}
		lex.pstack.prediction = new_prediction
		new_fnames = C.c2v_realloc(voidptr(lex.pstack.fnames), new_stack_size * sizeof(voidptr))
		if isnil(new_fnames) {
			return false != 0
		}
		lex.pstack.fnames = new_fnames
		new_fnull = C.c2v_realloc(voidptr(lex.pstack.fnull), new_stack_size * sizeof(bool))
		if isnil(new_fnull) {
			return false != 0
		}
		lex.pstack.fnull = new_fnull
		lex.pstack.stack_size = int(new_stack_size)
	}
	lex.lex_level += 1
	if lex.incremental {
		lex.pstack.fnames[lex.lex_level] = (voidptr(0))
	}
	return true != 0
}

@[markused]
pub fn dec_lex_level(lex &JsonLexContext_jsonapi) {
	set_fname(voidptr(lex), (voidptr(0)))
	lex.lex_level -= 1
}

@[markused]
pub fn push_prediction(pstack &JsonParserStack, entry Td_entry) {
	C.c2v_memcpy(voidptr(pstack.prediction + pstack.pred_index), voidptr(entry.prod), entry.len)
	pstack.pred_index += entry.len
}

@[markused]
pub fn pop_prediction(pstack &JsonParserStack) i8 {
	return pstack.prediction[c2v_prefix_add(unsafe { &pstack.pred_index }, u64(-1))]
}

@[markused]
pub fn next_prediction(pstack &JsonParserStack) i8 {
	return pstack.prediction[pstack.pred_index - usize(1)]
}

@[markused]
pub fn have_prediction(pstack &JsonParserStack) bool {
	return pstack.pred_index > usize(false)
}

@[markused]
pub fn set_fname(lex &JsonLexContext_jsonapi, fname &i8) {
	if lex.flags & Bits32((1 << 2)) {
		C.c2v_free(voidptr(lex.pstack.fnames[lex.lex_level]))
	}
	lex.pstack.fnames[lex.lex_level] = fname
}

@[markused]
pub fn get_fname(lex &JsonLexContext_jsonapi) &i8 {
	return lex.pstack.fnames[lex.lex_level]
}

@[markused]
pub fn set_fnull(lex &JsonLexContext_jsonapi, fnull bool) {
	lex.pstack.fnull[lex.lex_level] = fnull
}

@[markused]
pub fn get_fnull(lex &JsonLexContext_jsonapi) bool {
	return lex.pstack.fnull[lex.lex_level]
}

@[export: 'freeJsonLexContext']
@[markused]
pub fn free_json_lex_context(lex_param &JsonLexContext) {
	mut lex := unsafe { &JsonLexContext_jsonapi(voidptr(lex_param)) }
	if !free_json_lex_context_empty_inited {
		free_json_lex_context_empty = JsonLexContext_jsonapi{}

		free_json_lex_context_empty_inited = true
	}

	if isnil(lex) || usize(lex) == usize(&libpq_jsonapi_failed_oom) {
		return
	}
	if lex.flags & Bits32((1 << 1)) {
		destroy_pq_exp_buffer(lex.strval)
	}
	if lex.errormsg {
		destroy_pq_exp_buffer(lex.errormsg)
	}
	if lex.incremental {
		term_pq_exp_buffer(&lex.inc_state.partial_token)
		C.c2v_free(voidptr(lex.inc_state))
		C.c2v_free(voidptr(lex.pstack.prediction))
		if lex.flags & Bits32((1 << 2)) {
			i := 0
			for i = 0; i <= lex.lex_level; i++ {
				C.c2v_free(voidptr(lex.pstack.fnames[i]))
			}
		}
		C.c2v_free(voidptr(lex.pstack.fnames))
		C.c2v_free(voidptr(lex.pstack.fnull))
		C.c2v_free(voidptr(lex.pstack.scalar_val))
		C.c2v_free(voidptr(lex.pstack))
	}
	if lex.flags & Bits32((1 << 0)) {
		C.c2v_free(voidptr(lex))
	} else {
		unsafe { *lex = free_json_lex_context_empty }
	}
}

@[export: 'pg_parse_json']
@[markused]
pub fn pg_parse_json(lex_param &JsonLexContext, sem &JsonSemAction) JsonParseErrorType {
	mut lex := unsafe { &JsonLexContext_jsonapi(voidptr(lex_param)) }
	tok := JsonTokenType{}
	result := JsonParseErrorType{}
	if usize(lex) == usize(&libpq_jsonapi_failed_oom) {
		return JsonParseErrorType.json_out_of_memory
	}
	if lex.incremental {
		return JsonParseErrorType.json_invalid_lexer_type
	}
	result = json_lex(voidptr(lex))
	if u32(result) != u32(JsonParseErrorType.json_success) {
		return result
	}
	tok = lex_peek(voidptr(lex))
	match tok {
		.json_token_object_start {
			result = parse_object(voidptr(lex), sem)
		}
		.json_token_array_start {
			result = parse_array(voidptr(lex), sem)
		}
		else {
			result = parse_scalar(voidptr(lex), sem)
		}
	}

	if u32(result) == u32(JsonParseErrorType.json_success) {
		result = lex_expect(JsonParseContext(JsonParseContext.json_parse_end), voidptr(lex), JsonTokenType(JsonTokenType.json_token_end))
	}
	return result
}

@[export: 'json_count_array_elements']
@[markused]
pub fn json_count_array_elements(lex_param &JsonLexContext, elements &int) JsonParseErrorType {
	mut lex := unsafe { &JsonLexContext_jsonapi(voidptr(lex_param)) }
	copylex := JsonLexContext_jsonapi{}
	count := 0
	result := JsonParseErrorType{}
	if usize(lex) == usize(&libpq_jsonapi_failed_oom) {
		return JsonParseErrorType.json_out_of_memory
	}
	C.c2v_memcpy(voidptr(&copylex), voidptr(lex), sizeof(JsonLexContext_jsonapi))
	copylex.need_escapes = (0 != 0)
	copylex.lex_level++
	count = 0
	result = lex_expect(JsonParseContext(JsonParseContext.json_parse_array_start), voidptr(&copylex), JsonTokenType(JsonTokenType.json_token_array_start))
	if u32(result) != u32(JsonParseErrorType.json_success) {
		return result
	}
	if u32(lex_peek(voidptr(&copylex))) != u32(JsonTokenType.json_token_array_end) {
		for {
			count++
			result = parse_array_element(voidptr(&copylex), &null_sem_action)
			if u32(result) != u32(JsonParseErrorType.json_success) {
				return result
			}
			if u32(copylex.token_type) != u32(JsonTokenType.json_token_comma) {
				break
			}
			result = json_lex(voidptr(&copylex))
			if u32(result) != u32(JsonParseErrorType.json_success) {
				return result
			}
		}
	}
	result = lex_expect(JsonParseContext(JsonParseContext.json_parse_array_next), voidptr(&copylex), JsonTokenType(JsonTokenType.json_token_array_end))
	if u32(result) != u32(JsonParseErrorType.json_success) {
		return result
	}
	unsafe { *elements = count }
	return JsonParseErrorType.json_success
}

@[export: 'pg_parse_json_incremental']
@[markused]
pub fn pg_parse_json_incremental(lex_param &JsonLexContext, sem &JsonSemAction, json &i8, len usize, is_last bool) JsonParseErrorType {
	mut lex := unsafe { &JsonLexContext_jsonapi(voidptr(lex_param)) }
	tok := JsonTokenType{}
	result := JsonParseErrorType{}
	ctx := JsonParseContext.json_parse_value
	pstack := lex.pstack
	if usize(lex) == usize(&libpq_jsonapi_failed_oom) || usize(lex.inc_state) == usize(&libpq_jsonapi_failed_inc_oom) {
		return JsonParseErrorType.json_out_of_memory
	}
	if !lex.incremental {
		return JsonParseErrorType.json_invalid_lexer_type
	}
	lex.line_start = json
	lex.token_terminator = lex.line_start
	lex.input = lex.token_terminator
	lex.input_length = len
	lex.inc_state.is_last_chunk = is_last
	lex.inc_state.started = (1 != 0)
	result = json_lex(voidptr(lex))
	if u32(result) != u32(JsonParseErrorType.json_success) {
		return result
	}
	tok = lex_peek(voidptr(lex))
	if !have_prediction(pstack) {
		goal := Td_entry{
			len: sizeof([3]i8) - u64(1)
			prod: unsafe { &libpq_jsonapi_json_prod_goal[0] }
		}

		push_prediction(pstack, goal)
	}
	for have_prediction(pstack) {
		top := pop_prediction(pstack)
		entry := Td_entry{}
		if u32(top) == u32(tok) {
			if u32(tok) < u32(JsonTokenType.json_token_end) {
				result = json_lex(voidptr(lex))
				if u32(result) != u32(JsonParseErrorType.json_success) {
					return result
				}
				tok = lex_peek(voidptr(lex))
			}
		} else {
			if (int(top) & 32) && usize(c2v_assign[Td_entry](unsafe { &entry }, libpq_jsonapi_td_parser_table[int(top) - int(JsonNonTerminal.json_nt_json)][tok]).prod) != usize((voidptr(0))) {
				push_prediction(pstack, entry)
			} else if (int(top) & 64) {
				match JsonParserSem(int(top)) {
					.json_sem_ostart {
						ostart := sem.object_start
						if lex.lex_level >= 6400 {
							return JsonParseErrorType.json_nesting_too_deep
						}
						if ostart != (voidptr(0)) {
							result = ostart(voidptr(sem.semstate))
							if u32(result) != u32(JsonParseErrorType.json_success) {
								return result
							}
						}
						if !inc_lex_level(voidptr(lex)) {
							return JsonParseErrorType.json_out_of_memory
						}
					}
					.json_sem_oend {
						oend := sem.object_end
						dec_lex_level(voidptr(lex))
						if oend != (voidptr(0)) {
							result = oend(voidptr(sem.semstate))
							if u32(result) != u32(JsonParseErrorType.json_success) {
								return result
							}
						}
					}
					.json_sem_astart {
						astart := sem.array_start
						if lex.lex_level >= 6400 {
							return JsonParseErrorType.json_nesting_too_deep
						}
						if astart != (voidptr(0)) {
							result = astart(voidptr(sem.semstate))
							if u32(result) != u32(JsonParseErrorType.json_success) {
								return result
							}
						}
						if !inc_lex_level(voidptr(lex)) {
							return JsonParseErrorType.json_out_of_memory
						}
					}
					.json_sem_aend {
						aend := sem.array_end
						dec_lex_level(voidptr(lex))
						if aend != (voidptr(0)) {
							result = aend(voidptr(sem.semstate))
							if u32(result) != u32(JsonParseErrorType.json_success) {
								return result
							}
						}
					}
					.json_sem_ofield_init {
						fname := unsafe { &i8(nil) }
						ostart := sem.object_field_start
						oend := sem.object_field_end
						if (ostart != (voidptr(0)) || oend != (voidptr(0))) && int(lex.need_escapes) {
							fname = C.c2v_strdup(lex.strval.data)
							if usize(fname) == usize((voidptr(0))) {
								return JsonParseErrorType.json_out_of_memory
							}
						}
						set_fname(voidptr(lex), fname)
					}
					.json_sem_ofield_start {
						isnull := (u32(tok) == u32(JsonTokenType.json_token_null))
						ostart := sem.object_field_start
						set_fnull(voidptr(lex), isnull)
						if ostart != (voidptr(0)) {
							fname := get_fname(voidptr(lex))
							result = ostart(voidptr(sem.semstate), fname, isnull)
							if u32(result) != u32(JsonParseErrorType.json_success) {
								return result
							}
						}
					}
					.json_sem_ofield_end {
						oend := sem.object_field_end
						if oend != (voidptr(0)) {
							fname := get_fname(voidptr(lex))
							isnull := get_fnull(voidptr(lex))
							result = oend(voidptr(sem.semstate), fname, isnull)
							if u32(result) != u32(JsonParseErrorType.json_success) {
								return result
							}
						}
					}
					.json_sem_aelem_start {
						astart := sem.array_element_start
						isnull := (u32(tok) == u32(JsonTokenType.json_token_null))
						set_fnull(voidptr(lex), isnull)
						if astart != (voidptr(0)) {
							result = astart(voidptr(sem.semstate), isnull)
							if u32(result) != u32(JsonParseErrorType.json_success) {
								return result
							}
						}
					}
					.json_sem_aelem_end {
						aend := sem.array_element_end
						if aend != (voidptr(0)) {
							isnull := get_fnull(voidptr(lex))
							result = aend(voidptr(sem.semstate), isnull)
							if u32(result) != u32(JsonParseErrorType.json_success) {
								return result
							}
						}
					}
					.json_sem_scalar_init {
						sfunc := sem.scalar
						pstack.scalar_val = (voidptr(0))
						if sfunc != (voidptr(0)) {
							if u32(tok) == u32(JsonTokenType.json_token_string) {
								if lex.need_escapes {
									pstack.scalar_val = C.c2v_strdup(lex.strval.data)
									if usize(pstack.scalar_val) == usize((voidptr(0))) {
										return JsonParseErrorType.json_out_of_memory
									}
								}
							} else {
								tlen := (i64((isize(lex.token_terminator) - isize(lex.token_start)) / isize(sizeof(i8))))
								pstack.scalar_val = &i8(C.c2v_malloc(u64(tlen + isize(1))))
								if usize(pstack.scalar_val) == usize((voidptr(0))) {
									return JsonParseErrorType.json_out_of_memory
								}
								C.c2v_memcpy(voidptr(pstack.scalar_val), voidptr(lex.token_start), u64(tlen))
								pstack.scalar_val[tlen] = i8(`\0`)
							}
							pstack.scalar_tok = tok
						}
					}
					.json_sem_scalar_call {
						sfunc := sem.scalar
						if sfunc != (voidptr(0)) {
							result = sfunc(voidptr(sem.semstate), pstack.scalar_val, pstack.scalar_tok)
							if lex.flags & Bits32((1 << 2)) {
								C.c2v_free(voidptr(pstack.scalar_val))
							}
							pstack.scalar_val = (voidptr(0))
							if u32(result) != u32(JsonParseErrorType.json_success) {
								return result
							}
						}
					}
					else {
					}
				}
			} else {
				match int(top) {
					int(JsonTokenType.json_token_string) {
						if int(next_prediction(pstack)) == JsonTokenType.json_token_colon {
							ctx = JsonParseContext.json_parse_string
						} else {
							ctx = JsonParseContext.json_parse_value
						}
					}
					int(JsonTokenType.json_token_number), int(JsonTokenType.json_token_true), int(JsonTokenType.json_token_false), int(JsonTokenType.json_token_null), int(JsonTokenType.json_token_array_start), int(JsonTokenType.json_token_object_start) {
						ctx = JsonParseContext.json_parse_value
					}
					int(JsonTokenType.json_token_array_end) {
						ctx = JsonParseContext.json_parse_array_next
					}
					int(JsonTokenType.json_token_object_end) {
						ctx = JsonParseContext.json_parse_object_next
					}
					int(JsonTokenType.json_token_comma) {
						if int(next_prediction(pstack)) == JsonTokenType.json_token_string {
							ctx = JsonParseContext.json_parse_object_next
						} else {
							ctx = JsonParseContext.json_parse_array_next
						}
					}
					int(JsonTokenType.json_token_colon) {
						ctx = JsonParseContext.json_parse_object_label
					}
					int(JsonTokenType.json_token_end) {
						ctx = JsonParseContext.json_parse_end
					}
					int(JsonNonTerminal.json_nt_more_array_elements) {
						ctx = JsonParseContext.json_parse_array_next
					}
					int(JsonNonTerminal.json_nt_array_elements) {
						ctx = JsonParseContext.json_parse_array_start
					}
					int(JsonNonTerminal.json_nt_more_key_pairs) {
						ctx = JsonParseContext.json_parse_object_next
					}
					int(JsonNonTerminal.json_nt_key_pairs) {
						ctx = JsonParseContext.json_parse_object_start
					}
					else {
						ctx = JsonParseContext.json_parse_value
					}
				}

				return report_parse_error(ctx, voidptr(lex))
			}
		}
	}
	return JsonParseErrorType.json_success
}

@[markused]
pub fn parse_scalar(lex &JsonLexContext_jsonapi, sem &JsonSemAction) JsonParseErrorType {
	val := unsafe { &i8(nil) }
	sfunc := sem.scalar
	tok := lex_peek(voidptr(lex))
	result := JsonParseErrorType{}
	mut __c2v_condition_0 := false
	mut __c2v_condition_1 := false
	__c2v_condition_1 = u32(tok) != u32(JsonTokenType.json_token_string)
	if __c2v_condition_1 {
		__c2v_condition_1 = u32(tok) != u32(JsonTokenType.json_token_number)
	}
	if __c2v_condition_1 {
		__c2v_condition_1 = u32(tok) != u32(JsonTokenType.json_token_true)
	}
	if __c2v_condition_1 {
		__c2v_condition_1 = u32(tok) != u32(JsonTokenType.json_token_false)
	}
	if __c2v_condition_1 {
		__c2v_condition_1 = u32(tok) != u32(JsonTokenType.json_token_null)
	}
	__c2v_condition_0 = __c2v_condition_1
	if __c2v_condition_0 {
		return report_parse_error(JsonParseContext(JsonParseContext.json_parse_value), voidptr(lex))
	}
	if sfunc == (voidptr(0)) {
		return json_lex(voidptr(lex))
	}
	if u32(lex_peek(voidptr(lex))) == u32(JsonTokenType.json_token_string) {
		if lex.need_escapes {
			val = C.c2v_strdup(lex.strval.data)
			if usize(val) == usize((voidptr(0))) {
				return JsonParseErrorType.json_out_of_memory
			}
		}
	} else {
		len := int((i64((isize(lex.token_terminator) - isize(lex.token_start)) / isize(sizeof(i8)))))
		val = &i8(C.c2v_malloc(u64(len + 1)))
		if usize(val) == usize((voidptr(0))) {
			return JsonParseErrorType.json_out_of_memory
		}
		C.c2v_memcpy(voidptr(val), voidptr(lex.token_start), u64(len))
		val[len] = i8(`\0`)
	}
	result = json_lex(voidptr(lex))
	if u32(result) != u32(JsonParseErrorType.json_success) {
		C.c2v_free(voidptr(val))
		return result
	}
	result = sfunc(voidptr(sem.semstate), val, tok)
	if lex.flags & Bits32((1 << 2)) {
		C.c2v_free(voidptr(val))
	}
	return result
}

@[markused]
pub fn parse_object_field(lex &JsonLexContext_jsonapi, sem &JsonSemAction) JsonParseErrorType {
	fname := unsafe { &i8(nil) }
	ostart := sem.object_field_start
	oend := sem.object_field_end
	isnull := false
	tok := JsonTokenType{}
	result := JsonParseErrorType{}
	if u32(lex_peek(voidptr(lex))) != u32(JsonTokenType.json_token_string) {
		return report_parse_error(JsonParseContext(JsonParseContext.json_parse_string), voidptr(lex))
	}
	if (ostart != (voidptr(0)) || oend != (voidptr(0))) && int(lex.need_escapes) {
		fname = C.c2v_strdup(lex.strval.data)
		if usize(fname) == usize((voidptr(0))) {
			return JsonParseErrorType.json_out_of_memory
		}
	}
	result = json_lex(voidptr(lex))
	if u32(result) != u32(JsonParseErrorType.json_success) {
		C.c2v_free(voidptr(fname))
		return result
	}
	result = lex_expect(JsonParseContext(JsonParseContext.json_parse_object_label), voidptr(lex), JsonTokenType(JsonTokenType.json_token_colon))
	if u32(result) != u32(JsonParseErrorType.json_success) {
		C.c2v_free(voidptr(fname))
		return result
	}
	tok = lex_peek(voidptr(lex))
	isnull = (u32(tok) == u32(JsonTokenType.json_token_null))
	if ostart != (voidptr(0)) {
		result = ostart(voidptr(sem.semstate), fname, isnull)
		if u32(result) != u32(JsonParseErrorType.json_success) {
			unsafe {
				goto ofield_cleanup
			}
		}
	}
	match tok {
		.json_token_object_start {
			result = parse_object(voidptr(lex), sem)
		}
		.json_token_array_start {
			result = parse_array(voidptr(lex), sem)
		}
		else {
			result = parse_scalar(voidptr(lex), sem)
		}
	}

	if u32(result) != u32(JsonParseErrorType.json_success) {
		unsafe {
			goto ofield_cleanup
		}
	}
	if oend != (voidptr(0)) {
		result = oend(voidptr(sem.semstate), fname, isnull)
		if u32(result) != u32(JsonParseErrorType.json_success) {
			unsafe {
				goto ofield_cleanup
			}
		}
	}
	ofield_cleanup:
	if lex.flags & Bits32((1 << 2)) {
		C.c2v_free(voidptr(fname))
	}
	return result
}

@[markused]
pub fn parse_object(lex &JsonLexContext_jsonapi, sem &JsonSemAction) JsonParseErrorType {
	ostart := sem.object_start
	oend := sem.object_end
	tok := JsonTokenType{}
	result := JsonParseErrorType{}
	if ostart != (voidptr(0)) {
		result = ostart(voidptr(sem.semstate))
		if u32(result) != u32(JsonParseErrorType.json_success) {
			return result
		}
	}
	lex.lex_level++

	result = json_lex(voidptr(lex))
	if u32(result) != u32(JsonParseErrorType.json_success) {
		return result
	}
	tok = lex_peek(voidptr(lex))
	match tok {
		.json_token_string {
			result = parse_object_field(voidptr(lex), sem)
			for u32(result) == u32(JsonParseErrorType.json_success) && u32(lex_peek(voidptr(lex))) == u32(JsonTokenType.json_token_comma) {
				result = json_lex(voidptr(lex))
				if u32(result) != u32(JsonParseErrorType.json_success) {
					break
				}
				result = parse_object_field(voidptr(lex), sem)
			}
		}
		.json_token_object_end {
		}
		else {
			result = report_parse_error(JsonParseContext(JsonParseContext.json_parse_object_start), voidptr(lex))
		}
	}

	if u32(result) != u32(JsonParseErrorType.json_success) {
		return result
	}
	result = lex_expect(JsonParseContext(JsonParseContext.json_parse_object_next), voidptr(lex), JsonTokenType(JsonTokenType.json_token_object_end))
	if u32(result) != u32(JsonParseErrorType.json_success) {
		return result
	}
	lex.lex_level--
	if oend != (voidptr(0)) {
		result = oend(voidptr(sem.semstate))
		if u32(result) != u32(JsonParseErrorType.json_success) {
			return result
		}
	}
	return JsonParseErrorType.json_success
}

@[markused]
pub fn parse_array_element(lex &JsonLexContext_jsonapi, sem &JsonSemAction) JsonParseErrorType {
	astart := sem.array_element_start
	aend := sem.array_element_end
	tok := lex_peek(voidptr(lex))
	result := JsonParseErrorType{}
	isnull := false
	isnull = (u32(tok) == u32(JsonTokenType.json_token_null))
	if astart != (voidptr(0)) {
		result = astart(voidptr(sem.semstate), isnull)
		if u32(result) != u32(JsonParseErrorType.json_success) {
			return result
		}
	}
	match tok {
		.json_token_object_start {
			result = parse_object(voidptr(lex), sem)
		}
		.json_token_array_start {
			result = parse_array(voidptr(lex), sem)
		}
		else {
			result = parse_scalar(voidptr(lex), sem)
		}
	}

	if u32(result) != u32(JsonParseErrorType.json_success) {
		return result
	}
	if aend != (voidptr(0)) {
		result = aend(voidptr(sem.semstate), isnull)
		if u32(result) != u32(JsonParseErrorType.json_success) {
			return result
		}
	}
	return JsonParseErrorType.json_success
}

@[markused]
pub fn parse_array(lex &JsonLexContext_jsonapi, sem &JsonSemAction) JsonParseErrorType {
	astart := sem.array_start
	aend := sem.array_end
	result := JsonParseErrorType{}
	if astart != (voidptr(0)) {
		result = astart(voidptr(sem.semstate))
		if u32(result) != u32(JsonParseErrorType.json_success) {
			return result
		}
	}
	lex.lex_level++
	result = lex_expect(JsonParseContext(JsonParseContext.json_parse_array_start), voidptr(lex), JsonTokenType(JsonTokenType.json_token_array_start))
	if u32(result) == u32(JsonParseErrorType.json_success) && u32(lex_peek(voidptr(lex))) != u32(JsonTokenType.json_token_array_end) {
		result = parse_array_element(voidptr(lex), sem)
		for u32(result) == u32(JsonParseErrorType.json_success) && u32(lex_peek(voidptr(lex))) == u32(JsonTokenType.json_token_comma) {
			result = json_lex(voidptr(lex))
			if u32(result) != u32(JsonParseErrorType.json_success) {
				break
			}
			result = parse_array_element(voidptr(lex), sem)
		}
	}
	if u32(result) != u32(JsonParseErrorType.json_success) {
		return result
	}
	result = lex_expect(JsonParseContext(JsonParseContext.json_parse_array_next), voidptr(lex), JsonTokenType(JsonTokenType.json_token_array_end))
	if u32(result) != u32(JsonParseErrorType.json_success) {
		return result
	}
	lex.lex_level--
	if aend != (voidptr(0)) {
		result = aend(voidptr(sem.semstate))
		if u32(result) != u32(JsonParseErrorType.json_success) {
			return result
		}
	}
	return JsonParseErrorType.json_success
}

@[export: 'json_lex']
@[markused]
pub fn json_lex(lex_param &JsonLexContext) JsonParseErrorType {
	mut lex := unsafe { &JsonLexContext_jsonapi(voidptr(lex_param)) }
	s := &i8(0)
	end := lex.input + lex.input_length
	result := JsonParseErrorType{}
	if usize(lex) == usize(&libpq_jsonapi_failed_oom) || usize(lex.inc_state) == usize(&libpq_jsonapi_failed_inc_oom) {
		return JsonParseErrorType.json_out_of_memory
	}
	if lex.incremental {
		if lex.inc_state.partial_completed {
			reset_pq_exp_buffer(&lex.inc_state.partial_token)
			lex.token_terminator = lex.input
			lex.inc_state.partial_completed = (0 != 0)
		}
		if (lex.inc_state.partial_token.maxlen == usize(0)) {
			return JsonParseErrorType.json_out_of_memory
		}
	}
	s = lex.token_terminator
	if int(lex.incremental) && lex.inc_state.partial_token.len {
		ptok := &lex.inc_state.partial_token
		added := usize(0)
		tok_done := (0 != 0)
		dummy_lex := JsonLexContext_jsonapi{}

		partial_result := JsonParseErrorType{}
		if int(ptok.data[0]) == i8(`\"`) {
			escapes := 0
			for i := int(ptok.len - usize(1)); i > 0; i-- {
				if int(ptok.data[i]) == i8(`\\`) {
					escapes++
				} else {
					break
				}
			}
			for i := usize(0); i < lex.input_length; i++ {
				c := lex.input[i]
				append_pq_exp_buffer_char(ptok, i8(c))
				added++
				if int(c) == i8(`\"`) && escapes % 2 == 0 {
					tok_done = (1 != 0)
					break
				}
				if int(c) == i8(`\\`) {
					escapes++
				} else {
					escapes = 0
				}
			}
		} else {
			c := ptok.data[0]
			if int(c) == i8(`-`) || (int(c) >= i8(`0`) && int(c) <= i8(`9`)) {
				numend := (0 != 0)
				seen_dot := (0 != 0)
				seen_exp := (0 != 0)
				prev := i8(0)
				for j := 0; usize(j) < ptok.len; j++ {
					pc := ptok.data[j]
					if int(pc) == i8(`.`) {
						seen_dot = (1 != 0)
					} else if int(pc) == i8(`e`) || int(pc) == i8(`E`) {
						seen_exp = (1 != 0)
					}
				}
				prev = ptok.data[ptok.len - usize(1)]
				for i := usize(0); i < lex.input_length && !numend; i++ {
					cc := lex.input[i]
					match int(cc) {
						int(`+`), int(`-`) {
							if int(prev) != i8(`e`) && int(prev) != i8(`E`) {
								numend = (1 != 0)
								unsafe {
									goto c2v_switch_end_48
								}
							}
							append_pq_exp_buffer_char(ptok, i8(cc))
							added++
						}
						int(`.`) {
							if int(seen_dot) || int(seen_exp) {
								numend = (1 != 0)
								unsafe {
									goto c2v_switch_end_48
								}
							}
							seen_dot = (1 != 0)
							append_pq_exp_buffer_char(ptok, i8(cc))
							added++
						}
						int(`e`), int(`E`) {
							if seen_exp {
								numend = (1 != 0)
								unsafe {
									goto c2v_switch_end_48
								}
							}
							seen_exp = (1 != 0)
							append_pq_exp_buffer_char(ptok, i8(cc))
							added++
						}
						int(`0`), int(`1`), int(`2`), int(`3`), int(`4`), int(`5`), int(`6`), int(`7`), int(`8`), int(`9`) {
							append_pq_exp_buffer_char(ptok, i8(cc))
							added++
						}
						else {
							numend = (1 != 0)
						}
					}
					c2v_switch_end_48:

					if !numend {
						prev = cc
					}
				}
			}
			for i := added; i < lex.input_length; i++ {
				cc := lex.input[i]
				if ((int(cc) >= i8(`a`) && int(cc) <= i8(`z`)) || (int(cc) >= i8(`A`) && int(cc) <= i8(`Z`)) || (int(cc) >= i8(`0`) && int(cc) <= i8(`9`)) || int(cc) == i8(`_`) || (int(u8(cc)) & 128)) {
					append_pq_exp_buffer_char(ptok, i8(cc))
					added++
				} else {
					tok_done = (1 != 0)
					break
				}
			}
			if added == lex.input_length && int(lex.inc_state.is_last_chunk) {
				tok_done = (1 != 0)
			}
		}
		if !tok_done {
			if !lex.inc_state.is_last_chunk {
				return JsonParseErrorType.json_incomplete
			}
			lex.token_start = ptok.data
			lex.token_terminator = ptok.data + ptok.len
			return JsonParseErrorType.json_invalid_token
		}
		c2v_pointer_prefix(voidptr(&lex.input), lex.input, isize(added))
		lex.input_length -= added
		dummy_lex.line_start = ptok.data
		dummy_lex.token_terminator = dummy_lex.line_start
		dummy_lex.input = dummy_lex.token_terminator
		dummy_lex.line_number = lex.line_number
		dummy_lex.input_length = ptok.len
		dummy_lex.input_encoding = lex.input_encoding
		dummy_lex.incremental = (0 != 0)
		dummy_lex.need_escapes = lex.need_escapes
		dummy_lex.strval = lex.strval
		partial_result = json_lex(voidptr(&dummy_lex))
		lex.token_type = dummy_lex.token_type
		lex.line_number = dummy_lex.line_number
		lex.prev_token_terminator = (voidptr(0))
		lex.token_start = dummy_lex.token_start
		lex.token_terminator = dummy_lex.token_terminator
		if u32(partial_result) == u32(JsonParseErrorType.json_success) {
			if usize(i64((isize(lex.token_terminator) - isize(lex.token_start)) / isize(sizeof(i8)))) != ptok.len {
				return JsonParseErrorType.json_invalid_token
			}
			lex.inc_state.partial_completed = (1 != 0)
		}
		return partial_result
	}
	for usize(s) < usize(end) && (int((unsafe { *s })) == i8(` `) || int((unsafe { *s })) == i8(`\t`) || int((unsafe { *s })) == i8(`\n`) || int((unsafe { *s })) == i8(`\r`)) {
		if int((unsafe { *c2v_pointer_postfix(voidptr(&s), s, isize(1)) })) == i8(`\n`) {
			lex.line_number++
			lex.line_start = s
		}
	}
	lex.token_start = s
	if usize(s) >= usize(end) {
		lex.token_start = (voidptr(0))
		lex.prev_token_terminator = lex.token_terminator
		lex.token_terminator = s
		lex.token_type = JsonTokenType.json_token_end
	} else {
		match int((unsafe { *s })) {
			int(`{`) {
				lex.prev_token_terminator = lex.token_terminator
				lex.token_terminator = s + 1
				lex.token_type = JsonTokenType.json_token_object_start
			}
			int(`}`) {
				lex.prev_token_terminator = lex.token_terminator
				lex.token_terminator = s + 1
				lex.token_type = JsonTokenType.json_token_object_end
			}
			int(`[`) {
				lex.prev_token_terminator = lex.token_terminator
				lex.token_terminator = s + 1
				lex.token_type = JsonTokenType.json_token_array_start
			}
			int(`]`) {
				lex.prev_token_terminator = lex.token_terminator
				lex.token_terminator = s + 1
				lex.token_type = JsonTokenType.json_token_array_end
			}
			int(`,`) {
				lex.prev_token_terminator = lex.token_terminator
				lex.token_terminator = s + 1
				lex.token_type = JsonTokenType.json_token_comma
			}
			int(`:`) {
				lex.prev_token_terminator = lex.token_terminator
				lex.token_terminator = s + 1
				lex.token_type = JsonTokenType.json_token_colon
			}
			int(`\"`) {
				result = json_lex_string(voidptr(lex))
				if u32(result) != u32(JsonParseErrorType.json_success) {
					return result
				}
				lex.token_type = JsonTokenType.json_token_string
			}
			int(`-`) {
				result = json_lex_number(voidptr(lex), s + 1, (voidptr(0)), (voidptr(0)))
				if u32(result) != u32(JsonParseErrorType.json_success) {
					return result
				}
				lex.token_type = JsonTokenType.json_token_number
			}
			int(`0`), int(`1`), int(`2`), int(`3`), int(`4`), int(`5`), int(`6`), int(`7`), int(`8`), int(`9`) {
				result = json_lex_number(voidptr(lex), s, (voidptr(0)), (voidptr(0)))
				if u32(result) != u32(JsonParseErrorType.json_success) {
					return result
				}
				lex.token_type = JsonTokenType.json_token_number
			}
			else {
				p := &i8(0)
				for p = s; usize(p) < usize(end) && ((int((unsafe { *p })) >= i8(`a`) && int((unsafe { *p })) <= i8(`z`)) || (int((unsafe { *p })) >= i8(`A`) && int((unsafe { *p })) <= i8(`Z`)) || (int((unsafe { *p })) >= i8(`0`) && int((unsafe { *p })) <= i8(`9`)) || int((unsafe { *p })) == i8(`_`) || (int(u8((unsafe { *p }))) & 128)); p = unsafe { p + 1 } {
				}
				if usize(p) == usize(s) {
					lex.prev_token_terminator = lex.token_terminator
					lex.token_terminator = s + 1
					return JsonParseErrorType.json_invalid_token
				}
				if int(lex.incremental) && !lex.inc_state.is_last_chunk && usize(p) == usize(lex.input + lex.input_length) {
					append_binary_pq_exp_buffer(&lex.inc_state.partial_token, s, usize(i64((isize(end) - isize(s)) / isize(sizeof(i8)))))
					return JsonParseErrorType.json_incomplete
				}
				lex.prev_token_terminator = lex.token_terminator
				lex.token_terminator = p
				if i64((isize(p) - isize(s)) / isize(sizeof(i8))) == i64(4) {
					if C.c2v_memcmp(voidptr(s), voidptr(c'true'), u64(4)) == 0 {
						lex.token_type = JsonTokenType.json_token_true
					} else if C.c2v_memcmp(voidptr(s), voidptr(c'null'), u64(4)) == 0 {
						lex.token_type = JsonTokenType.json_token_null
					} else {
						return JsonParseErrorType.json_invalid_token
					}
				} else if i64((isize(p) - isize(s)) / isize(sizeof(i8))) == i64(5) && C.c2v_memcmp(voidptr(s), voidptr(c'false'), u64(5)) == 0 {
					lex.token_type = JsonTokenType.json_token_false
				} else {
					return JsonParseErrorType.json_invalid_token
				}
			}
		}
	}
	if int(lex.incremental) && u32(lex.token_type) == u32(JsonTokenType.json_token_end) && !lex.inc_state.is_last_chunk {
		return JsonParseErrorType.json_incomplete
	} else {
		return JsonParseErrorType.json_success
	}
}

@[markused]
pub fn json_lex_string(lex &JsonLexContext_jsonapi) JsonParseErrorType {
	s := &i8(0)
	end := lex.input + lex.input_length
	hi_surrogate := -1
	if lex.need_escapes {
		if usize(lex.strval) == usize((voidptr(0))) {
			return JsonParseErrorType.json_out_of_memory
		}
		reset_pq_exp_buffer(lex.strval)
	}

	s = lex.token_start
	for {
		c2v_pointer_postfix(voidptr(&s), s, isize(1))
		if usize(s) >= usize(end) {
			for {
				if int(lex.incremental) && !lex.inc_state.is_last_chunk {
					append_binary_pq_exp_buffer(&lex.inc_state.partial_token, lex.token_start, usize(i64((isize(end) - isize(lex.token_start)) / isize(sizeof(i8)))))
					return JsonParseErrorType.json_incomplete
				}
				lex.token_terminator = s
				return JsonParseErrorType.json_invalid_token
			}
		} else if int((unsafe { *s })) == i8(`\"`) {
			break
		} else if int((unsafe { *s })) == i8(`\\`) {
			c2v_pointer_postfix(voidptr(&s), s, isize(1))
			if usize(s) >= usize(end) {
				for {
					if int(lex.incremental) && !lex.inc_state.is_last_chunk {
						append_binary_pq_exp_buffer(&lex.inc_state.partial_token, lex.token_start, usize(i64((isize(end) - isize(lex.token_start)) / isize(sizeof(i8)))))
						return JsonParseErrorType.json_incomplete
					}
					lex.token_terminator = s
					return JsonParseErrorType.json_invalid_token
				}
			} else if int((unsafe { *s })) == i8(`u`) {
				i := 0
				ch := 0
				for i = 1; i <= 4; i++ {
					c2v_pointer_postfix(voidptr(&s), s, isize(1))
					if usize(s) >= usize(end) {
						for {
							if int(lex.incremental) && !lex.inc_state.is_last_chunk {
								append_binary_pq_exp_buffer(&lex.inc_state.partial_token, lex.token_start, usize(i64((isize(end) - isize(lex.token_start)) / isize(sizeof(i8)))))
								return JsonParseErrorType.json_incomplete
							}
							lex.token_terminator = s
							return JsonParseErrorType.json_invalid_token
						}
					} else if int((unsafe { *s })) >= i8(`0`) && int((unsafe { *s })) <= i8(`9`) {
						ch = (ch * 16) + (int((unsafe { *s })) - int(`0`))
					} else if int((unsafe { *s })) >= i8(`a`) && int((unsafe { *s })) <= i8(`f`) {
						ch = (ch * 16) + (int((unsafe { *s })) - int(`a`)) + 10
					} else if int((unsafe { *s })) >= i8(`A`) && int((unsafe { *s })) <= i8(`F`) {
						ch = (ch * 16) + (int((unsafe { *s })) - int(`A`)) + 10
					} else {
						for {
							remaining := i64((isize(end) - isize(s)) / isize(sizeof(i8)))
							charlen := 0
							charlen = pg_encoding_mblen_or_incomplete(lex.input_encoding, s, usize(remaining))
							lex.token_terminator = if (isize(charlen) <= remaining) {
								s + charlen
							} else {
								end
							}
							return JsonParseErrorType.json_unicode_escape_format
						}
					}
				}
				if lex.need_escapes {
					if libpq_jsonapi_is_utf16_surrogate_first(Pg_wchar(ch)) {
						if hi_surrogate != -1 {
							for {
								remaining := i64((isize(end) - isize(s)) / isize(sizeof(i8)))
								charlen := 0
								charlen = pg_encoding_mblen_or_incomplete(lex.input_encoding, s, usize(remaining))
								lex.token_terminator = if (isize(charlen) <= remaining) {
									s + charlen
								} else {
									end
								}
								return JsonParseErrorType.json_unicode_high_surrogate
							}
						}
						hi_surrogate = ch
						continue
					} else if libpq_jsonapi_is_utf16_surrogate_second(Pg_wchar(ch)) {
						if hi_surrogate == -1 {
							for {
								remaining := i64((isize(end) - isize(s)) / isize(sizeof(i8)))
								charlen := 0
								charlen = pg_encoding_mblen_or_incomplete(lex.input_encoding, s, usize(remaining))
								lex.token_terminator = if (isize(charlen) <= remaining) {
									s + charlen
								} else {
									end
								}
								return JsonParseErrorType.json_unicode_low_surrogate
							}
						}
						ch = int(libpq_jsonapi_surrogate_pair_to_codepoint(Pg_wchar(hi_surrogate), Pg_wchar(ch)))
						hi_surrogate = -1
					}
					if hi_surrogate != -1 {
						for {
							remaining := i64((isize(end) - isize(s)) / isize(sizeof(i8)))
							charlen := 0
							charlen = pg_encoding_mblen_or_incomplete(lex.input_encoding, s, usize(remaining))
							lex.token_terminator = if (isize(charlen) <= remaining) {
								s + charlen
							} else {
								end
							}
							return JsonParseErrorType.json_unicode_low_surrogate
						}
					}
					if ch == 0 {
						for {
							remaining := i64((isize(end) - isize(s)) / isize(sizeof(i8)))
							charlen := 0
							charlen = pg_encoding_mblen_or_incomplete(lex.input_encoding, s, usize(remaining))
							lex.token_terminator = if (isize(charlen) <= remaining) {
								s + charlen
							} else {
								end
							}
							return JsonParseErrorType.json_unicode_code_point_zero
						}
					}
					if lex.input_encoding == Pg_enc.pg_utf8 {
						utf8str := [5]i8{}
						utf8len := 0
						libpq_jsonapi_unicode_to_utf8(Pg_wchar(ch), &u8(voidptr(unsafe { &utf8str[0] })))
						utf8len = pg_utf_mblen(&u8(voidptr(unsafe { &utf8str[0] })))
						append_binary_pq_exp_buffer(lex.strval, unsafe { &i8(&utf8str[0]) }, usize(utf8len))
					} else if ch <= 127 {
						append_pq_exp_buffer_char(lex.strval, i8(i8(ch)))
					} else {
						for {
							remaining := i64((isize(end) - isize(s)) / isize(sizeof(i8)))
							charlen := 0
							charlen = pg_encoding_mblen_or_incomplete(lex.input_encoding, s, usize(remaining))
							lex.token_terminator = if (isize(charlen) <= remaining) {
								s + charlen
							} else {
								end
							}
							return JsonParseErrorType.json_unicode_high_escape
						}
					}
				}
			} else if lex.need_escapes {
				if hi_surrogate != -1 {
					for {
						remaining := i64((isize(end) - isize(s)) / isize(sizeof(i8)))
						charlen := 0
						charlen = pg_encoding_mblen_or_incomplete(lex.input_encoding, s, usize(remaining))
						lex.token_terminator = if (isize(charlen) <= remaining) {
							s + charlen
						} else {
							end
						}
						return JsonParseErrorType.json_unicode_low_surrogate
					}
				}
				match int((unsafe { *s })) {
					int(`\"`), int(`\\`), int(`/`) {
						append_pq_exp_buffer_char(lex.strval, i8((unsafe { *s })))
					}
					int(`b`) {
						append_pq_exp_buffer_char(lex.strval, i8(`\b`))
					}
					int(`f`) {
						append_pq_exp_buffer_char(lex.strval, i8(`\f`))
					}
					int(`n`) {
						append_pq_exp_buffer_char(lex.strval, i8(`\n`))
					}
					int(`r`) {
						append_pq_exp_buffer_char(lex.strval, i8(`\r`))
					}
					int(`t`) {
						append_pq_exp_buffer_char(lex.strval, i8(`\t`))
					}
					else {
						lex.token_start = s
						for {
							remaining := i64((isize(end) - isize(s)) / isize(sizeof(i8)))
							charlen := 0
							charlen = pg_encoding_mblen_or_incomplete(lex.input_encoding, s, usize(remaining))
							lex.token_terminator = if (isize(charlen) <= remaining) {
								s + charlen
							} else {
								end
							}
							return JsonParseErrorType.json_escaping_invalid
						}
					}
				}
			} else if usize(C.c2v_strchr(c'"\\/bfnrt', int((unsafe { *s })))) == usize((voidptr(0))) {
				lex.token_start = s
				for {
					remaining := i64((isize(end) - isize(s)) / isize(sizeof(i8)))
					charlen := 0
					charlen = pg_encoding_mblen_or_incomplete(lex.input_encoding, s, usize(remaining))
					lex.token_terminator = if (isize(charlen) <= remaining) {
						s + charlen
					} else {
						end
					}
					return JsonParseErrorType.json_escaping_invalid
				}
			}
		} else {
			p := s
			if hi_surrogate != -1 {
				for {
					remaining := i64((isize(end) - isize(s)) / isize(sizeof(i8)))
					charlen := 0
					charlen = pg_encoding_mblen_or_incomplete(lex.input_encoding, s, usize(remaining))
					lex.token_terminator = if (isize(charlen) <= remaining) {
						s + charlen
					} else {
						end
					}
					return JsonParseErrorType.json_unicode_low_surrogate
				}
			}
			for usize(p) < usize(end - sizeof(Vector8)) && !pg_lfind8(Uint8(`\\`), &Uint8(voidptr(p)), Uint32(sizeof(Vector8))) && !pg_lfind8(Uint8(`\"`), &Uint8(voidptr(p)), Uint32(sizeof(Vector8))) && !pg_lfind8_le(Uint8(31), &Uint8(voidptr(p)), Uint32(sizeof(Vector8))) {
				c2v_pointer_prefix(voidptr(&p), p, isize(sizeof(Vector8)))
			}
			for ; usize(p) < usize(end); p = unsafe { p + 1 } {
				if int((unsafe { *p })) == i8(`\\`) || int((unsafe { *p })) == i8(`\"`) {
					break
				} else if int(u8((unsafe { *p }))) <= 31 {
					lex.token_terminator = p
					return JsonParseErrorType.json_escaping_required
				}
			}
			if lex.need_escapes {
				append_binary_pq_exp_buffer(lex.strval, s, usize(i64((isize(p) - isize(s)) / isize(sizeof(i8)))))
			}
			s = p - 1
		}
	}
	if hi_surrogate != -1 {
		lex.token_terminator = s + 1
		return JsonParseErrorType.json_unicode_low_surrogate
	}
	if int(lex.need_escapes) && (usize((lex.strval)) == usize((voidptr(0))) || lex.strval.maxlen == usize(0)) {
		return JsonParseErrorType.json_out_of_memory
	}
	lex.prev_token_terminator = lex.token_terminator
	lex.token_terminator = s + 1
	return JsonParseErrorType.json_success
}

@[markused]
pub fn json_lex_number(lex &JsonLexContext_jsonapi, s &i8, num_err &bool, total_len &usize) JsonParseErrorType {
	error_ := (0 != 0)
	len := int(i64((isize(s) - isize(lex.input)) / isize(sizeof(i8))))
	if usize(len) < lex.input_length && int((unsafe { *s })) == i8(`0`) {
		c2v_pointer_postfix(voidptr(&s), s, isize(1))
		len++
	} else if usize(len) < lex.input_length && int((unsafe { *s })) >= i8(`1`) && int((unsafe { *s })) <= i8(`9`) {
		for {
			c2v_pointer_postfix(voidptr(&s), s, isize(1))
			len++
			if !(usize(len) < lex.input_length && int((unsafe { *s })) >= i8(`0`) && int((unsafe { *s })) <= i8(`9`)) {
				break
			}
		}
	} else {
		error_ = (1 != 0)
	}
	if usize(len) < lex.input_length && int((unsafe { *s })) == i8(`.`) {
		c2v_pointer_postfix(voidptr(&s), s, isize(1))
		len++
		if usize(len) == lex.input_length || int((unsafe { *s })) < i8(`0`) || int((unsafe { *s })) > i8(`9`) {
			error_ = (1 != 0)
		} else {
			for {
				c2v_pointer_postfix(voidptr(&s), s, isize(1))
				len++
				if !(usize(len) < lex.input_length && int((unsafe { *s })) >= i8(`0`) && int((unsafe { *s })) <= i8(`9`)) {
					break
				}
			}
		}
	}
	if usize(len) < lex.input_length && (int((unsafe { *s })) == i8(`e`) || int((unsafe { *s })) == i8(`E`)) {
		c2v_pointer_postfix(voidptr(&s), s, isize(1))
		len++
		if usize(len) < lex.input_length && (int((unsafe { *s })) == i8(`+`) || int((unsafe { *s })) == i8(`-`)) {
			c2v_pointer_postfix(voidptr(&s), s, isize(1))
			len++
		}
		if usize(len) == lex.input_length || int((unsafe { *s })) < i8(`0`) || int((unsafe { *s })) > i8(`9`) {
			error_ = (1 != 0)
		} else {
			for {
				c2v_pointer_postfix(voidptr(&s), s, isize(1))
				len++
				if !(usize(len) < lex.input_length && int((unsafe { *s })) >= i8(`0`) && int((unsafe { *s })) <= i8(`9`)) {
					break
				}
			}
		}
	}
	for ; usize(len) < lex.input_length && ((int((unsafe { *s })) >= i8(`a`) && int((unsafe { *s })) <= i8(`z`)) || (int((unsafe { *s })) >= i8(`A`) && int((unsafe { *s })) <= i8(`Z`)) || (int((unsafe { *s })) >= i8(`0`) && int((unsafe { *s })) <= i8(`9`)) || int((unsafe { *s })) == i8(`_`) || (int(u8((unsafe { *s }))) & 128)); s = unsafe { s + 1 } {
		error_ = (1 != 0)
		len++
	}
	if usize(total_len) != usize((voidptr(0))) {
		unsafe { *total_len = usize(len) }
	}
	if int(lex.incremental) && !lex.inc_state.is_last_chunk && usize(len) >= lex.input_length {
		append_binary_pq_exp_buffer(&lex.inc_state.partial_token, lex.token_start, usize(i64((isize(s) - isize(lex.token_start)) / isize(sizeof(i8)))))
		if usize(num_err) != usize((voidptr(0))) {
			unsafe { *num_err = error_ }
		}
		return JsonParseErrorType.json_incomplete
	} else if usize(num_err) != usize((voidptr(0))) {
		unsafe { *num_err = error_ }
	} else {
		lex.prev_token_terminator = lex.token_terminator
		lex.token_terminator = s
		if error_ {
			return JsonParseErrorType.json_invalid_token
		}
	}
	return JsonParseErrorType.json_success
}

@[markused]
pub fn report_parse_error(ctx JsonParseContext, lex &JsonLexContext_jsonapi) JsonParseErrorType {
	if usize(lex.token_start) == usize((voidptr(0))) || u32(lex.token_type) == u32(JsonTokenType.json_token_end) {
		return JsonParseErrorType.json_expected_more
	}
	match ctx {
		.json_parse_end {
			return JsonParseErrorType.json_expected_end
		}
		.json_parse_value {
			return JsonParseErrorType.json_expected_json
		}
		.json_parse_string {
			return JsonParseErrorType.json_expected_string
		}
		.json_parse_array_start {
			return JsonParseErrorType.json_expected_array_first
		}
		.json_parse_array_next {
			return JsonParseErrorType.json_expected_array_next
		}
		.json_parse_object_start {
			return JsonParseErrorType.json_expected_object_first
		}
		.json_parse_object_label {
			return JsonParseErrorType.json_expected_colon
		}
		.json_parse_object_next {
			return JsonParseErrorType.json_expected_object_next
		}
		.json_parse_object_comma {
			return JsonParseErrorType.json_expected_string
		}
		else {}
	}

	return JsonParseErrorType.json_success
}

@[export: 'json_errdetail']
@[markused]
pub fn json_errdetail(error_ JsonParseErrorType, lex_param &JsonLexContext) &i8 {
	mut lex := unsafe { &JsonLexContext_jsonapi(voidptr(lex_param)) }
	if u32(error_) == u32(JsonParseErrorType.json_out_of_memory) || usize(lex) == usize(&libpq_jsonapi_failed_oom) {
		return unsafe { &i8(&c'out of memory'[0]) }
	}
	if lex.errormsg {
		reset_pq_exp_buffer(lex.errormsg)
	} else {
		lex.errormsg = create_pq_exp_buffer()
	}
	match error_ {
		.json_incomplete, .json_success {
		}
		.json_invalid_lexer_type {
			if lex.incremental {
				return unsafe { &i8(&c'Recursive descent parser cannot use incremental lexer.'[0]) }
			} else {
				return unsafe { &i8(&c'Incremental parser requires incremental lexer.'[0]) }
			}
		}
		.json_nesting_too_deep {
			return unsafe { &i8(&c'JSON nested too deep, maximum permitted depth is 6400.'[0]) }
		}
		.json_escaping_invalid {
			append_pq_exp_buffer(lex.errormsg, unsafe { &i8(&c'Escape sequence "\\%.*s" is invalid.'[0]) }, int((i64((isize(lex.token_terminator) - isize(lex.token_start)) / isize(sizeof(i8))))), voidptr(lex.token_start))
		}
		.json_escaping_required {
			append_pq_exp_buffer(lex.errormsg, unsafe { &i8(&c'Character with value 0x%02x must be escaped.'[0]) }, int(u8((unsafe { *lex.token_terminator }))))
		}
		.json_expected_end {
			append_pq_exp_buffer(lex.errormsg, unsafe { &i8(&c'Expected end of input, but found "%.*s".'[0]) }, int((i64((isize(lex.token_terminator) - isize(lex.token_start)) / isize(sizeof(i8))))), voidptr(lex.token_start))
		}
		.json_expected_array_first {
			append_pq_exp_buffer(lex.errormsg, unsafe { &i8(&c'Expected array element or "]", but found "%.*s".'[0]) }, int((i64((isize(lex.token_terminator) - isize(lex.token_start)) / isize(sizeof(i8))))), voidptr(lex.token_start))
		}
		.json_expected_array_next {
			append_pq_exp_buffer(lex.errormsg, unsafe { &i8(&c'Expected "," or "]", but found "%.*s".'[0]) }, int((i64((isize(lex.token_terminator) - isize(lex.token_start)) / isize(sizeof(i8))))), voidptr(lex.token_start))
		}
		.json_expected_colon {
			append_pq_exp_buffer(lex.errormsg, unsafe { &i8(&c'Expected ":", but found "%.*s".'[0]) }, int((i64((isize(lex.token_terminator) - isize(lex.token_start)) / isize(sizeof(i8))))), voidptr(lex.token_start))
		}
		.json_expected_json {
			append_pq_exp_buffer(lex.errormsg, unsafe { &i8(&c'Expected JSON value, but found "%.*s".'[0]) }, int((i64((isize(lex.token_terminator) - isize(lex.token_start)) / isize(sizeof(i8))))), voidptr(lex.token_start))
		}
		.json_expected_more {
			return unsafe { &i8(&c'The input string ended unexpectedly.'[0]) }
		}
		.json_expected_object_first {
			append_pq_exp_buffer(lex.errormsg, unsafe { &i8(&c'Expected string or "}", but found "%.*s".'[0]) }, int((i64((isize(lex.token_terminator) - isize(lex.token_start)) / isize(sizeof(i8))))), voidptr(lex.token_start))
		}
		.json_expected_object_next {
			append_pq_exp_buffer(lex.errormsg, unsafe { &i8(&c'Expected "," or "}", but found "%.*s".'[0]) }, int((i64((isize(lex.token_terminator) - isize(lex.token_start)) / isize(sizeof(i8))))), voidptr(lex.token_start))
		}
		.json_expected_string {
			append_pq_exp_buffer(lex.errormsg, unsafe { &i8(&c'Expected string, but found "%.*s".'[0]) }, int((i64((isize(lex.token_terminator) - isize(lex.token_start)) / isize(sizeof(i8))))), voidptr(lex.token_start))
		}
		.json_invalid_token {
			append_pq_exp_buffer(lex.errormsg, unsafe { &i8(&c'Token "%.*s" is invalid.'[0]) }, int((i64((isize(lex.token_terminator) - isize(lex.token_start)) / isize(sizeof(i8))))), voidptr(lex.token_start))
		}
		.json_out_of_memory {
		}
		.json_unicode_code_point_zero {
			return unsafe { &i8(&c'\\u0000 cannot be converted to text.'[0]) }
		}
		.json_unicode_escape_format {
			return unsafe { &i8(&c'"\\u" must be followed by four hexadecimal digits.'[0]) }
		}
		.json_unicode_high_escape {
			return unsafe { &i8(&c'Unicode escape values cannot be used for code point values above 007F when the encoding is not UTF8.'[0]) }
		}
		.json_unicode_untranslatable {
		}
		.json_unicode_high_surrogate {
			return unsafe { &i8(&c'Unicode high surrogate must not follow a high surrogate.'[0]) }
		}
		.json_unicode_low_surrogate {
			return unsafe { &i8(&c'Unicode low surrogate must follow a high surrogate.'[0]) }
		}
		.json_sem_action_failed {
		}
		else {}
	}

	if !isnil(lex.errormsg) && lex.errormsg.len == usize(0) {
		append_pq_exp_buffer(lex.errormsg, c'unexpected json parse error type: %d', int(error_))
	}
	if (usize((lex.errormsg)) == usize((voidptr(0))) || lex.errormsg.maxlen == usize(0)) {
		return unsafe { &i8(&c'out of memory while constructing error description'[0]) }
	}
	return lex.errormsg.data
}
