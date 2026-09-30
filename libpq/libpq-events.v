@[translated]
module libpq

pub type PGcancelConn_libpq_events = Pg_cancel_conn

pub type PGcancel_libpq_events = Pg_cancel

@[markused]
pub fn libpq_libpq_events_is_unixsock_path(path &i8) bool {
	return (i32(path[false]) == i8(`/`)) || i32(path[false]) == i8(`@`)
}

@[export: 'PQregisterEventProc']
@[markused]
pub fn pq_register_event_proc(conn &PGconn, proc PGEventProc, name &i8, pass_through voidptr) i32 {
	i := i32(0)
	regevt := PGEventRegister{}
	if isnil(proc) || isnil(conn) || isnil(name) || !(unsafe { *name }) {
		return 0
	}
	for i = 0; i < conn.nEvents; i++ {
		if conn.events[i].proc == proc {
			return 0
		}
	}
	if conn.nEvents >= conn.eventArraySize {
		e := &PGEvent(0)
		new_size := i32(0)
		new_size = if conn.eventArraySize { conn.eventArraySize * 2 } else { 8 }
		if conn.events {
			e = &PGEvent(C.c2v_realloc(voidptr(conn.events), u64(new_size) * sizeof(PGEvent)))
		} else {
			e = &PGEvent(C.c2v_malloc(u64(new_size) * sizeof(PGEvent)))
		}
		if isnil(e) {
			return 0
		}
		conn.eventArraySize = new_size
		conn.events = e
	}
	conn.events[conn.nEvents].proc = proc
	conn.events[conn.nEvents].name = C.c2v_strdup(name)
	if isnil(conn.events[conn.nEvents].name) {
		return 0
	}
	conn.events[conn.nEvents].passThrough = pass_through
	conn.events[conn.nEvents].data = unsafe { nil }
	conn.events[conn.nEvents].resultInitialized = (0 != 0)
	conn.nEvents++
	regevt.conn = conn
	if !proc(PGEventId(PGEventId.pgevt_register), voidptr(&regevt), voidptr(pass_through)) {
		conn.nEvents--
		C.c2v_free(voidptr(conn.events[conn.nEvents].name))
		return 0
	}
	return 1
}

@[export: 'PQsetInstanceData']
@[markused]
pub fn pq_set_instance_data(conn &PGconn, proc PGEventProc, data voidptr) i32 {
	i := i32(0)
	if isnil(conn) || isnil(proc) {
		return 0
	}
	for i = 0; i < conn.nEvents; i++ {
		if conn.events[i].proc == proc {
			conn.events[i].data = data
			return 1
		}
	}
	return 0
}

@[export: 'PQinstanceData']
@[markused]
pub fn pq_instance_data(conn &PGconn, proc PGEventProc) voidptr {
	i := i32(0)
	if isnil(conn) || isnil(proc) {
		return unsafe { nil }
	}
	for i = 0; i < conn.nEvents; i++ {
		if conn.events[i].proc == proc {
			return conn.events[i].data
		}
	}
	return unsafe { nil }
}

@[export: 'PQresultSetInstanceData']
@[markused]
pub fn pq_result_set_instance_data(result &PGresult, proc PGEventProc, data voidptr) i32 {
	i := i32(0)
	if isnil(result) || isnil(proc) {
		return 0
	}
	for i = 0; i < result.nEvents; i++ {
		if result.events[i].proc == proc {
			result.events[i].data = data
			return 1
		}
	}
	return 0
}

@[export: 'PQresultInstanceData']
@[markused]
pub fn pq_result_instance_data(result &PGresult, proc PGEventProc) voidptr {
	i := i32(0)
	if isnil(result) || isnil(proc) {
		return unsafe { nil }
	}
	for i = 0; i < result.nEvents; i++ {
		if result.events[i].proc == proc {
			return result.events[i].data
		}
	}
	return unsafe { nil }
}

@[export: 'PQfireResultCreateEvents']
@[markused]
pub fn pq_fire_result_create_events(conn &PGconn, res &PGresult) i32 {
	result := i32(1)
	i := i32(0)
	if isnil(res) {
		return 0
	}
	for i = 0; i < res.nEvents; i++ {
		if !res.events[i].resultInitialized {
			evt := PGEventResultCreate{}
			evt.conn = conn
			evt.result = res
			if res.events[i].proc(PGEventId(PGEventId.pgevt_resultcreate), voidptr(&evt), voidptr(res.events[i].passThrough)) {
				res.events[i].resultInitialized = (1 != 0)
			} else {
				result = 0
			}
		}
	}
	return result
}
