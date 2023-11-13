--tabla para jerarquia del catalogo de cuentas
-- DROP TABLE public.dw_account_order;
CREATE TABLE public.dw_account_order (
	id serial4 NOT NULL,
	company_id int4 not NULL,
	account_id int4 not null,
	account_code varchar(64) not null,
	--tentativo 
    --account_type_code (primer digito)
	has_parent boolean,
	account_parent_id int4 null,
	account_parent_code varchar(64),
	CONSTRAINT dw_account_order PRIMARY KEY (id)
);
-- public.fact_finanzas foreign keys
ALTER TABLE public.dw_account_order ADD CONSTRAINT dw_account_order_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.res_company(id) ON DELETE RESTRICT;
ALTER TABLE public.dw_account_order ADD CONSTRAINT dw_account_order_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account_account(id) ON DELETE RESTRICT;
ALTER TABLE public.dw_account_order ADD CONSTRAINT dw_account_order_account_parent_id_fkey FOREIGN KEY (account_parent_id) REFERENCES public.account_account(id) ON DELETE RESTRICT;
