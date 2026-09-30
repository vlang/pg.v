@[translated]
module libpq

struct C.Pg_cancel {}

struct C.Pg_cancel_conn {}

struct C.StringInfoData {}

pub enum JsonTokenType {
	json_token_invalid
	json_token_string
	json_token_number
	json_token_object_start
	json_token_object_end
	json_token_array_start
	json_token_array_end
	json_token_comma
	json_token_colon
	json_token_true
	json_token_false
	json_token_null
	json_token_end
}

pub enum JsonParseErrorType {
	json_success
	json_incomplete
	json_invalid_lexer_type
	json_nesting_too_deep
	json_escaping_invalid
	json_escaping_required
	json_expected_array_first
	json_expected_array_next
	json_expected_colon
	json_expected_end
	json_expected_json
	json_expected_more
	json_expected_object_first
	json_expected_object_next
	json_expected_string
	json_invalid_token
	json_out_of_memory
	json_unicode_code_point_zero
	json_unicode_escape_format
	json_unicode_high_escape
	json_unicode_untranslatable
	json_unicode_high_surrogate
	json_unicode_low_surrogate
	json_sem_action_failed
}

pub struct JsonLexContext {
pub mut:
	input                 &i8
	input_length          usize
	input_encoding        i32
	token_start           &i8
	token_terminator      &i8
	prev_token_terminator &i8
	incremental           bool
	token_type            JsonTokenType
	lex_level             i32
	flags                 Bits32
	line_number           i32
	line_start            &i8
	pstack                &JsonParserStack
	inc_state             &JsonIncrementalState
	need_escapes          bool
	strval                &C.StringInfoData
	errormsg              &C.StringInfoData
}

pub type Json_struct_action = fn (voidptr) JsonParseErrorType

pub type Json_ofield_action = fn (voidptr, &i8, bool) JsonParseErrorType

pub type Json_aelem_action = fn (voidptr, bool) JsonParseErrorType

pub type Json_scalar_action = fn (voidptr, &i8, JsonTokenType) JsonParseErrorType

pub struct JsonSemAction {
pub mut:
	semstate            voidptr
	object_start        Json_struct_action
	object_end          Json_struct_action
	array_start         Json_struct_action
	array_end           Json_struct_action
	object_field_start  Json_ofield_action
	object_field_end    Json_ofield_action
	array_element_start Json_aelem_action
	array_element_end   Json_aelem_action
	scalar              Json_scalar_action
}

pub enum ConnStatusType {
	connection_ok
	connection_bad
	connection_started
	connection_made
	connection_awaiting_response
	connection_auth_ok
	connection_setenv
	connection_ssl_startup
	connection_needed
	connection_check_writable
	connection_consume
	connection_gss_startup
	connection_check_target
	connection_check_standby
	connection_allocated
	connection_authenticating
}

pub enum PostgresPollingStatusType {
	pgres_polling_failed = 0
	pgres_polling_reading
	pgres_polling_writing
	pgres_polling_ok
	pgres_polling_active
}

pub enum ExecStatusType {
	pgres_empty_query = 0
	pgres_command_ok
	pgres_tuples_ok
	pgres_copy_out
	pgres_copy_in
	pgres_bad_response
	pgres_nonfatal_error
	pgres_fatal_error
	pgres_copy_both
	pgres_single_tuple
	pgres_pipeline_sync
	pgres_pipeline_aborted
	pgres_tuples_chunk
}

pub enum PGTransactionStatusType {
	pqtrans_idle
	pqtrans_active
	pqtrans_intrans
	pqtrans_inerror
	pqtrans_unknown
}

pub enum PGVerbosity {
	pqerrors_terse
	pqerrors_default
	pqerrors_verbose
	pqerrors_sqlstate
}

pub enum PGContextVisibility {
	pqshow_context_never
	pqshow_context_errors
	pqshow_context_always
}

pub enum PGPing {
	pqping_ok
	pqping_reject
	pqping_no_response
	pqping_no_attempt
}

pub enum PGpipelineStatus {
	pq_pipeline_off
	pq_pipeline_on
	pq_pipeline_aborted
}

pub enum PGauthData {
	pqauthdata_prompt_oauth_device
	pqauthdata_oauth_bearer_token
}

pub type PGconn = Pg_conn

pub type PGcancelConn = C.Pg_cancel_conn

pub type PGresult = Pg_result

pub type PGcancel = C.Pg_cancel

pub struct PGnotify {
pub mut:
	relname &i8
	be_pid  i32
	extra   &i8
	next    &PGnotify
}

pub type Pg_usec_time_t = i64

pub type PQnoticeReceiver = fn (voidptr, &PGresult)

pub type PQnoticeProcessor = fn (voidptr, &i8)

pub type Pqbool = i8

pub struct PQprintOpt {
pub mut:
	header    Pqbool
	align     Pqbool
	standard  Pqbool
	html3     Pqbool
	expanded  Pqbool
	pager     Pqbool
	fieldSep  &i8
	tableOpt  &i8
	caption   &i8
	fieldName &&u8
}

pub struct PQconninfoOption {
pub mut:
	keyword  &i8
	envvar   &i8
	compiled &i8
	val      &i8
	label    &i8
	dispchar &i8
	dispsize i32
}

pub union PQArgBlock_u {
pub mut:
	ptr     &i32
	integer i32
}

pub struct PQArgBlock {
pub mut:
	len   i32
	isint i32
	u     PQArgBlock_u
}

