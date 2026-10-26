--
-- PostgreSQL database dump
--

\restrict xph2vSfMcZp12IkB0ju5SuL63DKWFoBXJGawg5GT3lSCdCDgWbRVjmZSQllFoqV

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.tique DROP CONSTRAINT fk_tique_usuario;
ALTER TABLE ONLY public.tique DROP CONSTRAINT fk_tique_tarifa;
ALTER TABLE ONLY public.tique DROP CONSTRAINT fk_tique_pago;
ALTER TABLE ONLY public.tarifa DROP CONSTRAINT fk_tarifa_funcion;
ALTER TABLE ONLY public.tarifa DROP CONSTRAINT fk_tarifa_asiento;
ALTER TABLE ONLY public.pago DROP CONSTRAINT fk_pago_usuario;
ALTER TABLE ONLY public.funcion DROP CONSTRAINT fk_funcion_recinto;
ALTER TABLE ONLY public.funcion DROP CONSTRAINT fk_funcion_evento;
ALTER TABLE ONLY public.evento DROP CONSTRAINT fk_evento_categoria;
ALTER TABLE ONLY public.asiento DROP CONSTRAINT fk_asiento_recinto;
ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_usuario_key;
ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_correo_key;
ALTER TABLE ONLY public.tarifa DROP CONSTRAINT uq_tarifa_funcion_asiento;
ALTER TABLE ONLY public.asiento DROP CONSTRAINT uq_asiento_recinto;
ALTER TABLE ONLY public.tique DROP CONSTRAINT tique_pkey;
ALTER TABLE ONLY public.tique DROP CONSTRAINT tique_codigo_key;
ALTER TABLE ONLY public.tarifa DROP CONSTRAINT tarifa_pkey;
ALTER TABLE ONLY public.recinto DROP CONSTRAINT recinto_pkey;
ALTER TABLE ONLY public.pago DROP CONSTRAINT pago_pkey;
ALTER TABLE ONLY public.funcion DROP CONSTRAINT funcion_pkey;
ALTER TABLE ONLY public.evento DROP CONSTRAINT evento_pkey;
ALTER TABLE ONLY public.categoria DROP CONSTRAINT categoria_pkey;
ALTER TABLE ONLY public.asiento DROP CONSTRAINT asiento_pkey;
DROP TABLE public.usuario;
DROP TABLE public.tique;
DROP TABLE public.tarifa;
DROP TABLE public.recinto;
DROP TABLE public.pago;
DROP TABLE public.funcion;
DROP TABLE public.evento;
DROP TABLE public.categoria;
DROP TABLE public.asiento;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: asiento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asiento (
    idasiento bigint NOT NULL,
    fila character varying(10) NOT NULL,
    numero character varying(10) NOT NULL,
    zona character varying(50),
    idrecinto bigint NOT NULL
);


ALTER TABLE public.asiento OWNER TO postgres;

--
-- Name: asiento_idasiento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.asiento ALTER COLUMN idasiento ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.asiento_idasiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: categoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria (
    idcategoria bigint NOT NULL,
    categoria character varying(100) NOT NULL
);


ALTER TABLE public.categoria OWNER TO postgres;

--
-- Name: categoria_idcategoria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.categoria ALTER COLUMN idcategoria ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.categoria_idcategoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: evento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evento (
    idevento bigint NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion character varying(500),
    idcategoria bigint NOT NULL
);


ALTER TABLE public.evento OWNER TO postgres;

--
-- Name: evento_idevento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.evento ALTER COLUMN idevento ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.evento_idevento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: funcion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.funcion (
    idfuncion bigint NOT NULL,
    fecha date NOT NULL,
    hora time without time zone NOT NULL,
    idevento bigint NOT NULL,
    idrecinto bigint NOT NULL,
    estado character varying(30) DEFAULT 'programada'::character varying
);


ALTER TABLE public.funcion OWNER TO postgres;

