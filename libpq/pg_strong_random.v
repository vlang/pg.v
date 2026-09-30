@[translated]
module libpq

@[export: 'pg_strong_random_init']
@[markused]
pub fn pg_strong_random_init() {
}

@[export: 'pg_strong_random']
@[markused]
pub fn pg_strong_random(buf voidptr, len usize) bool {
	f := i32(0)
	p := &i8(buf)
	res := isize(0)
	f = C.c2v_open(c'/dev/urandom', 0, 0)
	if f == -1 {
		return false != 0
	}
	for len {
		res = C.c2v_read(f, voidptr(p), len)
		if res <= isize(0) {
			if (unsafe { *C.c2v___error() }) == 4 {
				continue
			}
			C.c2v_close(f)
			return false != 0
		}
		c2v_pointer_prefix(voidptr(&p), p, isize(res))
		len -= usize(res)
	}
	C.c2v_close(f)
	return true != 0
}
