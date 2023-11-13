-- DROP TABLE IF EXIST public.dw_account_sum;
CREATE TABLE public.dw_account_sum (
	id serial4 NOT NULL,
	fecha date NOT NULL,
	id_empresa int4 NULL,
	id_cuenta int4 not null,
	credito numeric NULL,
	debito numeric NULL,
	balance numeric NULL,
	CONSTRAINT dw_account_sum_pk PRIMARY KEY (id)
);
-- public.dw_account_sum foreign keys
ALTER TABLE public.dw_account_sum ADD CONSTRAINT dw_account_sum_id_empresa_fkey FOREIGN KEY (id_empresa) REFERENCES public.res_company(id) ON DELETE RESTRICT;
ALTER TABLE public.dw_account_sum ADD CONSTRAINT dw_account_sum_id_cuenta_fkey FOREIGN KEY (id_cuenta) REFERENCES public.account_account(id) ON DELETE RESTRICT;
