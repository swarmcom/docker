
--
-- Name: change_domain_on_restore(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION change_domain_on_restore(new_domain text) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
    old_domain text;
begin
    SELECT name into old_domain from domain;
    update location set fqdn = replace(fqdn, old_domain, new_domain);
    update domain_alias set alias = replace(alias, old_domain, new_domain);
    update domain set name = new_domain, sip_realm = new_domain;
end;
$$;

--
-- Name: change_primary_fqdn_on_restore(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION change_primary_fqdn_on_restore(new_fqdn text) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
    old_fqdn text;
begin
    SELECT fqdn from location into old_fqdn where primary_location = TRUE;
    update domain_alias set alias = new_fqdn where alias = old_fqdn;
    update location set fqdn = new_fqdn where primary_location = TRUE;
end;
$$;
--
-- Name: change_primary_ip_on_restore(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION change_primary_ip_on_restore(new_ip text) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
    old_ip text;
begin
    SELECT ip_address from location into old_ip where primary_location = TRUE;
    update domain_alias set alias = new_ip where alias = old_ip;
    update location set ip_address = new_ip where primary_location = TRUE;
    update sbc_device set address = new_ip where address = old_ip;
end;
$$;


--
-- Name: make_plpgsql(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION make_plpgsql() RETURNS void
    LANGUAGE sql
    AS $$
CREATE LANGUAGE plpgsql;
$$;


--
-- Name: set_include_device_files(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION set_include_device_files() RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
if (select count(*) from setting_value where path='backup/device') > 0
then 
  update backup_plan set include_device_files = false;
else
  update backup_plan set include_device_files = true;
end if;
end;
$$;


--
-- Name: uncover_pin_on_restore(text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION uncover_pin_on_restore(reset_pin text, reset_passwd text, max_len integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
    realm text;
    max_pin integer;
    pin integer;
    candidate text;
    hash text;
    new_pin text;
    new_passwd text;
    my_user record;
begin
    SELECT sip_realm from domain into realm;   
    raise NOTICE 'realm is %', realm;
	for my_user in select user_name, pintoken from users loop
	    new_pin := NULL;
	    new_passwd := NULL;
	    <<cracked>>
		for pin_len in 1..max_len loop
			max_pin := (10 ^ pin_len) - 1;			
			for pin in 0..max_pin loop
				candidate := lpad('' || pin, pin_len, '0');
				hash := md5(my_user.user_name || ':' || realm || ':' || candidate);
				if hash = my_user.pintoken then
				    new_pin := candidate;
				    new_passwd := candidate;
					exit cracked;
				end if;
			end loop;
		end loop;
		
		if new_pin is NULL then
  		  new_pin := reset_pin;
		  new_passwd := reset_passwd;
  		  raise NOTICE 'resetting pin for %', my_user.user_name;
		end if;
		
		update users
          set pintoken = new_passwd,
              voicemail_pintoken = md5(my_user.user_name || ':' || new_pin)
        where user_name = my_user.user_name;
	end loop;
end;	
$$;

--
-- Name: abe_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE abe_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: addr_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE addr_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


-- Name: address; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE address (
    address_id integer NOT NULL,
    street character varying(255),
    zip character varying(255),
    country character varying(255),
    state character varying(255),
    city character varying(255),
    office_designation character varying(255)
);

--
-- Name: address_book_entry; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE address_book_entry (
    address_book_entry_id integer NOT NULL,
    cell_phone_number character varying(255),
    home_phone_number character varying(255),
    assistant_name character varying(255),
    assistant_phone_number character varying(255),
    fax_number character varying(255),
    location character varying(255),
    company_name character varying(255),
    job_title character varying(255),
    job_dept character varying(255),
    im_id character varying(255),
    alternate_im_id character varying(255),
    im_display_name character varying(255),
    use_branch_address boolean DEFAULT false NOT NULL,
    email_address character varying(255),
    alternate_email_address character varying(255),
    home_address_id integer,
    office_address_id integer,
    branch_address_id integer,
    did_number character varying(255)
);

--
-- Name: admin_role; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE admin_role (
    admin_role_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255)
);


--
-- Name: admin_role_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE admin_role_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: alarm_code; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE alarm_code (
    alarm_code_id character varying(255) NOT NULL,
    email_group character varying(255) NOT NULL,
    min_threshold integer NOT NULL
);


--
-- Name: alarm_code_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE alarm_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: alarm_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE alarm_group (
    alarm_group_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    enabled boolean DEFAULT false NOT NULL
);


--
-- Name: alarm_group_emailcontacts; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE alarm_group_emailcontacts (
    alarm_group_id integer NOT NULL,
    address character varying(255) NOT NULL,
    index integer NOT NULL
);


--
-- Name: alarm_group_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE alarm_group_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: alarm_group_smscontacts; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE alarm_group_smscontacts (
    alarm_group_id integer NOT NULL,
    address character varying(255) NOT NULL,
    index integer NOT NULL
);


--
-- Name: alarm_receiver; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE alarm_receiver (
    alarm_receiver_id integer NOT NULL,
    address character varying(255) NOT NULL,
    port integer
);

--
-- Name: alarm_receiver_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE alarm_receiver_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: alarm_server; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE alarm_server (
    alarm_server_id integer NOT NULL,
    alarm_notification_enabled boolean,
    from_email_address character varying(255)
);


--
-- Name: alarm_server_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE alarm_server_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: attendant_dialing_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attendant_dialing_rule (
    attendant_dialing_rule_id integer NOT NULL,
    attendant_aliases character varying(255),
    extension character varying(255),
    after_hours_attendant_id integer,
    after_hours_attendant_enabled boolean NOT NULL,
    holiday_attendant_id integer,
    holiday_attendant_enabled boolean NOT NULL,
    working_time_attendant_id integer,
    working_time_attendant_enabled boolean NOT NULL,
    did character varying(255),
    live_attendant boolean DEFAULT false NOT NULL,
    live_attendant_extension character varying(255),
    live_attendant_ring_for integer DEFAULT 0 NOT NULL,
    follow_user_call_forward boolean DEFAULT false NOT NULL,
    live_attendant_enabled boolean DEFAULT true,
    live_attendant_code character varying(255),
    live_attendant_expire timestamp without time zone
);


--
-- Name: attendant_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attendant_group (
    auto_attendant_id integer NOT NULL,
    group_id integer NOT NULL
);

--
-- Name: attendant_menu_item; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attendant_menu_item (
    auto_attendant_id integer NOT NULL,
    action character varying(255),
    parameter character varying(255),
    dialpad_key character varying(255) NOT NULL
);


--
-- Name: attendant_special_mode; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attendant_special_mode (
    attendant_special_mode_id integer NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    auto_attendant_id integer
);


--
-- Name: attendant_working_hours; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attendant_working_hours (
    attendant_dialing_rule_id integer NOT NULL,
    index integer NOT NULL,
    enabled boolean NOT NULL,
    day character varying(255),
    start timestamp without time zone,
    stop timestamp without time zone
);


--
-- Name: auth_code; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_code (
    auth_code_id integer NOT NULL,
    code character varying(255) NOT NULL,
    description character varying(255),
    internal_user_id integer
);


--
-- Name: auth_code_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: authority; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE authority (
    name character varying(255) NOT NULL,
    data text NOT NULL,
    private_key text
);


--
-- Name: auto_attendant; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auto_attendant (
    auto_attendant_id integer NOT NULL,
    name character varying(255),
    prompt character varying(255),
    system_id character varying(255),
    description character varying(255),
    value_storage_id integer,
    group_id integer,
    language character varying(255) DEFAULT 'default'::character varying,
    deny_dial character varying(1024),
    allow_dial character varying(1024)
);

--
-- Name: auto_attendant_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auto_attendant_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: backup_plan; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE backup_plan (
    backup_plan_id integer NOT NULL,
    limited_count integer,
    backup_type character varying(16) NOT NULL,
    def character varying(256) NOT NULL,
    include_device_files boolean
);

--
-- Name: backup_plan_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE backup_plan_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: bean_with_settings; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE bean_with_settings (
    bean_with_settings_id integer NOT NULL,
    bean_id character varying(255) NOT NULL,
    value_storage_id integer
);

--
-- Name: bean_with_settings_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE bean_with_settings_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: branch; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE branch (
    branch_id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    phone_number character varying(255),
    fax_number character varying(255),
    address_id integer,
    time_zone character varying(255),
    fallback_branch_id integer
);

--
-- Name: branch_aa_dialing_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE branch_aa_dialing_rule (
    attendant_dialing_rule_id integer NOT NULL,
    branch_id integer NOT NULL
);


--
-- Name: branch_auth_code; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE branch_auth_code (
    auth_code_id integer NOT NULL,
    branch_id integer NOT NULL
);

--
-- Name: branch_auto_attendant; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE branch_auto_attendant (
    auto_attendant_id integer NOT NULL,
    branch_id integer NOT NULL
);

--
-- Name: branch_branch; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE branch_branch (
    branch_id integer NOT NULL,
    associated_branch_id integer NOT NULL
);

--
-- Name: branch_branch_inbound; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE branch_branch_inbound (
    branch_id integer NOT NULL,
    associated_branch_id integer NOT NULL
);

--
-- Name: branch_call_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE branch_call_group (
    call_group_id integer NOT NULL,
    branch_id integer NOT NULL
);


--
-- Name: branch_call_queue; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE branch_call_queue (
    freeswitch_ext_id integer NOT NULL,
    branch_id integer NOT NULL
);


--
-- Name: branch_conference; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE branch_conference (
    meetme_conference_id integer NOT NULL,
    branch_id integer NOT NULL
);


--
-- Name: branch_paging_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE branch_paging_group (
    paging_group_id integer NOT NULL,
    branch_id integer NOT NULL
);


--
-- Name: branch_park_orbit; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE branch_park_orbit (
    park_orbit_id integer NOT NULL,
    branch_id integer NOT NULL
);


--
-- Name: branch_route_domain; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE branch_route_domain (
    branch_id integer NOT NULL,
    domain character varying(255) NOT NULL,
    index integer NOT NULL
);

--
-- Name: branch_route_subnet; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE branch_route_subnet (
    branch_id integer NOT NULL,
    subnet character varying(255) NOT NULL,
    index integer NOT NULL
);


--
-- Name: branch_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE branch_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: call_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE call_group (
    call_group_id integer NOT NULL,
    enabled boolean,
    name character varying(255),
    extension character varying(255),
    description character varying(255),
    fallback_destination character varying(255),
    voicemail_fallback boolean DEFAULT false NOT NULL,
    user_forward boolean DEFAULT true NOT NULL,
    sip_password character varying(255),
    did character varying(255),
    use_fwd_timers boolean DEFAULT false,
    fallback_expire integer DEFAULT 30 NOT NULL
);

--
-- Name: call_group_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE call_group_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: call_queue_agent; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE call_queue_agent (
    call_queue_agent_id integer NOT NULL,
    name character varying(255) NOT NULL,
    extension character varying(255),
    description character varying(255),
    value_storage_id integer
);

--
-- Name: call_queue_agent_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE call_queue_agent_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: call_queue_tier; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE call_queue_tier (
    call_queue_agent_id integer,
    freeswitch_ext_id integer,
    "position" integer,
    level integer
);

--
-- Name: call_rate_limit; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE call_rate_limit (
    call_rate_limit_id integer NOT NULL,
    call_rate_rule_id integer NOT NULL,
    rate integer NOT NULL,
    sip_method character varying(255) NOT NULL,
    "interval" character varying(255) NOT NULL
);

--
-- Name: call_rate_limit_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE call_rate_limit_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: call_rate_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE call_rate_rule (
    call_rate_rule_id integer NOT NULL,
    start_ip character varying(255) NOT NULL,
    end_ip character varying(255),
    name character varying(255) NOT NULL,
    "position" integer,
    description character varying(255)
);

--
-- Name: call_rate_rule_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE call_rate_rule_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: cert; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cert (
    name character varying(255) NOT NULL,
    data text NOT NULL,
    private_key text,
    authority character varying(255)
);

--
-- Name: cron_schedule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cron_schedule (
    cron_schedule_id integer NOT NULL,
    cron_string character varying(255),
    enabled boolean DEFAULT false NOT NULL
);

--
-- Name: custom_dialing_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE custom_dialing_rule (
    custom_dialing_rule_id integer NOT NULL,
    call_pattern_digits character varying(255),
    call_pattern_prefix character varying(255)
);

--
-- Name: custom_dialing_rule_permission; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE custom_dialing_rule_permission (
    custom_dialing_rule_id integer NOT NULL,
    permission character varying(255)
);

--
-- Name: daily_backup_schedule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE daily_backup_schedule (
    daily_backup_schedule_id integer NOT NULL,
    enabled boolean,
    time_of_day timestamp without time zone,
    scheduled_day character varying(255),
    backup_plan_id integer
);

--
-- Name: daily_backup_schedule_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE daily_backup_schedule_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: dial_pattern; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dial_pattern (
    custom_dialing_rule_id integer NOT NULL,
    element_prefix character varying(255),
    element_digits integer,
    index integer NOT NULL
);

--
-- Name: dial_plan; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dial_plan (
    dial_plan_id integer NOT NULL,
    type character varying(255)
);

--
-- Name: dial_plan_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dial_plan_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: dialing_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dialing_rule (
    dialing_rule_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    enabled boolean,
    "position" integer,
    dial_plan_id integer,
    schedule_id integer
);

--
-- Name: dialing_rule_gateway; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dialing_rule_gateway (
    dialing_rule_id integer NOT NULL,
    gateway_id integer NOT NULL,
    index integer NOT NULL
);


--
-- Name: dialing_rule_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dialing_rule_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: dns_custom; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dns_custom (
    dns_custom_id integer NOT NULL,
    name character varying(255) NOT NULL,
    records text
);

--
-- Name: dns_custom_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dns_custom_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: dns_custom_view_link; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dns_custom_view_link (
    dns_custom_id integer NOT NULL,
    dns_view_id integer NOT NULL
);

--
-- Name: dns_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dns_group (
    dns_group_id integer NOT NULL,
    dns_plan_id integer,
    "position" integer NOT NULL
);

--
-- Name: dns_group_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dns_group_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: dns_plan; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dns_plan (
    dns_plan_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: dns_plan_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dns_plan_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: dns_target; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dns_target (
    dns_group_id integer NOT NULL,
    percentage integer NOT NULL,
    region_id integer,
    location_id integer,
    basic_id character(1)
);

--
-- Name: dns_view; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dns_view (
    dns_view_id integer NOT NULL,
    name character varying(255) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    dns_plan_id integer,
    region_id integer,
    "position" integer NOT NULL,
    excluded character varying(32)
);


--
-- Name: dns_view_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dns_view_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: domain; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE domain (
    domain_id integer NOT NULL,
    name character varying(255) NOT NULL,
    shared_secret character varying(255),
    sip_realm character varying(255)
);

--
-- Name: domain_alias; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE domain_alias (
    domain_id integer NOT NULL,
    alias character varying(255) NOT NULL
);

--
-- Name: domain_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE domain_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: e911_erl; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE e911_erl (
    erl_id integer NOT NULL,
    location character varying NOT NULL,
    elin character varying NOT NULL,
    address_info character varying,
    ip_addr_start character varying,
    ip_addr_end character varying,
    description character varying
);

--
-- Name: emergency_dialing_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE emergency_dialing_rule (
    emergency_dialing_rule_id integer NOT NULL,
    optional_prefix character varying(255),
    emergency_number character varying(255)
);

--
-- Name: erl_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE erl_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: extension_pool; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE extension_pool (
    extension_pool_id integer NOT NULL,
    enabled boolean NOT NULL,
    name character varying(255) NOT NULL,
    first_extension integer,
    last_extension integer,
    next_extension integer
);

--
-- Name: extension_pool_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE extension_pool_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: feature_global; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE feature_global (
    feature_id character varying(255) NOT NULL
);

--
-- Name: feature_local; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE feature_local (
    feature_id character varying(255) NOT NULL,
    location_id integer NOT NULL
);

--
-- Name: firewall_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE firewall_rule (
    firewall_rule_id integer NOT NULL,
    prioritize boolean DEFAULT false,
    address_type character varying(32) NOT NULL,
    firewall_server_group_id integer,
    system_id character varying(16)
);

--
-- Name: firewall_rule_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE firewall_rule_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: firewall_server_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE firewall_server_group (
    firewall_server_group_id integer NOT NULL,
    name character varying(255) NOT NULL,
    servers character varying(255) NOT NULL
);

--
-- Name: firewall_server_group_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE firewall_server_group_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: freeswitch_action; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE freeswitch_action (
    freeswitch_action_id integer NOT NULL,
    application character varying(255) NOT NULL,
    data character varying(255),
    freeswitch_condition_id integer NOT NULL
);


--
-- Name: freeswitch_action_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE freeswitch_action_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: freeswitch_condition; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE freeswitch_condition (
    freeswitch_condition_id integer NOT NULL,
    field character varying(255) NOT NULL,
    expression character varying(255) NOT NULL,
    freeswitch_ext_id integer NOT NULL,
    regex boolean DEFAULT false
);

--
-- Name: freeswitch_condition_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE freeswitch_condition_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: freeswitch_ext_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE freeswitch_ext_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: freeswitch_extension; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE freeswitch_extension (
    freeswitch_ext_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    freeswitch_ext_type character(1) NOT NULL,
    did character varying(255),
    alias character varying(255),
    enabled boolean DEFAULT true NOT NULL,
    value_storage_id integer
);

--
-- Name: fxo_port; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE fxo_port (
    fxo_port_id integer NOT NULL,
    gateway_id integer NOT NULL,
    "position" integer,
    value_storage_id integer
);

--
-- Name: fxo_port_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE fxo_port_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: gateway; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE gateway (
    gateway_id integer NOT NULL,
    bean_id character varying(255) NOT NULL,
    name character varying(255),
    address character varying(255),
    description character varying(255),
    serial_number character varying(255),
    value_storage_id integer,
    model_id character varying(64) NOT NULL,
    device_version_id character varying(32),
    prefix character varying(255),
    default_caller_alias character varying(255),
    anonymous boolean DEFAULT false NOT NULL,
    ignore_user_info boolean DEFAULT false NOT NULL,
    transform_user_extension boolean DEFAULT false NOT NULL,
    add_prefix character varying(255),
    keep_digits integer DEFAULT 0 NOT NULL,
    address_port integer DEFAULT 0 NOT NULL,
    address_transport character varying(8) DEFAULT 'none'::character varying NOT NULL,
    sbc_device_id integer,
    display_name character varying(255),
    url_parameters character varying(255),
    shared boolean NOT NULL,
    branch_id integer,
    enabled boolean NOT NULL,
    use_sipxbridge boolean DEFAULT true,
    outbound_address character varying(255),
    outbound_port integer DEFAULT 5060
);

--
-- Name: gateway_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE gateway_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: google_domain; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE google_domain (
    google_domain_id integer NOT NULL,
    domain_name character varying(255)
);

--
-- Name: google_domain_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE google_domain_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: group_storage; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE group_storage (
    group_id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    resource character varying(255),
    weight integer,
    branch_id integer
);

--
-- Name: group_weight; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE group_weight (
    weight integer NOT NULL
);

--
-- Name: group_weight_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE group_weight_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: holiday_dates; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE holiday_dates (
    attendant_dialing_rule_id integer NOT NULL,
    "position" integer NOT NULL,
    start_date timestamp without time zone,
    end_date timestamp without time zone
);

--
-- Name: intercom; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE intercom (
    intercom_id integer NOT NULL,
    enabled boolean NOT NULL,
    prefix character varying(255) NOT NULL,
    timeout integer NOT NULL,
    code character varying(255) NOT NULL
);

--
-- Name: intercom_phone_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE intercom_phone_group (
    intercom_id integer NOT NULL,
    group_id integer NOT NULL
);

--
-- Name: intercom_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE intercom_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: internal_dialing_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE internal_dialing_rule (
    internal_dialing_rule_id integer NOT NULL,
    auto_attendant_id integer,
    local_extension_len integer,
    voice_mail character varying(255),
    voice_mail_prefix character varying(255),
    aa_aliases character varying(255),
    media_server_type character varying(255),
    media_server_hostname character varying(255),
    did character varying(255),
    media_server_port integer,
    external_authorization_checked boolean
);

--
-- Name: international_dialing_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE international_dialing_rule (
    international_dialing_rule_id integer NOT NULL,
    international_prefix character varying(255)
);

--
-- Name: job; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE job (
    job_id integer NOT NULL,
    type integer,
    status character(1),
    start_time_string character varying(255),
    details character varying(255),
    progress character varying(255),
    exception_message character varying(255)
);

--
-- Name: job_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE job_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: ldap_attr_map; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ldap_attr_map (
    ldap_attr_map_id integer NOT NULL,
    default_group_name character varying(255),
    default_pin character varying(255),
    search_base character varying(255),
    object_class character varying(255),
    filter character varying
);

--
-- Name: ldap_connection; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ldap_connection (
    ldap_connection_id integer NOT NULL,
    host character varying(255),
    port integer,
    principal character varying(255),
    secret character varying(255),
    cron_schedule_id integer,
    use_tls boolean DEFAULT false NOT NULL,
    timeout integer
);

--
-- Name: ldap_selected_object_classes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ldap_selected_object_classes (
    ldap_attr_map_id integer NOT NULL,
    object_class character varying(255)
);

--
-- Name: ldap_settings; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ldap_settings (
    ldap_settings_id integer NOT NULL,
    authentication_options character varying(8) DEFAULT 'noLDAP'::character varying NOT NULL,
    enable_openfire_configuration boolean NOT NULL,
    configured boolean DEFAULT false NOT NULL
);

--
-- Name: ldap_settings_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ldap_settings_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: ldap_user_property_to_ldap_attr; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ldap_user_property_to_ldap_attr (
    ldap_attr_map_id integer NOT NULL,
    user_property character varying(255) NOT NULL,
    ldap_attr character varying(255)
);

--
-- Name: license; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE license (
    name character varying(255) NOT NULL,
    data text NOT NULL,
    upload_time bigint NOT NULL,
    hash character varying(255)
);

--
-- Name: line; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE line (
    line_id integer NOT NULL,
    phone_id integer NOT NULL,
    "position" integer,
    user_id integer,
    value_storage_id integer
);

--
-- Name: line_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE line_group (
    line_id integer NOT NULL,
    group_id integer NOT NULL
);

--
-- Name: line_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE line_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: local_dialing_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE local_dialing_rule (
    local_dialing_rule_id integer NOT NULL,
    external_len integer,
    pstn_prefix character varying(255)
);

--
-- Name: localization; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE localization (
    localization_id integer NOT NULL,
    region character varying(255),
    language character varying(255)
);

--
-- Name: localization_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE localization_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: location; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE location (
    location_id integer NOT NULL,
    name character varying(255) NOT NULL,
    fqdn character varying(255) NOT NULL,
    ip_address character varying(255),
    password character varying(255),
    primary_location boolean DEFAULT false NOT NULL,
    registered boolean DEFAULT false NOT NULL,
    use_stun boolean DEFAULT true NOT NULL,
    stun_address character varying(255),
    stun_interval integer DEFAULT 60 NOT NULL,
    public_address character varying(255),
    public_port integer DEFAULT 5060 NOT NULL,
    start_rtp_port integer DEFAULT 30000 NOT NULL,
    stop_rtp_port integer DEFAULT 31000 NOT NULL,
    branch_id integer,
    public_tls_port integer DEFAULT 5061 NOT NULL,
    state character varying(32) DEFAULT 'UNCONFIGURED'::character varying NOT NULL,
    last_attempt timestamp without time zone,
    call_traffic boolean DEFAULT true NOT NULL,
    replicate_config boolean DEFAULT true NOT NULL,
    region_id integer
);

--
-- Name: location_failed_replications; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE location_failed_replications (
    location_id integer NOT NULL,
    entity_name character varying(255) NOT NULL
);

--
-- Name: location_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE location_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: long_distance_dialing_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE long_distance_dialing_rule (
    international_dialing_rule_id integer NOT NULL,
    area_codes character varying(255),
    external_len integer,
    long_distance_prefix character varying(255),
    permission character varying(255),
    pstn_prefix character varying(255),
    pstn_prefix_optional boolean,
    long_distance_prefix_optional boolean
);

--
-- Name: meetme_bridge; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE meetme_bridge (
    meetme_bridge_id integer NOT NULL,
    value_storage_id integer,
    location_id integer NOT NULL
);

--
-- Name: meetme_conference; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE meetme_conference (
    meetme_conference_id integer NOT NULL,
    enabled boolean,
    name character varying(255) NOT NULL,
    description character varying(255),
    extension character varying(255),
    value_storage_id integer,
    meetme_bridge_id integer NOT NULL,
    owner_id integer,
    did character varying(255)
);

--
-- Name: meetme_participant; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE meetme_participant (
    meetme_participant_id integer NOT NULL,
    enabled boolean,
    value_storage_id integer,
    user_id integer NOT NULL,
    meetme_conference_id integer NOT NULL
);

--
-- Name: meetme_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE meetme_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: openacd_agent; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_agent (
    openacd_agent_id integer NOT NULL,
    openacd_agent_group_id integer NOT NULL,
    user_id integer NOT NULL,
    openacd_permission_profile_id integer NOT NULL,
    ring_timeout integer DEFAULT 0 NOT NULL
);

--
-- Name: openacd_agent_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_agent_group (
    openacd_agent_group_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    openacd_permission_profile_id integer NOT NULL,
    auto_logout boolean DEFAULT false,
    release_duration character varying(255) DEFAULT '0'::character varying,
    release_on_ring_failure integer,
    ring_timeout integer DEFAULT 12 NOT NULL
);

--
-- Name: openacd_agent_group_queue; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_agent_group_queue (
    openacd_queue_id integer NOT NULL,
    openacd_agent_group_id integer NOT NULL
);

--
-- Name: openacd_agent_group_queue_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_agent_group_queue_group (
    openacd_queue_group_id integer NOT NULL,
    openacd_agent_group_id integer NOT NULL
);

--
-- Name: openacd_agent_group_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE openacd_agent_group_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: openacd_agent_pstn; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_agent_pstn (
    openacd_agent_id integer NOT NULL,
    pstn_number character varying(255) NOT NULL,
    index integer NOT NULL
);

--
-- Name: openacd_agent_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE openacd_agent_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: openacd_call_disposition; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_call_disposition (
    openacd_client_id integer NOT NULL,
    disposition character varying(255) NOT NULL,
    index integer NOT NULL
);

--
-- Name: openacd_client; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_client (
    openacd_client_id integer NOT NULL,
    name character varying(255) NOT NULL,
    identity character varying(255) NOT NULL,
    description character varying(255),
    agent_callerid boolean DEFAULT true NOT NULL,
    outbound_callerid character varying(255),
    inbound_callerid character varying(255),
    record_calls boolean DEFAULT false NOT NULL,
    retain_recordings integer DEFAULT 7 NOT NULL,
    recording_location character varying(255),
    company_name character varying(255),
    company_street character varying(255),
    company_city character varying(255),
    company_state character varying(255),
    company_country character varying(255),
    company_zip character varying(255),
    company_designation character varying(255),
    company_phone_number character varying(255),
    company_fax_number character varying(255),
    contact_name character varying(255),
    contact_job character varying(255),
    contact_work_phone_number character varying(255),
    contact_cell_phone_number character varying(255),
    contact_email character varying(255),
    assistant_name character varying(255),
    assistant_phone_number character varying(255),
    assistant_email character varying(255),
    url_popup character varying(255),
    avatar character varying(255),
    ext_avatar character varying(255),
    use_ext_avatar boolean DEFAULT false NOT NULL,
    archive_recordings character varying(255),
    retain_recordings_in_archive integer DEFAULT 180 NOT NULL
);

--
-- Name: openacd_client_agent; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_client_agent (
    openacd_agent_id integer NOT NULL,
    openacd_client_id integer NOT NULL
);

--
-- Name: openacd_client_agent_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_client_agent_group (
    openacd_agent_group_id integer NOT NULL,
    openacd_client_id integer NOT NULL
);

--
-- Name: openacd_client_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE openacd_client_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: openacd_custom_header; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_custom_header (
    openacd_custom_header_id integer NOT NULL,
    name character varying(255) NOT NULL,
    active boolean DEFAULT false,
    description character varying(255) NOT NULL
);

--
-- Name: openacd_custom_header_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE openacd_custom_header_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: openacd_permission_agent_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_permission_agent_group (
    openacd_agent_group_id integer NOT NULL,
    openacd_permission_profile_id integer NOT NULL
);

--
-- Name: openacd_permission_profile; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_permission_profile (
    openacd_permission_profile_id integer NOT NULL,
    name character varying(255) NOT NULL,
    monitor boolean NOT NULL,
    barge boolean NOT NULL,
    customize_desktop boolean DEFAULT false NOT NULL,
    use_advanced_login boolean DEFAULT false NOT NULL,
    transfer_to_agent boolean DEFAULT true NOT NULL,
    transfer_to_queue boolean DEFAULT true NOT NULL,
    transfer_to_number boolean DEFAULT true NOT NULL,
    conference_to_agent boolean DEFAULT true NOT NULL,
    conference_to_queue boolean DEFAULT true NOT NULL,
    conference_to_number boolean DEFAULT true NOT NULL,
    change_skills_on_tran_conf boolean DEFAULT true NOT NULL,
    control_agent_state boolean DEFAULT true NOT NULL,
    reports_tab boolean DEFAULT false NOT NULL,
    supervisor_tab boolean DEFAULT false NOT NULL,
    allow_outbound boolean DEFAULT false NOT NULL
);

--
-- Name: openacd_permission_profile_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE openacd_permission_profile_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: openacd_permission_queue; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_permission_queue (
    openacd_queue_id integer NOT NULL,
    openacd_permission_profile_id integer NOT NULL
);

--
-- Name: openacd_permission_widget; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_permission_widget (
    openacd_permission_profile_id integer NOT NULL,
    widget character varying(255) NOT NULL
);

--
-- Name: openacd_queue; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_queue (
    openacd_queue_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    openacd_queue_group_id integer NOT NULL,
    weight integer NOT NULL,
    block_transfer boolean DEFAULT false,
    aging_factor numeric(11,1) DEFAULT 1.0 NOT NULL,
    enable_wrapup boolean DEFAULT false NOT NULL,
    wrapup_timer integer DEFAULT 0 NOT NULL,
    auto_wrapup integer DEFAULT 0 NOT NULL
);

--
-- Name: openacd_queue_agent; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_queue_agent (
    openacd_agent_id integer NOT NULL,
    openacd_queue_id integer NOT NULL
);

--
-- Name: openacd_queue_agent_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_queue_agent_group (
    openacd_agent_group_id integer NOT NULL,
    openacd_queue_id integer NOT NULL
);

--
-- Name: openacd_queue_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_queue_group (
    openacd_queue_group_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255)
);

--
-- Name: openacd_queue_group_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE openacd_queue_group_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: openacd_queue_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE openacd_queue_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: openacd_recipe_action; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_recipe_action (
    openacd_recipe_action_id integer NOT NULL,
    action character varying(255) NOT NULL,
    action_value character varying(255)
);

--
-- Name: openacd_recipe_action_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE openacd_recipe_action_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: openacd_recipe_condition; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_recipe_condition (
    openacd_recipe_step_id integer NOT NULL,
    condition character varying(255) NOT NULL,
    relation character varying(255) NOT NULL,
    value_condition character varying(255) NOT NULL,
    index integer NOT NULL
);

--
-- Name: openacd_recipe_step; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_recipe_step (
    openacd_recipe_step_id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    openacd_recipe_action_id integer,
    frequency character varying(255) NOT NULL,
    openacd_queue_id integer,
    openacd_queue_group_id integer
);

--
-- Name: openacd_recipe_step_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE openacd_recipe_step_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: openacd_release_codes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_release_codes (
    openacd_code_id integer NOT NULL,
    label character varying(255) NOT NULL,
    bias character varying(255) NOT NULL,
    description character varying(255)
);

--
-- Name: openacd_release_codes_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE openacd_release_codes_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: openacd_skill; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_skill (
    openacd_skill_id integer NOT NULL,
    name character varying(255) NOT NULL,
    atom character varying(255) NOT NULL,
    description character varying(255),
    default_skill boolean DEFAULT false NOT NULL,
    openacd_skill_group_id integer
);

--
-- Name: openacd_skill_agent; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_skill_agent (
    openacd_agent_id integer NOT NULL,
    openacd_skill_id integer NOT NULL
);

--
-- Name: openacd_skill_agent_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_skill_agent_group (
    openacd_agent_group_id integer NOT NULL,
    openacd_skill_id integer NOT NULL
);

--
-- Name: openacd_skill_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_skill_group (
    openacd_skill_group_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255)
);

--
-- Name: openacd_skill_group_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE openacd_skill_group_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: openacd_skill_queue; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_skill_queue (
    openacd_queue_id integer NOT NULL,
    openacd_skill_id integer NOT NULL
);

--
-- Name: openacd_skill_queue_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_skill_queue_group (
    openacd_queue_group_id integer NOT NULL,
    openacd_skill_id integer NOT NULL
);

--
-- Name: openacd_skill_recipe_action; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE openacd_skill_recipe_action (
    openacd_recipe_action_id integer NOT NULL,
    openacd_skill_id integer NOT NULL
);

--
-- Name: openacd_skill_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE openacd_skill_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: paging_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE paging_group (
    paging_group_id integer NOT NULL,
    page_group_number integer NOT NULL,
    description character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    sound character varying(255) NOT NULL,
    timeout integer DEFAULT 60 NOT NULL
);

--
-- Name: paging_group_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE paging_group_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: paging_server; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE paging_server (
    paging_server_id integer NOT NULL,
    prefix character varying(255) NOT NULL,
    sip_trace_level character varying(255) NOT NULL
);

--
-- Name: park_orbit; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE park_orbit (
    park_orbit_id integer NOT NULL,
    orbit_type character(1) NOT NULL,
    music character varying(255),
    enabled boolean,
    name character varying(255),
    extension character varying(255),
    description character varying(255),
    value_storage_id integer,
    group_id integer,
    location_id integer DEFAULT 1
);

--
-- Name: park_orbit_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE park_orbit_group (
    park_orbit_id integer NOT NULL,
    group_id integer NOT NULL
);

--
-- Name: park_orbit_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE park_orbit_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: patch; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE patch (
    name character varying(32) NOT NULL
);

--
-- Name: permission; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE permission (
    permission_id integer NOT NULL,
    description character varying(255),
    label character varying(255),
    default_value boolean NOT NULL
);

--
-- Name: permission_admin_role; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE permission_admin_role (
    admin_role_id integer NOT NULL,
    permission character varying(255) NOT NULL
);

--
-- Name: personal_attendant; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE personal_attendant (
    personal_attendant_id integer NOT NULL,
    user_id integer NOT NULL,
    language character varying(255),
    override_language boolean DEFAULT false NOT NULL
);

--
-- Name: personal_attendant_menu_item; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE personal_attendant_menu_item (
    personal_attendant_id integer NOT NULL,
    action character varying(255),
    parameter character varying(255),
    dialpad_key character varying(255) NOT NULL
);

--
-- Name: personal_attendant_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE personal_attendant_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: phone; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE phone (
    phone_id integer NOT NULL,
    description character varying(255),
    serial_number character varying(255) NOT NULL,
    bean_id character varying(255),
    value_storage_id integer,
    model_id character varying(64) NOT NULL,
    device_version_id character varying(32),
    e911_location_id integer
);

--
-- Name: phone_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE phone_group (
    phone_id integer NOT NULL,
    group_id integer NOT NULL
);

--
-- Name: phone_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE phone_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: phonebook; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE phonebook (
    phonebook_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    members_csv_filename character varying(255),
    members_vcard_filename character varying(255),
    user_id integer,
    show_on_phone boolean DEFAULT true
);

--
-- Name: phonebook_consumer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE phonebook_consumer (
    phonebook_id integer NOT NULL,
    group_id integer NOT NULL
);

--
-- Name: phonebook_file_entry; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE phonebook_file_entry (
    phonebook_file_entry_id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    phone_number character varying(255),
    address_book_entry_id integer,
    phonebook_id integer NOT NULL,
    phonebook_entry_type character(1),
    google_account_id character varying(255),
    internal_id character varying(255)
);

--
-- Name: phonebook_file_entry_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE phonebook_file_entry_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: phonebook_member; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE phonebook_member (
    phonebook_id integer NOT NULL,
    group_id integer NOT NULL
);

--
-- Name: phonebook_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE phonebook_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: private_user_key; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE private_user_key (
    private_user_key_id integer NOT NULL,
    key character varying(255),
    user_id integer
);

--
-- Name: private_user_key_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE private_user_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: region; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE region (
    region_id integer NOT NULL,
    name character varying(255),
    addresses character varying(1024)
);

--
-- Name: region_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE region_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: ring; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ring (
    ring_id integer NOT NULL,
    number character varying(255),
    "position" integer,
    expiration integer,
    ring_type character varying(255),
    user_id integer NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    schedule_id integer
);

--
-- Name: ring_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ring_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: sbc; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sbc (
    sbc_id integer NOT NULL,
    enabled boolean,
    sbc_type character(1) NOT NULL,
    sbc_device_id integer,
    address_actual character varying(255),
    port integer DEFAULT 5060
);

--
-- Name: sbc_device; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sbc_device (
    sbc_device_id integer NOT NULL,
    bean_id character varying(255) NOT NULL,
    name character varying(255),
    address character varying(255),
    description character varying(255),
    serial_number character varying(255),
    value_storage_id integer,
    model_id character varying(64) NOT NULL,
    device_version_id character varying(32),
    port integer DEFAULT 5060 NOT NULL
);

--
-- Name: sbc_route_domain; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sbc_route_domain (
    sbc_id integer NOT NULL,
    domain character varying(255) NOT NULL,
    index integer NOT NULL
);

--
-- Name: sbc_route_subnet; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sbc_route_subnet (
    sbc_id integer NOT NULL,
    subnet character varying(255) NOT NULL,
    index integer NOT NULL
);

--
-- Name: sbc_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sbc_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: schedule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE schedule (
    schedule_id integer NOT NULL,
    user_id integer,
    name character varying(255) NOT NULL,
    description character varying(255),
    group_id integer,
    schedule_type character(1)
);

--
-- Name: schedule_feature; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE schedule_feature (
    schedule_id integer NOT NULL,
    feature_id character varying(255) NOT NULL
);

--
-- Name: schedule_hours; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE schedule_hours (
    schedule_hours_id integer NOT NULL,
    schedule_id integer NOT NULL,
    start timestamp without time zone,
    stop timestamp without time zone,
    day character varying(255)
);

--
-- Name: schedule_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE schedule_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: service; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE service (
    service_id integer NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    bean_id character varying(32) NOT NULL,
    enabled boolean NOT NULL,
    descriptor_id character varying(32),
    value_storage_id integer,
    description character varying(255)
);

--
-- Name: service_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE service_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: setting_value; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE setting_value (
    value_storage_id integer NOT NULL,
    value character varying(7500) NOT NULL,
    path character varying(255) NOT NULL
);

--
-- Name: settings_location_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE settings_location_group (
    settings_with_location_id integer NOT NULL,
    group_id integer NOT NULL
);

--
-- Name: settings_with_location; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE settings_with_location (
    settings_with_location_id integer NOT NULL,
    bean_id character varying(255) NOT NULL,
    location_id integer NOT NULL,
    value_storage_id integer
);

--
-- Name: settings_with_location_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE settings_with_location_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: setup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE setup (
    setup_id character varying(255) NOT NULL
);

--
-- Name: shard; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shard (
    shard_id integer NOT NULL,
    name character varying(255) NOT NULL
);

--
-- Name: shard_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shard_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: site_to_site_dial_pattern; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE site_to_site_dial_pattern (
    site_to_site_dialing_rule_id integer NOT NULL,
    element_prefix character varying(255),
    element_digits integer,
    index integer NOT NULL
);

--
-- Name: site_to_site_dialing_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE site_to_site_dialing_rule (
    site_to_site_dialing_rule_id integer NOT NULL,
    call_pattern_digits character varying(255),
    call_pattern_prefix character varying(255)
);

--
-- Name: special_user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE special_user (
    special_user_id integer NOT NULL,
    user_type character varying(255),
    sip_password character varying(255)
);

--
-- Name: speeddial; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE speeddial (
    speeddial_id integer NOT NULL,
    user_id integer NOT NULL
);

--
-- Name: speeddial_button; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE speeddial_button (
    speeddial_id integer NOT NULL,
    label character varying(255),
    number character varying(255) NOT NULL,
    blf boolean DEFAULT false NOT NULL,
    "position" integer NOT NULL
);

--
-- Name: speeddial_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE speeddial_group (
    speeddial_id integer NOT NULL,
    group_id integer NOT NULL
);

--
-- Name: speeddial_group_button; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE speeddial_group_button (
    speeddial_id integer NOT NULL,
    label character varying(255),
    number character varying(255) NOT NULL,
    blf boolean DEFAULT false NOT NULL,
    "position" integer NOT NULL
);


--
-- Name: speeddial_group_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE speeddial_group_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: speeddial_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE speeddial_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: storage_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE storage_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: supervisor; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE supervisor (
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: timezone; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE timezone (
    timezone_id integer NOT NULL,
    gmt_offset integer,
    dstsavings_enabled boolean,
    dst_savings integer,
    start_month integer,
    start_week integer,
    start_day_of_week integer,
    start_time integer,
    stop_month integer,
    stop_week integer,
    stop_day_of_week integer,
    stop_time integer
);


--
-- Name: timezone_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE timezone_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: tls_peer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tls_peer (
    tls_peer_id integer NOT NULL,
    name character varying(255) NOT NULL,
    internal_user_id integer
);


--
-- Name: tls_peer_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tls_peer_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: unite_mobile_license; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE unite_mobile_license (
    uml_id integer NOT NULL,
    username character varying NOT NULL,
    profile_name character varying NOT NULL,
    uuid character varying NOT NULL,
    allocated timestamp without time zone NOT NULL
);


--
-- Name: unite_mobile_license_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE unite_mobile_license_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: upload; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE upload (
    upload_id integer NOT NULL,
    name character varying(255) NOT NULL,
    deployed boolean NOT NULL,
    bean_id character varying(32) NOT NULL,
    specification_id character varying(32),
    value_storage_id integer,
    description character varying(255)
);

--
-- Name: upload_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE upload_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

--
-- Name: user_admin_role; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_admin_role (
    admin_role_id integer NOT NULL,
    user_id integer NOT NULL
);

--
-- Name: user_alarm_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_alarm_group (
    alarm_group_id integer NOT NULL,
    user_id integer NOT NULL
);

--
-- Name: user_alias; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_alias (
    user_id integer NOT NULL,
    alias character varying(255) NOT NULL
);

--
-- Name: user_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_group (
    user_id integer NOT NULL,
    group_id integer NOT NULL
);

--
-- Name: user_paging_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_paging_group (
    paging_group_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: user_ring; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_ring (
    user_ring_id integer NOT NULL,
    "position" integer,
    expiration integer,
    ring_type character varying(255),
    call_group_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: user_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    user_id integer NOT NULL,
    first_name character varying(255),
    pintoken character varying(255),
    sip_password character varying(255),
    last_name character varying(255),
    user_name character varying(255) NOT NULL,
    value_storage_id integer,
    address_book_entry_id integer,
    is_shared boolean DEFAULT false NOT NULL,
    branch_id integer,
    user_type character(1),
    voicemail_pintoken character varying(255),
    notified boolean DEFAULT false NOT NULL,
    e911_location_id integer
);

--
-- Name: value_storage; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE value_storage (
    value_storage_id integer NOT NULL
);


--
-- Name: version_history; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE version_history (
    version integer NOT NULL,
    applied date NOT NULL
);


--
-- Name: address_book_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY address_book_entry
    ADD CONSTRAINT address_book_entry_pkey PRIMARY KEY (address_book_entry_id);


--
-- Name: address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (address_id);


--
-- Name: admin_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY admin_role
    ADD CONSTRAINT admin_role_pkey PRIMARY KEY (admin_role_id);


--
-- Name: alarm_code_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY alarm_code
    ADD CONSTRAINT alarm_code_pkey PRIMARY KEY (alarm_code_id);


--
-- Name: alarm_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY alarm_group
    ADD CONSTRAINT alarm_group_pkey PRIMARY KEY (alarm_group_id);


--
-- Name: alarm_receiver_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY alarm_receiver
    ADD CONSTRAINT alarm_receiver_pkey PRIMARY KEY (alarm_receiver_id);


--
-- Name: alarm_server_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY alarm_server
    ADD CONSTRAINT alarm_server_pkey PRIMARY KEY (alarm_server_id);


--
-- Name: attendant_dialing_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attendant_dialing_rule
    ADD CONSTRAINT attendant_dialing_rule_pkey PRIMARY KEY (attendant_dialing_rule_id);


--
-- Name: attendant_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attendant_group
    ADD CONSTRAINT attendant_group_pkey PRIMARY KEY (auto_attendant_id, group_id);


--
-- Name: attendant_menu_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attendant_menu_item
    ADD CONSTRAINT attendant_menu_item_pkey PRIMARY KEY (auto_attendant_id, dialpad_key);


--
-- Name: attendant_special_mode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attendant_special_mode
    ADD CONSTRAINT attendant_special_mode_pkey PRIMARY KEY (attendant_special_mode_id);


--
-- Name: attendant_working_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attendant_working_hours
    ADD CONSTRAINT attendant_working_hours_pkey PRIMARY KEY (attendant_dialing_rule_id, index);


--
-- Name: auth_code_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_code
    ADD CONSTRAINT auth_code_pkey PRIMARY KEY (auth_code_id);


--
-- Name: authority_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY authority
    ADD CONSTRAINT authority_pkey PRIMARY KEY (name);


--
-- Name: auto_attendant_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auto_attendant
    ADD CONSTRAINT auto_attendant_name_key UNIQUE (name);


--
-- Name: auto_attendant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auto_attendant
    ADD CONSTRAINT auto_attendant_pkey PRIMARY KEY (auto_attendant_id);


--
-- Name: backup_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY backup_plan
    ADD CONSTRAINT backup_plan_pkey PRIMARY KEY (backup_plan_id);


--
-- Name: bean_with_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bean_with_settings
    ADD CONSTRAINT bean_with_settings_pkey PRIMARY KEY (bean_with_settings_id);


--
-- Name: branch_aa_dialing_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch_aa_dialing_rule
    ADD CONSTRAINT branch_aa_dialing_rule_pkey PRIMARY KEY (attendant_dialing_rule_id, branch_id);


--
-- Name: branch_auth_code_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch_auth_code
    ADD CONSTRAINT branch_auth_code_pkey PRIMARY KEY (auth_code_id, branch_id);


--
-- Name: branch_auto_attendant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch_auto_attendant
    ADD CONSTRAINT branch_auto_attendant_pkey PRIMARY KEY (auto_attendant_id, branch_id);


--
-- Name: branch_branch_inbound_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch_branch_inbound
    ADD CONSTRAINT branch_branch_inbound_pkey PRIMARY KEY (branch_id, associated_branch_id);


--
-- Name: branch_branch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch_branch
    ADD CONSTRAINT branch_branch_pkey PRIMARY KEY (branch_id, associated_branch_id);


--
-- Name: branch_call_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch_call_group
    ADD CONSTRAINT branch_call_group_pkey PRIMARY KEY (call_group_id, branch_id);


--
-- Name: branch_call_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch_call_queue
    ADD CONSTRAINT branch_call_queue_pkey PRIMARY KEY (freeswitch_ext_id, branch_id);


--
-- Name: branch_conference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch_conference
    ADD CONSTRAINT branch_conference_pkey PRIMARY KEY (meetme_conference_id, branch_id);


--
-- Name: branch_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch
    ADD CONSTRAINT branch_name_key UNIQUE (name);


--
-- Name: branch_paging_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch_paging_group
    ADD CONSTRAINT branch_paging_group_pkey PRIMARY KEY (paging_group_id, branch_id);


--
-- Name: branch_park_orbit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch_park_orbit
    ADD CONSTRAINT branch_park_orbit_pkey PRIMARY KEY (park_orbit_id, branch_id);


--
-- Name: branch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch
    ADD CONSTRAINT branch_pkey PRIMARY KEY (branch_id);


--
-- Name: branch_route_domain_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch_route_domain
    ADD CONSTRAINT branch_route_domain_pkey PRIMARY KEY (branch_id, index);


--
-- Name: branch_route_subnet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch_route_subnet
    ADD CONSTRAINT branch_route_subnet_pkey PRIMARY KEY (branch_id, index);


--
-- Name: call_disposition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_call_disposition
    ADD CONSTRAINT call_disposition_pkey PRIMARY KEY (openacd_client_id, index);


--
-- Name: call_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY call_group
    ADD CONSTRAINT call_group_name_key UNIQUE (name);


--
-- Name: call_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY call_group
    ADD CONSTRAINT call_group_pkey PRIMARY KEY (call_group_id);


--
-- Name: call_queue_agent_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY call_queue_agent
    ADD CONSTRAINT call_queue_agent_name_key UNIQUE (name);


--
-- Name: call_queue_agent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY call_queue_agent
    ADD CONSTRAINT call_queue_agent_pkey PRIMARY KEY (call_queue_agent_id);


--
-- Name: call_queue_tier_agent_queue; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY call_queue_tier
    ADD CONSTRAINT call_queue_tier_agent_queue UNIQUE (freeswitch_ext_id, call_queue_agent_id);


--
-- Name: call_rate_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY call_rate_rule
    ADD CONSTRAINT call_rate_rule_pkey PRIMARY KEY (call_rate_rule_id);


--
-- Name: cert_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cert
    ADD CONSTRAINT cert_pkey PRIMARY KEY (name);


--
-- Name: conference_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY meetme_conference
    ADD CONSTRAINT conference_name_key UNIQUE (name);


--
-- Name: cron_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cron_schedule
    ADD CONSTRAINT cron_schedule_pkey PRIMARY KEY (cron_schedule_id);


--
-- Name: custom_dialing_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY custom_dialing_rule
    ADD CONSTRAINT custom_dialing_rule_pkey PRIMARY KEY (custom_dialing_rule_id);


--
-- Name: daily_backup_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY daily_backup_schedule
    ADD CONSTRAINT daily_backup_schedule_pkey PRIMARY KEY (daily_backup_schedule_id);


--
-- Name: dial_pattern_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dial_pattern
    ADD CONSTRAINT dial_pattern_pkey PRIMARY KEY (custom_dialing_rule_id, index);


--
-- Name: dial_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dial_plan
    ADD CONSTRAINT dial_plan_pkey PRIMARY KEY (dial_plan_id);


--
-- Name: dialing_rule_gateway_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dialing_rule_gateway
    ADD CONSTRAINT dialing_rule_gateway_pkey PRIMARY KEY (dialing_rule_id, index);


--
-- Name: dialing_rule_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dialing_rule
    ADD CONSTRAINT dialing_rule_name_key UNIQUE (name);


--
-- Name: dialing_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dialing_rule
    ADD CONSTRAINT dialing_rule_pkey PRIMARY KEY (dialing_rule_id);


--
-- Name: dns_custom_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dns_custom
    ADD CONSTRAINT dns_custom_name_key UNIQUE (name);


--
-- Name: dns_custom_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dns_custom
    ADD CONSTRAINT dns_custom_pkey PRIMARY KEY (dns_custom_id);


--
-- Name: dns_custom_view_link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dns_custom_view_link
    ADD CONSTRAINT dns_custom_view_link_pkey PRIMARY KEY (dns_custom_id, dns_view_id);


--
-- Name: dns_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dns_group
    ADD CONSTRAINT dns_group_pkey PRIMARY KEY (dns_group_id);


--
-- Name: dns_plan_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dns_plan
    ADD CONSTRAINT dns_plan_name_key UNIQUE (name);


--
-- Name: dns_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dns_plan
    ADD CONSTRAINT dns_plan_pkey PRIMARY KEY (dns_plan_id);


--
-- Name: dns_view_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dns_view
    ADD CONSTRAINT dns_view_name_key UNIQUE (name);


--
-- Name: dns_view_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dns_view
    ADD CONSTRAINT dns_view_pkey PRIMARY KEY (dns_view_id);


--
-- Name: domain_alias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY domain_alias
    ADD CONSTRAINT domain_alias_pkey PRIMARY KEY (domain_id, alias);


--
-- Name: domain_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY domain
    ADD CONSTRAINT domain_pkey PRIMARY KEY (domain_id);


--
-- Name: e911_erl_elin_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY e911_erl
    ADD CONSTRAINT e911_erl_elin_key UNIQUE (elin);


--
-- Name: e911_erl_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY e911_erl
    ADD CONSTRAINT e911_erl_pkey PRIMARY KEY (erl_id);


--
-- Name: emergency_dialing_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY emergency_dialing_rule
    ADD CONSTRAINT emergency_dialing_rule_pkey PRIMARY KEY (emergency_dialing_rule_id);


--
-- Name: extension_pool_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY extension_pool
    ADD CONSTRAINT extension_pool_name_key UNIQUE (name);


--
-- Name: extension_pool_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY extension_pool
    ADD CONSTRAINT extension_pool_pkey PRIMARY KEY (extension_pool_id);


--
-- Name: feature_global_feature_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY feature_global
    ADD CONSTRAINT feature_global_feature_id_key UNIQUE (feature_id);


--
-- Name: feature_local_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY feature_local
    ADD CONSTRAINT feature_local_pkey PRIMARY KEY (location_id, feature_id);


--
-- Name: firewall_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY firewall_rule
    ADD CONSTRAINT firewall_rule_pkey PRIMARY KEY (firewall_rule_id);


--
-- Name: firewall_server_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY firewall_server_group
    ADD CONSTRAINT firewall_server_group_name_key UNIQUE (name);


--
-- Name: firewall_server_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY firewall_server_group
    ADD CONSTRAINT firewall_server_group_pkey PRIMARY KEY (firewall_server_group_id);


--
-- Name: freeswitch_action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY freeswitch_action
    ADD CONSTRAINT freeswitch_action_pkey PRIMARY KEY (freeswitch_action_id);


--
-- Name: freeswitch_condition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY freeswitch_condition
    ADD CONSTRAINT freeswitch_condition_pkey PRIMARY KEY (freeswitch_condition_id);


--
-- Name: freeswitch_extension_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY freeswitch_extension
    ADD CONSTRAINT freeswitch_extension_pkey PRIMARY KEY (freeswitch_ext_id);


--
-- Name: fxo_port_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fxo_port
    ADD CONSTRAINT fxo_port_pkey PRIMARY KEY (fxo_port_id);


--
-- Name: gateway_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gateway
    ADD CONSTRAINT gateway_name_key UNIQUE (name);


--
-- Name: gateway_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gateway
    ADD CONSTRAINT gateway_pkey PRIMARY KEY (gateway_id);


--
-- Name: google_domain_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY google_domain
    ADD CONSTRAINT google_domain_pkey PRIMARY KEY (google_domain_id);


--
-- Name: group_emailcontacts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY alarm_group_emailcontacts
    ADD CONSTRAINT group_emailcontacts_pkey PRIMARY KEY (alarm_group_id, index);


--
-- Name: group_smscontacts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY alarm_group_smscontacts
    ADD CONSTRAINT group_smscontacts_pkey PRIMARY KEY (alarm_group_id, index);


--
-- Name: group_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY group_storage
    ADD CONSTRAINT group_storage_pkey PRIMARY KEY (group_id);


--
-- Name: group_weight_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY group_weight
    ADD CONSTRAINT group_weight_pkey PRIMARY KEY (weight);


--
-- Name: holiday_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY holiday_dates
    ADD CONSTRAINT holiday_dates_pkey PRIMARY KEY (attendant_dialing_rule_id, "position");


--
-- Name: intercom_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY intercom
    ADD CONSTRAINT intercom_code_key UNIQUE (code);


--
-- Name: intercom_phone_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY intercom_phone_group
    ADD CONSTRAINT intercom_phone_group_pkey PRIMARY KEY (intercom_id, group_id);


--
-- Name: intercom_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY intercom
    ADD CONSTRAINT intercom_pkey PRIMARY KEY (intercom_id);


--
-- Name: intercom_prefix_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY intercom
    ADD CONSTRAINT intercom_prefix_key UNIQUE (prefix);


--
-- Name: internal_dialing_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY internal_dialing_rule
    ADD CONSTRAINT internal_dialing_rule_pkey PRIMARY KEY (internal_dialing_rule_id);


--
-- Name: international_dialing_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY international_dialing_rule
    ADD CONSTRAINT international_dialing_rule_pkey PRIMARY KEY (international_dialing_rule_id);


--
-- Name: job_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY job
    ADD CONSTRAINT job_pkey PRIMARY KEY (job_id);


--
-- Name: ldap_attr_map_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ldap_attr_map
    ADD CONSTRAINT ldap_attr_map_pkey PRIMARY KEY (ldap_attr_map_id);


--
-- Name: ldap_connection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ldap_connection
    ADD CONSTRAINT ldap_connection_pkey PRIMARY KEY (ldap_connection_id);


--
-- Name: ldap_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ldap_settings
    ADD CONSTRAINT ldap_settings_pkey PRIMARY KEY (ldap_settings_id);


--
-- Name: ldap_user_property_to_ldap_attr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ldap_user_property_to_ldap_attr
    ADD CONSTRAINT ldap_user_property_to_ldap_attr_pkey PRIMARY KEY (ldap_attr_map_id, user_property);


--
-- Name: license_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY license
    ADD CONSTRAINT license_name_key UNIQUE (name);


--
-- Name: line_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY line_group
    ADD CONSTRAINT line_group_pkey PRIMARY KEY (line_id, group_id);


--
-- Name: line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY line
    ADD CONSTRAINT line_pkey PRIMARY KEY (line_id);


--
-- Name: local_dialing_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY local_dialing_rule
    ADD CONSTRAINT local_dialing_rule_pkey PRIMARY KEY (local_dialing_rule_id);


--
-- Name: localization_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY localization
    ADD CONSTRAINT localization_pkey PRIMARY KEY (localization_id);


--
-- Name: location_failed_replications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY location_failed_replications
    ADD CONSTRAINT location_failed_replications_pkey PRIMARY KEY (location_id, entity_name);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (location_id);


--
-- Name: long_distance_dialing_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY long_distance_dialing_rule
    ADD CONSTRAINT long_distance_dialing_rule_pkey PRIMARY KEY (international_dialing_rule_id);


--
-- Name: meetme_bridge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY meetme_bridge
    ADD CONSTRAINT meetme_bridge_pkey PRIMARY KEY (meetme_bridge_id);


--
-- Name: meetme_conference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY meetme_conference
    ADD CONSTRAINT meetme_conference_pkey PRIMARY KEY (meetme_conference_id);


--
-- Name: meetme_participant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY meetme_participant
    ADD CONSTRAINT meetme_participant_pkey PRIMARY KEY (meetme_participant_id);


--
-- Name: openacd_agent_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_agent_group
    ADD CONSTRAINT openacd_agent_group_name_key UNIQUE (name);


--
-- Name: openacd_agent_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_agent_group
    ADD CONSTRAINT openacd_agent_group_pkey PRIMARY KEY (openacd_agent_group_id);


--
-- Name: openacd_agent_group_queue_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_agent_group_queue_group
    ADD CONSTRAINT openacd_agent_group_queue_group_pkey PRIMARY KEY (openacd_queue_group_id, openacd_agent_group_id);


--
-- Name: openacd_agent_group_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_agent_group_queue
    ADD CONSTRAINT openacd_agent_group_queue_pkey PRIMARY KEY (openacd_queue_id, openacd_agent_group_id);


--
-- Name: openacd_agent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_agent
    ADD CONSTRAINT openacd_agent_pkey PRIMARY KEY (openacd_agent_id);


--
-- Name: openacd_agent_pstn_pstn_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_agent_pstn
    ADD CONSTRAINT openacd_agent_pstn_pstn_number_key UNIQUE (pstn_number);


--
-- Name: openacd_client_agent_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_client_agent_group
    ADD CONSTRAINT openacd_client_agent_group_pkey PRIMARY KEY (openacd_agent_group_id, openacd_client_id);


--
-- Name: openacd_client_agent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_client_agent
    ADD CONSTRAINT openacd_client_agent_pkey PRIMARY KEY (openacd_agent_id, openacd_client_id);


--
-- Name: openacd_client_identity_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_client
    ADD CONSTRAINT openacd_client_identity_key UNIQUE (identity);


--
-- Name: openacd_client_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_client
    ADD CONSTRAINT openacd_client_name_key UNIQUE (name);


--
-- Name: openacd_client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_client
    ADD CONSTRAINT openacd_client_pkey PRIMARY KEY (openacd_client_id);


--
-- Name: openacd_custom_header_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_custom_header
    ADD CONSTRAINT openacd_custom_header_name_key UNIQUE (name);


--
-- Name: openacd_custom_header_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_custom_header
    ADD CONSTRAINT openacd_custom_header_pkey PRIMARY KEY (openacd_custom_header_id);


--
-- Name: openacd_permission_agent_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_permission_agent_group
    ADD CONSTRAINT openacd_permission_agent_group_pkey PRIMARY KEY (openacd_agent_group_id, openacd_permission_profile_id);


--
-- Name: openacd_permission_profile_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_permission_profile
    ADD CONSTRAINT openacd_permission_profile_name_key UNIQUE (name);


--
-- Name: openacd_permission_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_permission_profile
    ADD CONSTRAINT openacd_permission_profile_pkey PRIMARY KEY (openacd_permission_profile_id);


--
-- Name: openacd_permission_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_permission_queue
    ADD CONSTRAINT openacd_permission_queue_pkey PRIMARY KEY (openacd_queue_id, openacd_permission_profile_id);


--
-- Name: openacd_permission_widget_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_permission_widget
    ADD CONSTRAINT openacd_permission_widget_pkey PRIMARY KEY (openacd_permission_profile_id, widget);


--
-- Name: openacd_queue_agent_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_queue_agent_group
    ADD CONSTRAINT openacd_queue_agent_group_pkey PRIMARY KEY (openacd_agent_group_id, openacd_queue_id);


--
-- Name: openacd_queue_agent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_queue_agent
    ADD CONSTRAINT openacd_queue_agent_pkey PRIMARY KEY (openacd_agent_id, openacd_queue_id);


--
-- Name: openacd_queue_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_queue_group
    ADD CONSTRAINT openacd_queue_group_name_key UNIQUE (name);


--
-- Name: openacd_queue_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_queue_group
    ADD CONSTRAINT openacd_queue_group_pkey PRIMARY KEY (openacd_queue_group_id);


--
-- Name: openacd_queue_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_queue
    ADD CONSTRAINT openacd_queue_name_key UNIQUE (name);


--
-- Name: openacd_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_queue
    ADD CONSTRAINT openacd_queue_pkey PRIMARY KEY (openacd_queue_id);


--
-- Name: openacd_recipe_action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_recipe_action
    ADD CONSTRAINT openacd_recipe_action_pkey PRIMARY KEY (openacd_recipe_action_id);


--
-- Name: openacd_recipe_step_openacd_recipe_action_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_recipe_step
    ADD CONSTRAINT openacd_recipe_step_openacd_recipe_action_id_key UNIQUE (openacd_recipe_action_id);


--
-- Name: openacd_recipe_step_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_recipe_step
    ADD CONSTRAINT openacd_recipe_step_pkey PRIMARY KEY (openacd_recipe_step_id);


--
-- Name: openacd_release_codes_label_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_release_codes
    ADD CONSTRAINT openacd_release_codes_label_key UNIQUE (label);


--
-- Name: openacd_release_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_release_codes
    ADD CONSTRAINT openacd_release_codes_pkey PRIMARY KEY (openacd_code_id);


--
-- Name: openacd_skill_agent_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_skill_agent_group
    ADD CONSTRAINT openacd_skill_agent_group_pkey PRIMARY KEY (openacd_agent_group_id, openacd_skill_id);


--
-- Name: openacd_skill_agent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_skill_agent
    ADD CONSTRAINT openacd_skill_agent_pkey PRIMARY KEY (openacd_agent_id, openacd_skill_id);


--
-- Name: openacd_skill_atom_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_skill
    ADD CONSTRAINT openacd_skill_atom_key UNIQUE (atom);


--
-- Name: openacd_skill_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_skill_group
    ADD CONSTRAINT openacd_skill_group_name_key UNIQUE (name);


--
-- Name: openacd_skill_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_skill_group
    ADD CONSTRAINT openacd_skill_group_pkey PRIMARY KEY (openacd_skill_group_id);


--
-- Name: openacd_skill_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_skill
    ADD CONSTRAINT openacd_skill_name_key UNIQUE (name);


--
-- Name: openacd_skill_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_skill
    ADD CONSTRAINT openacd_skill_pkey PRIMARY KEY (openacd_skill_id);


--
-- Name: openacd_skill_queue_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_skill_queue_group
    ADD CONSTRAINT openacd_skill_queue_group_pkey PRIMARY KEY (openacd_queue_group_id, openacd_skill_id);


--
-- Name: openacd_skill_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_skill_queue
    ADD CONSTRAINT openacd_skill_queue_pkey PRIMARY KEY (openacd_queue_id, openacd_skill_id);


--
-- Name: openacd_skill_recipe_action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_skill_recipe_action
    ADD CONSTRAINT openacd_skill_recipe_action_pkey PRIMARY KEY (openacd_recipe_action_id, openacd_skill_id);


--
-- Name: paging_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY paging_group
    ADD CONSTRAINT paging_group_pkey PRIMARY KEY (paging_group_id);


--
-- Name: paging_server_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY paging_server
    ADD CONSTRAINT paging_server_pkey PRIMARY KEY (paging_server_id);


--
-- Name: park_orbit_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY park_orbit_group
    ADD CONSTRAINT park_orbit_group_pkey PRIMARY KEY (park_orbit_id, group_id);


--
-- Name: park_orbit_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY park_orbit
    ADD CONSTRAINT park_orbit_name_key UNIQUE (name);


--
-- Name: park_orbit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY park_orbit
    ADD CONSTRAINT park_orbit_pkey PRIMARY KEY (park_orbit_id);


--
-- Name: patch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY patch
    ADD CONSTRAINT patch_pkey PRIMARY KEY (name);


--
-- Name: permission_admin_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY permission_admin_role
    ADD CONSTRAINT permission_admin_role_pkey PRIMARY KEY (admin_role_id, permission);


--
-- Name: permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (permission_id);


--
-- Name: personal_attendant_menu_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY personal_attendant_menu_item
    ADD CONSTRAINT personal_attendant_menu_item_pkey PRIMARY KEY (personal_attendant_id, dialpad_key);


--
-- Name: personal_attendant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY personal_attendant
    ADD CONSTRAINT personal_attendant_pkey PRIMARY KEY (personal_attendant_id);


--
-- Name: phone_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY phone_group
    ADD CONSTRAINT phone_group_pkey PRIMARY KEY (phone_id, group_id);


--
-- Name: phone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY phone
    ADD CONSTRAINT phone_pkey PRIMARY KEY (phone_id);


--
-- Name: phone_serial_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY phone
    ADD CONSTRAINT phone_serial_number_key UNIQUE (serial_number);


--
-- Name: phonebook_consumer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY phonebook_consumer
    ADD CONSTRAINT phonebook_consumer_pkey PRIMARY KEY (phonebook_id, group_id);


--
-- Name: phonebook_file_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY phonebook_file_entry
    ADD CONSTRAINT phonebook_file_entry_pkey PRIMARY KEY (phonebook_file_entry_id);


--
-- Name: phonebook_member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY phonebook_member
    ADD CONSTRAINT phonebook_member_pkey PRIMARY KEY (phonebook_id, group_id);


--
-- Name: phonebook_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY phonebook
    ADD CONSTRAINT phonebook_name_key UNIQUE (name);


--
-- Name: phonebook_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY phonebook
    ADD CONSTRAINT phonebook_pkey PRIMARY KEY (phonebook_id);


--
-- Name: pk_call_rate_limit_id_call_rate_rule_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY call_rate_limit
    ADD CONSTRAINT pk_call_rate_limit_id_call_rate_rule_id PRIMARY KEY (call_rate_limit_id, call_rate_rule_id);


--
-- Name: pk_schedule_hours_id_schedule_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY schedule_hours
    ADD CONSTRAINT pk_schedule_hours_id_schedule_id PRIMARY KEY (schedule_hours_id, schedule_id);


--
-- Name: private_user_key_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY private_user_key
    ADD CONSTRAINT private_user_key_key_key UNIQUE (key);


--
-- Name: private_user_key_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY private_user_key
    ADD CONSTRAINT private_user_key_pkey PRIMARY KEY (private_user_key_id);


--
-- Name: pstn_number_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_agent_pstn
    ADD CONSTRAINT pstn_number_pkey PRIMARY KEY (openacd_agent_id, index);


--
-- Name: recipe_condition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY openacd_recipe_condition
    ADD CONSTRAINT recipe_condition_pkey PRIMARY KEY (openacd_recipe_step_id, index);


--
-- Name: region_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_name_key UNIQUE (name);


--
-- Name: region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pkey PRIMARY KEY (region_id);


--
-- Name: ring_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ring
    ADD CONSTRAINT ring_pkey PRIMARY KEY (ring_id);


--
-- Name: sbc_device_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sbc_device
    ADD CONSTRAINT sbc_device_name_key UNIQUE (name);


--
-- Name: sbc_device_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sbc_device
    ADD CONSTRAINT sbc_device_pkey PRIMARY KEY (sbc_device_id);


--
-- Name: sbc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sbc
    ADD CONSTRAINT sbc_pkey PRIMARY KEY (sbc_id);


--
-- Name: sbc_route_domain_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sbc_route_domain
    ADD CONSTRAINT sbc_route_domain_pkey PRIMARY KEY (sbc_id, index);


--
-- Name: sbc_route_subnet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sbc_route_subnet
    ADD CONSTRAINT sbc_route_subnet_pkey PRIMARY KEY (sbc_id, index);


--
-- Name: schedule_feature_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY schedule_feature
    ADD CONSTRAINT schedule_feature_pkey PRIMARY KEY (schedule_id, feature_id);


--
-- Name: schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (schedule_id);


--
-- Name: service_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_name_key UNIQUE (name);


--
-- Name: service_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_pkey PRIMARY KEY (service_id);


--
-- Name: setting_value_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY setting_value
    ADD CONSTRAINT setting_value_pkey PRIMARY KEY (value_storage_id, path);


--
-- Name: settings_location_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY settings_location_group
    ADD CONSTRAINT settings_location_group_pkey PRIMARY KEY (settings_with_location_id, group_id);


--
-- Name: settings_with_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY settings_with_location
    ADD CONSTRAINT settings_with_location_pkey PRIMARY KEY (settings_with_location_id);


--
-- Name: setup_setup_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY setup
    ADD CONSTRAINT setup_setup_id_key UNIQUE (setup_id);


--
-- Name: shard_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shard
    ADD CONSTRAINT shard_name_key UNIQUE (name);


--
-- Name: shard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shard
    ADD CONSTRAINT shard_pkey PRIMARY KEY (shard_id);


--
-- Name: site_to_site_dial_pattern_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY site_to_site_dial_pattern
    ADD CONSTRAINT site_to_site_dial_pattern_pkey PRIMARY KEY (site_to_site_dialing_rule_id, index);


--
-- Name: site_to_site_dialing_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY site_to_site_dialing_rule
    ADD CONSTRAINT site_to_site_dialing_rule_pkey PRIMARY KEY (site_to_site_dialing_rule_id);


--
-- Name: special_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY special_user
    ADD CONSTRAINT special_user_pkey PRIMARY KEY (special_user_id);


--
-- Name: speeddial_button_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY speeddial_button
    ADD CONSTRAINT speeddial_button_pkey PRIMARY KEY (speeddial_id, "position");


--
-- Name: speeddial_group_button_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY speeddial_group_button
    ADD CONSTRAINT speeddial_group_button_pkey PRIMARY KEY (speeddial_id, "position");


--
-- Name: speeddial_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY speeddial_group
    ADD CONSTRAINT speeddial_group_pkey PRIMARY KEY (speeddial_id);


--
-- Name: speeddial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY speeddial
    ADD CONSTRAINT speeddial_pkey PRIMARY KEY (speeddial_id);


--
-- Name: supervisor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY supervisor
    ADD CONSTRAINT supervisor_pkey PRIMARY KEY (user_id, group_id);


--
-- Name: timezone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY timezone
    ADD CONSTRAINT timezone_pkey PRIMARY KEY (timezone_id);


--
-- Name: tls_peer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tls_peer
    ADD CONSTRAINT tls_peer_pkey PRIMARY KEY (tls_peer_id);


--
-- Name: unite_mobile_license_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unite_mobile_license
    ADD CONSTRAINT unite_mobile_license_pkey PRIMARY KEY (uml_id);


--
-- Name: upload_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT upload_name_key UNIQUE (name);


--
-- Name: upload_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT upload_pkey PRIMARY KEY (upload_id);


--
-- Name: uqc_group_storage_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY group_storage
    ADD CONSTRAINT uqc_group_storage_name UNIQUE (name, resource);


--
-- Name: user_admin_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_admin_role
    ADD CONSTRAINT user_admin_role_pkey PRIMARY KEY (admin_role_id, user_id);


--
-- Name: user_alarm_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_alarm_group
    ADD CONSTRAINT user_alarm_group_pkey PRIMARY KEY (alarm_group_id, user_id);


--
-- Name: user_alias_alias_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_alias
    ADD CONSTRAINT user_alias_alias_key UNIQUE (alias);


--
-- Name: user_alias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_alias
    ADD CONSTRAINT user_alias_pkey PRIMARY KEY (user_id, alias);


--
-- Name: user_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_group
    ADD CONSTRAINT user_group_pkey PRIMARY KEY (user_id, group_id);


--
-- Name: user_paging_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_paging_group
    ADD CONSTRAINT user_paging_group_pkey PRIMARY KEY (paging_group_id, user_id);


--
-- Name: user_ring_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_ring
    ADD CONSTRAINT user_ring_pkey PRIMARY KEY (user_ring_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users_user_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_user_name_key UNIQUE (user_name);


--
-- Name: value_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY value_storage
    ADD CONSTRAINT value_storage_pkey PRIMARY KEY (value_storage_id);


--
-- Name: version_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY version_history
    ADD CONSTRAINT version_history_pkey PRIMARY KEY (version);


--
-- Name: admin_role_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_admin_role
    ADD CONSTRAINT admin_role_fk1 FOREIGN KEY (admin_role_id) REFERENCES admin_role(admin_role_id);


--
-- Name: admin_role_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_admin_role
    ADD CONSTRAINT admin_role_fk2 FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: agent_group_queue_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_agent_group_queue
    ADD CONSTRAINT agent_group_queue_fk1 FOREIGN KEY (openacd_queue_id) REFERENCES openacd_queue(openacd_queue_id) ON DELETE CASCADE;


--
-- Name: agent_group_queue_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_agent_group_queue
    ADD CONSTRAINT agent_group_queue_fk2 FOREIGN KEY (openacd_agent_group_id) REFERENCES openacd_agent_group(openacd_agent_group_id) ON DELETE CASCADE;


--
-- Name: agent_group_queue_group_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_agent_group_queue_group
    ADD CONSTRAINT agent_group_queue_group_fk1 FOREIGN KEY (openacd_queue_group_id) REFERENCES openacd_queue_group(openacd_queue_group_id) ON DELETE CASCADE;


--
-- Name: agent_group_queue_group_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_agent_group_queue_group
    ADD CONSTRAINT agent_group_queue_group_fk2 FOREIGN KEY (openacd_agent_group_id) REFERENCES openacd_agent_group(openacd_agent_group_id) ON DELETE CASCADE;


--
-- Name: alarm_group_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_alarm_group
    ADD CONSTRAINT alarm_group_fk1 FOREIGN KEY (alarm_group_id) REFERENCES alarm_group(alarm_group_id);


--
-- Name: alarm_group_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_alarm_group
    ADD CONSTRAINT alarm_group_fk2 FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: bean_with_settings_value_storage_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bean_with_settings
    ADD CONSTRAINT bean_with_settings_value_storage_id FOREIGN KEY (value_storage_id) REFERENCES value_storage(value_storage_id);


--
-- Name: branch_aa_dialing_rule_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_aa_dialing_rule
    ADD CONSTRAINT branch_aa_dialing_rule_fk1 FOREIGN KEY (attendant_dialing_rule_id) REFERENCES attendant_dialing_rule(attendant_dialing_rule_id);


--
-- Name: branch_aa_dialing_rule_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_aa_dialing_rule
    ADD CONSTRAINT branch_aa_dialing_rule_fk2 FOREIGN KEY (branch_id) REFERENCES branch(branch_id);


--
-- Name: branch_auth_code_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_auth_code
    ADD CONSTRAINT branch_auth_code_fk1 FOREIGN KEY (auth_code_id) REFERENCES auth_code(auth_code_id);


--
-- Name: branch_auth_code_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_auth_code
    ADD CONSTRAINT branch_auth_code_fk2 FOREIGN KEY (branch_id) REFERENCES branch(branch_id);


--
-- Name: branch_auto_attendant_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_auto_attendant
    ADD CONSTRAINT branch_auto_attendant_fk1 FOREIGN KEY (auto_attendant_id) REFERENCES auto_attendant(auto_attendant_id);


--
-- Name: branch_auto_attendant_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_auto_attendant
    ADD CONSTRAINT branch_auto_attendant_fk2 FOREIGN KEY (branch_id) REFERENCES branch(branch_id);


--
-- Name: branch_branch_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_branch
    ADD CONSTRAINT branch_branch_fk1 FOREIGN KEY (branch_id) REFERENCES branch(branch_id);


--
-- Name: branch_branch_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_branch
    ADD CONSTRAINT branch_branch_fk2 FOREIGN KEY (associated_branch_id) REFERENCES branch(branch_id);


--
-- Name: branch_branch_inbound_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_branch_inbound
    ADD CONSTRAINT branch_branch_inbound_fk1 FOREIGN KEY (branch_id) REFERENCES branch(branch_id);


--
-- Name: branch_branch_inbound_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_branch_inbound
    ADD CONSTRAINT branch_branch_inbound_fk2 FOREIGN KEY (associated_branch_id) REFERENCES branch(branch_id);


--
-- Name: branch_call_group_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_call_group
    ADD CONSTRAINT branch_call_group_fk1 FOREIGN KEY (call_group_id) REFERENCES call_group(call_group_id);


--
-- Name: branch_call_group_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_call_group
    ADD CONSTRAINT branch_call_group_fk2 FOREIGN KEY (branch_id) REFERENCES branch(branch_id);


--
-- Name: branch_call_queue_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_call_queue
    ADD CONSTRAINT branch_call_queue_fk1 FOREIGN KEY (freeswitch_ext_id) REFERENCES freeswitch_extension(freeswitch_ext_id);


--
-- Name: branch_call_queue_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_call_queue
    ADD CONSTRAINT branch_call_queue_fk2 FOREIGN KEY (branch_id) REFERENCES branch(branch_id);


--
-- Name: branch_conference_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_conference
    ADD CONSTRAINT branch_conference_fk1 FOREIGN KEY (meetme_conference_id) REFERENCES meetme_conference(meetme_conference_id);


--
-- Name: branch_conference_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_conference
    ADD CONSTRAINT branch_conference_fk2 FOREIGN KEY (branch_id) REFERENCES branch(branch_id);


--
-- Name: branch_paging_group_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_paging_group
    ADD CONSTRAINT branch_paging_group_fk1 FOREIGN KEY (paging_group_id) REFERENCES paging_group(paging_group_id);


--
-- Name: branch_paging_group_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_paging_group
    ADD CONSTRAINT branch_paging_group_fk2 FOREIGN KEY (branch_id) REFERENCES branch(branch_id);


--
-- Name: branch_park_orbit_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_park_orbit
    ADD CONSTRAINT branch_park_orbit_fk1 FOREIGN KEY (park_orbit_id) REFERENCES park_orbit(park_orbit_id);


--
-- Name: branch_park_orbit_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_park_orbit
    ADD CONSTRAINT branch_park_orbit_fk2 FOREIGN KEY (branch_id) REFERENCES branch(branch_id);


--
-- Name: call_queue_agent_value_storage; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY call_queue_agent
    ADD CONSTRAINT call_queue_agent_value_storage FOREIGN KEY (value_storage_id) REFERENCES value_storage(value_storage_id);


--
-- Name: call_queue_tier_agent; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY call_queue_tier
    ADD CONSTRAINT call_queue_tier_agent FOREIGN KEY (call_queue_agent_id) REFERENCES call_queue_agent(call_queue_agent_id);


--
-- Name: client_agent_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_client_agent
    ADD CONSTRAINT client_agent_fk1 FOREIGN KEY (openacd_agent_id) REFERENCES openacd_agent(openacd_agent_id) ON DELETE CASCADE;


--
-- Name: client_agent_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_client_agent
    ADD CONSTRAINT client_agent_fk2 FOREIGN KEY (openacd_client_id) REFERENCES openacd_client(openacd_client_id) ON DELETE CASCADE;


--
-- Name: client_agent_group_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_client_agent_group
    ADD CONSTRAINT client_agent_group_fk1 FOREIGN KEY (openacd_agent_group_id) REFERENCES openacd_agent_group(openacd_agent_group_id) ON DELETE CASCADE;


--
-- Name: client_agent_group_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_client_agent_group
    ADD CONSTRAINT client_agent_group_fk2 FOREIGN KEY (openacd_client_id) REFERENCES openacd_client(openacd_client_id) ON DELETE CASCADE;


--
-- Name: dns_custom_view_link_dns_custom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dns_custom_view_link
    ADD CONSTRAINT dns_custom_view_link_dns_custom_id_fkey FOREIGN KEY (dns_custom_id) REFERENCES dns_custom(dns_custom_id) ON DELETE CASCADE;


--
-- Name: dns_custom_view_link_dns_view_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dns_custom_view_link
    ADD CONSTRAINT dns_custom_view_link_dns_view_id_fkey FOREIGN KEY (dns_view_id) REFERENCES dns_view(dns_view_id) ON DELETE CASCADE;


--
-- Name: dns_group_dns_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dns_group
    ADD CONSTRAINT dns_group_dns_plan_id_fkey FOREIGN KEY (dns_plan_id) REFERENCES dns_plan(dns_plan_id) ON DELETE CASCADE;


--
-- Name: dns_target_dns_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dns_target
    ADD CONSTRAINT dns_target_dns_group_id_fkey FOREIGN KEY (dns_group_id) REFERENCES dns_group(dns_group_id) ON DELETE CASCADE;


--
-- Name: dns_target_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dns_target
    ADD CONSTRAINT dns_target_location_id_fkey FOREIGN KEY (location_id) REFERENCES location(location_id);


--
-- Name: dns_target_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dns_target
    ADD CONSTRAINT dns_target_region_id_fkey FOREIGN KEY (region_id) REFERENCES region(region_id);


--
-- Name: dns_view_dns_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dns_view
    ADD CONSTRAINT dns_view_dns_plan_id_fkey FOREIGN KEY (dns_plan_id) REFERENCES dns_plan(dns_plan_id);


--
-- Name: dns_view_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dns_view
    ADD CONSTRAINT dns_view_region_id_fkey FOREIGN KEY (region_id) REFERENCES region(region_id);


--
-- Name: fk143bde242a05f79c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_ring
    ADD CONSTRAINT fk143bde242a05f79c FOREIGN KEY (call_group_id) REFERENCES call_group(call_group_id);


--
-- Name: fk143bde24f73aee0f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_ring
    ADD CONSTRAINT fk143bde24f73aee0f FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: fk32aff4b3b3158c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY line
    ADD CONSTRAINT fk32aff4b3b3158c FOREIGN KEY (phone_id) REFERENCES phone(phone_id);


--
-- Name: fk32aff4cb50fced; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY line
    ADD CONSTRAINT fk32aff4cb50fced FOREIGN KEY (value_storage_id) REFERENCES value_storage(value_storage_id);


--
-- Name: fk32aff4f73aee0f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY line
    ADD CONSTRAINT fk32aff4f73aee0f FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: fk356a30f73aee0f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ring
    ADD CONSTRAINT fk356a30f73aee0f FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: fk365020fd76b0539d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY local_dialing_rule
    ADD CONSTRAINT fk365020fd76b0539d FOREIGN KEY (local_dialing_rule_id) REFERENCES dialing_rule(dialing_rule_id);


--
-- Name: fk3b60f0a99f03ec22; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dialing_rule
    ADD CONSTRAINT fk3b60f0a99f03ec22 FOREIGN KEY (dial_plan_id) REFERENCES dial_plan(dial_plan_id);


--
-- Name: fk5518a4efe76e474; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY daily_backup_schedule
    ADD CONSTRAINT fk5518a4efe76e474 FOREIGN KEY (backup_plan_id) REFERENCES backup_plan(backup_plan_id);


--
-- Name: fk5d102eeb5beffe1d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY internal_dialing_rule
    ADD CONSTRAINT fk5d102eeb5beffe1d FOREIGN KEY (auto_attendant_id) REFERENCES auto_attendant(auto_attendant_id);


--
-- Name: fk5d102eebde4556ef; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY internal_dialing_rule
    ADD CONSTRAINT fk5d102eebde4556ef FOREIGN KEY (internal_dialing_rule_id) REFERENCES dialing_rule(dialing_rule_id);


--
-- Name: fk65b3d6ecb50fced; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY phone
    ADD CONSTRAINT fk65b3d6ecb50fced FOREIGN KEY (value_storage_id) REFERENCES value_storage(value_storage_id);


--
-- Name: fk65e824ae38f854f6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dialing_rule_gateway
    ADD CONSTRAINT fk65e824ae38f854f6 FOREIGN KEY (gateway_id) REFERENCES gateway(gateway_id);


--
-- Name: fk65e824aef6075471; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dialing_rule_gateway
    ADD CONSTRAINT fk65e824aef6075471 FOREIGN KEY (dialing_rule_id) REFERENCES dialing_rule(dialing_rule_id);


--
-- Name: fk6a68e08f73aee0f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk6a68e08f73aee0f FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: fk7eaee897444e2dc3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY emergency_dialing_rule
    ADD CONSTRAINT fk7eaee897444e2dc3 FOREIGN KEY (emergency_dialing_rule_id) REFERENCES dialing_rule(dialing_rule_id);


--
-- Name: fk8a142741e2e76db; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY line_group
    ADD CONSTRAINT fk8a142741e2e76db FOREIGN KEY (group_id) REFERENCES group_storage(group_id);


--
-- Name: fk8a14274a8b4d46; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY line_group
    ADD CONSTRAINT fk8a14274a8b4d46 FOREIGN KEY (line_id) REFERENCES line(line_id);


--
-- Name: fk8d4d2dc1454433a3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dial_pattern
    ADD CONSTRAINT fk8d4d2dc1454433a3 FOREIGN KEY (custom_dialing_rule_id) REFERENCES custom_dialing_rule(custom_dialing_rule_id);


--
-- Name: fk8f3ee457454433a3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY custom_dialing_rule_permission
    ADD CONSTRAINT fk8f3ee457454433a3 FOREIGN KEY (custom_dialing_rule_id) REFERENCES custom_dialing_rule(custom_dialing_rule_id);


--
-- Name: fk92bdf0bb1e2e76db; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_storage
    ADD CONSTRAINT fk92bdf0bb1e2e76db FOREIGN KEY (group_id) REFERENCES value_storage(value_storage_id);


--
-- Name: fk_address_book_entry_users_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_address_book_entry_users_id FOREIGN KEY (address_book_entry_id) REFERENCES address_book_entry(address_book_entry_id);


--
-- Name: fk_address_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch
    ADD CONSTRAINT fk_address_id FOREIGN KEY (address_id) REFERENCES address(address_id);


--
-- Name: fk_after_hours_attendant_auto_attendant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendant_dialing_rule
    ADD CONSTRAINT fk_after_hours_attendant_auto_attendant FOREIGN KEY (after_hours_attendant_id) REFERENCES auto_attendant(auto_attendant_id);


--
-- Name: fk_attendant_dialing_rule_dialing_rule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendant_dialing_rule
    ADD CONSTRAINT fk_attendant_dialing_rule_dialing_rule FOREIGN KEY (attendant_dialing_rule_id) REFERENCES dialing_rule(dialing_rule_id);


--
-- Name: fk_attendant_working_hours_attendant_dialing_rule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendant_working_hours
    ADD CONSTRAINT fk_attendant_working_hours_attendant_dialing_rule FOREIGN KEY (attendant_dialing_rule_id) REFERENCES attendant_dialing_rule(attendant_dialing_rule_id);


--
-- Name: fk_branch_address_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY address_book_entry
    ADD CONSTRAINT fk_branch_address_id FOREIGN KEY (branch_address_id) REFERENCES address(address_id) ON DELETE SET NULL;


--
-- Name: fk_branch_route_domain; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_route_domain
    ADD CONSTRAINT fk_branch_route_domain FOREIGN KEY (branch_id) REFERENCES branch(branch_id);


--
-- Name: fk_branch_route_subnet; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch_route_subnet
    ADD CONSTRAINT fk_branch_route_subnet FOREIGN KEY (branch_id) REFERENCES branch(branch_id);


--
-- Name: fk_call_rate_limit_call_rate_rule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY call_rate_limit
    ADD CONSTRAINT fk_call_rate_limit_call_rate_rule FOREIGN KEY (call_rate_rule_id) REFERENCES call_rate_rule(call_rate_rule_id) MATCH FULL;


--
-- Name: fk_dialing_rule_schedule_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dialing_rule
    ADD CONSTRAINT fk_dialing_rule_schedule_id FOREIGN KEY (schedule_id) REFERENCES schedule(schedule_id) MATCH FULL;


--
-- Name: fk_e911_location_phone_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY phone
    ADD CONSTRAINT fk_e911_location_phone_id FOREIGN KEY (e911_location_id) REFERENCES e911_erl(erl_id);


--
-- Name: fk_e911_location_users_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_e911_location_users_id FOREIGN KEY (e911_location_id) REFERENCES e911_erl(erl_id);


--
-- Name: fk_fallback_branch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY branch
    ADD CONSTRAINT fk_fallback_branch FOREIGN KEY (fallback_branch_id) REFERENCES branch(branch_id) MATCH FULL ON DELETE SET NULL;


--
-- Name: fk_freeswitch_condition; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY freeswitch_action
    ADD CONSTRAINT fk_freeswitch_condition FOREIGN KEY (freeswitch_condition_id) REFERENCES freeswitch_condition(freeswitch_condition_id);


--
-- Name: fk_freeswitch_ext; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY freeswitch_condition
    ADD CONSTRAINT fk_freeswitch_ext FOREIGN KEY (freeswitch_ext_id) REFERENCES freeswitch_extension(freeswitch_ext_id);


--
-- Name: fk_fxo_port_gateway; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fxo_port
    ADD CONSTRAINT fk_fxo_port_gateway FOREIGN KEY (gateway_id) REFERENCES gateway(gateway_id);


--
-- Name: fk_fxo_port_value_storage; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fxo_port
    ADD CONSTRAINT fk_fxo_port_value_storage FOREIGN KEY (value_storage_id) REFERENCES value_storage(value_storage_id);


--
-- Name: fk_gateway_branch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY gateway
    ADD CONSTRAINT fk_gateway_branch FOREIGN KEY (branch_id) REFERENCES branch(branch_id) MATCH FULL ON DELETE SET NULL;


--
-- Name: fk_group_storage_branch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_storage
    ADD CONSTRAINT fk_group_storage_branch FOREIGN KEY (branch_id) REFERENCES branch(branch_id) MATCH FULL ON DELETE SET NULL;


--
-- Name: fk_holiday_dates_attendant_dialing_rule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY holiday_dates
    ADD CONSTRAINT fk_holiday_dates_attendant_dialing_rule FOREIGN KEY (attendant_dialing_rule_id) REFERENCES attendant_dialing_rule(attendant_dialing_rule_id);


--
-- Name: fk_home_address_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY address_book_entry
    ADD CONSTRAINT fk_home_address_id FOREIGN KEY (home_address_id) REFERENCES address(address_id);


--
-- Name: fk_internal_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_code
    ADD CONSTRAINT fk_internal_user FOREIGN KEY (internal_user_id) REFERENCES users(user_id);


--
-- Name: fk_internal_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tls_peer
    ADD CONSTRAINT fk_internal_user FOREIGN KEY (internal_user_id) REFERENCES users(user_id);


--
-- Name: fk_ldap_selected_object_classes_ldap_attr_map; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ldap_selected_object_classes
    ADD CONSTRAINT fk_ldap_selected_object_classes_ldap_attr_map FOREIGN KEY (ldap_attr_map_id) REFERENCES ldap_attr_map(ldap_attr_map_id);


--
-- Name: fk_ldap_user_property_to_ldap_attr_ldap_attr_map; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ldap_user_property_to_ldap_attr
    ADD CONSTRAINT fk_ldap_user_property_to_ldap_attr_ldap_attr_map FOREIGN KEY (ldap_attr_map_id) REFERENCES ldap_attr_map(ldap_attr_map_id);


--
-- Name: fk_location_branch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_location_branch FOREIGN KEY (branch_id) REFERENCES branch(branch_id) MATCH FULL ON DELETE SET NULL;


--
-- Name: fk_meetme_conference_bridge; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY meetme_conference
    ADD CONSTRAINT fk_meetme_conference_bridge FOREIGN KEY (meetme_bridge_id) REFERENCES meetme_bridge(meetme_bridge_id);


--
-- Name: fk_meetme_participant_conference; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY meetme_participant
    ADD CONSTRAINT fk_meetme_participant_conference FOREIGN KEY (meetme_conference_id) REFERENCES meetme_conference(meetme_conference_id);


--
-- Name: fk_meetme_participant_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY meetme_participant
    ADD CONSTRAINT fk_meetme_participant_user FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: fk_office_address_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY address_book_entry
    ADD CONSTRAINT fk_office_address_id FOREIGN KEY (office_address_id) REFERENCES address(address_id) ON DELETE SET NULL;


--
-- Name: fk_openacd_agent; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_agent_pstn
    ADD CONSTRAINT fk_openacd_agent FOREIGN KEY (openacd_agent_id) REFERENCES openacd_agent(openacd_agent_id) ON DELETE CASCADE;


--
-- Name: fk_openacd_agent_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_agent
    ADD CONSTRAINT fk_openacd_agent_group FOREIGN KEY (openacd_agent_group_id) REFERENCES openacd_agent_group(openacd_agent_group_id);


--
-- Name: fk_openacd_permission_profile; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_agent
    ADD CONSTRAINT fk_openacd_permission_profile FOREIGN KEY (openacd_permission_profile_id) REFERENCES openacd_permission_profile(openacd_permission_profile_id);


--
-- Name: fk_openacd_permission_profile; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_agent_group
    ADD CONSTRAINT fk_openacd_permission_profile FOREIGN KEY (openacd_permission_profile_id) REFERENCES openacd_permission_profile(openacd_permission_profile_id);


--
-- Name: fk_openacd_queue; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_recipe_step
    ADD CONSTRAINT fk_openacd_queue FOREIGN KEY (openacd_queue_id) REFERENCES openacd_queue(openacd_queue_id);


--
-- Name: fk_openacd_queue_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_queue
    ADD CONSTRAINT fk_openacd_queue_group FOREIGN KEY (openacd_queue_group_id) REFERENCES openacd_queue_group(openacd_queue_group_id);


--
-- Name: fk_openacd_queue_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_recipe_step
    ADD CONSTRAINT fk_openacd_queue_group FOREIGN KEY (openacd_queue_group_id) REFERENCES openacd_queue_group(openacd_queue_group_id);


--
-- Name: fk_openacd_skill_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_skill
    ADD CONSTRAINT fk_openacd_skill_group FOREIGN KEY (openacd_skill_group_id) REFERENCES openacd_skill_group(openacd_skill_group_id) MATCH FULL;


--
-- Name: fk_owner_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY meetme_conference
    ADD CONSTRAINT fk_owner_id FOREIGN KEY (owner_id) REFERENCES users(user_id) ON DELETE SET NULL;


--
-- Name: fk_personal_atendant_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personal_attendant
    ADD CONSTRAINT fk_personal_atendant_users FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: fk_personal_attendant_menu_item_personal_attendant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personal_attendant_menu_item
    ADD CONSTRAINT fk_personal_attendant_menu_item_personal_attendant FOREIGN KEY (personal_attendant_id) REFERENCES personal_attendant(personal_attendant_id);


--
-- Name: fk_phonebook_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY phonebook
    ADD CONSTRAINT fk_phonebook_users FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: fk_private_user_key_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY private_user_key
    ADD CONSTRAINT fk_private_user_key_user FOREIGN KEY (user_id) REFERENCES users(user_id) MATCH FULL ON DELETE CASCADE;


--
-- Name: fk_ring_schedule_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ring
    ADD CONSTRAINT fk_ring_schedule_id FOREIGN KEY (schedule_id) REFERENCES schedule(schedule_id) MATCH FULL;


--
-- Name: fk_sbc_device_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY gateway
    ADD CONSTRAINT fk_sbc_device_id FOREIGN KEY (sbc_device_id) REFERENCES sbc_device(sbc_device_id) MATCH FULL;


--
-- Name: fk_sbc_device_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sbc
    ADD CONSTRAINT fk_sbc_device_id FOREIGN KEY (sbc_device_id) REFERENCES sbc_device(sbc_device_id) MATCH FULL;


--
-- Name: fk_sbc_route_domain_sbc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sbc_route_domain
    ADD CONSTRAINT fk_sbc_route_domain_sbc FOREIGN KEY (sbc_id) REFERENCES sbc(sbc_id);


--
-- Name: fk_sbc_route_subnet_sbc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sbc_route_subnet
    ADD CONSTRAINT fk_sbc_route_subnet_sbc FOREIGN KEY (sbc_id) REFERENCES sbc(sbc_id);


--
-- Name: fk_schedule_hours_schedule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY schedule_hours
    ADD CONSTRAINT fk_schedule_hours_schedule FOREIGN KEY (schedule_id) REFERENCES schedule(schedule_id) MATCH FULL;


--
-- Name: fk_schedule_user_groups; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT fk_schedule_user_groups FOREIGN KEY (group_id) REFERENCES group_storage(group_id);


--
-- Name: fk_schedule_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT fk_schedule_users FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: fk_speeddial_button_speeddial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY speeddial_button
    ADD CONSTRAINT fk_speeddial_button_speeddial FOREIGN KEY (speeddial_id) REFERENCES speeddial(speeddial_id);


--
-- Name: fk_speeddial_button_speeddial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY speeddial_group_button
    ADD CONSTRAINT fk_speeddial_button_speeddial FOREIGN KEY (speeddial_id) REFERENCES speeddial_group(speeddial_id);


--
-- Name: fk_speeddial_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY speeddial_group
    ADD CONSTRAINT fk_speeddial_group FOREIGN KEY (group_id) REFERENCES group_storage(group_id);


--
-- Name: fk_speeddial_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY speeddial
    ADD CONSTRAINT fk_speeddial_user FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_agent
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: fk_users_branch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_users_branch FOREIGN KEY (branch_id) REFERENCES branch(branch_id) MATCH FULL ON DELETE SET NULL;


--
-- Name: fk_users_branch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_users_branch FOREIGN KEY (region_id) REFERENCES region(region_id) MATCH FULL ON DELETE SET NULL;


--
-- Name: fk_working_time_attendant_auto_attendant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendant_dialing_rule
    ADD CONSTRAINT fk_working_time_attendant_auto_attendant FOREIGN KEY (working_time_attendant_id) REFERENCES auto_attendant(auto_attendant_id);


--
-- Name: fka10b67307dd83cc0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY long_distance_dialing_rule
    ADD CONSTRAINT fka10b67307dd83cc0 FOREIGN KEY (international_dialing_rule_id) REFERENCES dialing_rule(dialing_rule_id);


--
-- Name: fkb189aeb7454433a3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY custom_dialing_rule
    ADD CONSTRAINT fkb189aeb7454433a3 FOREIGN KEY (custom_dialing_rule_id) REFERENCES dialing_rule(dialing_rule_id);


--
-- Name: fkbb1806c2cb50fced; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY setting_value
    ADD CONSTRAINT fkbb1806c2cb50fced FOREIGN KEY (value_storage_id) REFERENCES value_storage(value_storage_id);


--
-- Name: fkd3f02d415beffe1d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendant_menu_item
    ADD CONSTRAINT fkd3f02d415beffe1d FOREIGN KEY (auto_attendant_id) REFERENCES auto_attendant(auto_attendant_id);


--
-- Name: fkd5244c6e1e2e76db; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY phone_group
    ADD CONSTRAINT fkd5244c6e1e2e76db FOREIGN KEY (group_id) REFERENCES group_storage(group_id);


--
-- Name: fkd5244c6eb3b3158c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY phone_group
    ADD CONSTRAINT fkd5244c6eb3b3158c FOREIGN KEY (phone_id) REFERENCES phone(phone_id);


--
-- Name: fke5d682ba7dd83cc0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY international_dialing_rule
    ADD CONSTRAINT fke5d682ba7dd83cc0 FOREIGN KEY (international_dialing_rule_id) REFERENCES dialing_rule(dialing_rule_id);


--
-- Name: fkf4ba4644cb50fced; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY gateway
    ADD CONSTRAINT fkf4ba4644cb50fced FOREIGN KEY (value_storage_id) REFERENCES value_storage(value_storage_id);


--
-- Name: freeswitch_ext_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY call_queue_tier
    ADD CONSTRAINT freeswitch_ext_id FOREIGN KEY (freeswitch_ext_id) REFERENCES freeswitch_extension(freeswitch_ext_id);


--
-- Name: intercom_phone_group_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY intercom_phone_group
    ADD CONSTRAINT intercom_phone_group_fk1 FOREIGN KEY (intercom_id) REFERENCES intercom(intercom_id);


--
-- Name: intercom_phone_group_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY intercom_phone_group
    ADD CONSTRAINT intercom_phone_group_fk2 FOREIGN KEY (group_id) REFERENCES group_storage(group_id);


--
-- Name: ldap_connection_cron_schedule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ldap_connection
    ADD CONSTRAINT ldap_connection_cron_schedule FOREIGN KEY (cron_schedule_id) REFERENCES cron_schedule(cron_schedule_id);


--
-- Name: location_failed_replications_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY location_failed_replications
    ADD CONSTRAINT location_failed_replications_fk FOREIGN KEY (location_id) REFERENCES location(location_id);


--
-- Name: openacd_permission_widget_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_permission_widget
    ADD CONSTRAINT openacd_permission_widget_fk1 FOREIGN KEY (openacd_permission_profile_id) REFERENCES openacd_permission_profile(openacd_permission_profile_id) ON DELETE CASCADE;


--
-- Name: paging_group_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_paging_group
    ADD CONSTRAINT paging_group_fk1 FOREIGN KEY (paging_group_id) REFERENCES paging_group(paging_group_id);


--
-- Name: paging_group_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_paging_group
    ADD CONSTRAINT paging_group_fk2 FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: permission_admin_role_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permission_admin_role
    ADD CONSTRAINT permission_admin_role_fk1 FOREIGN KEY (admin_role_id) REFERENCES admin_role(admin_role_id);


--
-- Name: permission_agent_group_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_permission_agent_group
    ADD CONSTRAINT permission_agent_group_fk1 FOREIGN KEY (openacd_agent_group_id) REFERENCES openacd_agent_group(openacd_agent_group_id) ON DELETE CASCADE;


--
-- Name: permission_agent_group_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_permission_agent_group
    ADD CONSTRAINT permission_agent_group_fk2 FOREIGN KEY (openacd_permission_profile_id) REFERENCES openacd_permission_profile(openacd_permission_profile_id) ON DELETE CASCADE;


--
-- Name: permission_queue_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_permission_queue
    ADD CONSTRAINT permission_queue_fk1 FOREIGN KEY (openacd_queue_id) REFERENCES openacd_queue(openacd_queue_id) ON DELETE CASCADE;


--
-- Name: permission_queue_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_permission_queue
    ADD CONSTRAINT permission_queue_fk2 FOREIGN KEY (openacd_permission_profile_id) REFERENCES openacd_permission_profile(openacd_permission_profile_id) ON DELETE CASCADE;


--
-- Name: phonebook_consumer_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY phonebook_consumer
    ADD CONSTRAINT phonebook_consumer_fk1 FOREIGN KEY (phonebook_id) REFERENCES phonebook(phonebook_id);


--
-- Name: phonebook_consumer_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY phonebook_consumer
    ADD CONSTRAINT phonebook_consumer_fk2 FOREIGN KEY (group_id) REFERENCES group_storage(group_id);


--
-- Name: phonebook_entry_address_book_entry; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY phonebook_file_entry
    ADD CONSTRAINT phonebook_entry_address_book_entry FOREIGN KEY (address_book_entry_id) REFERENCES address_book_entry(address_book_entry_id);


--
-- Name: phonebook_entry_phonebook; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY phonebook_file_entry
    ADD CONSTRAINT phonebook_entry_phonebook FOREIGN KEY (phonebook_id) REFERENCES phonebook(phonebook_id);


--
-- Name: phonebook_member_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY phonebook_member
    ADD CONSTRAINT phonebook_member_fk1 FOREIGN KEY (phonebook_id) REFERENCES phonebook(phonebook_id);


--
-- Name: phonebook_member_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY phonebook_member
    ADD CONSTRAINT phonebook_member_fk2 FOREIGN KEY (group_id) REFERENCES group_storage(group_id);


--
-- Name: queue_agent_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_queue_agent
    ADD CONSTRAINT queue_agent_fk1 FOREIGN KEY (openacd_agent_id) REFERENCES openacd_agent(openacd_agent_id) ON DELETE CASCADE;


--
-- Name: queue_agent_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_queue_agent
    ADD CONSTRAINT queue_agent_fk2 FOREIGN KEY (openacd_queue_id) REFERENCES openacd_queue(openacd_queue_id) ON DELETE CASCADE;


--
-- Name: queue_agent_group_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_queue_agent_group
    ADD CONSTRAINT queue_agent_group_fk1 FOREIGN KEY (openacd_agent_group_id) REFERENCES openacd_agent_group(openacd_agent_group_id);


--
-- Name: queue_agent_group_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_queue_agent_group
    ADD CONSTRAINT queue_agent_group_fk2 FOREIGN KEY (openacd_queue_id) REFERENCES openacd_queue(openacd_queue_id) ON DELETE CASCADE;


--
-- Name: service_value_storage; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_value_storage FOREIGN KEY (value_storage_id) REFERENCES value_storage(value_storage_id);


--
-- Name: settings_location_group_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY settings_location_group
    ADD CONSTRAINT settings_location_group_group_id FOREIGN KEY (group_id) REFERENCES group_storage(group_id);


--
-- Name: settings_location_group_settings_with_location_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY settings_location_group
    ADD CONSTRAINT settings_location_group_settings_with_location_id FOREIGN KEY (settings_with_location_id) REFERENCES settings_with_location(settings_with_location_id);


--
-- Name: settings_with_location_location_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY settings_with_location
    ADD CONSTRAINT settings_with_location_location_id FOREIGN KEY (location_id) REFERENCES location(location_id);


--
-- Name: settings_with_location_value_storage_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY settings_with_location
    ADD CONSTRAINT settings_with_location_value_storage_id FOREIGN KEY (value_storage_id) REFERENCES value_storage(value_storage_id);


--
-- Name: site_to_site_dialing_pattern_dialing_rule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY site_to_site_dial_pattern
    ADD CONSTRAINT site_to_site_dialing_pattern_dialing_rule FOREIGN KEY (site_to_site_dialing_rule_id) REFERENCES site_to_site_dialing_rule(site_to_site_dialing_rule_id);


--
-- Name: site_to_site_dialing_rule_dialing_rule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY site_to_site_dialing_rule
    ADD CONSTRAINT site_to_site_dialing_rule_dialing_rule FOREIGN KEY (site_to_site_dialing_rule_id) REFERENCES dialing_rule(dialing_rule_id);


--
-- Name: skill_agent_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_skill_agent
    ADD CONSTRAINT skill_agent_fk1 FOREIGN KEY (openacd_agent_id) REFERENCES openacd_agent(openacd_agent_id);


--
-- Name: skill_agent_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_skill_agent
    ADD CONSTRAINT skill_agent_fk2 FOREIGN KEY (openacd_skill_id) REFERENCES openacd_skill(openacd_skill_id);


--
-- Name: skill_agent_group_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_skill_agent_group
    ADD CONSTRAINT skill_agent_group_fk1 FOREIGN KEY (openacd_agent_group_id) REFERENCES openacd_agent_group(openacd_agent_group_id);


--
-- Name: skill_agent_group_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_skill_agent_group
    ADD CONSTRAINT skill_agent_group_fk2 FOREIGN KEY (openacd_skill_id) REFERENCES openacd_skill(openacd_skill_id);


--
-- Name: skill_queue_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_skill_queue
    ADD CONSTRAINT skill_queue_fk1 FOREIGN KEY (openacd_queue_id) REFERENCES openacd_queue(openacd_queue_id);


--
-- Name: skill_queue_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_skill_queue
    ADD CONSTRAINT skill_queue_fk2 FOREIGN KEY (openacd_skill_id) REFERENCES openacd_skill(openacd_skill_id);


--
-- Name: skill_queue_group_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_skill_queue_group
    ADD CONSTRAINT skill_queue_group_fk1 FOREIGN KEY (openacd_queue_group_id) REFERENCES openacd_queue_group(openacd_queue_group_id);


--
-- Name: skill_queue_group_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_skill_queue_group
    ADD CONSTRAINT skill_queue_group_fk2 FOREIGN KEY (openacd_skill_id) REFERENCES openacd_skill(openacd_skill_id);


--
-- Name: skill_recipe_action_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_skill_recipe_action
    ADD CONSTRAINT skill_recipe_action_fk1 FOREIGN KEY (openacd_recipe_action_id) REFERENCES openacd_recipe_action(openacd_recipe_action_id);


--
-- Name: skill_recipe_action_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY openacd_skill_recipe_action
    ADD CONSTRAINT skill_recipe_action_fk2 FOREIGN KEY (openacd_skill_id) REFERENCES openacd_skill(openacd_skill_id);


--
-- Name: supervisor_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY supervisor
    ADD CONSTRAINT supervisor_fk1 FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: supervisor_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY supervisor
    ADD CONSTRAINT supervisor_fk2 FOREIGN KEY (group_id) REFERENCES group_storage(group_id);


--
-- Name: upload_value_storage; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT upload_value_storage FOREIGN KEY (value_storage_id) REFERENCES value_storage(value_storage_id);


--
-- Name: user_alias_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_alias
    ADD CONSTRAINT user_alias_fk1 FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: user_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT user_fk1 FOREIGN KEY (value_storage_id) REFERENCES value_storage(value_storage_id);


--
-- Name: user_group_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_group
    ADD CONSTRAINT user_group_fk1 FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: user_group_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_group
    ADD CONSTRAINT user_group_fk2 FOREIGN KEY (group_id) REFERENCES group_storage(group_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

