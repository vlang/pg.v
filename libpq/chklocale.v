@[translated]
module libpq

pub type Pg_wchar = u32

pub enum Pg_enc {
	pg_sql_ascii = 0
	pg_euc_jp
	pg_euc_cn
	pg_euc_kr
	pg_euc_tw
	pg_euc_jis_2004
	pg_utf8
	pg_mule_internal
	pg_latin1
	pg_latin2
	pg_latin3
	pg_latin4
	pg_latin5
	pg_latin6
	pg_latin7
	pg_latin8
	pg_latin9
	pg_latin10
	pg_win1256
	pg_win1258
	pg_win866
	pg_win874
	pg_koi8r
	pg_win1251
	pg_win1252
	pg_iso_8859_5
	pg_iso_8859_6
	pg_iso_8859_7
	pg_iso_8859_8
	pg_win1250
	pg_win1253
	pg_win1254
	pg_win1255
	pg_win1257
	pg_koi8u
	pg_sjis
	pg_big5
	pg_gbk
	pg_uhc
	pg_gb18030
	pg_johab
	pg_shift_jis_2004
	pg_last_encoding_
}

pub struct Pg_enc2name {
pub mut:
	name     &i8
	encoding Pg_enc
}

pub type Mb2wchar_with_len_converter = fn (&u8, &Pg_wchar, i32) i32

pub type Wchar2mb_with_len_converter = fn (&Pg_wchar, &u8, i32) i32

pub type Mblen_converter = fn (&u8) i32

pub type Mbdisplaylen_converter = fn (&u8) i32

pub type Mbcharacter_incrementer = fn (&u8, i32) bool

pub type Mbchar_verifier = fn (&u8, i32) i32

pub type Mbstr_verifier = fn (&u8, i32) i32

pub struct Pg_wchar_tbl {
pub mut:
	mb2wchar_with_len Mb2wchar_with_len_converter
	wchar2mb_with_len Wchar2mb_with_len_converter
	mblen             Mblen_converter
	dsplen            Mbdisplaylen_converter
	mbverifychar      Mbchar_verifier
	mbverifystr       Mbstr_verifier
	maxmblen          i32
}

pub struct Pg_mb_radix_tree {
pub mut:
	chars16    &Uint16
	chars32    &Uint32
	b1root     Uint32
	b1_lower   Uint8
	b1_upper   Uint8
	b2root     Uint32
	b2_1_lower Uint8
	b2_1_upper Uint8
	b2_2_lower Uint8
	b2_2_upper Uint8
	b3root     Uint32
	b3_1_lower Uint8
	b3_1_upper Uint8
	b3_2_lower Uint8
	b3_2_upper Uint8
	b3_3_lower Uint8
	b3_3_upper Uint8
	b4root     Uint32
	b4_1_lower Uint8
	b4_1_upper Uint8
	b4_2_lower Uint8
	b4_2_upper Uint8
	b4_3_lower Uint8
	b4_3_upper Uint8
	b4_4_lower Uint8
	b4_4_upper Uint8
}

pub struct Pg_utf_to_local_combined {
pub mut:
	utf1 Uint32
	utf2 Uint32
	code Uint32
}

pub struct Pg_local_to_utf_combined {
pub mut:
	code Uint32
	utf1 Uint32
	utf2 Uint32
}

pub type Utf_local_conversion_func = fn (Uint32) Uint32

@[markused]
pub fn is_valid_unicode_codepoint(c Pg_wchar) bool {
	return (c > Pg_wchar(false) && c <= Pg_wchar(1114111)) != 0
}

@[markused]
pub fn is_utf16_surrogate_first(c Pg_wchar) bool {
	return (c >= Pg_wchar(55296) && c <= Pg_wchar(56319)) != 0
}

@[markused]
pub fn is_utf16_surrogate_second(c Pg_wchar) bool {
	return (c >= Pg_wchar(56320) && c <= Pg_wchar(57343)) != 0
}

