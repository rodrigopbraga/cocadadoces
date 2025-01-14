PGDMP     9                    y            dbcocadadoces    9.6.22    9.6.22 @    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    16394    dbcocadadoces    DATABASE     �   CREATE DATABASE dbcocadadoces WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
    DROP DATABASE dbcocadadoces;
             cocada    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    3                        3079    12387    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            �           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �            1255    24904    get_user_data()    FUNCTION     ?  CREATE FUNCTION public.get_user_data() RETURNS TABLE(id_usuario integer, usuario character varying, func character varying)
    LANGUAGE plpgsql
    AS $$
begin
	create or replace view user_data as
	SELECT id_usuario, usuario, func FROM usuarios;
	return query select * from user_data order by id_usuario asc;
end;
$$;
 &   DROP FUNCTION public.get_user_data();
       public       cocada    false    1    3            �            1255    24823    getdoceped(integer)    FUNCTION     Z  CREATE FUNCTION public.getdoceped(id_ped integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
declare
	id_doc integer;
	nome_doc varchar;
begin
   select id_doce
   into id_doc
   from pedidos
   where id_pedido=id_ped;
   
   select nome_doce
   into nome_doc
   from doces
   where id_doce=id_doc;
   
   return nome_doc;
end;
$$;
 1   DROP FUNCTION public.getdoceped(id_ped integer);
       public       postgres    false    3    1            �            1255    24824    getiddoceped(integer)    FUNCTION     �   CREATE FUNCTION public.getiddoceped(id_ped integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	id_doc integer;
begin
   select id_doce
   into id_doc
   from pedidos
   where id_pedido=id_ped;
   
   return id_doc;
end;
$$;
 3   DROP FUNCTION public.getiddoceped(id_ped integer);
       public       postgres    false    3    1            �            1255    24821    getlucrovendido(integer)    FUNCTION     �  CREATE FUNCTION public.getlucrovendido(id_ped integer) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
declare
	doce_lucro double precision;
begin
   select ((sum(quant_doce)*d.preco_venda)-sum(quant_doce)*d.custo_medio)
   into doce_lucro
   from pedidos as ped cross join doces as d
   where ped.id_pedido=id_ped group by d.preco_venda, d.custo_medio;
   
   return doce_lucro;
end;
$$;
 6   DROP FUNCTION public.getlucrovendido(id_ped integer);
       public       postgres    false    1    3            �            1255    24820    gettotalvendido(integer)    FUNCTION       CREATE FUNCTION public.gettotalvendido(id_ped integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	doce_count integer;
begin
   select sum(quant_doce) 
   into doce_count
   from pedidos
   where id_pedido=id_ped;
   
   return doce_count;
end;
$$;
 6   DROP FUNCTION public.gettotalvendido(id_ped integer);
       public       postgres    false    1    3            �            1255    24910    setdocevendido(integer)    FUNCTION     '  CREATE FUNCTION public.setdocevendido(iddoce integer) RETURNS TABLE(id_doce integer, quant_doce bigint)
    LANGUAGE plpgsql
    AS $$
begin
	CREATE TEMPORARY TABLE temp_table(
	   id_doce int
	);
	INSERT INTO temp_table(id_doce)	VALUES (iddoce);
	create or replace view doce_vendas as
	select ped.id_doce, sum(ped.quant_doce) as quantidade from pedidos ped, vendas ven, temp_table tem
	where ven.id_pedido=ped.id_pedido
		and ven.status='VENDIDO'
		and ped.id_doce=tem.id_doce
	group by ped.id_doce;
	return query select * from doce_vendas;
end;
$$;
 5   DROP FUNCTION public.setdocevendido(iddoce integer);
       public       cocada    false    3    1            �            1255    24876    setquantdocevendido(integer)    FUNCTION     �  CREATE FUNCTION public.setquantdocevendido(quant_rel integer) RETURNS TABLE(id_doce integer, quant_doce bigint)
    LANGUAGE plpgsql
    AS $$
begin
	create or replace view quant_doces as
	select ped.id_doce, sum(ped.quant_doce) as quantidade from pedidos ped, vendas ven
	where ven.id_pedido=ped.id_pedido
		and ven.status='VENDIDO'
		group by ped.id_doce;
	return query select * from quant_doces order by quantidade desc limit quant_rel;
end;
$$;
 =   DROP FUNCTION public.setquantdocevendido(quant_rel integer);
       public       cocada    false    1    3            �            1255    24874 /   setquantdocevendidoperiodo(integer, date, date)    FUNCTION       CREATE FUNCTION public.setquantdocevendidoperiodo(quant_rel integer, data_i date, data_f date) RETURNS TABLE(id_doce integer, quant_doce bigint)
    LANGUAGE plpgsql
    AS $$
begin
	create or replace view quant_doces as
	select ped.id_doce, sum(ped.quant_doce) as quantidade from pedidos ped, vendas ven
	where ven.id_pedido=ped.id_pedido
		and ven.status='VENDIDO'
		AND ven.data BETWEEN '2021-10-24' AND ldata_f
		group by ped.id_doce;
	return query select * from quant_doces order by quantidade desc limit quant_rel;
end;
$$;
 ^   DROP FUNCTION public.setquantdocevendidoperiodo(quant_rel integer, data_i date, data_f date);
       public       cocada    false    1    3            �            1255    25065    setvendasporusuario(integer)    FUNCTION       CREATE FUNCTION public.setvendasporusuario(iduser integer) RETURNS TABLE(id_usuario integer, quant_doces numeric, valor_vendido double precision, valor_desconto double precision)
    LANGUAGE plpgsql
    AS $$
begin
	create or replace view ped_mult as
	select id_pedido, sum(quant_doce) from pedidos group by id_pedido order by id_pedido;
	
	create temporary table get_user(
	   id_usuario int
	);
	INSERT INTO get_user(id_usuario) VALUES (iduser);
	
	return query select ven.id_usuario,
		sum(ped.sum) as quant_doces,
		sum(ven.bruto) as valor_vendido,
		sum(ven.desconto) as valor_desconto
		from ped_mult ped, vendas ven, get_user gu
		where ven.status='VENDIDO'
			and ven.id_pedido=ped.id_pedido
			and ven.id_usuario=gu.id_usuario
		group by ven.id_usuario order by quant_doces desc;
end;
$$;
 :   DROP FUNCTION public.setvendasporusuario(iduser integer);
       public       cocada    false    3    1            �            1255    25064    setvendasusuario()    FUNCTION     o  CREATE FUNCTION public.setvendasusuario() RETURNS TABLE(id_usuario integer, quant_doces numeric, valor_vendido double precision, valor_desconto double precision)
    LANGUAGE plpgsql
    AS $$
begin
	create or replace view ped_mult as
	select id_pedido, sum(quant_doce) from pedidos group by id_pedido order by id_pedido;
	
	return query select ven.id_usuario,
		sum(ped.sum) as quant_doces,
		sum(ven.bruto) as valor_vendido,
		sum(ven.desconto) as valor_desconto
		from ped_mult ped, vendas ven
		where ven.status='VENDIDO'
			and ven.id_pedido=ped.id_pedido
		group by ven.id_usuario order by quant_doces desc;
end;
$$;
 )   DROP FUNCTION public.setvendasusuario();
       public       cocada    false    3    1            �            1259    16395    clientes_id_seq    SEQUENCE     x   CREATE SEQUENCE public.clientes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.clientes_id_seq;
       public       cocada    false    3            �            1259    16405    clientes    TABLE     �   CREATE TABLE public.clientes (
    id_cliente integer DEFAULT nextval('public.clientes_id_seq'::regclass) NOT NULL,
    cpf numeric NOT NULL,
    nome_cliente character varying(100) NOT NULL,
    telefone character varying(20)
);
    DROP TABLE public.clientes;
       public         cocada    false    203    3            �            1259    16403 !   clientes_endereco_id_endereco_seq    SEQUENCE     �   CREATE SEQUENCE public.clientes_endereco_id_endereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.clientes_endereco_id_endereco_seq;
       public       cocada    false    3            �            1259    16450    clientes_logradouros    TABLE       CREATE TABLE public.clientes_logradouros (
    id_logradouro integer DEFAULT nextval('public.clientes_endereco_id_endereco_seq'::regclass) NOT NULL,
    id_cliente integer NOT NULL,
    endereco character varying(99) NOT NULL,
    num character varying(9) NOT NULL,
    complemento character varying(99) DEFAULT ''::character varying,
    bairro character varying(99) NOT NULL,
    cidade character varying(30) NOT NULL,
    uf character varying(30) NOT NULL,
    cep character varying(8) NOT NULL,
    pais character varying(30) NOT NULL
);
 (   DROP TABLE public.clientes_logradouros;
       public         cocada    false    207    3            �            1259    16397    doces_id_seq    SEQUENCE     u   CREATE SEQUENCE public.doces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.doces_id_seq;
       public       cocada    false    3            �            1259    16418    doces    TABLE     6  CREATE TABLE public.doces (
    id_doce integer DEFAULT nextval('public.doces_id_seq'::regclass) NOT NULL,
    nome_doce character varying(30) NOT NULL,
    ingredientes character varying(90) NOT NULL,
    custo_medio double precision DEFAULT 0 NOT NULL,
    preco_venda double precision DEFAULT 1 NOT NULL
);
    DROP TABLE public.doces;
       public         cocada    false    204    3            �            1259    24759    fidelidades    TABLE     �   CREATE TABLE public.fidelidades (
    cod_fidelidade integer NOT NULL,
    pontos integer DEFAULT 0 NOT NULL,
    bonus integer DEFAULT 0 NOT NULL,
    resgates integer DEFAULT 0 NOT NULL
);
    DROP TABLE public.fidelidades;
       public         cocada    false    3            �            1259    24792    metodos_pagamento_id_seq    SEQUENCE     �   CREATE SEQUENCE public.metodos_pagamento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.metodos_pagamento_id_seq;
       public       cocada    false    3            �            1259    24784    metodos_pagamento    TABLE     �   CREATE TABLE public.metodos_pagamento (
    cod_metodo integer DEFAULT nextval('public.metodos_pagamento_id_seq'::regclass) NOT NULL,
    desc_metodo character varying NOT NULL
);
 %   DROP TABLE public.metodos_pagamento;
       public         cocada    false    217    3            �            1259    24608    pedidos_id_pedido_seq    SEQUENCE     ~   CREATE SEQUENCE public.pedidos_id_pedido_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.pedidos_id_pedido_seq;
       public       cocada    false    3            �            1259    24754    pedidos    TABLE     �   CREATE TABLE public.pedidos (
    id_pedido integer DEFAULT nextval('public.pedidos_id_pedido_seq'::regclass) NOT NULL,
    id_doce integer NOT NULL,
    quant_doce integer DEFAULT 1 NOT NULL
);
    DROP TABLE public.pedidos;
       public         cocada    false    212    3            �            1259    25053    ped_mult    VIEW     �   CREATE VIEW public.ped_mult AS
 SELECT pedidos.id_pedido,
    sum(pedidos.quant_doce) AS sum
   FROM public.pedidos
  GROUP BY pedidos.id_pedido
  ORDER BY pedidos.id_pedido;
    DROP VIEW public.ped_mult;
       public       postgres    false    214    214    3            �            1259    16401    vendas_id_venda_seq    SEQUENCE     |   CREATE SEQUENCE public.vendas_id_venda_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.vendas_id_venda_seq;
       public       cocada    false    3            �            1259    24736    vendas    TABLE     �  CREATE TABLE public.vendas (
    id_venda integer DEFAULT nextval('public.vendas_id_venda_seq'::regclass) NOT NULL,
    status character varying(15) DEFAULT 'PRONTO'::character varying NOT NULL,
    id_cliente integer,
    data date DEFAULT ('now'::text)::date NOT NULL,
    bruto double precision NOT NULL,
    desconto double precision DEFAULT 0,
    cod_metodo integer,
    id_pedido integer NOT NULL,
    id_usuario integer
);
    DROP TABLE public.vendas;
       public         cocada    false    206    3            �            1259    24850    quant_doces    VIEW     �   CREATE VIEW public.quant_doces AS
 SELECT ped.id_doce,
    sum(ped.quant_doce) AS quantidade
   FROM public.pedidos ped,
    public.vendas ven
  WHERE ((ven.id_pedido = ped.id_pedido) AND ((ven.status)::text = 'VENDIDO'::text))
  GROUP BY ped.id_doce;
    DROP VIEW public.quant_doces;
       public       cocada    false    214    213    213    214    214    3            �            1259    24829    rel_mais_vendidos    VIEW     �  CREATE VIEW public.rel_mais_vendidos AS
 SELECT DISTINCT doc.id_doce,
    doc.nome_doce,
    ( SELECT public.gettotalvendido(ped.id_pedido) AS gettotalvendido) AS quant_vendida,
    ( SELECT public.getlucrovendido(ven.id_pedido) AS getlucrovendido) AS lucro
   FROM ((public.pedidos ped
     JOIN public.doces doc ON ((ped.id_doce = doc.id_doce)))
     JOIN public.vendas ven ON ((ven.id_pedido = ped.id_pedido)))
  WHERE ((ven.status)::text = 'VENDIDO'::text);
 $   DROP VIEW public.rel_mais_vendidos;
       public       postgres    false    214    209    240    238    214    213    213    209    3            �            1259    24825    rel_mais_vendidos_doce    VIEW     �  CREATE VIEW public.rel_mais_vendidos_doce AS
 SELECT ( SELECT public.getiddoceped(vendas.id_pedido) AS getiddoceped) AS id_doce,
    ( SELECT public.getdoceped(vendas.id_pedido) AS getdoceped) AS nome_doce,
    ( SELECT public.gettotalvendido(vendas.id_pedido) AS gettotalvendido) AS quant_vendida,
    ( SELECT public.getlucrovendido(vendas.id_pedido) AS getlucrovendido) AS lucro
   FROM public.vendas
  WHERE ((vendas.status)::text = 'VENDIDO'::text);
 )   DROP VIEW public.rel_mais_vendidos_doce;
       public       postgres    false    239    238    240    237    213    213    3            �            1259    24870    temp_vendas    VIEW     �   CREATE VIEW public.temp_vendas AS
 SELECT vendas.id_venda,
    vendas.status,
    vendas.id_cliente,
    vendas.data,
    vendas.bruto,
    vendas.desconto,
    vendas.cod_metodo,
    vendas.id_pedido
   FROM public.vendas;
    DROP VIEW public.temp_vendas;
       public       postgres    false    213    213    213    213    213    213    213    213    3            �            1259    16399    usuarios_id_seq    SEQUENCE     x   CREATE SEQUENCE public.usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.usuarios_id_seq;
       public       cocada    false    3            �            1259    16429    usuarios    TABLE       CREATE TABLE public.usuarios (
    id_usuario integer DEFAULT nextval('public.usuarios_id_seq'::regclass) NOT NULL,
    usuario character varying NOT NULL,
    senha character varying NOT NULL,
    func character varying DEFAULT 'COZINHA'::character varying NOT NULL
);
    DROP TABLE public.usuarios;
       public         cocada    false    205    3            �            1259    24900 	   user_data    VIEW     ~   CREATE VIEW public.user_data AS
 SELECT usuarios.id_usuario,
    usuarios.usuario,
    usuarios.func
   FROM public.usuarios;
    DROP VIEW public.user_data;
       public       cocada    false    210    210    210    3            �            1259    24905    userdata    VIEW     }   CREATE VIEW public.userdata AS
 SELECT usuarios.id_usuario,
    usuarios.usuario,
    usuarios.func
   FROM public.usuarios;
    DROP VIEW public.userdata;
       public       postgres    false    210    210    210    3            �          0    16405    clientes 
   TABLE DATA               K   COPY public.clientes (id_cliente, cpf, nome_cliente, telefone) FROM stdin;
    public       cocada    false    208   �\       �           0    0 !   clientes_endereco_id_endereco_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.clientes_endereco_id_endereco_seq', 5, true);
            public       cocada    false    207            �           0    0    clientes_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.clientes_id_seq', 28, true);
            public       cocada    false    203            �          0    16450    clientes_logradouros 
   TABLE DATA               �   COPY public.clientes_logradouros (id_logradouro, id_cliente, endereco, num, complemento, bairro, cidade, uf, cep, pais) FROM stdin;
    public       cocada    false    211   O]       �          0    16418    doces 
   TABLE DATA               [   COPY public.doces (id_doce, nome_doce, ingredientes, custo_medio, preco_venda) FROM stdin;
    public       cocada    false    209   �]       �           0    0    doces_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.doces_id_seq', 4, true);
            public       cocada    false    204            �          0    24759    fidelidades 
   TABLE DATA               N   COPY public.fidelidades (cod_fidelidade, pontos, bonus, resgates) FROM stdin;
    public       cocada    false    215   �^       �          0    24784    metodos_pagamento 
   TABLE DATA               D   COPY public.metodos_pagamento (cod_metodo, desc_metodo) FROM stdin;
    public       cocada    false    216   �^       �           0    0    metodos_pagamento_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.metodos_pagamento_id_seq', 15, true);
            public       cocada    false    217            �          0    24754    pedidos 
   TABLE DATA               A   COPY public.pedidos (id_pedido, id_doce, quant_doce) FROM stdin;
    public       cocada    false    214   Z_       �           0    0    pedidos_id_pedido_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.pedidos_id_pedido_seq', 219, true);
            public       cocada    false    212            �          0    16429    usuarios 
   TABLE DATA               D   COPY public.usuarios (id_usuario, usuario, senha, func) FROM stdin;
    public       cocada    false    210   g`       �           0    0    usuarios_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.usuarios_id_seq', 30, true);
            public       cocada    false    205            �          0    24736    vendas 
   TABLE DATA               x   COPY public.vendas (id_venda, status, id_cliente, data, bruto, desconto, cod_metodo, id_pedido, id_usuario) FROM stdin;
    public       cocada    false    213   �a       �           0    0    vendas_id_venda_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.vendas_id_venda_seq', 49, true);
            public       cocada    false    206            G           2606    16415    clientes cliente_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cliente);
 ?   ALTER TABLE ONLY public.clientes DROP CONSTRAINT cliente_pkey;
       public         cocada    false    208    208            O           2606    16455 +   clientes_logradouros clientes_endereco_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.clientes_logradouros
    ADD CONSTRAINT clientes_endereco_pkey PRIMARY KEY (id_logradouro);
 U   ALTER TABLE ONLY public.clientes_logradouros DROP CONSTRAINT clientes_endereco_pkey;
       public         cocada    false    211    211            I           2606    16417    clientes cpf 
   CONSTRAINT     F   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT cpf UNIQUE (cpf);
 6   ALTER TABLE ONLY public.clientes DROP CONSTRAINT cpf;
       public         cocada    false    208    208            K           2606    16425    doces doce_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.doces
    ADD CONSTRAINT doce_pkey PRIMARY KEY (id_doce);
 9   ALTER TABLE ONLY public.doces DROP CONSTRAINT doce_pkey;
       public         cocada    false    209    209            Q           2606    24764    fidelidades id_fidelidade 
   CONSTRAINT     c   ALTER TABLE ONLY public.fidelidades
    ADD CONSTRAINT id_fidelidade PRIMARY KEY (cod_fidelidade);
 C   ALTER TABLE ONLY public.fidelidades DROP CONSTRAINT id_fidelidade;
       public         cocada    false    215    215            S           2606    24791 (   metodos_pagamento metodos_pagamento_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.metodos_pagamento
    ADD CONSTRAINT metodos_pagamento_pkey PRIMARY KEY (cod_metodo);
 R   ALTER TABLE ONLY public.metodos_pagamento DROP CONSTRAINT metodos_pagamento_pkey;
       public         cocada    false    216    216            M           2606    16437    usuarios usuario_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);
 ?   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuario_pkey;
       public         cocada    false    210    210            T           2606    16456 6   clientes_logradouros clientes_endereco_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.clientes_logradouros
    ADD CONSTRAINT clientes_endereco_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente) ON DELETE CASCADE;
 `   ALTER TABLE ONLY public.clientes_logradouros DROP CONSTRAINT clientes_endereco_id_cliente_fkey;
       public       cocada    false    208    211    2119            U           2606    24749 %   vendas pedidos_vendas_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT pedidos_vendas_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.vendas DROP CONSTRAINT pedidos_vendas_id_cliente_fkey;
       public       cocada    false    208    213    2119            �   �   x�Uͽ
