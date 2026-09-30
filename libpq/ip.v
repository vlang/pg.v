@[translated]
module libpq

@[markused]
pub fn libpq_ip_is_unixsock_path(path &i8) bool {
	return (int(path[false]) == i8(`/`)) || int(path[false]) == i8(`@`)
}

@[export: 'pg_getaddrinfo_all']
@[markused]
pub fn pg_getaddrinfo_all(hostname &i8, servname &i8, hintp &C.addrinfo, result &&C.addrinfo) int {
	rc := 0
	unsafe { *result = (voidptr(0)) }
	if hintp.ai_family == 1 {
		return getaddrinfo_unix(servname, hintp, result)
	}
	rc = C.c2v_getaddrinfo(unsafe {
		if (isnil(hostname) || int(hostname[0]) == i8(`\0`)) {
			&i8(nil)
		} else {
			hostname
		}
	}, servname, hintp, result)
	return rc
}

@[export: 'pg_freeaddrinfo_all']
@[markused]
pub fn pg_freeaddrinfo_all(hint_ai_family int, ai &C.addrinfo) {
	if hint_ai_family == 1 {
		for usize(ai) != usize((voidptr(0))) {
			p := ai
			ai = ai.ai_next
			C.c2v_free(voidptr(p.ai_addr))
			C.c2v_free(voidptr(p))
		}
	} else {
		if usize(ai) != usize((voidptr(0))) {
			C.c2v_freeaddrinfo(ai)
		}
	}
}

@[export: 'pg_getnameinfo_all']
@[markused]
pub fn pg_getnameinfo_all(addr &C.sockaddr_storage, salen int, node &i8, nodelen int, service &i8, servicelen int, flags int) int {
	rc := 0
	if !isnil(addr) && int(addr.ss_family) == 1 {
		rc = getnameinfo_unix(&C.sockaddr_un(voidptr(addr)), salen, node, nodelen, service, servicelen, flags)
	} else {
		rc = C.c2v_getnameinfo(&C.sockaddr(voidptr(addr)), u32(salen), node, u32(nodelen), service, u32(servicelen), flags)
	}
	if rc != 0 {
		if node {
			C.c2v_strlcpy(node, c'???', u64(nodelen))
		}
		if service {
			C.c2v_strlcpy(service, c'???', u64(servicelen))
		}
	}
	return rc
}

@[markused]
pub fn getaddrinfo_unix(path &i8, hintsp &C.addrinfo, result &&C.addrinfo) int {
	hints := C.addrinfo{}

	aip := &C.addrinfo(0)
	unp := &C.sockaddr_un(0)
	unsafe { *result = (voidptr(0)) }
	if C.c2v_strlen(path) >= sizeof([104]i8) {
		return 4
	}
	if usize(hintsp) == usize((voidptr(0))) {
		hints.ai_family = 1
		hints.ai_socktype = 1
	} else {
		C.c2v_memcpy(voidptr(&hints), voidptr(hintsp), sizeof(hints))
	}
	if hints.ai_socktype == 0 {
		hints.ai_socktype = 1
	}
	if hints.ai_family != 1 {
		return 4
	}
	aip = C.c2v_calloc(u64(1), sizeof(C.addrinfo))
	if usize(aip) == usize((voidptr(0))) {
		return 6
	}
	unp = C.c2v_calloc(u64(1), sizeof(C.sockaddr_un))
	if usize(unp) == usize((voidptr(0))) {
		C.c2v_free(voidptr(aip))
		return 6
	}
	aip.ai_family = 1
	aip.ai_socktype = hints.ai_socktype
	aip.ai_protocol = hints.ai_protocol
	aip.ai_next = (voidptr(0))
	aip.ai_canonname = (voidptr(0))
	unsafe { *result = aip }
	unp.sun_family = u8(1)
	aip.ai_addr = &C.sockaddr(voidptr(unp))
	aip.ai_addrlen = u32(sizeof(C.sockaddr_un))
	C.c2v_strcpy(unsafe { &i8(&unp.sun_path[0]) }, path)
	if int(path[0]) == i8(`@`) {
		unp.sun_path[0] = i8(`\0`)
		aip.ai_addrlen = u32((u64(usize(__offsetof(C.sockaddr_un, sun_path)))) + C.c2v_strlen(path))
	}
	return 0
}

@[markused]
pub fn getnameinfo_unix(sa &C.sockaddr_un, salen int, node &i8, nodelen int, service &i8, servicelen int, flags int) int {
	ret := 0
	if usize(sa) == usize((voidptr(0))) || int(sa.sun_family) != 1 || (usize(node) == usize((voidptr(0))) && usize(service) == usize((voidptr(0)))) {
		return 4
	}
	if node {
		ret = pg_snprintf(node, usize(nodelen), c'%s', voidptr(c'[local]'))
		if ret < 0 || ret >= nodelen {
			return 6
		}
	}
	if service {
		if int(sa.sun_path[0]) == i8(`\0`) && int(sa.sun_path[1]) != i8(`\0`) {
			ret = pg_snprintf(service, usize(servicelen), c'@%s', voidptr(unsafe { &sa.sun_path[0] } + 1))
		} else {
			ret = pg_snprintf(service, usize(servicelen), c'%s', unsafe { voidptr(&sa.sun_path[0]) })
		}
		if ret < 0 || ret >= servicelen {
			return 6
		}
	}
	return 0
}
