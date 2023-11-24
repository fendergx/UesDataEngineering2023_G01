--tabla para jerarquia del catalogo de cuentas
-- DROP TABLE public.dw_account_order;
CREATE TABLE public.dw_account_order (
	id serial4 NOT NULL,
	company_id int4 not NULL,
	account_id int4 not null,
	account_code varchar(64) not null,
	account_name varchar(100) not null, 
	account_type varchar(150) not null,
	account_group varchar (15) not null, --internal group,1,2,3...
	has_parent boolean null default null,
	parent_account_id int4 null default null,
	parent_account_code varchar(64) null default null,
	parent_account_name varchar(100) null default null,
    created_at timestamp default now(),
	CONSTRAINT dw_account_order_pk PRIMARY KEY (id)
);
-- public.dw_account_sum foreign keys
ALTER TABLE public.dw_account_order ADD CONSTRAINT dw_account_order_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.res_company(id) ON DELETE RESTRICT;
ALTER TABLE public.dw_account_order ADD CONSTRAINT dw_account_order_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account_account(id) ON DELETE RESTRICT;
ALTER TABLE public.dw_account_order ADD CONSTRAINT dw_account_order_parent_account_id_fkey FOREIGN KEY (parent_account_id) REFERENCES public.account_account(id) ON DELETE RESTRICT;
--comentarios
COMMENT ON COLUMN public.dw_account_order.account_id IS 'id de la cuenta en el catalogo account_account';
COMMENT ON COLUMN public.dw_account_order.account_code IS 'codigo de la cuenta del catalogo';
COMMENT ON COLUMN public.dw_account_order.company_id IS 'id de la sucursal de la cuenta';
COMMENT ON COLUMN public.dw_account_order.account_name IS 'nombre de la cuenta del catalogo base';
COMMENT ON COLUMN public.dw_account_order.account_type IS 'tipo de cuenta, esto es una sub-categoria del grupo';
COMMENT ON COLUMN public.dw_account_order.account_group IS 'el nombre del grupo de cuenta al que pertenece la cuenta';
COMMENT ON COLUMN public.dw_account_order.has_parent IS 'Si la cuenta tiene una cuenta padre (jerarquicamente) estará true, sino sera false';
COMMENT ON COLUMN public.dw_account_order.parent_account_id IS 'id de la cuenta padre si la tuviere';
COMMENT ON COLUMN public.dw_account_order.parent_account_name IS 'nombre de la cuenta padre si la tuviere';
COMMENT ON COLUMN public.dw_account_order.parent_account_code IS 'codigo de la cuenta padre si la tuviere';
COMMENT ON COLUMN public.dw_account_order.created_at IS 'fecha y hora de la creacion del registro, este campo se llena con la informacion del momento que se registra';