�0���ާ�������� ���c)"1��b�g��?��[������.Y]d�*���:�c�<M򐴊թ|�&��x6j�����e��z��AQ͈�cTӫ�Ф@Ӟ��v�׎�?�/�      �   �   x�U���0�s�{�M1r����0���`|��
!����_{&Oe����!L1�[Cw��Yqd��+�5���k�����4�[*��+o'��Q��O�C,�R�Iм�SLݏܥyw��0����z۞Zy�d��������d�� Yt3�      �   �   x�M�1� �W��%�%�H����@��/����I����`Ųcr�^R�14\Qþ}��LE��Awn��YV�i)�~*��v)���uJ�a �%
��>�	�����+�9�?9q�'�_J]�g��q��J�'�      �   >   x�=��� �o�ȝ�q��?����%�@ݡꏸ�F�/$�!��n��:h��WHN���      �   k   x�˻� D�x�
U�a�b�m�A
]�+�D79W0q���0� ����p���`w�N���Qc�Ly��w���uOGꙊ������ԦooG�����<      �   �   x�=�A�� �z�yB�.�����U�1���Y��*�Z��hK'S�c����<n��(�;��:}cQ�=���x̾��F�	Mu�7����e䴝G�y�-��A�����@tj�thw �;��>'��!��9�|<��\�sm?rM�rr9�A�`aq?�>1����ޱ|:�9������E��y���Mъ����z�A=���sh�>�o��G��A�J?t��
~�{�<?����HEty      �   8  x�]�Qk�0��O~�H�V}�V��T(c���UM�Y�ߍ�"���/�ܓ(g"��yaW������^۪:��C���Lpp����d�fx,���dB G�������T��d���?69��Z]����ONE�m�-���(g�j��KD�f4�p�Fo<�/���uR�u5ɠ��dО�i�G 9�2���V ���lg,�U+��[�<��$έ�֩�w�+�`z��n�����lg���кߌL`7�v֎���s�gp���
d�Ɲh'5(*A��hr"�q�?���Ł�����m��_��c��h��      �     x�}�;n1Dk�.4Կ��4�A�����V^��>�3R,�{ۮ��]W\��&�����|}�����S�L�&$��^D��@��y�;�*}X���c#�H�|��.B�6Y���N�)���%kz���r�PL�]�S7�pA=81�`���s:3��Y6�T��ܬ<�񙤅YL��J�t��;N�t�nY��[���rNV�$ŷ�j�"�4D�@�ĵ���7k������}����jX�^�E��=2��1/di�>���z/��O���8�� w�     