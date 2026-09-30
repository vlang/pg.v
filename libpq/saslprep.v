@[translated]
module libpq

@[markused]
pub fn libpq_saslprep_is_valid_unicode_codepoint(c Pg_wchar) bool {
	return (c > Pg_wchar(false) && c <= Pg_wchar(1114111)) != 0
}

@[markused]
pub fn libpq_saslprep_is_utf16_surrogate_first(c Pg_wchar) bool {
	return (c >= Pg_wchar(55296) && c <= Pg_wchar(56319)) != 0
}

@[markused]
pub fn libpq_saslprep_is_utf16_surrogate_second(c Pg_wchar) bool {
	return (c >= Pg_wchar(56320) && c <= Pg_wchar(57343)) != 0
}

@[markused]
pub fn libpq_saslprep_surrogate_pair_to_codepoint(first Pg_wchar, second Pg_wchar) Pg_wchar {
	return ((first & Pg_wchar(1023)) << 10) + Pg_wchar(65536) + (second & Pg_wchar(1023))
}

@[markused]
pub fn libpq_saslprep_utf8_to_unicode(c &u8) Pg_wchar {
	if (i32((unsafe { *c })) & 128) == 0 {
		return Pg_wchar(c[0])
	} else if (i32((unsafe { *c })) & 224) == 192 {
		return Pg_wchar((((i32(c[0]) & 31) << 6) | (i32(c[1]) & 63)))
	} else if (i32((unsafe { *c })) & 240) == 224 {
		return Pg_wchar((((i32(c[0]) & 15) << 12) | ((i32(c[1]) & 63) << 6) | (i32(c[2]) & 63)))
	} else if (i32((unsafe { *c })) & 248) == 240 {
		return Pg_wchar((((i32(c[0]) & 7) << 18) | ((i32(c[1]) & 63) << 12) | ((i32(c[2]) & 63) << 6) | (i32(c[3]) & 63)))
	} else {
		return u32(4294967295)
	}
}

