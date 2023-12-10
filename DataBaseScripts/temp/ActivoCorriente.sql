--activo corriente
select t01.date_sum,t01.company_id,sum(credit) as credit, sum(debit) as debit,sum(balance) as balance from dw_account_sum t01
inner join dw_account_order t02
on t02.account_id =t01.account_id
where t01.company_id =1
and date_sum='2024-01-15'
and t02.account_type ='asset_current' and t02.account_code not in ('101000')
group by t01.date_sum,t01.company_id
;

--pasivo corriente
select t01.date_sum,t01.company_id,sum(credit) as credit, sum(debit) as debit,sum(balance) as balance from dw_account_sum t01
inner join dw_account_order t02
on t02.account_id =t01.account_id
where t01.company_id =1
and date_sum='2024-01-15'
and t02.account_type ='liability_current' and t02.account_code not in ('201000')
group by t01.date_sum,t01.company_id
;


--
update dw_account_sum set credit=1.00,debit=100.00,balance=99.00
where company_id =1 and account_code ='101000' and date_sum ='2024-01-15';
