@[translated]
module libpq

@[export: 'pg_strcasecmp']
@[markused]
pub fn pg_strcasecmp(s1 &i8, s2 &i8) int {
	for {
		ch1 := u8((unsafe { *c2v_pointer_postfix(voidptr(&s1), s1, isize(1)) }))
		ch2 := u8((unsafe { *c2v_pointer_postfix(voidptr(&s2), s2, isize(1)) }))
		if int(ch1) != int(ch2) {
			if int(ch1) >= `A` && int(ch1) <= `Z` {
				ch1 += int(`a`) - int(`A`)
			} else if (int(u8(ch1)) & 128) && C.c2v_isupper(int(ch1)) {
				ch1 = u8(C.c2v_tolower(int(ch1)))
			}
			if int(ch2) >= `A` && int(ch2) <= `Z` {
				ch2 += int(`a`) - int(`A`)
			} else if (int(u8(ch2)) & 128) && C.c2v_isupper(int(ch2)) {
				ch2 = u8(C.c2v_tolower(int(ch2)))
			}
			if int(ch1) != int(ch2) {
				return int(ch1) - int(ch2)
			}
		}
		if int(ch1) == 0 {
			break
		}
	}
	return 0
}

@[export: 'pg_strncasecmp']
@[markused]
pub fn pg_strncasecmp(s1 &i8, s2 &i8, n usize) int {
	for n-- > usize(0) {
		ch1 := u8((unsafe { *c2v_pointer_postfix(voidptr(&s1), s1, isize(1)) }))
		ch2 := u8((unsafe { *c2v_pointer_postfix(voidptr(&s2), s2, isize(1)) }))
		if int(ch1) != int(ch2) {
			if int(ch1) >= `A` && int(ch1) <= `Z` {
				ch1 += int(`a`) - int(`A`)
			} else if (int(u8(ch1)) & 128) && C.c2v_isupper(int(ch1)) {
				ch1 = u8(C.c2v_tolower(int(ch1)))
			}
			if int(ch2) >= `A` && int(ch2) <= `Z` {
				ch2 += int(`a`) - int(`A`)
			} else if (int(u8(ch2)) & 128) && C.c2v_isupper(int(ch2)) {
				ch2 = u8(C.c2v_tolower(int(ch2)))
			}
			if int(ch1) != int(ch2) {
				return int(ch1) - int(ch2)
			}
		}
		if int(ch1) == 0 {
			break
		}
	}
	return 0
}

@[export: 'pg_toupper']
@[markused]
pub fn pg_toupper(ch u8) u8 {
	if int(ch) >= `a` && int(ch) <= `z` {
		ch += int(`A`) - int(`a`)
	} else if (int(u8(ch)) & 128) && C.c2v_islower(int(ch)) {
		ch = u8(C.c2v_toupper(int(ch)))
	}
	return ch
}

@[export: 'pg_tolower']
@[markused]
pub fn pg_tolower(ch u8) u8 {
	if int(ch) >= `A` && int(ch) <= `Z` {
		ch += int(`a`) - int(`A`)
	} else if (int(u8(ch)) & 128) && C.c2v_isupper(int(ch)) {
		ch = u8(C.c2v_tolower(int(ch)))
	}
	return ch
}

@[export: 'pg_ascii_toupper']
@[markused]
pub fn pg_ascii_toupper(ch u8) u8 {
	if int(ch) >= `a` && int(ch) <= `z` {
		ch += int(`A`) - int(`a`)
	}
	return ch
}

@[export: 'pg_ascii_tolower']
@[markused]
pub fn pg_ascii_tolower(ch u8) u8 {
	if int(ch) >= `A` && int(ch) <= `Z` {
		ch += int(`a`) - int(`A`)
	}
	return ch
}