@[markused]
pub fn libpq_saslprep_unicode_to_utf8(c Pg_wchar, utf8string &u8) &u8 {
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
pub fn libpq_saslprep_unicode_utf8len(c Pg_wchar) i32 {
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

pub enum UnicodeNormalizationForm {
	unicode_nfc  = 0
	unicode_nfd  = 1
	unicode_nfkc = 2
	unicode_nfkd = 3
}

pub enum UnicodeNormalizationQC {
	unicode_norm_qc_no    = 0
	unicode_norm_qc_yes   = 1
	unicode_norm_qc_maybe = -1
}

pub fn unicode_is_normalized_quickcheck(form UnicodeNormalizationForm, input &Pg_wchar) UnicodeNormalizationQC

@[markused]
pub fn codepoint_range_cmp(a voidptr, b voidptr) i32 {
	c2v_gc_register_thread()
	key := &Pg_wchar(a)
	range := &Pg_wchar(b)
	if (unsafe { *key }) < range[0] {
		return -1
	}
	if (unsafe { *key }) > range[1] {
		return 1
	}
	return 0
}

@[markused]
pub fn is_code_in_table(code Pg_wchar, map_ &Pg_wchar, mapsize i32) bool {
	if code < map_[0] || code > map_[mapsize - 1] {
		return false != 0
	}
	if C.c2v_bsearch(voidptr(&code), voidptr(map_), usize(mapsize / 2), sizeof(Pg_wchar) * u64(2), codepoint_range_cmp) {
		return true != 0
	} else {
		return false != 0
	}
}

@[markused]
pub fn pg_utf8_string_len(source &i8) i32 {
	p := &u8(voidptr(source))
	l := i32(0)
	num_chars := i32(0)
	len := C.c2v_strlen(source)
	for len {
		l = pg_utf_mblen(p)
		if len < usize(l) || !pg_utf8_islegal(p, l) {
			return -1
		}
		c2v_pointer_prefix(voidptr(&p), p, isize(l))
		len -= usize(l)
		num_chars++
	}
	return num_chars
}

@[export: 'pg_saslprep']
@[markused]
pub fn pg_saslprep(input &i8, output &&u8) Pg_saslprep_rc {
	input_chars := unsafe { &Pg_wchar(nil) }
	output_chars := unsafe { &Pg_wchar(nil) }
	input_size := i32(0)
	result := &i8(0)
	result_size := i32(0)
	count := i32(0)
	i := i32(0)
	contains_rand_al_cat := false
	p := &u8(0)
	wp := &Pg_wchar(0)
	unsafe { *output = nil }
	if pg_is_ascii(input) {
		unsafe { *output = C.c2v_strdup(input) }
		if isnil((unsafe { *output })) {
			unsafe {
				goto oom
			}
		}
		return Pg_saslprep_rc.saslprep_success
	}
	input_size = pg_utf8_string_len(input)
	if input_size < 0 {
		return Pg_saslprep_rc.saslprep_invalid_utf8
	}
	if u64(input_size) >= (Size(1073741823)) / sizeof(Pg_wchar) {
		unsafe {
			goto oom
		}
	}
	input_chars = C.c2v_malloc(u64((input_size + 1)) * sizeof(Pg_wchar))
	if isnil(input_chars) {
		unsafe {
			goto oom
		}
	}
	p = &u8(voidptr(input))
	for i = 0; i < input_size; i++ {
		input_chars[i] = libpq_saslprep_utf8_to_unicode(p)
		c2v_pointer_prefix(voidptr(&p), p, isize(pg_utf_mblen(p)))
	}
	input_chars[i] = Pg_wchar(`\0`)
	count = 0
	for i = 0; i < input_size; i++ {
		code := input_chars[i]
		if is_code_in_table(code, &libpq_saslprep_non_ascii_space_ranges[0], 12) {
			input_chars[count++] = Pg_wchar(32)
		} else if is_code_in_table(code, &libpq_saslprep_commonly_mapped_to_nothing_ranges[0], 16) {
		} else {
			input_chars[count++] = code
		}
	}
	input_chars[count] = Pg_wchar(`\0`)
	input_size = count
	if input_size == 0 {
		unsafe {
			goto prohibited
		}
	}
	output_chars = unicode_normalize(UnicodeNormalizationForm(UnicodeNormalizationForm.unicode_nfkc), input_chars)
	if isnil(output_chars) {
		unsafe {
			goto oom
		}
	}
	for i = 0; i < input_size; i++ {
		code := input_chars[i]
		if is_code_in_table(code, &libpq_saslprep_prohibited_output_ranges[0], 72) {
			unsafe {
				goto prohibited
			}
		}
		if is_code_in_table(code, &libpq_saslprep_unassigned_codepoint_ranges[0], 792) {
			unsafe {
				goto prohibited
			}
		}
	}
	contains_rand_al_cat = (0 != 0)
	for i = 0; i < input_size; i++ {
		code := input_chars[i]
		if is_code_in_table(code, &libpq_saslprep_rand_al_cat_codepoint_ranges[0], 68) {
			contains_rand_al_cat = (1 != 0)
			break
		}
	}
	if contains_rand_al_cat {
		first := input_chars[0]
		last := input_chars[input_size - 1]
		for i = 0; i < input_size; i++ {
			code := input_chars[i]
			if is_code_in_table(code, &libpq_saslprep_lc_at_codepoint_ranges[0], 720) {
				unsafe {
					goto prohibited
				}
			}
		}
		if !is_code_in_table(first, &libpq_saslprep_rand_al_cat_codepoint_ranges[0], 68) || !is_code_in_table(last, &libpq_saslprep_rand_al_cat_codepoint_ranges[0], 68) {
			unsafe {
				goto prohibited
			}
		}
	}
	result_size = 0
	for wp = output_chars; (unsafe { *wp }); wp = unsafe { wp + 1 } {
		buf := [4]u8{}
		libpq_saslprep_unicode_to_utf8((unsafe { *wp }), &buf[0])
		result_size += pg_utf_mblen(unsafe { &buf[0] })
	}
	result = &i8(C.c2v_malloc(u64(result_size + 1)))
	if isnil(result) {
		unsafe {
			goto oom
		}
	}
	p = &u8(voidptr(result))
	for wp = output_chars; (unsafe { *wp }); wp = unsafe { wp + 1 } {
		libpq_saslprep_unicode_to_utf8((unsafe { *wp }), p)
		c2v_pointer_prefix(voidptr(&p), p, isize(pg_utf_mblen(p)))
	}

	unsafe { *p = u8(`\0`) }
	C.c2v_free(voidptr(input_chars))
	C.c2v_free(voidptr(output_chars))
	unsafe { *output = result }
	return Pg_saslprep_rc.saslprep_success
	prohibited:
	if input_chars {
		C.c2v_free(voidptr(input_chars))
	}
	if output_chars {
		C.c2v_free(voidptr(output_chars))
	}
	return Pg_saslprep_rc.saslprep_prohibited
	oom:
	if input_chars {
		C.c2v_free(voidptr(input_chars))
	}
	if output_chars {
		C.c2v_free(voidptr(output_chars))
	}
	return Pg_saslprep_rc.saslprep_oom
}
