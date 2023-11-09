-- DROP TABLE IF EXIST public.fact_finanzas;
CREATE TABLE public.fact_finanzas (
	id serial4 NOT NULL,
	fecha date NOT NULL,
	id_empresa int4 NULL,
	id_cuenta int4 not null,
	credito numeric NULL,
	debito numeric NULL,
	balance numeric NULL,
	CONSTRAINT fact_finanzas_pk PRIMARY KEY (id)
);
-- public.fact_finanzas foreign keys
ALTER TABLE public.fact_finanzas ADD CONSTRAINT fact_finanzas_id_empresa_fkey FOREIGN KEY (id_empresa) REFERENCES public.res_company(id) ON DELETE RESTRICT;
ALTER TABLE public.fact_finanzas ADD CONSTRAINT fact_finanzas_id_cuenta_fkey FOREIGN KEY (id_cuenta) REFERENCES public.account_account(id) ON DELETE RESTRICT;