--
-- Name: funcion_idfuncion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.funcion ALTER COLUMN idfuncion ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.funcion_idfuncion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pago (
    idpago bigint NOT NULL,
    fecha date DEFAULT CURRENT_DATE,
    hora time without time zone DEFAULT CURRENT_TIME,
    montototal numeric(10,2) NOT NULL,
    metodopago character varying(50) NOT NULL,
    estado character varying(30) DEFAULT 'pendiente'::character varying,
    idusuario bigint NOT NULL,
    CONSTRAINT pago_montototal_check CHECK ((montototal >= (0)::numeric))
);


ALTER TABLE public.pago OWNER TO postgres;

--
-- Name: pago_idpago_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pago ALTER COLUMN idpago ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pago_idpago_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: recinto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recinto (
    idrecinto bigint NOT NULL,
    nombre character varying(150) NOT NULL,
    direccion character varying(255),
    ciudad character varying(100),
    capacidadtotal integer
);


ALTER TABLE public.recinto OWNER TO postgres;

--
-- Name: recinto_idrecinto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.recinto ALTER COLUMN idrecinto ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.recinto_idrecinto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tarifa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tarifa (
    idtarifa bigint NOT NULL,
    precio numeric(10,2) NOT NULL,
    estado character varying(30) DEFAULT 'activa'::character varying,
    idfuncion bigint NOT NULL,
    idasiento bigint NOT NULL,
    CONSTRAINT tarifa_precio_check CHECK ((precio >= (0)::numeric))
);


ALTER TABLE public.tarifa OWNER TO postgres;

--
-- Name: tarifa_idtarifa_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tarifa ALTER COLUMN idtarifa ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tarifa_idtarifa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tique; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tique (
    idtique bigint NOT NULL,
    codigo character varying(100) NOT NULL,
    preciopagado numeric(10,2) NOT NULL,
    fechaemision timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado character varying(30) DEFAULT 'emitido'::character varying,
    idprecio bigint NOT NULL,
    idpago bigint NOT NULL,
    idusuario bigint NOT NULL,
    CONSTRAINT tique_preciopagado_check CHECK ((preciopagado >= (0)::numeric))
);


ALTER TABLE public.tique OWNER TO postgres;

--
-- Name: tique_idtique_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tique ALTER COLUMN idtique ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tique_idtique_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    idusuario bigint NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    correo character varying(150) NOT NULL,
    telefono character varying(20),
    usuario character varying(50) NOT NULL,
    clave character varying(255) NOT NULL,
    fecharegistro date DEFAULT CURRENT_DATE,
    estado character varying(30) DEFAULT 'activo'::character varying
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- Name: usuario_idusuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.usuario ALTER COLUMN idusuario ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.usuario_idusuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: asiento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asiento (idasiento, fila, numero, zona, idrecinto) FROM stdin;
\.


--
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria (idcategoria, categoria) FROM stdin;
\.


--
-- Data for Name: evento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evento (idevento, nombre, descripcion, idcategoria) FROM stdin;
\.


--
-- Data for Name: funcion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.funcion (idfuncion, fecha, hora, idevento, idrecinto, estado) FROM stdin;
\.


--
-- Data for Name: pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pago (idpago, fecha, hora, montototal, metodopago, estado, idusuario) FROM stdin;
\.


--
-- Data for Name: recinto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recinto (idrecinto, nombre, direccion, ciudad, capacidadtotal) FROM stdin;
\.


--
-- Data for Name: tarifa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tarifa (idtarifa, precio, estado, idfuncion, idasiento) FROM stdin;
\.


--
-- Data for Name: tique; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tique (idtique, codigo, preciopagado, fechaemision, estado, idprecio, idpago, idusuario) FROM stdin;
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (idusuario, nombre, apellido, correo, telefono, usuario, clave, fecharegistro, estado) FROM stdin;
\.


--
-- Name: asiento_idasiento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asiento_idasiento_seq', 1, false);


--
-- Name: categoria_idcategoria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_idcategoria_seq', 1, false);


--
-- Name: evento_idevento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.evento_idevento_seq', 1, false);


