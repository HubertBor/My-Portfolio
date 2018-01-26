--------------CREATE TEMP TABLE (If does not exists)------------
Create table #Check (Errorcode int , contract_id int )
--------------Cursor populating TempTable with values 
							--Use Error code as Id of data you insert	
declare Check_Valuation cursor for 
 	(((select '1' as Errorcode , contract_id  from test.valuation_31032017 where (pm_real='IN' or pm_real='IT') and (paymentMode = 'PRE-I' or paymentMode ='PRE') and DTYPE = 'AmortisationCashFlow'
	EXCEPT
	select '1' as Errorcode , substring (deal_id,6,7)   from ipf_sa.dbo.t_trn_loan_valuation where valuation_type ='PREPAYMENT'))
UNION ALL
(select '2' as Errorcode ,substring (deal_id,6,7) from ipf_sa.dbo.t_trn_loan_valuation where valuation_type ='PREPAYMENT'
EXCEPT
select '2' as Errorcode , contract_id from test.valuation_31032017 where (pm_real='IN' or pm_real='IT') and (paymentMode = 'PRE-I' or paymentMode ='PRE')and DTYPE = 'AmortisationCashFlow') )

declare @Error int , @DealID int
Open Check_Valuation
FETCH NEXT FROM Check_Valuation INTO @Error , @DealID
WHILE @@FETCH_STATUS = 0
BEGIN
insert into #Check (Errorcode  , contract_id  ) 
values ( @Error , @DealID)

 FETCH NEXT FROM Check_Valuation INTO @Error, @DealID
END
CLOSE Check_Valuation
DEALLOCATE Check_Valuation
-----------------------------End of cursor
----- Check up querries
select * from #Check

--Check if contract is avaiable in atable 
select * from test.valuation_31032017 where contract_id = '3012615' 
select * from ipf_sa.dbo.t_trn_loan_valuation where deal_id = 'FIAIO3012615'   and valuation_type ='PREPAYMENT'
-------

select * from ipf_sa.dbo.t_trn_loan_valuation V join #Check C on (substring (deal_id,6,7)) = C.contract_id where valuation_type ='PREPAYMENT'
order by V.deal_id desc

select * from test.valuation_31032017 V join #Check C on V.contract_id = C.contract_id where  valuation_type ='PREPAYMENT'
order by V.contract_id desc

--------Clear Table after testing -----
TRUNCATE TABLE 
#Check