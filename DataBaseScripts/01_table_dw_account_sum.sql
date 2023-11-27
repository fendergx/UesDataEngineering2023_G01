-- DROP TABLE public.dw_account_sum;
CREATE TABLE public.dw_account_sum (
	id serial4 NOT NULL,
	date_sum date NOT NULL, --fecha en formato YYYY-mm-DD
	company_id int4 not NULL,
	company_name varchar(100) not null, --nombre de la sucursal
	account_id int4 NOT NULL,
	account_code varchar(64) not null, --codigo de la cuenta
	account_name varchar(100) not null, --nombre de la cuenta
	credit numeric not NULL,
	debit numeric not NULL,
	balance numeric not NULL,
	created_at timestamp NOT NULL default now(),
	CONSTRAINT dw_account_sum_pk PRIMARY KEY (id)
);
-- public.dw_account_sum foreign keys
ALTER TABLE public.dw_account_sum ADD CONSTRAINT dw_account_sum_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.res_company(id) ON DELETE RESTRICT;
ALTER TABLE public.dw_account_sum ADD CONSTRAINT dw_account_sum_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account_account(id) ON DELETE RESTRICT;
--comentarios
COMMENT ON COLUMN public.dw_account_sum.date_sum IS 'fecha de formato YYYY-mm-DD de la suma de los balances de la cuenta';
COMMENT ON COLUMN public.dw_account_sum.company_id IS 'id de la sucursal de la cuenta';
COMMENT ON COLUMN public.dw_account_sum.company_name IS 'nombre de la sucursal de la cuenta';
COMMENT ON COLUMN public.dw_account_sum.account_id IS 'id de la cuenta asociada al registro';
COMMENT ON COLUMN public.dw_account_sum.account_code IS 'codigo de la cuenta asociada al registro';
COMMENT ON COLUMN public.dw_account_sum.account_name IS 'nombre de la cuenta asociada al registro';
COMMENT ON COLUMN public.dw_account_sum.credit IS 'suma de el total de creditos para la fecha del registro';
COMMENT ON COLUMN public.dw_account_sum.debit IS 'suma de el total de debitos para la fecha del registro';
COMMENT ON COLUMN public.dw_account_sum.balance IS 'suma de el total de balance diario para la fecha del registro';
COMMENT ON COLUMN public.dw_account_sum.created_at IS 'fecha y hora de la creacion del registro, este campo se llena con la informacion del momento que se registra';