pub struct PGresAttDesc {
pub mut:
	name      &i8
	tableid   Oid
	columnid  i32
	format    i32
	typid     Oid
	typlen    i32
	atttypmod i32
}

pub type Pgthreadlock_t = fn (i32)

pub struct PGpromptOAuthDevice {
pub mut:
	verification_uri          &i8
	user_code                 &i8
	verification_uri_complete &i8
	expires_in                i32
}

pub struct PGoauthBearerRequest {
pub mut:
	openid_configuration &i8
	scope                &i8
	async                fn (&PGconn, &PGoauthBearerRequest, &i32) PostgresPollingStatusType
	cleanup              fn (&PGconn, &PGoauthBearerRequest)
	token                &i8
	user                 voidptr
}

pub type PQauthDataHook_type = fn (PGauthData, &PGconn, voidptr) i32

pub type PQsslKeyPassHook_OpenSSL_type = fn (&i8, i32, &PGconn) i32

pub enum PGEventId {
	pgevt_register
	pgevt_connreset
	pgevt_conndestroy
	pgevt_resultcreate
	pgevt_resultcopy
	pgevt_resultdestroy
}

pub struct PGEventRegister {
pub mut:
	conn &PGconn
}

pub struct PGEventConnReset {
pub mut:
	conn &PGconn
}

pub struct PGEventConnDestroy {
pub mut:
	conn &PGconn
}

pub struct PGEventResultCreate {
pub mut:
	conn   &PGconn
	result &PGresult
}

pub struct PGEventResultCopy {
pub mut:
	src  &PGresult
	dest &PGresult
}

pub struct PGEventResultDestroy {
pub mut:
	result &PGresult
}

pub type PGEventProc = fn (PGEventId, voidptr, voidptr) i32

pub struct SockAddr {
pub mut:
	addr  C.sockaddr_storage
	salen u32
}

pub struct AddrInfo {
pub mut:
	family i32
	addr   SockAddr
}

@[markused]
pub fn is_unixsock_path(path &i8) bool {
	return (i32(path[false]) == i8(`/`)) || i32(path[false]) == i8(`@`)
}

pub type ProtocolVersion = u32

pub type MsgType = u32

pub type PacketLen = u32

pub type AuthRequest = u32

pub struct CancelRequestPacket {
pub mut:
	cancelRequestCode MsgType
	backendPID        Uint32
	cancelAuthCode    [1]Uint8
}

pub enum SASLStatus {
	sasl_complete = 0
	sasl_failed
	sasl_continue
	sasl_async
}

pub struct Pg_fe_sasl_mech {
pub mut:
	init          fn (&PGconn, &i8, &i8) voidptr
	exchange      fn (voidptr, bool, &i8, i32, &&u8, &i32) SASLStatus
	channel_bound fn (voidptr) bool
	free_         fn (voidptr)
}

pub struct PQExpBufferData {
pub mut:
	data   &i8
	len    usize
	maxlen usize
}

pub type PQExpBuffer = &PQExpBufferData

pub struct Pg_prng_state {
pub mut:
	s0 Uint64
	s1 Uint64
}

pub type PGresult_data = Pgresult_data

pub union Pgresult_data {
pub mut:
	next  &PGresult_data
	space [1]i8
}

pub struct PGresParamDesc {
pub mut:
	typid Oid
}

pub struct PGresAttValue {
pub mut:
	len   i32
	value &i8
}

pub struct PGMessageField {
pub mut:
	next     &PGMessageField
	code     i8
	contents [1]i8
}

pub struct PGNoticeHooks {
pub mut:
	noticeRec     PQnoticeReceiver
	noticeRecArg  voidptr
	noticeProc    PQnoticeProcessor
	noticeProcArg voidptr
}

pub struct PGEvent {
pub mut:
	proc              PGEventProc
	name              &i8
	passThrough       voidptr
	data              voidptr
	resultInitialized bool
}

pub struct Pg_result {
pub mut:
	ntups           i32
	numAttributes   i32
	attDescs        &PGresAttDesc
	tuples          &&PGresAttValue
	tupArrSize      i32
	numParameters   i32
	paramDescs      &PGresParamDesc
	resultStatus    ExecStatusType
	cmdStatus       [64]i8
	binary          i32
	noticeHooks     PGNoticeHooks
	events          &PGEvent
	nEvents         i32
	client_encoding i32
	errMsg          &i8
	errFields       &PGMessageField
	errQuery        &i8
	null_field      [1]i8
	curBlock        &PGresult_data
	curOffset       i32
	spaceLeft       i32
	memorySize      usize
}

pub enum PGAsyncStatusType {
	pgasync_idle
	pgasync_busy
	pgasync_ready
	pgasync_ready_more
	pgasync_copy_in
	pgasync_copy_out
	pgasync_copy_both
	pgasync_pipeline_idle
}

pub enum PGTargetServerType {
	server_type_any = 0
	server_type_read_write
	server_type_read_only
	server_type_primary
	server_type_standby
	server_type_prefer_standby
	server_type_prefer_standby_pass2
}

pub enum PGLoadBalanceType {
	load_balance_disable = 0
	load_balance_random
}

pub enum PGTernaryBool {
	pg_bool_unknown = 0
	pg_bool_yes
	pg_bool_no
}

pub struct PQEnvironmentOption {
pub mut:
	envName &i8
	pgName  &i8
}

pub struct PgParameterStatus {
pub mut:
	next  &PgParameterStatus
	name  &i8
	value &i8
}

