@[translated]
module libpq

@[markused]
pub fn libpq_unicode_norm_is_valid_unicode_codepoint(c Pg_wchar) bool {
	return (c > Pg_wchar(false) && c <= Pg_wchar(1114111)) != 0
}

@[markused]
pub fn libpq_unicode_norm_is_utf16_surrogate_first(c Pg_wchar) bool {
	return (c >= Pg_wchar(55296) && c <= Pg_wchar(56319)) != 0
}

@[markused]
pub fn libpq_unicode_norm_is_utf16_surrogate_second(c Pg_wchar) bool {
	return (c >= Pg_wchar(56320) && c <= Pg_wchar(57343)) != 0
}

@[markused]
pub fn libpq_unicode_norm_surrogate_pair_to_codepoint(first Pg_wchar, second Pg_wchar) Pg_wchar {
	return ((first & Pg_wchar(1023)) << 10) + Pg_wchar(65536) + (second & Pg_wchar(1023))
}

@[markused]
pub fn libpq_unicode_norm_utf8_to_unicode(c &u8) Pg_wchar {
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
pub fn libpq_unicode_norm_unicode_to_utf8(c Pg_wchar, utf8string &u8) &u8 {
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
pub fn libpq_unicode_norm_unicode_utf8len(c Pg_wchar) int {
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

pub struct Pg_unicode_decomposition {
pub mut:
	codepoint      Uint32
	comb_class     Uint8
	dec_size_flags Uint8
	dec_index      Uint16
}

@[markused]
pub fn conv_compare(p1 voidptr, p2 voidptr) int {
	c2v_gc_register_thread()
	v1 := Uint32(0)
	v2 := Uint32(0)

	v1 = unsafe { *&Uint32(p1) }
	v2 = (&Pg_unicode_decomposition(p2)).codepoint
	return if (v1 > v2) { 1 } else { (if (v1 == v2) { 0 } else { -1 }) }
}

@[markused]
pub fn get_code_entry(code Pg_wchar) &Pg_unicode_decomposition {
	return C.c2v_bsearch(voidptr(&code), voidptr(unsafe { &libpq_unicode_norm_unicode_decomp_main[0] }), 6843, sizeof(Pg_unicode_decomposition), conv_compare)
}

@[markused]
pub fn get_canonical_class(code Pg_wchar) Uint8 {
	entry := get_code_entry(code)
	if isnil(entry) {
		return Uint8(0)
	} else {
		return entry.comb_class
	}
}

@[markused]
pub fn get_code_decomposition(entry &Pg_unicode_decomposition, dec_size &int) &Pg_wchar {
	if ((int(entry.dec_size_flags) & 64) != 0) {
		get_code_decomposition_x = Pg_wchar(entry.dec_index)
		unsafe { *dec_size = 1 }
		return &get_code_decomposition_x
	} else {
		unsafe { *dec_size = (int(entry.dec_size_flags) & 31) }
		return unsafe { &libpq_unicode_norm_unicode_decomp_codepoints[0] + entry.dec_index }
	}
}

@[markused]
pub fn get_decomposed_size(code Pg_wchar, compat bool) int {
	entry := &Pg_unicode_decomposition(0)
	size := 0
	i := 0
	decomp := &Uint32(0)
	dec_size := 0
	if code >= Pg_wchar(44032) && code < Pg_wchar(44032 + 19 * 21 * 28) {
		tindex := Uint32(0)
		sindex := Uint32(0)

		sindex = code - Pg_wchar(44032)
		tindex = sindex % Uint32(28)
		if tindex != Uint32(0) {
			return 3
		}
		return 2
	}
	entry = get_code_entry(code)
	if usize(entry) == usize((voidptr(0))) || (int(entry.dec_size_flags) & 31) == 0 || (!compat && ((int(entry.dec_size_flags) & 32) != 0)) {
		return 1
	}
	decomp = get_code_decomposition(entry, &dec_size)
	for i = 0; i < dec_size; i++ {
		lcode := decomp[i]
		size += get_decomposed_size(lcode, compat)
	}
	return size
}

@[markused]
pub fn recompose_code(start Uint32, code Uint32, result &Uint32) bool {
	if start >= Uint32(4352) && start < Uint32(4352 + 19) && code >= Uint32(4449) && code < Uint32(4449 + 21) {
		lindex := start - Uint32(4352)
		vindex := code - Uint32(4449)
		unsafe { *result = Uint32(44032) + (lindex * Uint32(21) + vindex) * Uint32(28) }
		return true != 0
	} else if start >= Uint32(44032) && start < Uint32((44032 + 19 * 21 * 28)) && ((start - Uint32(44032)) % Uint32(28)) == Uint32(0) && code > Uint32(4519) && code < Uint32((4519 + 28)) {
		tindex := code - Uint32(4519)
		unsafe { *result = start + tindex }
		return true != 0
	} else {
		entry := &Pg_unicode_decomposition(0)
		i := 0
		for i = 0; u64(i) < 6843; i++ {
			entry = unsafe { &libpq_unicode_norm_unicode_decomp_main[0] + i }
			if (int(entry.dec_size_flags) & 31) != 2 {
				continue
			}
			if ((int(entry.dec_size_flags) & (128 | 32)) != 0) {
				continue
			}
			if start == libpq_unicode_norm_unicode_decomp_codepoints[entry.dec_index] && code == libpq_unicode_norm_unicode_decomp_codepoints[int(entry.dec_index) + 1] {
				unsafe { *result = entry.codepoint }
				return true != 0
			}
		}
	}
	return false != 0
}

@[markused]
pub fn decompose_code(code Pg_wchar, compat bool, result &&Pg_wchar, current &int) {
	entry := &Pg_unicode_decomposition(0)
	i := 0
	decomp := &Uint32(0)
	dec_size := 0
	if code >= Pg_wchar(44032) && code < Pg_wchar(44032 + 19 * 21 * 28) {
		l := Uint32(0)
		v := Uint32(0)
		tindex := Uint32(0)
		sindex := Uint32(0)

		res := (unsafe { *result })
		sindex = code - Pg_wchar(44032)
		l = Uint32(4352) + sindex / Uint32((21 * 28))
		v = Uint32(4449) + (sindex % Uint32((21 * 28))) / Uint32(28)
		tindex = sindex % Uint32(28)
		unsafe { res[*current] = l }
		unsafe { (*current)++ }
		unsafe { res[*current] = v }
		unsafe { (*current)++ }
		if tindex != Uint32(0) {
			unsafe { res[*current] = Uint32(4519) + tindex }
			unsafe { (*current)++ }
		}
		return
	}
	entry = get_code_entry(code)
	if usize(entry) == usize((voidptr(0))) || (int(entry.dec_size_flags) & 31) == 0 || (!compat && ((int(entry.dec_size_flags) & 32) != 0)) {
		res := (unsafe { *result })
		unsafe { res[*current] = code }
		unsafe { (*current)++ }
		return
	}
	decomp = get_code_decomposition(entry, &dec_size)
	for i = 0; i < dec_size; i++ {
		lcode := Pg_wchar(decomp[i])
		decompose_code(lcode, compat, result, current)
	}
}

@[export: 'unicode_normalize']
@[markused]
pub fn unicode_normalize(form UnicodeNormalizationForm, input &Pg_wchar) &Pg_wchar {
	compat := ((u32(form) == u32(UnicodeNormalizationForm.unicode_nfkc) || u32(form) == u32(UnicodeNormalizationForm.unicode_nfkd)) != 0)
	recompose := ((u32(form) == u32(UnicodeNormalizationForm.unicode_nfc) || u32(form) == u32(UnicodeNormalizationForm.unicode_nfkc)) != 0)
	decomp_chars := &Pg_wchar(0)
	recomp_chars := &Pg_wchar(0)
	decomp_size := 0
	current_size := 0

	count := 0
	p := &Pg_wchar(0)
	last_class := 0
	starter_pos := 0
	target_pos := 0
	starter_ch := Uint32(0)
	decomp_size = 0
	for p = input; (unsafe { *p }); p = unsafe { p + 1 } {
		decomp_size += get_decomposed_size((unsafe { *p }), compat)
		if (i64((u64(decomp_size) > (Size(1073741823)) / sizeof(Pg_wchar)) != 0)) {
			return unsafe { nil }
		}
	}
	decomp_chars = &Pg_wchar(C.c2v_malloc(u64((decomp_size + 1)) * sizeof(Pg_wchar)))
	if usize(decomp_chars) == usize((voidptr(0))) {
		return unsafe { nil }
	}
	current_size = 0
	for p = input; (unsafe { *p }); p = unsafe { p + 1 } {
		decompose_code((unsafe { *p }), compat, &&Pg_wchar(&&Pg_wchar(c2v_address_of(&decomp_chars))), &current_size)
	}
	decomp_chars[decomp_size] = Pg_wchar(`\0`)

	if decomp_size == 0 {
		return decomp_chars
	}
	for count = 1; count < decomp_size; count++ {
		prev := decomp_chars[count - 1]
		next := decomp_chars[count]
		tmp := Pg_wchar(0)
		prev_class := get_canonical_class(prev)
		next_class := get_canonical_class(next)
		if int(prev_class) == 0 || int(next_class) == 0 {
			continue
		}
		if int(prev_class) <= int(next_class) {
			continue
		}
		tmp = decomp_chars[count - 1]
		decomp_chars[count - 1] = decomp_chars[count]
		decomp_chars[count] = tmp
		if count > 1 {
			count -= 2
		}
	}
	if !recompose {
		return decomp_chars
	}
	recomp_chars = &Pg_wchar(C.c2v_malloc(u64((decomp_size + 1)) * sizeof(Pg_wchar)))
	if isnil(recomp_chars) {
		C.c2v_free(voidptr(decomp_chars))
		return unsafe { nil }
	}
	last_class = -1
	starter_pos = 0
	target_pos = 1
	recomp_chars[0] = decomp_chars[0]
	starter_ch = recomp_chars[0]
	for count = 1; count < decomp_size; count++ {
		ch := decomp_chars[count]
		ch_class := int(get_canonical_class(ch))
		composite := Pg_wchar(0)
		if last_class < ch_class && int(recompose_code(starter_ch, ch, unsafe { &Uint32(&composite) })) {
			recomp_chars[starter_pos] = composite
			starter_ch = composite
		} else if ch_class == 0 {
			starter_pos = target_pos
			starter_ch = ch
			last_class = -1
			recomp_chars[target_pos++] = ch
		} else {
			last_class = ch_class
			recomp_chars[target_pos++] = ch
		}
	}
	recomp_chars[target_pos] = Pg_wchar(`\0`)
	C.c2v_free(voidptr(decomp_chars))
	return recomp_chars
}
