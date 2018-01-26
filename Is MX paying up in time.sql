------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------OPEN DEALS MX--------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------
select deal_id,TB.contract_id ,TC.closed , 
--OVERDUE AIO--------------------------------------------------
												(((Select outstanding /100
															from test.balances_31032017_V2 
														where 
														contract_id = TB.contract_id and
														cashflowType = 'PRINCIPAL')) +
												
												(cast((( Select sum(outstanding)  
															from test.balances_31032017_V2 TB3
															
														where 
														TB3.contract_id = TB.contract_id and
														cashflowType in (
															'CHANGE_DUE_DATE',
															'DUE_DATE_REMINDER',
															'PAYMENT_HOLIDAY',
															'UPGRADE_CREDITLINE',
															'DOWNGRADE_CREDITLINE',
															'UPSELL_INSTALLMENT',
															'EVENGRADE_CREDITLINE',
															'INSTALLMENT_TO_CREDITLINE',
															'REPAYMENT_PLAN',
															'CANCEL_REPAYMENT_PLAN','DRAWDOWN_FEE', 'INVOICE_FEE','INTEREST' , 'PROVISIONING_FEE' , 'OPENING_FEE'))/100/1.16) as decimal (10,2))))
												Sum_Overdue 
------------------------------------------------------ and  P_valueDate = '2017-03-31'
, amount  
from test.balances_31032017_V2 TB 

join test.contracts_31032017 TC 
	on TB.contract_id = TC.contract_id
join ipf_sa.dbo.t_trn_loan_valuation V
	on substring (V.deal_id,6,7) = TB.contract_ID
----------Join for non fee overdue amounts-----
join 
			(select sum(overdue) overdue ,contract_ID from test.balances_31032017_V2 where
			cashflowType  in (
			'PRINCIPAL','INTEREST' , 'PROVISIONING_FEE' , 'OPENING_FEE'
			) group by contract_ID	) TB2 
------------------------------------------------	
	on TB2.contract_ID = TB.contract_ID
------------------------------------------------
------------------------------------------------
--Open contidion-----------------------------------------------------------
---------------------------------------------------------------------------
where (cast (Tc.closed as date) > '2017-03-31' or TC.closed is null) 
---------------------------------------------------------------------------
----------------------------------------------------------------------------
	and valuation_type ='OUTSTANDING COSTS' 
	and entity = 'MX_IPFD' 
group by TC.closed ,amount ,deal_id ,  TB.contract_id ,TB2.overdue

having 
--------------------AIO Overdue----------------------------			
											(((Select outstanding /100
															from test.balances_31032017_V2 
														where 
														contract_id = TB.contract_id and
														cashflowType = 'PRINCIPAL')) +
												
												(cast((( Select sum(outstanding)  
															from test.balances_31032017_V2 TB3
															
														where 
														TB3.contract_id = TB.contract_id and
														cashflowType in (
															'CHANGE_DUE_DATE',
															'DUE_DATE_REMINDER',
															'PAYMENT_HOLIDAY',
															'UPGRADE_CREDITLINE',
															'DOWNGRADE_CREDITLINE',
															'UPSELL_INSTALLMENT',
															'EVENGRADE_CREDITLINE',
															'INSTALLMENT_TO_CREDITLINE',
															'REPAYMENT_PLAN',
															'CANCEL_REPAYMENT_PLAN','DRAWDOWN_FEE', 'INVOICE_FEE','INTEREST' , 'PROVISIONING_FEE' , 'OPENING_FEE'))/100/1.16) as decimal (10,2))))
----------------------------------------------------------------------------------------------------------------
																!= amount

--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------