pub struct PGlobjfuncs {
pub mut:
	fn_lo_open       Oid
	fn_lo_close      Oid
	fn_lo_creat      Oid
	fn_lo_create     Oid
	fn_lo_unlink     Oid
	fn_lo_lseek      Oid
	fn_lo_lseek64    Oid
	fn_lo_tell       Oid
	fn_lo_tell64     Oid
	fn_lo_truncate   Oid
	fn_lo_truncate64 Oid
	fn_lo_read       Oid
	fn_lo_write      Oid
}

pub struct PGdataValue {
pub mut:
	len   i32
	value &i8
}

pub enum Pg_conn_host_type {
	cht_host_name
	cht_host_address
	cht_unix_socket
}

pub enum PGQueryClass {
	pgquery_simple
	pgquery_extended
	pgquery_prepare
	pgquery_describe
	pgquery_sync
	pgquery_close
}

pub struct PGcmdQueueEntry {
pub mut:
	queryclass PGQueryClass
	query      &i8
	next       &PGcmdQueueEntry
}

pub struct Pg_conn_host {
pub mut:
	type_    Pg_conn_host_type
	host     &i8
	hostaddr &i8
	port     &i8
	password &i8
}

pub struct Pg_conn {
pub mut:
	pghost                        &i8
	pghostaddr                    &i8
	pgport                        &i8
	connect_timeout               &i8
	pgtcp_user_timeout            &i8
	client_encoding_initial       &i8
	pgoptions                     &i8
	appname                       &i8
	fbappname                     &i8
	dbName                        &i8
	replication                   &i8
	pgservice                     &i8
	pguser                        &i8
	pgpass                        &i8
	pgpassfile                    &i8
	channel_binding               &i8
	keepalives                    &i8
	keepalives_idle               &i8
	keepalives_interval           &i8
	keepalives_count              &i8
	sslmode                       &i8
	sslnegotiation                &i8
	sslcompression                &i8
	sslkey                        &i8
	sslcert                       &i8
	sslpassword                   &i8
	sslcertmode                   &i8
	sslrootcert                   &i8
	sslcrl                        &i8
	sslcrldir                     &i8
	sslsni                        &i8
	requirepeer                   &i8
	gssencmode                    &i8
	krbsrvname                    &i8
	gsslib                        &i8
	gssdelegation                 &i8
	min_protocol_version          &i8
	max_protocol_version          &i8
	ssl_min_protocol_version      &i8
	ssl_max_protocol_version      &i8
	target_session_attrs          &i8
	require_auth                  &i8
	load_balance_hosts            &i8
	scram_client_key              &i8
	scram_server_key              &i8
	sslkeylogfile                 &i8
	cancelRequest                 bool
	oauth_issuer                  &i8
	oauth_issuer_id               &i8
	oauth_discovery_uri           &i8
	oauth_client_id               &i8
	oauth_client_secret           &i8
	oauth_scope                   &i8
	oauth_token                   &i8
	oauth_want_retry              bool
	pfdebug                       &C.FILE
	traceFlags                    i32
	noticeHooks                   PGNoticeHooks
	events                        &PGEvent
	nEvents                       i32
	eventArraySize                i32
	status                        ConnStatusType
	asyncStatus                   PGAsyncStatusType
	xactStatus                    PGTransactionStatusType
	last_sqlstate                 [6]i8
	options_valid                 bool
	nonblocking                   bool
	pipelineStatus                PGpipelineStatus
	partialResMode                bool
	singleRowMode                 bool
	maxChunkSize                  i32
	copy_is_binary                i8
	copy_already_done             i32
	notifyHead                    &PGnotify
	notifyTail                    &PGnotify
	nconnhost                     i32
	whichhost                     i32
	connhost                      &Pg_conn_host
	connip                        &i8
	cmd_queue_head                &PGcmdQueueEntry
	cmd_queue_tail                &PGcmdQueueEntry
	cmd_queue_recycle             &PGcmdQueueEntry
	sock                          Pgsocket
	laddr                         SockAddr
	raddr                         SockAddr
	pversion                      ProtocolVersion
	sversion                      i32
	pversion_negotiated           bool
	auth_req_received             bool
	password_needed               bool
	gssapi_used                   bool
	sigpipe_so                    bool
	sigpipe_flag                  bool
	write_failed                  bool
	write_err_msg                 &i8
	auth_required                 bool
	allowed_auth_methods          Uint32
	allowed_sasl_mechs            [2]&Pg_fe_sasl_mech
	client_finished_auth          bool
	current_auth_response         i8
	async_auth                    fn (&PGconn) PostgresPollingStatusType
	cleanup_async_auth            fn (&PGconn)
	altsock                       Pgsocket
	target_server_type            PGTargetServerType
	load_balance_type             PGLoadBalanceType
	try_next_addr                 bool
	try_next_host                 bool
	naddr                         i32
	whichaddr                     i32
	addr                          &AddrInfo
	send_appname                  bool
	scram_client_key_len          usize
	scram_client_key_binary       &Uint8
	scram_server_key_len          usize
	scram_server_key_binary       &Uint8
	min_pversion                  ProtocolVersion
	max_pversion                  ProtocolVersion
	be_pid                        i32
	be_cancel_key_len             i32
	be_cancel_key                 &Uint8
	pstatus                       &PgParameterStatus
	client_encoding               i32
	std_strings                   bool
	default_transaction_read_only PGTernaryBool
	in_hot_standby                PGTernaryBool
	verbosity                     PGVerbosity
	show_context                  PGContextVisibility
	lobjfuncs                     &PGlobjfuncs
	prng_state                    Pg_prng_state
	inBuffer                      &i8
	inBufSize                     i32
	inStart                       i32
	inCursor                      i32
	inEnd                         i32
	outBuffer                     &i8
	outBufSize                    i32
	outCount                      i32
	outMsgStart                   i32
	outMsgEnd                     i32
	rowBuf                        &PGdataValue
	rowBufLen                     i32
	result                        &PGresult
	error_result                  bool
	saved_result                  &PGresult
	sasl                          &Pg_fe_sasl_mech
	sasl_state                    voidptr
	scram_sha_256_iterations      i32
	allowed_enc_methods           Uint8
	failed_enc_methods            Uint8
	current_enc_method            Uint8
	ssl_in_use                    bool
	ssl_handshake_started         bool
	ssl_cert_requested            bool
	ssl_cert_sent                 bool
	last_read_was_eof             bool
	errorMessage                  PQExpBufferData
	errorReported                 i32
	workBuffer                    PQExpBufferData
}

