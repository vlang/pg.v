@[translated]
module libpq

@[export: 'pg_strcasecmp']
@[markused]
pub fn pg_strcasecmp(s1 &i8, s2 &i8) i32 {
	for {
		ch1 := u8((unsafe { *c2v_pointer_postfix(voidptr(&s1), s1, isize(1)) }))
		ch2 := u8((unsafe { *c2v_pointer_postfix(voidptr(&s2), s2, isize(1)) }))
		if i32(ch1) != i32(ch2) {
			if i32(ch1) >= `A` && i32(ch1) <= `Z` {
				ch1 += i32(`a`) - i32(`A`)
			} else if (i32(u8(ch1)) & 128) && C.c2v_isupper(i32(ch1)) {
				ch1 = u8(C.c2v_tolower(i32(ch1)))
			}
			if i32(ch2) >= `A` && i32(ch2) <= `Z` {
				ch2 += i32(`a`) - i32(`A`)
			} else if (i32(u8(ch2)) & 128) && C.c2v_isupper(i32(ch2)) {
				ch2 = u8(C.c2v_tolower(i32(ch2)))
			}
			if i32(ch1) != i32(ch2) {
				return i32(ch1) - i32(ch2)
			}
		}
		if i32(ch1) == 0 {
			break
		}
	}
	return 0
}

@[export: 'pg_strncasecmp']
@[markused]
pub fn pg_strncasecmp(s1 &i8, s2 &i8, n usize) i32 {
	for n-- > usize(0) {
		ch1 := u8((unsafe { *c2v_pointer_postfix(voidptr(&s1), s1, isize(1)) }))
		ch2 := u8((unsafe { *c2v_pointer_postfix(voidptr(&s2), s2, isize(1)) }))
		if i32(ch1) != i32(ch2) {
			if i32(ch1) >= `A` && i32(ch1) <= `Z` {
				ch1 += i32(`a`) - i32(`A`)
			} else if (i32(u8(ch1)) & 128) && C.c2v_isupper(i32(ch1)) {
				ch1 = u8(C.c2v_tolower(i32(ch1)))
			}
			if i32(ch2) >= `A` && i32(ch2) <= `Z` {
				ch2 += i32(`a`) - i32(`A`)
			} else if (i32(u8(ch2)) & 128) && C.c2v_isupper(i32(ch2)) {
				ch2 = u8(C.c2v_tolower(i32(ch2)))
			}
			if i32(ch1) != i32(ch2) {
				return i32(ch1) - i32(ch2)
			}
		}
		if i32(ch1) == 0 {
			break
		}
	}
	return 0
}

@[export: 'pg_toupper']
@[markused]
pub fn pg_toupper(ch u8) u8 {
	if i32(ch) >= `a` && i32(ch) <= `z` {
		ch += i32(`A`) - i32(`a`)
	} else if (i32(u8(ch)) & 128) && C.c2v_islower(i32(ch)) {
		ch = u8(C.c2v_toupper(i32(ch)))
	}
	return ch
}

@[export: 'pg_tolower']
@[markused]
pub fn pg_tolower(ch u8) u8 {
	if i32(ch) >= `A` && i32(ch) <= `Z` {
		ch += i32(`a`) - i32(`A`)
	} else if (i32(u8(ch)) & 128) && C.c2v_isupper(i32(ch)) {
		ch = u8(C.c2v_tolower(i32(ch)))
	}
	return ch
}

@[export: 'pg_ascii_toupper']
@[markused]
pub fn pg_ascii_toupper(ch u8) u8 {
	if i32(ch) >= `a` && i32(ch) <= `z` {
		ch += i32(`A`) - i32(`a`)
	}
	return ch
}

@[export: 'pg_ascii_tolower']
@[markused]
pub fn pg_ascii_tolower(ch u8) u8 {
	if i32(ch) >= `A` && i32(ch) <= `Z` {
		ch += i32(`a`) - i32(`A`)
	}
	return ch
}
