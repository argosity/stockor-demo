--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.4
-- Dumped by pg_dump version 9.5.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET search_path = public, pg_catalog;

--
-- Name: skr_next_sequential_id(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION skr_next_sequential_id(character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
    next_id integer;
begin
    select current_value into next_id from skr_sequential_ids where name = $1 for update;
    if not found then
        insert into skr_sequential_ids ( name, current_value ) values ( $1, 1 );
        return 1;
    else
        update skr_sequential_ids set current_value = next_id+1 where name = $1;
        return next_id+1;
    end if;
end;
$_$;


--
-- Name: btree_hstore_ops; Type: OPERATOR FAMILY; Schema: public; Owner: -
--

CREATE OPERATOR FAMILY btree_hstore_ops USING btree;


--
-- Name: gin_hstore_ops; Type: OPERATOR FAMILY; Schema: public; Owner: -
--

CREATE OPERATOR FAMILY gin_hstore_ops USING gin;


--
-- Name: gist_hstore_ops; Type: OPERATOR FAMILY; Schema: public; Owner: -
--

CREATE OPERATOR FAMILY gist_hstore_ops USING gist;


--
-- Name: hash_hstore_ops; Type: OPERATOR FAMILY; Schema: public; Owner: -
--

CREATE OPERATOR FAMILY hash_hstore_ops USING hash;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: assets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE assets (
    id integer NOT NULL,
    owner_type character varying NOT NULL,
    owner_id integer NOT NULL,
    "order" integer,
    file_data jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assets_id_seq OWNED BY assets.id;


--
-- Name: lanes_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE lanes_users (
    id integer NOT NULL,
    login character varying NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    password_digest character varying NOT NULL,
    role_names character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    options jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: lanes_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lanes_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lanes_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lanes_users_id_seq OWNED BY lanes_users.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: skr_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_addresses (
    id integer NOT NULL,
    name character varying,
    email character varying,
    phone character varying,
    line1 character varying,
    line2 character varying,
    city character varying,
    state character varying,
    postal_code character varying,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_addresses_id_seq OWNED BY skr_addresses.id;


--
-- Name: skr_bank_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_bank_accounts (
    id integer NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    description text,
    routing_number text,
    account_number text,
    address_id integer NOT NULL,
    gl_account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: skr_bank_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_bank_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_bank_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_bank_accounts_id_seq OWNED BY skr_bank_accounts.id;


--
-- Name: skr_uoms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_uoms (
    id integer NOT NULL,
    sku_id integer NOT NULL,
    price numeric(15,2) NOT NULL,
    size smallint DEFAULT 1 NOT NULL,
    code character varying DEFAULT 'EA'::character varying NOT NULL,
    weight numeric(6,1),
    height numeric(6,1),
    width numeric(6,1),
    depth numeric(6,1),
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_combined_uom; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_combined_uom AS
 SELECT uom.id AS skr_uom_id,
        CASE
            WHEN (uom.size = 1) THEN (uom.code)::text
            ELSE (((uom.code)::text || '/'::text) || uom.size)
        END AS combined_uom
   FROM skr_uoms uom;


--
-- Name: skr_customer_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_customer_projects (
    id integer NOT NULL,
    code character varying NOT NULL,
    name text,
    description text,
    po_num text,
    sku_id integer NOT NULL,
    customer_id integer NOT NULL,
    invoice_form character varying,
    rates jsonb,
    options jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: skr_customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_customers (
    id integer NOT NULL,
    code character varying NOT NULL,
    billing_address_id integer,
    shipping_address_id integer,
    terms_id integer NOT NULL,
    gl_receivables_account_id integer NOT NULL,
    credit_limit numeric(15,2) DEFAULT 0.0,
    open_balance numeric(15,2) DEFAULT 0.0,
    is_tax_exempt boolean DEFAULT false NOT NULL,
    hash_code character varying NOT NULL,
    name character varying NOT NULL,
    notes text,
    website text,
    options jsonb,
    forms jsonb,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_skus; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_skus (
    id integer NOT NULL,
    default_vendor_id integer,
    gl_asset_account_id integer NOT NULL,
    default_uom_code character varying NOT NULL,
    code character varying NOT NULL,
    description character varying NOT NULL,
    is_discontinued boolean DEFAULT false NOT NULL,
    is_other_charge boolean DEFAULT false NOT NULL,
    does_track_inventory boolean DEFAULT false NOT NULL,
    can_backorder boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL,
    is_public boolean DEFAULT true NOT NULL
);


--
-- Name: skr_customer_project_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_customer_project_details AS
 SELECT cp.id AS customer_project_id,
    c.code AS customer_code,
    c.name AS customer_description,
    s.code AS sku_code,
    s.description AS sku_description
   FROM ((skr_customer_projects cp
     JOIN skr_skus s ON ((s.id = cp.sku_id)))
     JOIN skr_customers c ON ((c.id = cp.customer_id)));


--
-- Name: skr_customer_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_customer_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_customer_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_customer_projects_id_seq OWNED BY skr_customer_projects.id;


--
-- Name: skr_customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_customers_id_seq OWNED BY skr_customers.id;


--
-- Name: skr_event_invoice_xrefs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_event_invoice_xrefs (
    id integer NOT NULL,
    event_id integer NOT NULL,
    invoice_id integer NOT NULL
);


--
-- Name: skr_event_invoice_xrefs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_event_invoice_xrefs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_event_invoice_xrefs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_event_invoice_xrefs_id_seq OWNED BY skr_event_invoice_xrefs.id;


--
-- Name: skr_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_events (
    id integer NOT NULL,
    code character varying NOT NULL,
    sku_id integer NOT NULL,
    title text NOT NULL,
    sub_title text,
    info text,
    venue text,
    email_from text,
    email_signature text,
    post_purchase_message text,
    starts_at timestamp without time zone,
    max_qty integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: skr_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_events_id_seq OWNED BY skr_events.id;


--
-- Name: skr_expense_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_expense_categories (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    gl_account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_expense_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_expense_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_expense_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_expense_categories_id_seq OWNED BY skr_expense_categories.id;


--
-- Name: skr_expense_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_expense_entries (
    id integer NOT NULL,
    uuid uuid NOT NULL,
    name text NOT NULL,
    memo text,
    occured timestamp without time zone NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL
);


--
-- Name: skr_expense_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_expense_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_expense_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_expense_entries_id_seq OWNED BY skr_expense_entries.id;


--
-- Name: skr_expense_entry_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_expense_entry_categories (
    id integer NOT NULL,
    category_id integer NOT NULL,
    entry_id integer NOT NULL,
    amount numeric(15,2) NOT NULL
);


--
-- Name: skr_expense_entry_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_expense_entry_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_expense_entry_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_expense_entry_categories_id_seq OWNED BY skr_expense_entry_categories.id;


--
-- Name: skr_gl_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_gl_transactions (
    id integer NOT NULL,
    period_id integer NOT NULL,
    source_type character varying,
    source_id integer,
    description text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL
);


--
-- Name: skr_expense_entry_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_expense_entry_details AS
 SELECT xref.expense_entry_id,
    array_agg(xref.gl_transaction_id) FILTER (WHERE (xref.gl_transaction_id IS NOT NULL)) AS gl_transaction_ids,
    array_agg(xref.category_id) AS category_ids,
    sum(xref.amount) AS category_total,
    json_agg(row_to_json(( SELECT t.*::record AS t
           FROM ( SELECT xref.category_id,
                    xref.amount,
                    xref.balance) t(category_id, amount, balance)))) AS category_list
   FROM ( SELECT entry.id AS expense_entry_id,
            gl.id AS gl_transaction_id,
            ec.category_id,
            ec.amount,
            sum(ec.amount) OVER (PARTITION BY ec.category_id ORDER BY entry.occured) AS balance
           FROM ((skr_expense_entries entry
             LEFT JOIN skr_gl_transactions gl ON ((((gl.source_type)::text = 'Skr::ExpenseEntry'::text) AND (gl.source_id = entry.id))))
             JOIN skr_expense_entry_categories ec ON ((entry.id = ec.entry_id)))) xref
  GROUP BY xref.expense_entry_id;


--
-- Name: skr_gl_account_balances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_gl_account_balances (
    gl_account_id integer,
    branch_number text,
    balance numeric
);

ALTER TABLE ONLY skr_gl_account_balances REPLICA IDENTITY NOTHING;


--
-- Name: skr_gl_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_gl_accounts (
    id integer NOT NULL,
    number character varying NOT NULL,
    name character varying NOT NULL,
    description text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_gl_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_gl_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_gl_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_gl_accounts_id_seq OWNED BY skr_gl_accounts.id;


--
-- Name: skr_gl_manual_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_gl_manual_entries (
    id integer NOT NULL,
    visible_id character varying NOT NULL,
    notes text,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_gl_manual_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_gl_manual_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_gl_manual_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_gl_manual_entries_id_seq OWNED BY skr_gl_manual_entries.id;


--
-- Name: skr_gl_periods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_gl_periods (
    id integer NOT NULL,
    year smallint NOT NULL,
    period smallint NOT NULL,
    is_locked boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_gl_periods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_gl_periods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_gl_periods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_gl_periods_id_seq OWNED BY skr_gl_periods.id;


--
-- Name: skr_gl_postings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_gl_postings (
    id integer NOT NULL,
    gl_transaction_id integer NOT NULL,
    account_number character varying NOT NULL,
    amount numeric(15,2) NOT NULL,
    is_debit boolean NOT NULL,
    year smallint NOT NULL,
    period smallint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL
);


--
-- Name: skr_gl_postings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_gl_postings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_gl_postings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_gl_postings_id_seq OWNED BY skr_gl_postings.id;


--
-- Name: skr_gl_transaction_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_gl_transaction_details AS
 SELECT glt.id AS gl_transaction_id,
    to_char(glt.created_at, 'YYYY-MM-DD'::text) AS transaction_date,
    pr.period AS accounting_period,
    pr.year AS accounting_year,
    ( SELECT array_agg(skr_gl_postings.account_number) AS array_agg
           FROM skr_gl_postings
          WHERE (skr_gl_postings.gl_transaction_id = glt.id)) AS account_numbers,
    ( SELECT array_to_json(array_agg(row_to_json(postings.*))) AS array_to_json
           FROM ( SELECT skr_gl_postings.account_number,
                    skr_gl_postings.amount
                   FROM skr_gl_postings
                  WHERE ((skr_gl_postings.gl_transaction_id = glt.id) AND (skr_gl_postings.is_debit = true))) postings) AS debit_details,
    ( SELECT array_to_json(array_agg(row_to_json(postings.*))) AS array_to_json
           FROM ( SELECT skr_gl_postings.account_number,
                    skr_gl_postings.amount
                   FROM skr_gl_postings
                  WHERE ((skr_gl_postings.gl_transaction_id = glt.id) AND (skr_gl_postings.is_debit = false))) postings) AS credit_details
   FROM (skr_gl_transactions glt
     JOIN skr_gl_periods pr ON ((pr.id = glt.period_id)));


--
-- Name: skr_gl_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_gl_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_gl_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_gl_transactions_id_seq OWNED BY skr_gl_transactions.id;


--
-- Name: skr_ia_lines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_ia_lines (
    id integer NOT NULL,
    inventory_adjustment_id integer NOT NULL,
    sku_loc_id integer NOT NULL,
    qty integer DEFAULT 1 NOT NULL,
    uom_code character varying DEFAULT 'EA'::character varying NOT NULL,
    uom_size smallint DEFAULT 1 NOT NULL,
    cost numeric(15,2),
    cost_was_set boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_ia_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_ia_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_ia_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_ia_lines_id_seq OWNED BY skr_ia_lines.id;


--
-- Name: skr_ia_reasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_ia_reasons (
    id integer NOT NULL,
    gl_account_id integer NOT NULL,
    code character varying NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_ia_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_ia_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_ia_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_ia_reasons_id_seq OWNED BY skr_ia_reasons.id;


--
-- Name: skr_inv_lines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_inv_lines (
    id integer NOT NULL,
    invoice_id integer NOT NULL,
    sku_loc_id integer NOT NULL,
    pt_line_id integer,
    so_line_id integer,
    time_entry_id integer,
    price numeric(15,2) NOT NULL,
    sku_code character varying NOT NULL,
    description character varying NOT NULL,
    uom_code character varying NOT NULL,
    uom_size smallint NOT NULL,
    "position" smallint NOT NULL,
    qty numeric(15,2) NOT NULL,
    is_revised boolean DEFAULT false NOT NULL,
    options jsonb,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_invoices (
    id integer NOT NULL,
    visible_id character varying NOT NULL,
    state smallint DEFAULT 0 NOT NULL,
    terms_id integer NOT NULL,
    customer_id integer NOT NULL,
    location_id integer NOT NULL,
    customer_project_id integer,
    sales_order_id integer,
    pick_ticket_id integer,
    shipping_address_id integer,
    billing_address_id integer,
    is_tax_exempt boolean DEFAULT false NOT NULL,
    hash_code character varying NOT NULL,
    invoice_date date NOT NULL,
    po_num character varying,
    notes text,
    form character varying,
    options jsonb,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_payments (
    id integer NOT NULL,
    visible_id character varying NOT NULL,
    bank_account_id integer NOT NULL,
    category_id integer,
    vendor_id integer,
    location_id integer NOT NULL,
    hash_code character varying NOT NULL,
    amount numeric(15,2) NOT NULL,
    date date NOT NULL,
    check_number character varying,
    name text NOT NULL,
    address text,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    invoice_id integer,
    metadata jsonb DEFAULT '{}'::jsonb
);


--
-- Name: skr_pick_tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_pick_tickets (
    id integer NOT NULL,
    visible_id character varying NOT NULL,
    sales_order_id integer NOT NULL,
    location_id integer NOT NULL,
    shipped_at date,
    is_complete boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_sales_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_sales_orders (
    id integer NOT NULL,
    visible_id character varying NOT NULL,
    state smallint DEFAULT 0 NOT NULL,
    customer_id integer NOT NULL,
    location_id integer NOT NULL,
    shipping_address_id integer,
    billing_address_id integer,
    terms_id integer NOT NULL,
    is_tax_exempt boolean DEFAULT false NOT NULL,
    order_date date NOT NULL,
    is_revised boolean DEFAULT false NOT NULL,
    hash_code character varying NOT NULL,
    ship_partial boolean DEFAULT false NOT NULL,
    po_num character varying,
    notes text,
    form character varying,
    options jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_sku_locs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_sku_locs (
    id integer NOT NULL,
    sku_id integer NOT NULL,
    location_id integer NOT NULL,
    mac numeric(15,4) DEFAULT 0.0 NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    qty_allocated integer DEFAULT 0 NOT NULL,
    qty_picking integer DEFAULT 0 NOT NULL,
    qty_reserved integer DEFAULT 0 NOT NULL,
    bin character varying,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_inv_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_inv_details AS
 SELECT inv.id AS invoice_id,
    so.visible_id AS sales_order_visible_id,
    pt.id AS pick_ticket_id,
    to_char(so.created_at, 'YYYY-MM-DD'::text) AS string_order_date,
    to_char(inv.created_at, 'YYYY-MM-DD'::text) AS string_invoice_date,
    cust.code AS customer_code,
    cust.name AS customer_name,
    ba.name AS bill_addr_name,
    COALESCE(ttls.total, 0.0) AS invoice_total,
    COALESCE(ttls.num_lines, (0)::bigint) AS num_lines,
    COALESCE(ttls.other_charge_total, (0)::numeric) AS total_other_charge_amount,
    (COALESCE(ttls.total, 0.0) - COALESCE(ttls.other_charge_total, 0.0)) AS subtotal_amount,
    COALESCE(payments.amount_paid, (0)::numeric) AS amount_paid
   FROM ((((((skr_invoices inv
     JOIN skr_customers cust ON ((cust.id = inv.customer_id)))
     LEFT JOIN skr_addresses ba ON ((ba.id = inv.billing_address_id)))
     LEFT JOIN skr_sales_orders so ON ((so.id = inv.sales_order_id)))
     LEFT JOIN skr_pick_tickets pt ON ((pt.id = inv.pick_ticket_id)))
     LEFT JOIN ( SELECT ivl.invoice_id,
            sum((ivl.qty * ivl.price)) AS total,
            sum(
                CASE
                    WHEN s.is_other_charge THEN (ivl.qty * ivl.price)
                    ELSE (0)::numeric
                END) AS other_charge_total,
            count(ivl.*) AS num_lines
           FROM ((skr_inv_lines ivl
             JOIN skr_sku_locs sl ON ((sl.id = ivl.sku_loc_id)))
             JOIN skr_skus s ON ((s.id = sl.sku_id)))
          GROUP BY ivl.invoice_id) ttls ON ((ttls.invoice_id = inv.id)))
     LEFT JOIN ( SELECT skr_payments.invoice_id,
            sum(skr_payments.amount) AS amount_paid
           FROM skr_payments
          WHERE (skr_payments.invoice_id IS NOT NULL)
          GROUP BY skr_payments.invoice_id) payments ON ((payments.invoice_id = inv.id)));


--
-- Name: skr_inv_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_inv_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_inv_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_inv_lines_id_seq OWNED BY skr_inv_lines.id;


--
-- Name: skr_inventory_adjustments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_inventory_adjustments (
    id integer NOT NULL,
    visible_id character varying NOT NULL,
    state smallint DEFAULT 0 NOT NULL,
    location_id integer NOT NULL,
    reason_id integer NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_inventory_adjustments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_inventory_adjustments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_inventory_adjustments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_inventory_adjustments_id_seq OWNED BY skr_inventory_adjustments.id;


--
-- Name: skr_invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_invoices_id_seq OWNED BY skr_invoices.id;


--
-- Name: skr_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_locations (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    address_id integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    gl_branch_code character varying(2) DEFAULT '01'::character varying NOT NULL,
    options jsonb,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_locations_id_seq OWNED BY skr_locations.id;


--
-- Name: skr_payment_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_payment_categories (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    gl_account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: skr_payment_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_payment_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_payment_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_payment_categories_id_seq OWNED BY skr_payment_categories.id;


--
-- Name: skr_payment_terms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_payment_terms (
    id integer NOT NULL,
    code character varying NOT NULL,
    days integer DEFAULT 0 NOT NULL,
    description character varying NOT NULL,
    discount_days integer,
    discount_amount character varying,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_payment_terms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_payment_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_payment_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_payment_terms_id_seq OWNED BY skr_payment_terms.id;


--
-- Name: skr_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_payments_id_seq OWNED BY skr_payments.id;


--
-- Name: skr_pick_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_pick_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_pick_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_pick_tickets_id_seq OWNED BY skr_pick_tickets.id;


--
-- Name: skr_po_lines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_po_lines (
    id integer NOT NULL,
    purchase_order_id integer NOT NULL,
    sku_loc_id integer NOT NULL,
    sku_vendor_id integer NOT NULL,
    part_code character varying NOT NULL,
    sku_code character varying NOT NULL,
    description character varying NOT NULL,
    uom_code character varying NOT NULL,
    uom_size smallint NOT NULL,
    "position" smallint NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    qty_received integer DEFAULT 0 NOT NULL,
    qty_canceled integer DEFAULT 0 NOT NULL,
    price numeric(15,2) NOT NULL,
    is_revised boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_po_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_po_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_po_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_po_lines_id_seq OWNED BY skr_po_lines.id;


--
-- Name: skr_po_receipts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_po_receipts (
    id integer NOT NULL,
    visible_id character varying NOT NULL,
    location_id integer NOT NULL,
    freight numeric(15,2) DEFAULT 0.0 NOT NULL,
    purchase_order_id integer NOT NULL,
    vendor_id integer NOT NULL,
    voucher_id integer,
    refno character varying,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL
);


--
-- Name: skr_po_receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_po_receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_po_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_po_receipts_id_seq OWNED BY skr_po_receipts.id;


--
-- Name: skr_por_lines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_por_lines (
    id integer NOT NULL,
    po_receipt_id integer NOT NULL,
    po_line_id integer,
    sku_loc_id integer NOT NULL,
    sku_vendor_id integer,
    sku_code character varying NOT NULL,
    part_code character varying NOT NULL,
    description character varying NOT NULL,
    uom_code character varying NOT NULL,
    uom_size smallint NOT NULL,
    "position" smallint NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    price numeric(15,2) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL
);


--
-- Name: skr_por_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_por_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_por_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_por_lines_id_seq OWNED BY skr_por_lines.id;


--
-- Name: skr_pt_lines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_pt_lines (
    id integer NOT NULL,
    pick_ticket_id integer NOT NULL,
    so_line_id integer NOT NULL,
    sku_loc_id integer NOT NULL,
    price numeric(15,2) NOT NULL,
    sku_code character varying NOT NULL,
    description character varying NOT NULL,
    uom_code character varying NOT NULL,
    bin character varying,
    uom_size smallint NOT NULL,
    "position" smallint NOT NULL,
    qty numeric(15,2) NOT NULL,
    qty_invoiced integer DEFAULT 0 NOT NULL,
    is_complete boolean DEFAULT false NOT NULL
);


--
-- Name: skr_pt_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_pt_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_pt_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_pt_lines_id_seq OWNED BY skr_pt_lines.id;


--
-- Name: skr_purchase_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_purchase_orders (
    id integer NOT NULL,
    visible_id character varying NOT NULL,
    state smallint DEFAULT 0 NOT NULL,
    vendor_id integer NOT NULL,
    location_id integer NOT NULL,
    ship_addr_id integer NOT NULL,
    terms_id integer NOT NULL,
    is_revised boolean DEFAULT false NOT NULL,
    order_date date NOT NULL,
    receiving_completed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_purchase_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_purchase_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_purchase_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_purchase_orders_id_seq OWNED BY skr_purchase_orders.id;


--
-- Name: skr_sales_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_sales_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_sales_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_sales_orders_id_seq OWNED BY skr_sales_orders.id;


--
-- Name: skr_sequential_ids; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_sequential_ids (
    name character varying NOT NULL,
    current_value integer DEFAULT 0 NOT NULL
);


--
-- Name: skr_sku_inv_xref; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_sku_inv_xref AS
 SELECT skr_inv_lines.invoice_id,
    skr_sku_locs.sku_id
   FROM (skr_inv_lines
     JOIN skr_sku_locs ON ((skr_sku_locs.id = skr_inv_lines.sku_loc_id)));


--
-- Name: skr_sku_vendors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_sku_vendors (
    id integer NOT NULL,
    sku_id integer NOT NULL,
    vendor_id integer NOT NULL,
    list_price numeric(15,2) NOT NULL,
    part_code character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    uom_size integer DEFAULT 1 NOT NULL,
    uom_code character varying DEFAULT 'EA'::character varying NOT NULL,
    cost numeric(15,2) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_vendors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_vendors (
    id integer NOT NULL,
    billing_address_id integer,
    shipping_address_id integer,
    terms_id integer NOT NULL,
    gl_payables_account_id integer NOT NULL,
    gl_freight_account_id integer NOT NULL,
    open_balance numeric(15,2) DEFAULT 0.0,
    code character varying NOT NULL,
    hash_code character varying NOT NULL,
    name character varying NOT NULL,
    notes text,
    account_code character varying,
    website character varying,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_sku_loc_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_sku_loc_details AS
 SELECT sl.id AS sku_loc_id,
    s.code AS sku_code,
    s.description AS sku_description,
    s.default_uom_code,
    uom.id AS default_uom_id,
    COALESCE((uom.size)::integer, 1) AS default_uom_size,
    COALESCE(uom.price, 0.0) AS default_price,
    v.code AS vendor_code,
    v.name AS vendor_name,
    sv.part_code AS vendor_part_code,
    sv.cost AS purchase_cost
   FROM ((((skr_sku_locs sl
     JOIN skr_skus s ON ((s.id = sl.sku_id)))
     LEFT JOIN skr_uoms uom ON (((uom.sku_id = s.id) AND ((uom.code)::text = (s.default_uom_code)::text))))
     JOIN skr_vendors v ON ((s.default_vendor_id = v.id)))
     JOIN skr_sku_vendors sv ON (((sv.vendor_id = v.id) AND (sv.sku_id = s.id))));


--
-- Name: skr_sku_locs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_sku_locs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_sku_locs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_sku_locs_id_seq OWNED BY skr_sku_locs.id;


--
-- Name: skr_so_lines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_so_lines (
    id integer NOT NULL,
    sales_order_id integer NOT NULL,
    sku_loc_id integer NOT NULL,
    price numeric(15,2) NOT NULL,
    sku_code character varying NOT NULL,
    description character varying NOT NULL,
    uom_code character varying NOT NULL,
    uom_size smallint NOT NULL,
    "position" smallint NOT NULL,
    qty numeric(15,2) NOT NULL,
    qty_allocated numeric(15,2) DEFAULT 0 NOT NULL,
    qty_picking numeric(15,2) DEFAULT 0 NOT NULL,
    qty_invoiced numeric(15,2) DEFAULT 0 NOT NULL,
    qty_canceled numeric(15,2) DEFAULT 0 NOT NULL,
    is_revised boolean DEFAULT false NOT NULL,
    options jsonb,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_sku_qty_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_sku_qty_details AS
 SELECT s.id AS sku_id,
    sl_ttl.qty AS qty_on_hand,
    COALESCE(sol_ttl.qty, (0)::numeric) AS qty_on_orders,
    COALESCE(pol_ttl.qty, (0)::bigint) AS qty_incoming
   FROM (((skr_skus s
     JOIN ( SELECT sum(sl.qty) AS qty,
            sl.sku_id
           FROM skr_sku_locs sl
          GROUP BY sl.sku_id) sl_ttl ON ((sl_ttl.sku_id = s.id)))
     LEFT JOIN ( SELECT s_1.id AS sku_id,
            sum(((sol.qty - sol.qty_canceled) * (sol.uom_size)::numeric)) AS qty
           FROM (((skr_so_lines sol
             JOIN skr_sales_orders so ON (((so.id = sol.sales_order_id) AND (so.state <> ALL (ARRAY[5, 10])))))
             JOIN skr_sku_locs sl ON ((sl.id = sol.sku_loc_id)))
             JOIN skr_skus s_1 ON ((s_1.id = sl.sku_id)))
          GROUP BY s_1.id) sol_ttl ON ((sol_ttl.sku_id = s.id)))
     LEFT JOIN ( SELECT s_1.id AS sku_id,
            sum(((pol.qty - pol.qty_canceled) * pol.uom_size)) AS qty
           FROM (((skr_po_lines pol
             JOIN skr_purchase_orders po ON (((po.id = pol.purchase_order_id) AND (po.state <> ALL (ARRAY[5, 15])))))
             JOIN skr_sku_locs sl ON ((sl.id = pol.sku_loc_id)))
             JOIN skr_skus s_1 ON ((s_1.id = sl.sku_id)))
          GROUP BY s_1.id) pol_ttl ON ((pol_ttl.sku_id = s.id)));


--
-- Name: skr_sku_so_xref; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_sku_so_xref AS
 SELECT skr_so_lines.sales_order_id,
    skr_sku_locs.sku_id
   FROM (skr_so_lines
     JOIN skr_sku_locs ON ((skr_sku_locs.id = skr_so_lines.sku_loc_id)));


--
-- Name: skr_sku_trans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_sku_trans (
    id integer NOT NULL,
    origin_type character varying,
    origin_id integer,
    sku_loc_id integer NOT NULL,
    cost numeric(15,2) NOT NULL,
    origin_description character varying NOT NULL,
    prior_qty integer NOT NULL,
    mac numeric(15,4) NOT NULL,
    prior_mac numeric(15,4) NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    uom_code character varying DEFAULT 'EA'::character varying NOT NULL,
    uom_size integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL
);


--
-- Name: skr_sku_trans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_sku_trans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_sku_trans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_sku_trans_id_seq OWNED BY skr_sku_trans.id;


--
-- Name: skr_sku_vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_sku_vendors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_sku_vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_sku_vendors_id_seq OWNED BY skr_sku_vendors.id;


--
-- Name: skr_skus_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_skus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_skus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_skus_id_seq OWNED BY skr_skus.id;


--
-- Name: skr_so_allocation_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_so_allocation_details AS
 SELECT sol.sales_order_id,
    count(*) AS number_of_lines,
    sum((sol.qty_allocated * sol.price)) AS allocated_total,
    sum(
        CASE
            WHEN (((sol.qty_allocated - sol.qty_canceled) - sol.qty_picking) > (0)::numeric) THEN 1
            ELSE 0
        END) AS number_of_lines_allocated,
    sum(
        CASE
            WHEN (sol.qty_allocated = ((sol.qty - sol.qty_canceled) - sol.qty_picking)) THEN 1
            ELSE 0
        END) AS number_of_lines_fully_allocated
   FROM ((skr_so_lines sol
     JOIN skr_sku_locs sl ON ((sl.id = sol.sku_loc_id)))
     JOIN skr_skus s ON (((s.id = sl.sku_id) AND (s.is_other_charge = false))))
  GROUP BY sol.sales_order_id
 HAVING (sum(
        CASE
            WHEN (((sol.qty_allocated - sol.qty_canceled) - sol.qty_picking) > (0)::numeric) THEN 1
            ELSE 0
        END) > 0);


--
-- Name: skr_so_dailly_sales_history; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_so_dailly_sales_history AS
 SELECT days_ago.days_ago,
    date_trunc('day'::text, ((('now'::text)::date - days_ago.days_ago))::timestamp with time zone) AS day,
    COALESCE(ttls.order_count, (0)::bigint) AS order_count,
    COALESCE(ttls.line_count, (0)::bigint) AS line_count,
    COALESCE(ttls.total, 0.0) AS line_total
   FROM (generate_series(0, 120, 1) days_ago(days_ago)
     LEFT JOIN ( SELECT count(DISTINCT sol.sales_order_id) AS order_count,
            count(*) AS line_count,
            sum((sol.price * sol.qty)) AS total,
            date_trunc('day'::text, so.created_at) AS so_date
           FROM (skr_so_lines sol
             JOIN skr_sales_orders so ON ((sol.sales_order_id = so.id)))
          GROUP BY (date_trunc('day'::text, so.created_at))) ttls ON ((ttls.so_date = date_trunc('day'::text, ((('now'::text)::date - days_ago.days_ago))::timestamp with time zone))))
  ORDER BY (date_trunc('day'::text, ((('now'::text)::date - days_ago.days_ago))::timestamp with time zone)) DESC;


--
-- Name: skr_so_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_so_details AS
 SELECT so.id AS sales_order_id,
    to_char((so.order_date)::timestamp with time zone, 'YYYY-MM-DD'::text) AS string_order_date,
    cust.code AS customer_code,
    cust.name AS customer_name,
    addr.name AS bill_addr_name,
    COALESCE(ttls.total, 0.0) AS order_total,
    COALESCE(ttls.num_lines, (0)::bigint) AS num_lines,
    COALESCE(ttls.other_charge_total, (0)::numeric) AS total_other_charge_amount,
    COALESCE(ttls.tax_charge_total, (0)::numeric) AS total_tax_amount,
    COALESCE(ttls.shipping_charge_total, (0)::numeric) AS total_shipping_amount,
    (COALESCE(ttls.total, 0.0) - COALESCE(ttls.other_charge_total, 0.0)) AS subtotal_amount
   FROM (((skr_sales_orders so
     LEFT JOIN skr_customers cust ON ((cust.id = so.customer_id)))
     LEFT JOIN skr_addresses addr ON ((addr.id = so.billing_address_id)))
     LEFT JOIN ( SELECT sol.sales_order_id,
            sum((sol.qty * sol.price)) AS total,
            sum(
                CASE
                    WHEN s.is_other_charge THEN (sol.qty * sol.price)
                    ELSE (0)::numeric
                END) AS other_charge_total,
            sum(
                CASE
                    WHEN ((sol.sku_code)::text = 'SHIP'::text) THEN (sol.qty * sol.price)
                    ELSE (0)::numeric
                END) AS shipping_charge_total,
            sum(
                CASE
                    WHEN ((sol.sku_code)::text = 'TAX'::text) THEN (sol.qty * sol.price)
                    ELSE (0)::numeric
                END) AS tax_charge_total,
            count(sol.*) AS num_lines
           FROM ((skr_so_lines sol
             JOIN skr_sku_locs sl ON ((sl.id = sol.sku_loc_id)))
             JOIN skr_skus s ON ((s.id = sl.sku_id)))
          GROUP BY sol.sales_order_id) ttls ON ((ttls.sales_order_id = so.id)));


--
-- Name: skr_so_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_so_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_so_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_so_lines_id_seq OWNED BY skr_so_lines.id;


--
-- Name: skr_time_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_time_entries (
    id integer NOT NULL,
    customer_project_id integer NOT NULL,
    lanes_user_id integer NOT NULL,
    is_invoiced boolean DEFAULT false NOT NULL,
    options jsonb DEFAULT '{}'::jsonb NOT NULL,
    start_at timestamp without time zone NOT NULL,
    end_at timestamp without time zone NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_time_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_time_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_time_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_time_entries_id_seq OWNED BY skr_time_entries.id;


--
-- Name: skr_uoms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_uoms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_uoms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_uoms_id_seq OWNED BY skr_uoms.id;


--
-- Name: skr_vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_vendors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_vendors_id_seq OWNED BY skr_vendors.id;


--
-- Name: skr_vo_lines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_vo_lines (
    id integer NOT NULL,
    voucher_id integer NOT NULL,
    sku_vendor_id integer NOT NULL,
    po_line_id integer,
    sku_code character varying NOT NULL,
    part_code character varying NOT NULL,
    description character varying NOT NULL,
    uom_code character varying NOT NULL,
    uom_size smallint NOT NULL,
    "position" smallint NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    price numeric(15,2) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_vo_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_vo_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_vo_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_vo_lines_id_seq OWNED BY skr_vo_lines.id;


--
-- Name: skr_vouchers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE skr_vouchers (
    id integer NOT NULL,
    visible_id character varying NOT NULL,
    state smallint DEFAULT 0 NOT NULL,
    vendor_id integer NOT NULL,
    purchase_order_id integer,
    terms_id integer NOT NULL,
    confirmation_date date,
    refno character varying,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_vouchers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_vouchers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_vouchers_id_seq OWNED BY skr_vouchers.id;


--
-- Name: system_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE system_settings (
    id integer NOT NULL,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: system_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE system_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE system_settings_id_seq OWNED BY system_settings.id;


--
-- Name: testers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE testers (
    id integer NOT NULL,
    name character varying,
    email character varying,
    visits text[] DEFAULT '{}'::text[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: testers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE testers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: testers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE testers_id_seq OWNED BY testers.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assets ALTER COLUMN id SET DEFAULT nextval('assets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lanes_users ALTER COLUMN id SET DEFAULT nextval('lanes_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_addresses ALTER COLUMN id SET DEFAULT nextval('skr_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_bank_accounts ALTER COLUMN id SET DEFAULT nextval('skr_bank_accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_customer_projects ALTER COLUMN id SET DEFAULT nextval('skr_customer_projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_customers ALTER COLUMN id SET DEFAULT nextval('skr_customers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_event_invoice_xrefs ALTER COLUMN id SET DEFAULT nextval('skr_event_invoice_xrefs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_events ALTER COLUMN id SET DEFAULT nextval('skr_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_expense_categories ALTER COLUMN id SET DEFAULT nextval('skr_expense_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_expense_entries ALTER COLUMN id SET DEFAULT nextval('skr_expense_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_expense_entry_categories ALTER COLUMN id SET DEFAULT nextval('skr_expense_entry_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_accounts ALTER COLUMN id SET DEFAULT nextval('skr_gl_accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_manual_entries ALTER COLUMN id SET DEFAULT nextval('skr_gl_manual_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_periods ALTER COLUMN id SET DEFAULT nextval('skr_gl_periods_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_postings ALTER COLUMN id SET DEFAULT nextval('skr_gl_postings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_transactions ALTER COLUMN id SET DEFAULT nextval('skr_gl_transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_ia_lines ALTER COLUMN id SET DEFAULT nextval('skr_ia_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_ia_reasons ALTER COLUMN id SET DEFAULT nextval('skr_ia_reasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inv_lines ALTER COLUMN id SET DEFAULT nextval('skr_inv_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inventory_adjustments ALTER COLUMN id SET DEFAULT nextval('skr_inventory_adjustments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices ALTER COLUMN id SET DEFAULT nextval('skr_invoices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_locations ALTER COLUMN id SET DEFAULT nextval('skr_locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_payment_categories ALTER COLUMN id SET DEFAULT nextval('skr_payment_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_payment_terms ALTER COLUMN id SET DEFAULT nextval('skr_payment_terms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_payments ALTER COLUMN id SET DEFAULT nextval('skr_payments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pick_tickets ALTER COLUMN id SET DEFAULT nextval('skr_pick_tickets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_lines ALTER COLUMN id SET DEFAULT nextval('skr_po_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_receipts ALTER COLUMN id SET DEFAULT nextval('skr_po_receipts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_por_lines ALTER COLUMN id SET DEFAULT nextval('skr_por_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pt_lines ALTER COLUMN id SET DEFAULT nextval('skr_pt_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_purchase_orders ALTER COLUMN id SET DEFAULT nextval('skr_purchase_orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sales_orders ALTER COLUMN id SET DEFAULT nextval('skr_sales_orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_locs ALTER COLUMN id SET DEFAULT nextval('skr_sku_locs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_trans ALTER COLUMN id SET DEFAULT nextval('skr_sku_trans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_vendors ALTER COLUMN id SET DEFAULT nextval('skr_sku_vendors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_skus ALTER COLUMN id SET DEFAULT nextval('skr_skus_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_so_lines ALTER COLUMN id SET DEFAULT nextval('skr_so_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_time_entries ALTER COLUMN id SET DEFAULT nextval('skr_time_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_uoms ALTER COLUMN id SET DEFAULT nextval('skr_uoms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vendors ALTER COLUMN id SET DEFAULT nextval('skr_vendors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vo_lines ALTER COLUMN id SET DEFAULT nextval('skr_vo_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vouchers ALTER COLUMN id SET DEFAULT nextval('skr_vouchers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY system_settings ALTER COLUMN id SET DEFAULT nextval('system_settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY testers ALTER COLUMN id SET DEFAULT nextval('testers_id_seq'::regclass);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- Name: lanes_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lanes_users
    ADD CONSTRAINT lanes_users_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: skr_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_addresses
    ADD CONSTRAINT skr_addresses_pkey PRIMARY KEY (id);


--
-- Name: skr_bank_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_bank_accounts
    ADD CONSTRAINT skr_bank_accounts_pkey PRIMARY KEY (id);


--
-- Name: skr_customer_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_customer_projects
    ADD CONSTRAINT skr_customer_projects_pkey PRIMARY KEY (id);


--
-- Name: skr_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_customers
    ADD CONSTRAINT skr_customers_pkey PRIMARY KEY (id);


--
-- Name: skr_event_invoice_xrefs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_event_invoice_xrefs
    ADD CONSTRAINT skr_event_invoice_xrefs_pkey PRIMARY KEY (id);


--
-- Name: skr_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_events
    ADD CONSTRAINT skr_events_pkey PRIMARY KEY (id);


--
-- Name: skr_expense_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_expense_categories
    ADD CONSTRAINT skr_expense_categories_pkey PRIMARY KEY (id);


--
-- Name: skr_expense_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_expense_entries
    ADD CONSTRAINT skr_expense_entries_pkey PRIMARY KEY (id);


--
-- Name: skr_expense_entry_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_expense_entry_categories
    ADD CONSTRAINT skr_expense_entry_categories_pkey PRIMARY KEY (id);


--
-- Name: skr_gl_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_accounts
    ADD CONSTRAINT skr_gl_accounts_pkey PRIMARY KEY (id);


--
-- Name: skr_gl_manual_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_manual_entries
    ADD CONSTRAINT skr_gl_manual_entries_pkey PRIMARY KEY (id);


--
-- Name: skr_gl_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_periods
    ADD CONSTRAINT skr_gl_periods_pkey PRIMARY KEY (id);


--
-- Name: skr_gl_postings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_postings
    ADD CONSTRAINT skr_gl_postings_pkey PRIMARY KEY (id);


--
-- Name: skr_gl_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_transactions
    ADD CONSTRAINT skr_gl_transactions_pkey PRIMARY KEY (id);


--
-- Name: skr_ia_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_ia_lines
    ADD CONSTRAINT skr_ia_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_ia_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_ia_reasons
    ADD CONSTRAINT skr_ia_reasons_pkey PRIMARY KEY (id);


--
-- Name: skr_inv_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inv_lines
    ADD CONSTRAINT skr_inv_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_inventory_adjustments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inventory_adjustments
    ADD CONSTRAINT skr_inventory_adjustments_pkey PRIMARY KEY (id);


--
-- Name: skr_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_pkey PRIMARY KEY (id);


--
-- Name: skr_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_locations
    ADD CONSTRAINT skr_locations_pkey PRIMARY KEY (id);


--
-- Name: skr_payment_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_payment_categories
    ADD CONSTRAINT skr_payment_categories_pkey PRIMARY KEY (id);


--
-- Name: skr_payment_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_payment_terms
    ADD CONSTRAINT skr_payment_terms_pkey PRIMARY KEY (id);


--
-- Name: skr_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_payments
    ADD CONSTRAINT skr_payments_pkey PRIMARY KEY (id);


--
-- Name: skr_pick_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pick_tickets
    ADD CONSTRAINT skr_pick_tickets_pkey PRIMARY KEY (id);


--
-- Name: skr_po_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_lines
    ADD CONSTRAINT skr_po_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_po_receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_receipts
    ADD CONSTRAINT skr_po_receipts_pkey PRIMARY KEY (id);


--
-- Name: skr_por_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_por_lines
    ADD CONSTRAINT skr_por_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_pt_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pt_lines
    ADD CONSTRAINT skr_pt_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_purchase_orders
    ADD CONSTRAINT skr_purchase_orders_pkey PRIMARY KEY (id);


--
-- Name: skr_sales_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sales_orders
    ADD CONSTRAINT skr_sales_orders_pkey PRIMARY KEY (id);


--
-- Name: skr_sequential_ids_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sequential_ids
    ADD CONSTRAINT skr_sequential_ids_pkey PRIMARY KEY (name);


--
-- Name: skr_sku_locs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_locs
    ADD CONSTRAINT skr_sku_locs_pkey PRIMARY KEY (id);


--
-- Name: skr_sku_trans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_trans
    ADD CONSTRAINT skr_sku_trans_pkey PRIMARY KEY (id);


--
-- Name: skr_sku_vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_vendors
    ADD CONSTRAINT skr_sku_vendors_pkey PRIMARY KEY (id);


--
-- Name: skr_skus_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_skus
    ADD CONSTRAINT skr_skus_pkey PRIMARY KEY (id);


--
-- Name: skr_so_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_so_lines
    ADD CONSTRAINT skr_so_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_time_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_time_entries
    ADD CONSTRAINT skr_time_entries_pkey PRIMARY KEY (id);


--
-- Name: skr_uoms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_uoms
    ADD CONSTRAINT skr_uoms_pkey PRIMARY KEY (id);


--
-- Name: skr_vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vendors
    ADD CONSTRAINT skr_vendors_pkey PRIMARY KEY (id);


--
-- Name: skr_vo_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vo_lines
    ADD CONSTRAINT skr_vo_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_vouchers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vouchers
    ADD CONSTRAINT skr_vouchers_pkey PRIMARY KEY (id);


--
-- Name: system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- Name: testers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY testers
    ADD CONSTRAINT testers_pkey PRIMARY KEY (id);


--
-- Name: index_assets_on_owner_id_and_owner_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_owner_id_and_owner_type ON assets USING btree (owner_id, owner_type);


--
-- Name: index_lanes_users_on_role_names; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lanes_users_on_role_names ON lanes_users USING gin (role_names);


--
-- Name: index_skr_customer_projects_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_customer_projects_on_code ON skr_customer_projects USING btree (code);


--
-- Name: index_skr_customers_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_customers_on_code ON skr_customers USING btree (code);


--
-- Name: index_skr_event_invoice_xrefs_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_event_invoice_xrefs_on_event_id ON skr_event_invoice_xrefs USING btree (event_id);


--
-- Name: index_skr_event_invoice_xrefs_on_event_id_and_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_skr_event_invoice_xrefs_on_event_id_and_invoice_id ON skr_event_invoice_xrefs USING btree (event_id, invoice_id);


--
-- Name: index_skr_expense_categories_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_expense_categories_on_code ON skr_expense_categories USING btree (code);


--
-- Name: index_skr_expense_entries_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_skr_expense_entries_on_uuid ON skr_expense_entries USING btree (uuid);


--
-- Name: index_skr_expense_entry_categories_on_entry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_expense_entry_categories_on_entry_id ON skr_expense_entry_categories USING btree (entry_id);


--
-- Name: index_skr_gl_manual_entries_on_visible_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_gl_manual_entries_on_visible_id ON skr_gl_manual_entries USING btree (visible_id);


--
-- Name: index_skr_gl_postings_on_period_and_year_and_account_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_gl_postings_on_period_and_year_and_account_number ON skr_gl_postings USING btree (period, year, account_number);


--
-- Name: index_skr_gl_transactions_on_source_type_and_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_gl_transactions_on_source_type_and_source_id ON skr_gl_transactions USING btree (source_type, source_id);


--
-- Name: index_skr_inv_lines_on_sku_loc_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_inv_lines_on_sku_loc_id ON skr_inv_lines USING btree (sku_loc_id);


--
-- Name: index_skr_inventory_adjustments_on_visible_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_inventory_adjustments_on_visible_id ON skr_inventory_adjustments USING btree (visible_id);


--
-- Name: index_skr_invoices_on_visible_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_invoices_on_visible_id ON skr_invoices USING btree (visible_id);


--
-- Name: index_skr_locations_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_locations_on_code ON skr_locations USING btree (code);


--
-- Name: index_skr_payment_terms_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_payment_terms_on_code ON skr_payment_terms USING btree (code);


--
-- Name: index_skr_payments_on_visible_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_payments_on_visible_id ON skr_payments USING btree (visible_id);


--
-- Name: index_skr_pick_tickets_on_visible_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_pick_tickets_on_visible_id ON skr_pick_tickets USING btree (visible_id);


--
-- Name: index_skr_po_receipts_on_visible_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_po_receipts_on_visible_id ON skr_po_receipts USING btree (visible_id);


--
-- Name: index_skr_purchase_orders_on_visible_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_purchase_orders_on_visible_id ON skr_purchase_orders USING btree (visible_id);


--
-- Name: index_skr_sales_orders_on_visible_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_sales_orders_on_visible_id ON skr_sales_orders USING btree (visible_id);


--
-- Name: index_skr_sku_locs_on_sku_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_sku_locs_on_sku_id ON skr_sku_locs USING btree (sku_id);


--
-- Name: index_skr_sku_trans_on_origin_type_and_origin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_sku_trans_on_origin_type_and_origin_id ON skr_sku_trans USING btree (origin_type, origin_id);


--
-- Name: index_skr_so_lines_on_sku_loc_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_so_lines_on_sku_loc_id ON skr_so_lines USING btree (sku_loc_id);


--
-- Name: index_skr_time_entries_on_lanes_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_time_entries_on_lanes_user_id ON skr_time_entries USING btree (lanes_user_id);


--
-- Name: index_skr_vouchers_on_visible_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_skr_vouchers_on_visible_id ON skr_vouchers USING btree (visible_id);


--
-- Name: _RETURN; Type: RULE; Schema: public; Owner: -
--

CREATE RULE "_RETURN" AS
    ON SELECT TO skr_gl_account_balances DO INSTEAD  SELECT gla.id AS gl_account_id,
    "right"((glp.account_number)::text, 2) AS branch_number,
    COALESCE(sum(glp.amount), 0.00) AS balance
   FROM (skr_gl_accounts gla
     LEFT JOIN skr_gl_postings glp ON (("left"((glp.account_number)::text, 4) = (gla.number)::text)))
  GROUP BY gla.id, ("right"((glp.account_number)::text, 2))
  ORDER BY gla.number;


--
-- Name: fk_rails_a04e857496; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_time_entries
    ADD CONSTRAINT fk_rails_a04e857496 FOREIGN KEY (lanes_user_id) REFERENCES lanes_users(id);


--
-- Name: skr_bank_accounts_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_bank_accounts
    ADD CONSTRAINT skr_bank_accounts_address_id_fk FOREIGN KEY (address_id) REFERENCES skr_addresses(id);


--
-- Name: skr_bank_accounts_gl_account_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_bank_accounts
    ADD CONSTRAINT skr_bank_accounts_gl_account_id_fk FOREIGN KEY (gl_account_id) REFERENCES skr_gl_accounts(id);


--
-- Name: skr_customer_projects_customer_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_customer_projects
    ADD CONSTRAINT skr_customer_projects_customer_id_fk FOREIGN KEY (customer_id) REFERENCES skr_customers(id);


--
-- Name: skr_customer_projects_sku_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_customer_projects
    ADD CONSTRAINT skr_customer_projects_sku_id_fk FOREIGN KEY (sku_id) REFERENCES skr_skus(id);


--
-- Name: skr_customers_gl_receivables_account_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_customers
    ADD CONSTRAINT skr_customers_gl_receivables_account_id_fk FOREIGN KEY (gl_receivables_account_id) REFERENCES skr_gl_accounts(id);


--
-- Name: skr_customers_shipping_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_customers
    ADD CONSTRAINT skr_customers_shipping_address_id_fk FOREIGN KEY (shipping_address_id) REFERENCES skr_addresses(id);


--
-- Name: skr_customers_terms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_customers
    ADD CONSTRAINT skr_customers_terms_id_fk FOREIGN KEY (terms_id) REFERENCES skr_payment_terms(id);


--
-- Name: skr_event_invoice_xrefs_event_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_event_invoice_xrefs
    ADD CONSTRAINT skr_event_invoice_xrefs_event_id_fk FOREIGN KEY (event_id) REFERENCES skr_events(id);


--
-- Name: skr_event_invoice_xrefs_invoice_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_event_invoice_xrefs
    ADD CONSTRAINT skr_event_invoice_xrefs_invoice_id_fk FOREIGN KEY (invoice_id) REFERENCES skr_invoices(id);


--
-- Name: skr_events_sku_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_events
    ADD CONSTRAINT skr_events_sku_id_fk FOREIGN KEY (sku_id) REFERENCES skr_skus(id);


--
-- Name: skr_expense_categories_gl_account_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_expense_categories
    ADD CONSTRAINT skr_expense_categories_gl_account_id_fk FOREIGN KEY (gl_account_id) REFERENCES skr_gl_accounts(id);


--
-- Name: skr_expense_entry_categories_category_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_expense_entry_categories
    ADD CONSTRAINT skr_expense_entry_categories_category_id_fk FOREIGN KEY (category_id) REFERENCES skr_expense_categories(id);


--
-- Name: skr_expense_entry_categories_entry_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_expense_entry_categories
    ADD CONSTRAINT skr_expense_entry_categories_entry_id_fk FOREIGN KEY (entry_id) REFERENCES skr_expense_entries(id);


--
-- Name: skr_gl_postings_gl_transaction_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_postings
    ADD CONSTRAINT skr_gl_postings_gl_transaction_id_fk FOREIGN KEY (gl_transaction_id) REFERENCES skr_gl_transactions(id);


--
-- Name: skr_gl_transactions_period_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_transactions
    ADD CONSTRAINT skr_gl_transactions_period_id_fk FOREIGN KEY (period_id) REFERENCES skr_gl_periods(id);


--
-- Name: skr_ia_lines_inventory_adjustment_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_ia_lines
    ADD CONSTRAINT skr_ia_lines_inventory_adjustment_id_fk FOREIGN KEY (inventory_adjustment_id) REFERENCES skr_inventory_adjustments(id);


--
-- Name: skr_ia_lines_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_ia_lines
    ADD CONSTRAINT skr_ia_lines_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_ia_reasons_gl_account_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_ia_reasons
    ADD CONSTRAINT skr_ia_reasons_gl_account_id_fk FOREIGN KEY (gl_account_id) REFERENCES skr_gl_accounts(id);


--
-- Name: skr_inv_lines_invoice_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inv_lines
    ADD CONSTRAINT skr_inv_lines_invoice_id_fk FOREIGN KEY (invoice_id) REFERENCES skr_invoices(id);


--
-- Name: skr_inv_lines_pt_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inv_lines
    ADD CONSTRAINT skr_inv_lines_pt_line_id_fk FOREIGN KEY (pt_line_id) REFERENCES skr_pt_lines(id);


--
-- Name: skr_inv_lines_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inv_lines
    ADD CONSTRAINT skr_inv_lines_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_inv_lines_so_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inv_lines
    ADD CONSTRAINT skr_inv_lines_so_line_id_fk FOREIGN KEY (so_line_id) REFERENCES skr_so_lines(id);


--
-- Name: skr_inv_lines_time_entry_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inv_lines
    ADD CONSTRAINT skr_inv_lines_time_entry_id_fk FOREIGN KEY (time_entry_id) REFERENCES skr_time_entries(id);


--
-- Name: skr_inventory_adjustments_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inventory_adjustments
    ADD CONSTRAINT skr_inventory_adjustments_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_inventory_adjustments_reason_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inventory_adjustments
    ADD CONSTRAINT skr_inventory_adjustments_reason_id_fk FOREIGN KEY (reason_id) REFERENCES skr_ia_reasons(id);


--
-- Name: skr_invoices_billing_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_billing_address_id_fk FOREIGN KEY (billing_address_id) REFERENCES skr_addresses(id);


--
-- Name: skr_invoices_customer_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_customer_id_fk FOREIGN KEY (customer_id) REFERENCES skr_customers(id);


--
-- Name: skr_invoices_customer_project_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_customer_project_id_fk FOREIGN KEY (customer_project_id) REFERENCES skr_customer_projects(id);


--
-- Name: skr_invoices_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_invoices_pick_ticket_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_pick_ticket_id_fk FOREIGN KEY (pick_ticket_id) REFERENCES skr_pick_tickets(id);


--
-- Name: skr_invoices_sales_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_sales_order_id_fk FOREIGN KEY (sales_order_id) REFERENCES skr_sales_orders(id);


--
-- Name: skr_invoices_terms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_terms_id_fk FOREIGN KEY (terms_id) REFERENCES skr_payment_terms(id);


--
-- Name: skr_locations_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_locations
    ADD CONSTRAINT skr_locations_address_id_fk FOREIGN KEY (address_id) REFERENCES skr_addresses(id);


--
-- Name: skr_payment_categories_gl_account_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_payment_categories
    ADD CONSTRAINT skr_payment_categories_gl_account_id_fk FOREIGN KEY (gl_account_id) REFERENCES skr_gl_accounts(id);


--
-- Name: skr_payments_bank_account_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_payments
    ADD CONSTRAINT skr_payments_bank_account_id_fk FOREIGN KEY (bank_account_id) REFERENCES skr_bank_accounts(id);


--
-- Name: skr_payments_category_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_payments
    ADD CONSTRAINT skr_payments_category_id_fk FOREIGN KEY (category_id) REFERENCES skr_payment_categories(id);


--
-- Name: skr_payments_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_payments
    ADD CONSTRAINT skr_payments_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_payments_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_payments
    ADD CONSTRAINT skr_payments_vendor_id_fk FOREIGN KEY (vendor_id) REFERENCES skr_vendors(id);


--
-- Name: skr_pick_tickets_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pick_tickets
    ADD CONSTRAINT skr_pick_tickets_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_pick_tickets_sales_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pick_tickets
    ADD CONSTRAINT skr_pick_tickets_sales_order_id_fk FOREIGN KEY (sales_order_id) REFERENCES skr_sales_orders(id);


--
-- Name: skr_po_lines_purchase_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_lines
    ADD CONSTRAINT skr_po_lines_purchase_order_id_fk FOREIGN KEY (purchase_order_id) REFERENCES skr_purchase_orders(id);


--
-- Name: skr_po_lines_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_lines
    ADD CONSTRAINT skr_po_lines_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_po_lines_sku_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_lines
    ADD CONSTRAINT skr_po_lines_sku_vendor_id_fk FOREIGN KEY (sku_vendor_id) REFERENCES skr_sku_vendors(id);


--
-- Name: skr_po_receipts_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_receipts
    ADD CONSTRAINT skr_po_receipts_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_po_receipts_purchase_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_receipts
    ADD CONSTRAINT skr_po_receipts_purchase_order_id_fk FOREIGN KEY (purchase_order_id) REFERENCES skr_purchase_orders(id);


--
-- Name: skr_po_receipts_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_receipts
    ADD CONSTRAINT skr_po_receipts_vendor_id_fk FOREIGN KEY (vendor_id) REFERENCES skr_vendors(id);


--
-- Name: skr_po_receipts_voucher_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_receipts
    ADD CONSTRAINT skr_po_receipts_voucher_id_fk FOREIGN KEY (voucher_id) REFERENCES skr_vouchers(id);


--
-- Name: skr_por_lines_po_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_por_lines
    ADD CONSTRAINT skr_por_lines_po_line_id_fk FOREIGN KEY (po_line_id) REFERENCES skr_po_lines(id);


--
-- Name: skr_por_lines_po_receipt_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_por_lines
    ADD CONSTRAINT skr_por_lines_po_receipt_id_fk FOREIGN KEY (po_receipt_id) REFERENCES skr_po_receipts(id);


--
-- Name: skr_por_lines_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_por_lines
    ADD CONSTRAINT skr_por_lines_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_por_lines_sku_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_por_lines
    ADD CONSTRAINT skr_por_lines_sku_vendor_id_fk FOREIGN KEY (sku_vendor_id) REFERENCES skr_sku_vendors(id);


--
-- Name: skr_pt_lines_pick_ticket_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pt_lines
    ADD CONSTRAINT skr_pt_lines_pick_ticket_id_fk FOREIGN KEY (pick_ticket_id) REFERENCES skr_pick_tickets(id);


--
-- Name: skr_pt_lines_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pt_lines
    ADD CONSTRAINT skr_pt_lines_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_pt_lines_so_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pt_lines
    ADD CONSTRAINT skr_pt_lines_so_line_id_fk FOREIGN KEY (so_line_id) REFERENCES skr_so_lines(id);


--
-- Name: skr_purchase_orders_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_purchase_orders
    ADD CONSTRAINT skr_purchase_orders_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_purchase_orders_ship_addr_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_purchase_orders
    ADD CONSTRAINT skr_purchase_orders_ship_addr_id_fk FOREIGN KEY (ship_addr_id) REFERENCES skr_addresses(id);


--
-- Name: skr_purchase_orders_terms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_purchase_orders
    ADD CONSTRAINT skr_purchase_orders_terms_id_fk FOREIGN KEY (terms_id) REFERENCES skr_payment_terms(id);


--
-- Name: skr_purchase_orders_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_purchase_orders
    ADD CONSTRAINT skr_purchase_orders_vendor_id_fk FOREIGN KEY (vendor_id) REFERENCES skr_vendors(id);


--
-- Name: skr_sales_orders_billing_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sales_orders
    ADD CONSTRAINT skr_sales_orders_billing_address_id_fk FOREIGN KEY (billing_address_id) REFERENCES skr_addresses(id);


--
-- Name: skr_sales_orders_customer_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sales_orders
    ADD CONSTRAINT skr_sales_orders_customer_id_fk FOREIGN KEY (customer_id) REFERENCES skr_customers(id);


--
-- Name: skr_sales_orders_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sales_orders
    ADD CONSTRAINT skr_sales_orders_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_sales_orders_terms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sales_orders
    ADD CONSTRAINT skr_sales_orders_terms_id_fk FOREIGN KEY (terms_id) REFERENCES skr_payment_terms(id);


--
-- Name: skr_sku_locs_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_locs
    ADD CONSTRAINT skr_sku_locs_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_sku_locs_sku_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_locs
    ADD CONSTRAINT skr_sku_locs_sku_id_fk FOREIGN KEY (sku_id) REFERENCES skr_skus(id);


--
-- Name: skr_sku_trans_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_trans
    ADD CONSTRAINT skr_sku_trans_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_sku_vendors_sku_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_vendors
    ADD CONSTRAINT skr_sku_vendors_sku_id_fk FOREIGN KEY (sku_id) REFERENCES skr_skus(id);


--
-- Name: skr_sku_vendors_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_vendors
    ADD CONSTRAINT skr_sku_vendors_vendor_id_fk FOREIGN KEY (vendor_id) REFERENCES skr_vendors(id);


--
-- Name: skr_skus_default_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_skus
    ADD CONSTRAINT skr_skus_default_vendor_id_fk FOREIGN KEY (default_vendor_id) REFERENCES skr_vendors(id);


--
-- Name: skr_skus_gl_asset_account_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_skus
    ADD CONSTRAINT skr_skus_gl_asset_account_id_fk FOREIGN KEY (gl_asset_account_id) REFERENCES skr_gl_accounts(id);


--
-- Name: skr_so_lines_sales_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_so_lines
    ADD CONSTRAINT skr_so_lines_sales_order_id_fk FOREIGN KEY (sales_order_id) REFERENCES skr_sales_orders(id);


--
-- Name: skr_so_lines_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_so_lines
    ADD CONSTRAINT skr_so_lines_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_time_entries_customer_project_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_time_entries
    ADD CONSTRAINT skr_time_entries_customer_project_id_fk FOREIGN KEY (customer_project_id) REFERENCES skr_customer_projects(id);


--
-- Name: skr_uoms_sku_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_uoms
    ADD CONSTRAINT skr_uoms_sku_id_fk FOREIGN KEY (sku_id) REFERENCES skr_skus(id);


--
-- Name: skr_vendors_gl_freight_account_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vendors
    ADD CONSTRAINT skr_vendors_gl_freight_account_id_fk FOREIGN KEY (gl_freight_account_id) REFERENCES skr_gl_accounts(id);


--
-- Name: skr_vendors_shipping_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vendors
    ADD CONSTRAINT skr_vendors_shipping_address_id_fk FOREIGN KEY (shipping_address_id) REFERENCES skr_addresses(id);


--
-- Name: skr_vendors_terms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vendors
    ADD CONSTRAINT skr_vendors_terms_id_fk FOREIGN KEY (terms_id) REFERENCES skr_payment_terms(id);


--
-- Name: skr_vo_lines_po_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vo_lines
    ADD CONSTRAINT skr_vo_lines_po_line_id_fk FOREIGN KEY (po_line_id) REFERENCES skr_po_lines(id);


--
-- Name: skr_vo_lines_sku_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vo_lines
    ADD CONSTRAINT skr_vo_lines_sku_vendor_id_fk FOREIGN KEY (sku_vendor_id) REFERENCES skr_sku_vendors(id);


--
-- Name: skr_vo_lines_voucher_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vo_lines
    ADD CONSTRAINT skr_vo_lines_voucher_id_fk FOREIGN KEY (voucher_id) REFERENCES skr_vouchers(id);


--
-- Name: skr_vouchers_purchase_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vouchers
    ADD CONSTRAINT skr_vouchers_purchase_order_id_fk FOREIGN KEY (purchase_order_id) REFERENCES skr_purchase_orders(id);


--
-- Name: skr_vouchers_terms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vouchers
    ADD CONSTRAINT skr_vouchers_terms_id_fk FOREIGN KEY (terms_id) REFERENCES skr_payment_terms(id);


--
-- Name: skr_vouchers_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vouchers
    ADD CONSTRAINT skr_vouchers_vendor_id_fk FOREIGN KEY (vendor_id) REFERENCES skr_vendors(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES
('1'),
('2'),
('20120110142845'),
('20140202185309'),
('20140202193316'),
('20140202193318'),
('20140202193319'),
('20140202193700'),
('20140202194700'),
('20140213040608'),
('20140220031700'),
('20140220031800'),
('20140220190836'),
('20140220203029'),
('20140224034759'),
('20140225032853'),
('20140320030501'),
('20140321031604'),
('20140322012143'),
('20140322014401'),
('20140322023453'),
('20140322035024'),
('20140322223912'),
('20140322223920'),
('20140323001446'),
('20140327202102'),
('20140327202107'),
('20140327202207'),
('20140327202209'),
('20140327214000'),
('20140327223002'),
('20140327224000'),
('20140327224002'),
('20140330232808'),
('20140330232810'),
('20140400164729'),
('20140400164733'),
('20140401164729'),
('20140401164740'),
('20140422024010'),
('20140615031600'),
('20150220015108'),
('20151121211323'),
('20160216142845'),
('20160229002044'),
('20160229041711'),
('20160307022705'),
('20160517032350'),
('20160531014306'),
('20160604195848'),
('20160605024432'),
('20160608023553'),
('20160620010455'),
('20160726004411'),
('20160805002717'),
('20161219174024');