pub fn pgtls_open_client(conn &PGconn) PostgresPollingStatusType

pub fn pgtls_close(conn &PGconn)

pub fn pgtls_read(conn &PGconn, ptr voidptr, len usize) isize

pub fn pgtls_bytes_pending(conn &PGconn) isize

pub fn pgtls_write(conn &PGconn, ptr voidptr, len usize) isize

pub fn pgtls_get_peer_certificate_hash(conn &PGconn, len &usize) &i8

pub fn pgtls_verify_peer_name_matches_certificate_guts(conn &PGconn, names_examined &i32, first_name &&u8) i32

pub enum Fe_oauth_step {
	fe_oauth_init
	fe_oauth_bearer_sent
	fe_oauth_requesting_token
	fe_oauth_server_error
}

pub struct Fe_oauth_state {
pub mut:
	step         Fe_oauth_step
	conn         &PGconn
	async_ctx    voidptr
	builtin_flow voidptr
}

@[markused]
pub fn libpq_fe_auth_oauth_is_valid_unicode_codepoint(c Pg_wchar) bool {
	return (c > Pg_wchar(false) && c <= Pg_wchar(1114111)) != 0
}

@[markused]
pub fn libpq_fe_auth_oauth_is_utf16_surrogate_first(c Pg_wchar) bool {
	return (c >= Pg_wchar(55296) && c <= Pg_wchar(56319)) != 0
}

@[markused]
pub fn libpq_fe_auth_oauth_is_utf16_surrogate_second(c Pg_wchar) bool {
	return (c >= Pg_wchar(56320) && c <= Pg_wchar(57343)) != 0
}

@[markused]
pub fn libpq_fe_auth_oauth_surrogate_pair_to_codepoint(first Pg_wchar, second Pg_wchar) Pg_wchar {
	return ((first & Pg_wchar(1023)) << 10) + Pg_wchar(65536) + (second & Pg_wchar(1023))
}

