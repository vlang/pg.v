@[translated]
module libpq

@[markused]
pub fn libpq_encnames_is_valid_unicode_codepoint(c Pg_wchar) bool {
	return (c > Pg_wchar(false) && c <= Pg_wchar(1114111)) != 0
}

@[markused]
pub fn libpq_encnames_is_utf16_surrogate_first(c Pg_wchar) bool {
	return (c >= Pg_wchar(55296) && c <= Pg_wchar(56319)) != 0
}

@[markused]
pub fn libpq_encnames_is_utf16_surrogate_second(c Pg_wchar) bool {
	return (c >= Pg_wchar(56320) && c <= Pg_wchar(57343)) != 0
}

@[markused]
pub fn libpq_encnames_surrogate_pair_to_codepoint(first Pg_wchar, second Pg_wchar) Pg_wchar {
	return ((first & Pg_wchar(1023)) << 10) + Pg_wchar(65536) + (second & Pg_wchar(1023))
}

@[markused]
pub fn libpq_encnames_utf8_to_unicode(c &u8) Pg_wchar {
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
pub fn libpq_encnames_unicode_to_utf8(c Pg_wchar, utf8string &u8) &u8 {
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
pub fn libpq_encnames_unicode_utf8len(c Pg_wchar) int {
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

pub struct Pg_encname {
pub mut:
	name     &i8
	encoding Pg_enc
}

@[export: 'is_encoding_supported_by_icu']
@[markused]
pub fn is_encoding_supported_by_icu(encoding int) bool {
	if !(encoding >= 0 && encoding <= Pg_enc.pg_koi8u) {
		return false != 0
	}
	return (usize(libpq_encnames_pg_enc2icu_tbl[encoding]) != usize((voidptr(0)))) != 0
}

@[export: 'get_encoding_name_for_icu']
@[markused]
pub fn get_encoding_name_for_icu(encoding int) &i8 {
	if !(encoding >= 0 && encoding <= Pg_enc.pg_koi8u) {
		return unsafe { nil }
	}
	return libpq_encnames_pg_enc2icu_tbl[encoding]
}

@[export: 'pg_valid_client_encoding']
@[markused]
pub fn pg_valid_client_encoding(name &i8) int {
	enc := 0
	enc = pg_char_to_encoding(name)
	if enc < 0 {
		return -1
	}
	if !(enc >= 0 && enc < Pg_enc.pg_last_encoding_) {
		return -1
	}
	return enc
}

@[export: 'pg_valid_server_encoding']
@[markused]
pub fn pg_valid_server_encoding(name &i8) int {
	enc := 0
	enc = pg_char_to_encoding(name)
	if enc < 0 {
		return -1
	}
	if !(enc >= 0 && enc <= Pg_enc.pg_koi8u) {
		return -1
	}
	return enc
}

@[export: 'pg_valid_server_encoding_id']
@[markused]
pub fn pg_valid_server_encoding_id(encoding int) int {
	return int((encoding >= 0 && encoding <= Pg_enc.pg_koi8u))
}

@[markused]
pub fn clean_encoding_name(key &i8, newkey &i8) &i8 {
	p := &i8(0)
	np := &i8(0)
	p = key
	for np = newkey; int((unsafe { *p })) != i8(`\0`); p = unsafe { p + 1 } {
		if C.c2v_isalnum(int(u8((unsafe { *p })))) {
			if int((unsafe { *p })) >= i8(`A`) && int((unsafe { *p })) <= i8(`Z`) {
				mut __c2v_lhs_tmp_0 := unsafe { c2v_pointer_postfix(voidptr(&np), np, isize(1)) }
				unsafe { *__c2v_lhs_tmp_0 = i8(int(*p) + int(`a`) - int(`A`)) }
			} else {
				mut __c2v_lhs_tmp_1 := unsafe { c2v_pointer_postfix(voidptr(&np), np, isize(1)) }
				unsafe { *__c2v_lhs_tmp_1 = *p }
			}
		}
	}
	unsafe { *np = i8(`\0`) }
	return newkey
}

@[export: 'pg_char_to_encoding']
@[markused]
pub fn pg_char_to_encoding(name &i8) int {
	nel := 81
	base := unsafe { &Pg_encname(&libpq_encnames_pg_encname_tbl[0]) }
	last := base + nel - 1
	position := &Pg_encname(0)

	result := 0
	buff := [64]i8{}
	key := &i8(0)

	if usize(name) == usize((voidptr(0))) || int((unsafe { *name })) == i8(`\0`) {
		return -1
	}
	if C.c2v_strlen(name) >= u64(64) {
		return -1
	}
	key = clean_encoding_name(name, unsafe { &i8(&buff[0]) })
	for usize(last) >= usize(base) {
		position = base + ((i64((isize(last) - isize(base)) / isize(sizeof(Pg_encname)))) >> 1)
		result = int(key[0]) - int(position.name[0])
		if result == 0 {
			result = C.c2v_strcmp(key, position.name)
			if result == 0 {
				return int(position.encoding)
			}
		}
		if result < 0 {
			last = position - 1
		} else {
			base = position + 1
		}
	}
	return -1
}

@[export: 'pg_encoding_to_char']
@[markused]
pub fn pg_encoding_to_char(encoding int) &i8 {
	if (encoding >= 0 && encoding < Pg_enc.pg_last_encoding_) {
		p := unsafe { &pg_enc2name_tbl[0] + encoding }

		return p.name
	}
	return unsafe { &i8(&c''[0]) }
}
