@[translated]
module libpq

#flag '-D__STDC_WANT_LIB_EXT1__=1'

@[export: 'explicit_bzero']
@[markused]
pub fn explicit_bzero(buf voidptr, len usize) {
	C.c2v_memset_s(voidptr(buf), len, 0, len)
}