@[markused]
pub fn libpq_fe_auth_oauth_utf8_to_unicode(c &u8) Pg_wchar {
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
pub fn libpq_fe_auth_oauth_unicode_to_utf8(c Pg_wchar, utf8string &u8) &u8 {
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
pub fn libpq_fe_auth_oauth_unicode_utf8len(c Pg_wchar) i32 {
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

@[markused]
pub fn oauth_init(conn &PGconn, password &i8, sasl_mechanism &i8) voidptr {
	c2v_gc_register_thread()
	state := &Fe_oauth_state(0)

	state = C.c2v_calloc(u64(1), sizeof(Fe_oauth_state))
	if isnil(state) {
		return unsafe { nil }
	}
	state.step = Fe_oauth_step.fe_oauth_init
	state.conn = conn
	return state
}

@[markused]
pub fn oauth_free(opaq voidptr) {
	c2v_gc_register_thread()
	state := &Fe_oauth_state(opaq)

	C.c2v_free(voidptr(state))
}

@[markused]
pub fn client_initial_response(conn &PGconn, discover bool) &i8 {
	static resp_format := c'n,,\001auth=%s%s\001\001'
	buf := PQExpBufferData{}
	authn_scheme := &i8(0)
	response := unsafe { &i8(nil) }
	token := conn.oauth_token
	if discover {
		token = c''
		authn_scheme = token
	} else {
		authn_scheme = c'Bearer '
		if isnil(token) {
			libpq_append_conn_error(conn, c'internal error: no OAuth token was set for the connection')
			return unsafe { nil }
		}
	}
	init_pq_exp_buffer(&buf)
	append_pq_exp_buffer(&buf, resp_format, voidptr(authn_scheme), voidptr(token))
	if !(buf.maxlen == usize(0)) {
		response = C.c2v_strdup(buf.data)
	}
	term_pq_exp_buffer(&buf)
	if isnil(response) {
		libpq_append_conn_error(conn, c'out of memory')
	}
	return response
}

pub struct Json_ctx {
pub mut:
	errmsg            &i8
	errbuf            PQExpBufferData
	nested            i32
	target_field_name &i8
	target_field      &&u8
	status            &i8
	scope             &i8
	discovery_uri     &i8
}

@[markused]
pub fn oauth_json_object_start(state voidptr) JsonParseErrorType {
	c2v_gc_register_thread()
	ctx := &Json_ctx(state)
	if ctx.target_field {
		for {
			append_pq_exp_buffer(&ctx.errbuf, unsafe { &i8(&c'field "%s" must be a string'[0]) }, voidptr(ctx.target_field_name))
			ctx.errmsg = ctx.errbuf.data
			break
		}
	}
	ctx.nested++
	if ctx.nested > 8 {
		for {
			append_pq_exp_buffer(&ctx.errbuf, unsafe { &i8(&c'JSON is too deeply nested'[0]) })
			ctx.errmsg = ctx.errbuf.data
			break
		}
	}
	return if ((ctx.errbuf.maxlen == usize(0)) || !isnil(ctx.errmsg)) {
		JsonParseErrorType.json_sem_action_failed
	} else {
		JsonParseErrorType.json_success
	}
}

@[markused]
pub fn oauth_json_object_end(state voidptr) JsonParseErrorType {
	c2v_gc_register_thread()
	ctx := &Json_ctx(state)
	ctx.nested--
	return JsonParseErrorType.json_success
}

@[markused]
pub fn oauth_json_object_field_start(state voidptr, name &i8, isnull bool) JsonParseErrorType {
	c2v_gc_register_thread()
	ctx := &Json_ctx(state)
	if ctx.nested == 1 {
		if C.c2v_strcmp(name, c'status') == 0 {
			ctx.target_field_name = c'status'
			ctx.target_field = &ctx.status
		} else if C.c2v_strcmp(name, c'scope') == 0 {
			ctx.target_field_name = c'scope'
			ctx.target_field = &ctx.scope
		} else if C.c2v_strcmp(name, c'openid-configuration') == 0 {
			ctx.target_field_name = c'openid-configuration'
			ctx.target_field = &ctx.discovery_uri
		}
	}
	return JsonParseErrorType.json_success
}

@[markused]
pub fn oauth_json_array_start(state voidptr) JsonParseErrorType {
	c2v_gc_register_thread()
	ctx := &Json_ctx(state)
	if !ctx.nested {
		for {
			append_pq_exp_buffer(&ctx.errbuf, unsafe { &i8(&c'top-level element must be an object'[0]) })
			ctx.errmsg = ctx.errbuf.data
			break
		}
	} else if ctx.target_field {
		for {
			append_pq_exp_buffer(&ctx.errbuf, unsafe { &i8(&c'field "%s" must be a string'[0]) }, voidptr(ctx.target_field_name))
			ctx.errmsg = ctx.errbuf.data
			break
		}
	}
	ctx.nested++
	if ctx.nested > 8 {
		for {
			append_pq_exp_buffer(&ctx.errbuf, unsafe { &i8(&c'JSON is too deeply nested'[0]) })
			ctx.errmsg = ctx.errbuf.data
			break
		}
	}
	return if ((ctx.errbuf.maxlen == usize(0)) || !isnil(ctx.errmsg)) {
		JsonParseErrorType.json_sem_action_failed
	} else {
		JsonParseErrorType.json_success
	}
}

@[markused]
pub fn oauth_json_array_end(state voidptr) JsonParseErrorType {
	c2v_gc_register_thread()
	ctx := &Json_ctx(state)
	ctx.nested--
	return JsonParseErrorType.json_success
}

@[markused]
pub fn oauth_json_scalar(state voidptr, token &i8, type_ JsonTokenType) JsonParseErrorType {
	c2v_gc_register_thread()
	ctx := &Json_ctx(state)
	if !ctx.nested {
		for {
			append_pq_exp_buffer(&ctx.errbuf, unsafe { &i8(&c'top-level element must be an object'[0]) })
			ctx.errmsg = ctx.errbuf.data
			break
		}
		return JsonParseErrorType.json_sem_action_failed
	}
	if ctx.target_field {
		if ctx.nested != 1 {
			for {
				append_pq_exp_buffer(&ctx.errbuf, c'internal error: target scalar found at nesting level %d during OAUTHBEARER parsing', ctx.nested)
				ctx.errmsg = ctx.errbuf.data
				break
			}
			return JsonParseErrorType.json_sem_action_failed
		}
		if unsafe { *ctx.target_field != nil } {
			for {
				append_pq_exp_buffer(&ctx.errbuf, unsafe { &i8(&c'field "%s" is duplicated'[0]) }, voidptr(ctx.target_field_name))
				ctx.errmsg = ctx.errbuf.data
				break
			}
			return JsonParseErrorType.json_sem_action_failed
		}
		if u32(type_) != u32(JsonTokenType.json_token_string) {
			for {
				append_pq_exp_buffer(&ctx.errbuf, unsafe { &i8(&c'field "%s" must be a string'[0]) }, voidptr(ctx.target_field_name))
				ctx.errmsg = ctx.errbuf.data
				break
			}
			return JsonParseErrorType.json_sem_action_failed
		}
		unsafe { *ctx.target_field = C.c2v_strdup(token) }
		if isnil((unsafe { *ctx.target_field })) {
			return JsonParseErrorType.json_out_of_memory
		}
		ctx.target_field = unsafe { nil }
		ctx.target_field_name = unsafe { nil }
	} else {
	}
	return JsonParseErrorType.json_success
}

@[markused]
pub fn issuer_from_well_known_uri(conn &PGconn, wkuri &i8) &i8 {
	authority_start := unsafe { &i8(nil) }
	wk_start := &i8(0)
	wk_end := &i8(0)
	issuer := &i8(0)
	start_offset := isize(0)
	end_offset := isize(0)

	end_len := usize(0)
	if pg_strncasecmp(wkuri, c'https://', C.c2v_strlen(c'https://')) == 0 {
		authority_start = wkuri + C.c2v_strlen(c'https://')
	}
	if isnil(authority_start) && i32(oauth_unsafe_debugging_enabled()) && pg_strncasecmp(wkuri, c'http://', C.c2v_strlen(c'http://')) == 0 {
		authority_start = wkuri + C.c2v_strlen(c'http://')
	}
	if isnil(authority_start) {
		libpq_append_conn_error(conn, c'OAuth discovery URI "%s" must use HTTPS', voidptr(wkuri))
		return unsafe { nil }
	}
	if usize(C.c2v_strpbrk(authority_start, c'?#')) != usize((voidptr(0))) {
		libpq_append_conn_error(conn, c'OAuth discovery URI "%s" must not contain query or fragment components', voidptr(wkuri))
		return unsafe { nil }
	}
	wk_start = C.c2v_strstr(authority_start, c'/.well-known/')
	if isnil(wk_start) {
		libpq_append_conn_error(conn, c'OAuth discovery URI "%s" is not a .well-known URI', voidptr(wkuri))
		return unsafe { nil }
	}
	wk_end = wk_start + C.c2v_strlen(c'/.well-known/')
	if C.c2v_strncmp(wk_end, c'openid-configuration', C.c2v_strlen(c'openid-configuration')) == 0 {
		c2v_pointer_prefix(voidptr(&wk_end), wk_end, isize(C.c2v_strlen(c'openid-configuration')))
	} else if C.c2v_strncmp(wk_end, c'oauth-authorization-server', C.c2v_strlen(c'oauth-authorization-server')) == 0 {
		c2v_pointer_prefix(voidptr(&wk_end), wk_end, isize(C.c2v_strlen(c'oauth-authorization-server')))
	} else {
		wk_end = unsafe { nil }
	}
	if isnil(wk_end) || (i32((unsafe { *wk_end })) != i8(`/`) && i32((unsafe { *wk_end })) != i8(`\0`)) {
		libpq_append_conn_error(conn, c'OAuth discovery URI "%s" uses an unsupported .well-known suffix', voidptr(wkuri))
		return unsafe { nil }
	}
	if i32((unsafe { *wk_end })) != i8(`\0`) {
		path_start := &i8(0)
		path_start = C.c2v_strchr(authority_start, `/`)

		if usize(wk_start) != usize(path_start) {
			libpq_append_conn_error(conn, c'OAuth discovery URI "%s" uses an invalid format', voidptr(wkuri))
			return unsafe { nil }
		}
	}
	issuer = C.c2v_strdup(wkuri)
	if isnil(issuer) {
		libpq_append_conn_error(conn, c'out of memory')
		return unsafe { nil }
	}
	start_offset = i64((isize(wk_start) - isize(wkuri)) / isize(sizeof(i8)))
	end_offset = i64((isize(wk_end) - isize(wkuri)) / isize(sizeof(i8)))
	end_len = C.c2v_strlen(wk_end) + u64(1)
	C.c2v_memmove(voidptr(issuer + start_offset), voidptr(issuer + end_offset), end_len)
	return issuer
}

@[markused]
pub fn handle_oauth_sasl_error(conn &PGconn, msg &i8, msglen i32) bool {
	lex := &JsonLexContext(0)
	sem := JsonSemAction{}

	err := JsonParseErrorType{}
	ctx := Json_ctx{}

	errmsg := unsafe { &i8(nil) }
	success := (0 != 0)

	if C.c2v_strlen(msg) != u64(msglen) {
		libpq_append_conn_error(conn, c"server's error message contained an embedded NULL, and was discarded")
		return false != 0
	}
	if pg_encoding_verifymbstr(i32(Pg_enc.pg_utf8), msg, msglen) != msglen {
		libpq_append_conn_error(conn, c"server's error response is not valid UTF-8")
		return false != 0
	}
	lex = make_json_lex_context_cstring_len((voidptr(0)), msg, usize(msglen), i32(Pg_enc.pg_utf8), (1 != 0))
	set_json_lex_context_owns_tokens(lex, (1 != 0))
	init_pq_exp_buffer(&ctx.errbuf)
	sem.semstate = &ctx
	sem.object_start = oauth_json_object_start
	sem.object_end = oauth_json_object_end
	sem.object_field_start = oauth_json_object_field_start
	sem.array_start = oauth_json_array_start
	sem.array_end = oauth_json_array_end
	sem.scalar = oauth_json_scalar
	err = pg_parse_json(lex, &sem)
	if u32(err) == u32(JsonParseErrorType.json_sem_action_failed) {
		if (ctx.errbuf.maxlen == usize(0)) {
			errmsg = unsafe { &c'out of memory'[0] }
		} else if ctx.errmsg {
			errmsg = ctx.errmsg
		} else {
			errmsg = c'<unexpected empty error>'
		}
	} else if u32(err) != u32(JsonParseErrorType.json_success) {
		errmsg = json_errdetail(err, lex)
	}
	if errmsg {
		libpq_append_conn_error(conn, c"failed to parse server's error response: %s", voidptr(errmsg))
	}
	term_pq_exp_buffer(&ctx.errbuf)
	free_json_lex_context(lex)
	if errmsg {
		unsafe {
			goto cleanup
		}
	}
	if ctx.discovery_uri {
		discovery_issuer := &i8(0)
		discovery_issuer = issuer_from_well_known_uri(conn, ctx.discovery_uri)
		if isnil(discovery_issuer) {
			unsafe {
				goto cleanup
			}
		}
		if C.c2v_strcmp(conn.oauth_issuer_id, discovery_issuer) != 0 {
			libpq_append_conn_error(conn, c'server\'s discovery document at %s (issuer "%s") is incompatible with oauth_issuer (%s)', voidptr(ctx.discovery_uri), voidptr(discovery_issuer), voidptr(conn.oauth_issuer_id))
			C.c2v_free(voidptr(discovery_issuer))
			unsafe {
				goto cleanup
			}
		}
		C.c2v_free(voidptr(discovery_issuer))
		if isnil(conn.oauth_discovery_uri) {
			conn.oauth_discovery_uri = ctx.discovery_uri
			ctx.discovery_uri = unsafe { nil }
		} else {
			if C.c2v_strcmp(conn.oauth_discovery_uri, ctx.discovery_uri) != 0 {
				libpq_append_conn_error(conn, c"server's discovery document has moved to %s (previous location was %s)", voidptr(ctx.discovery_uri), voidptr(conn.oauth_discovery_uri))
				unsafe {
					goto cleanup
				}
			}
		}
	}
	if ctx.scope {
		if isnil(conn.oauth_scope) {
			conn.oauth_scope = ctx.scope
			ctx.scope = unsafe { nil }
		}
	}
	if isnil(ctx.status) {
		libpq_append_conn_error(conn, c'server sent error response without a status')
		unsafe {
			goto cleanup
		}
	}
	if C.c2v_strcmp(ctx.status, c'invalid_token') != 0 {
		libpq_append_conn_error(conn, c'server rejected OAuth bearer token: %s', voidptr(ctx.status))
		unsafe {
			goto cleanup
		}
	}
	success = (1 != 0)
	cleanup:
	C.c2v_free(voidptr(ctx.status))
	C.c2v_free(voidptr(ctx.scope))
	C.c2v_free(voidptr(ctx.discovery_uri))
	return success
}

@[markused]
pub fn run_user_oauth_flow(conn &PGconn) PostgresPollingStatusType {
	c2v_gc_register_thread()
	state := &Fe_oauth_state(conn.sasl_state)
	request := &PGoauthBearerRequest(state.async_ctx)
	status := PostgresPollingStatusType{}
	if isnil(request.async) {
		libpq_append_conn_error(conn, c'user-defined OAuth flow provided neither a token nor an async callback')
		return PostgresPollingStatusType.pgres_polling_failed
	}
	status = request.async(conn, request, &conn.altsock)
	if u32(status) == u32(PostgresPollingStatusType.pgres_polling_failed) {
		libpq_append_conn_error(conn, c'user-defined OAuth flow failed')
		return status
	} else if u32(status) == u32(PostgresPollingStatusType.pgres_polling_ok) {
		if isnil(request.token) {
			libpq_append_conn_error(conn, c'user-defined OAuth flow did not provide a token')
			return PostgresPollingStatusType.pgres_polling_failed
		}
		conn.oauth_token = C.c2v_strdup(request.token)
		if isnil(conn.oauth_token) {
			libpq_append_conn_error(conn, c'out of memory')
			return PostgresPollingStatusType.pgres_polling_failed
		}
		return PostgresPollingStatusType.pgres_polling_ok
	}
	if conn.altsock == (-1) {
		libpq_append_conn_error(conn, c'user-defined OAuth flow did not provide a socket for polling')
		return PostgresPollingStatusType.pgres_polling_failed
	}
	return status
}

@[markused]
pub fn cleanup_user_oauth_flow(conn &PGconn) {
	c2v_gc_register_thread()
	state := &Fe_oauth_state(conn.sasl_state)
	request := &PGoauthBearerRequest(state.async_ctx)

	if request.cleanup {
		request.cleanup(conn, request)
	}
	conn.altsock = (-1)
	C.c2v_free(voidptr(request))
	state.async_ctx = unsafe { nil }
}

@[export: 'use_builtin_flow']
@[markused]
pub fn use_builtin_flow(conn &PGconn, state &Fe_oauth_state) bool {
	return false != 0
}

@[markused]
pub fn setup_token_request(conn &PGconn, state &Fe_oauth_state) bool {
	res := i32(0)
	request := PGoauthBearerRequest{
		openid_configuration: conn.oauth_discovery_uri
		scope: conn.oauth_scope
	}

	res = pq_auth_data_hook(PGauthData(PGauthData.pqauthdata_oauth_bearer_token), conn, voidptr(&request))
	if res > 0 {
		request_copy := &PGoauthBearerRequest(0)
		if request.token {
			conn.oauth_token = C.c2v_strdup(request.token)
			if isnil(conn.oauth_token) {
				libpq_append_conn_error(conn, c'out of memory')
				unsafe {
					goto fail
				}
			}
			if request.cleanup {
				request.cleanup(conn, &request)
			}
			return true != 0
		}
		request_copy = C.c2v_malloc(sizeof(PGoauthBearerRequest))
		if isnil(request_copy) {
			libpq_append_conn_error(conn, c'out of memory')
			unsafe {
				goto fail
			}
		}
		unsafe { *request_copy = request }
		conn.async_auth = run_user_oauth_flow
		conn.cleanup_async_auth = cleanup_user_oauth_flow
		state.async_ctx = request_copy
	} else if res < 0 {
		libpq_append_conn_error(conn, c'user-defined OAuth flow failed')
		unsafe {
			goto fail
		}
	} else if !use_builtin_flow(conn, state) {
		libpq_append_conn_error(conn, c'no OAuth flows are available (try installing the libpq-oauth package)')
		unsafe {
			goto fail
		}
	}
	return true != 0
	fail:
	if request.cleanup {
		request.cleanup(conn, &request)
	}
	return false != 0
}

@[markused]
pub fn setup_oauth_parameters(conn &PGconn) bool {
	if conn.oauth_issuer_id {
		return true != 0
	}
	if isnil(conn.oauth_issuer) || isnil(conn.oauth_client_id) {
		libpq_append_conn_error(conn, c'server requires OAuth authentication, but oauth_issuer and oauth_client_id are not both set')
		return false != 0
	}
	if usize(C.c2v_strstr(conn.oauth_issuer, c'/.well-known/')) != usize((voidptr(0))) {
		conn.oauth_issuer_id = issuer_from_well_known_uri(conn, conn.oauth_issuer)
		if isnil(conn.oauth_issuer_id) {
			return false != 0
		}
		conn.oauth_discovery_uri = C.c2v_strdup(conn.oauth_issuer)
		if isnil(conn.oauth_discovery_uri) {
			libpq_append_conn_error(conn, c'out of memory')
			return false != 0
		}
	} else {
		conn.oauth_issuer_id = C.c2v_strdup(conn.oauth_issuer)
		if isnil(conn.oauth_issuer_id) {
			libpq_append_conn_error(conn, c'out of memory')
			return false != 0
		}
	}
	return true != 0
}

@[markused]
pub fn oauth_exchange(opaq voidptr, final bool, input &i8, inputlen i32, output &&u8, outputlen &i32) SASLStatus {
	c2v_gc_register_thread()
	state := &Fe_oauth_state(opaq)
	conn := state.conn
	discover := (0 != 0)
	unsafe { *output = nil }
	unsafe { *outputlen = 0 }
	match state.step {
		.fe_oauth_init {
			if !setup_oauth_parameters(conn) {
				return SASLStatus.sasl_failed
			}
			if conn.oauth_token {
			} else if conn.oauth_discovery_uri {
				if !setup_token_request(conn, state) {
					return SASLStatus.sasl_failed
				}
				if conn.oauth_token {
				} else {
					discover = (1 != 0)
				}
			} else {
				discover = (1 != 0)
			}
			unsafe { *output = client_initial_response(conn, discover) }
			if isnil((unsafe { *output })) {
				return SASLStatus.sasl_failed
			}
			unsafe { *outputlen = i32(C.c2v_strlen(*output)) }
			state.step = Fe_oauth_step.fe_oauth_bearer_sent
			if conn.oauth_token {
				conn.client_finished_auth = (1 != 0)
			}
			return SASLStatus.sasl_continue
		}
		.fe_oauth_bearer_sent {
			if final {
				libpq_append_conn_error(conn, c'server sent unexpected additional OAuth data')
				return SASLStatus.sasl_failed
			}
			unsafe { *output = C.c2v_strdup(c'\001') }
			if (i64((isnil((unsafe { *output }))) != 0)) {
				libpq_append_conn_error(conn, c'out of memory')
				return SASLStatus.sasl_failed
			}
			unsafe { *outputlen = i32(C.c2v_strlen(*output)) }
			if !handle_oauth_sasl_error(conn, input, inputlen) {
				return SASLStatus.sasl_failed
			}
			if conn.oauth_token {
				state.step = Fe_oauth_step.fe_oauth_server_error
				return SASLStatus.sasl_continue
			}
			if isnil(conn.async_auth) {
				if isnil(conn.oauth_discovery_uri) {
					libpq_append_conn_error(conn, c'server requires OAuth authentication, but no discovery metadata was provided')
					return SASLStatus.sasl_failed
				}
				if !setup_token_request(conn, state) {
					return SASLStatus.sasl_failed
				}
				if conn.oauth_token {
					unsafe {
						goto reconnect
					}
				}
			}

			state.step = Fe_oauth_step.fe_oauth_requesting_token
			return SASLStatus.sasl_async
		}
		.fe_oauth_requesting_token {
			if isnil(conn.oauth_token) {
				libpq_append_conn_error(conn, c'internal error: OAuth flow did not set a token')
				return SASLStatus.sasl_failed
			}
			unsafe {
				goto reconnect
			}
		}
		.fe_oauth_server_error {
			libpq_append_conn_error(conn, c'server sent additional OAuth data after error')
			return SASLStatus.sasl_failed
		}
		else {
			libpq_append_conn_error(conn, c'invalid OAuth exchange state')
		}
	}

	return SASLStatus.sasl_failed
	reconnect:
	libpq_append_conn_error(conn, c'retrying connection with new bearer token')
	conn.oauth_want_retry = (1 != 0)
	return SASLStatus.sasl_failed
}

@[markused]
pub fn oauth_channel_bound(opaq voidptr) bool {
	c2v_gc_register_thread()
	return false != 0
}

@[export: 'pqClearOAuthToken']
@[markused]
pub fn pq_clear_oa_uth_token(conn &PGconn) {
	if isnil(conn.oauth_token) {
		return
	}
	explicit_bzero(voidptr(conn.oauth_token), C.c2v_strlen(conn.oauth_token))
	C.c2v_free(voidptr(conn.oauth_token))
	conn.oauth_token = unsafe { nil }
}

@[export: 'oauth_unsafe_debugging_enabled']
@[markused]
pub fn oauth_unsafe_debugging_enabled() bool {
	env := C.c2v_getenv(c'PGOAUTHDEBUG')
	return (!isnil(env) && C.c2v_strcmp(env, c'UNSAFE') == false) != 0
}