@[markused]
pub fn surrogate_pair_to_codepoint(first Pg_wchar, second Pg_wchar) Pg_wchar {
	return ((first & Pg_wchar(1023)) << 10) + Pg_wchar(65536) + (second & Pg_wchar(1023))
}

@[markused]
pub fn utf8_to_unicode(c &u8) Pg_wchar {
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
pub fn unicode_to_utf8(c Pg_wchar, utf8string &u8) &u8 {
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
pub fn unicode_utf8len(c Pg_wchar) i32 {
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

pub fn pg_mb2wchar(from &i8, to &Pg_wchar) i32

pub fn pg_mb2wchar_with_len(from &i8, to &Pg_wchar, len i32) i32

pub fn pg_encoding_mb2wchar_with_len(encoding i32, from &i8, to &Pg_wchar, len i32) i32

pub fn pg_wchar2mb(from &Pg_wchar, to &i8) i32

pub fn pg_wchar2mb_with_len(from &Pg_wchar, to &i8, len i32) i32

pub fn pg_encoding_wchar2mb_with_len(encoding i32, from &Pg_wchar, to &i8, len i32) i32

pub fn pg_char_and_wchar_strcmp(s1 &i8, s2 &Pg_wchar) i32

pub fn pg_wchar_strncmp(s1 &Pg_wchar, s2 &Pg_wchar, n usize) i32

pub fn pg_char_and_wchar_strncmp(s1 &i8, s2 &Pg_wchar, n usize) i32

pub fn pg_wchar_strlen(str &Pg_wchar) usize

pub fn pg_mblen_cstr(mbstr &i8) i32

pub fn pg_mblen_range(mbstr &i8, end &i8) i32

pub fn pg_mblen_with_len(mbstr &i8, limit i32) i32

pub fn pg_mblen_unbounded(mbstr &i8) i32

pub fn pg_mblen(mbstr &i8) i32

pub fn pg_dsplen(mbstr &i8) i32

pub fn pg_mbstrlen(mbstr &i8) i32

pub fn pg_mbstrlen_with_len(mbstr &i8, limit i32) i32

pub fn pg_mbcliplen(mbstr &i8, len i32, limit i32) i32

pub fn pg_encoding_mbcliplen(encoding i32, mbstr &i8, len i32, limit i32) i32

pub fn pg_mbcharcliplen(mbstr &i8, len i32, limit i32) i32

pub fn pg_database_encoding_max_length() i32

pub fn pg_database_encoding_character_incrementer() Mbcharacter_incrementer

@[c:'PrepareClientEncoding']
pub fn prepare_client_encoding(encoding i32) i32

@[c:'SetClientEncoding']
pub fn set_client_encoding(encoding i32) i32

@[c:'InitializeClientEncoding']
pub fn initialize_client_encoding()

pub fn pg_get_client_encoding() i32

pub fn pg_get_client_encoding_name() &i8

@[c:'SetDatabaseEncoding']
pub fn set_database_encoding(encoding i32)

@[c:'GetDatabaseEncoding']
pub fn get_database_encoding() i32

@[c:'GetDatabaseEncodingName']
pub fn get_database_encoding_name() &i8

@[c:'SetMessageEncoding']
pub fn set_message_encoding(encoding i32)

@[c:'GetMessageEncoding']
pub fn get_message_encoding() i32

pub fn pg_do_encoding_conversion(src &u8, len i32, src_encoding i32, dest_encoding i32) &u8

pub fn pg_do_encoding_conversion_buf(proc Oid, src_encoding i32, dest_encoding i32, src &u8, srclen i32, dest &u8, destlen i32, no_error bool) i32

pub fn pg_client_to_server(s &i8, len i32) &i8

pub fn pg_server_to_client(s &i8, len i32) &i8

pub fn pg_any_to_server(s &i8, len i32, encoding i32) &i8

pub fn pg_server_to_any(s &i8, len i32, encoding i32) &i8

pub fn pg_unicode_to_server(c Pg_wchar, s &u8)

pub fn pg_unicode_to_server_noerror(c Pg_wchar, s &u8) bool

@[c:'BIG5toCNS']
pub fn big_5to_cns(big5 u16, lc &u8) u16

@[c:'CNStoBIG5']
pub fn cn_sto_big_5(cns u16, lc u8) u16

@[c:'UtfToLocal']
pub fn utf_to_local(utf &u8, len i32, iso &u8, map_ &Pg_mb_radix_tree, cmap &Pg_utf_to_local_combined, cmapsize i32, conv_func Utf_local_conversion_func, encoding i32, no_error bool) i32

@[c:'LocalToUtf']
pub fn local_to_utf(iso &u8, len i32, utf &u8, map_ &Pg_mb_radix_tree, cmap &Pg_local_to_utf_combined, cmapsize i32, conv_func Utf_local_conversion_func, encoding i32, no_error bool) i32

pub fn pg_verifymbstr(mbstr &i8, len i32, no_error bool) bool

pub fn pg_verify_mbstr(encoding i32, mbstr &i8, len i32, no_error bool) bool

pub fn pg_verify_mbstr_len(encoding i32, mbstr &i8, len i32, no_error bool) i32

pub fn check_encoding_conversion_args(src_encoding i32, dest_encoding i32, len i32, expected_src_encoding i32, expected_dest_encoding i32)

pub fn local2local(l &u8, p &u8, len i32, src_encoding i32, dest_encoding i32, tab &u8, no_error bool) i32

pub fn latin2mic(l &u8, p &u8, len i32, lc i32, encoding i32, no_error bool) i32

pub fn mic2latin(mic &u8, p &u8, len i32, lc i32, encoding i32, no_error bool) i32

pub fn latin2mic_with_table(l &u8, p &u8, len i32, lc i32, encoding i32, tab &u8, no_error bool) i32

pub fn mic2latin_with_table(mic &u8, p &u8, len i32, lc i32, encoding i32, tab &u8, no_error bool) i32

pub struct Encoding_match {
pub mut:
	pg_enc_code     Pg_enc
	system_enc_name &i8
}

@[export: 'pg_get_encoding_from_locale']
@[markused]
pub fn pg_get_encoding_from_locale(ctype &i8, write_message bool) i32 {
	sys := &i8(0)
	i := i32(0)
	loc := voidptr(0)
	if isnil(ctype) {
		ctype = C.c2v_setlocale(2, (voidptr(0)))
	}
	if pg_strcasecmp(ctype, c'C') == 0 || pg_strcasecmp(ctype, c'POSIX') == 0 {
		return i32(Pg_enc.pg_sql_ascii)
	}
	loc = C.c2v_newlocale((1 << 1), ctype, voidptr(0))
	if usize(loc) == usize(voidptr(0)) {
		return -1
	}
	sys = C.c2v_nl_langinfo_l(0, voidptr(loc))
	if sys {
		sys = C.c2v_strdup(sys)
	}
	C.c2v_freelocale(voidptr(loc))
	if isnil(sys) {
		return -1
	}
	for i = 0; libpq_chklocale_encoding_match_list[i].system_enc_name; i++ {
		if pg_strcasecmp(sys, libpq_chklocale_encoding_match_list[i].system_enc_name) == 0 {
			C.c2v_free(voidptr(sys))
			return i32(libpq_chklocale_encoding_match_list[i].pg_enc_code)
		}
	}
	if C.c2v_strlen(sys) == u64(0) {
		C.c2v_free(voidptr(sys))
		return i32(Pg_enc.pg_utf8)
	}
	if write_message {
		pg_fprintf(C.stderr, unsafe { &i8(&c'could not determine encoding for locale "%s": codeset is "%s"'[0]) }, voidptr(ctype), voidptr(sys))
		C.c2v_fputc(`\n`, C.stderr)
	}
	C.c2v_free(voidptr(sys))
	return -1
}
