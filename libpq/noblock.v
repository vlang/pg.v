@[translated]
module libpq

@[export: 'pg_set_noblock']
@[markused]
pub fn pg_set_noblock(sock Pgsocket) bool {
	flags := 0
	flags = C.c2v_fcntl(sock, 3)
	if flags < 0 {
		return false != 0
	}
	if C.c2v_fcntl(sock, 4, (flags | 4)) == -1 {
		return false != 0
	}
	return true != 0
}

@[export: 'pg_set_block']
@[markused]
pub fn pg_set_block(sock Pgsocket) bool {
	flags := 0
	flags = C.c2v_fcntl(sock, 3)
	if flags < 0 {
		return false != 0
	}
	if C.c2v_fcntl(sock, 4, (flags & ~4)) == -1 {
		return false != 0
	}
	return true != 0
}