--
-- Name: funcion_idfuncion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.funcion_idfuncion_seq', 1, false);


--
-- Name: pago_idpago_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pago_idpago_seq', 1, false);


--
-- Name: recinto_idrecinto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recinto_idrecinto_seq', 1, false);


--
-- Name: tarifa_idtarifa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tarifa_idtarifa_seq', 1, false);


--
-- Name: tique_idtique_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tique_idtique_seq', 1, false);


--
-- Name: usuario_idusuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_idusuario_seq', 1, false);


--
-- Name: asiento asiento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asiento
    ADD CONSTRAINT asiento_pkey PRIMARY KEY (idasiento);


--
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (idcategoria);


--
-- Name: evento evento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evento
    ADD CONSTRAINT evento_pkey PRIMARY KEY (idevento);


--
-- Name: funcion funcion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcion
    ADD CONSTRAINT funcion_pkey PRIMARY KEY (idfuncion);


--
-- Name: pago pago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_pkey PRIMARY KEY (idpago);


--
-- Name: recinto recinto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recinto
    ADD CONSTRAINT recinto_pkey PRIMARY KEY (idrecinto);


--
-- Name: tarifa tarifa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarifa
    ADD CONSTRAINT tarifa_pkey PRIMARY KEY (idtarifa);


--
-- Name: tique tique_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tique
    ADD CONSTRAINT tique_codigo_key UNIQUE (codigo);


--
-- Name: tique tique_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tique
    ADD CONSTRAINT tique_pkey PRIMARY KEY (idtique);


--
-- Name: asiento uq_asiento_recinto; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asiento
    ADD CONSTRAINT uq_asiento_recinto UNIQUE (idrecinto, fila, numero);


--
-- Name: tarifa uq_tarifa_funcion_asiento; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarifa
    ADD CONSTRAINT uq_tarifa_funcion_asiento UNIQUE (idfuncion, idasiento);


--
-- Name: usuario usuario_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_correo_key UNIQUE (correo);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (idusuario);


--
-- Name: usuario usuario_usuario_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_usuario_key UNIQUE (usuario);


--
-- Name: asiento fk_asiento_recinto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asiento
    ADD CONSTRAINT fk_asiento_recinto FOREIGN KEY (idrecinto) REFERENCES public.recinto(idrecinto);


--
-- Name: evento fk_evento_categoria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evento
    ADD CONSTRAINT fk_evento_categoria FOREIGN KEY (idcategoria) REFERENCES public.categoria(idcategoria) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: funcion fk_funcion_evento; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcion
    ADD CONSTRAINT fk_funcion_evento FOREIGN KEY (idevento) REFERENCES public.evento(idevento);


--
-- Name: funcion fk_funcion_recinto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcion
    ADD CONSTRAINT fk_funcion_recinto FOREIGN KEY (idrecinto) REFERENCES public.recinto(idrecinto);


--
-- Name: pago fk_pago_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT fk_pago_usuario FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: tarifa fk_tarifa_asiento; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarifa
    ADD CONSTRAINT fk_tarifa_asiento FOREIGN KEY (idasiento) REFERENCES public.asiento(idasiento);


--
-- Name: tarifa fk_tarifa_funcion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarifa
    ADD CONSTRAINT fk_tarifa_funcion FOREIGN KEY (idfuncion) REFERENCES public.funcion(idfuncion);


--
-- Name: tique fk_tique_pago; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tique
    ADD CONSTRAINT fk_tique_pago FOREIGN KEY (idpago) REFERENCES public.pago(idpago);


--
-- Name: tique fk_tique_tarifa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tique
    ADD CONSTRAINT fk_tique_tarifa FOREIGN KEY (idprecio) REFERENCES public.tarifa(idtarifa);


--
-- Name: tique fk_tique_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tique
    ADD CONSTRAINT fk_tique_usuario FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario);


--
-- PostgreSQL database dump complete
--

\unrestrict xph2vSfMcZp12IkB0ju5SuL63DKWFoBXJGawg5GT3lSCdCDgWbRVjmZSQllFoqV

