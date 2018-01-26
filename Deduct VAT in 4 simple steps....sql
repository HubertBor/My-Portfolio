--- Step 1
select contract_id , cast ((sum (amount/100/1.16*-1))as decimal (10,2)) SumOfdecucted into #VATDEDUCTED from  test.valuation_31032017 where 
((pm_real='IN' and (paymentMode = 'PRE-I' or paymentMode ='PRE')) or (pm_real='IT' and (paymentMode = 'PRE-I' or paymentMode ='PRE')) )and dtype !='AmortisationCashFlow' and cashflowtype != 'Principal'
group by contract_id
--- Step 2
select contract_id , cast ((sum (amount/100*-1))as decimal (10,2)) Amount into #Principal  from  test.valuation_31032017 where 
((pm_real='IN' and (paymentMode = 'PRE-I' or paymentMode ='PRE')) or (pm_real='IT' and (paymentMode = 'PRE-I' or paymentMode ='PRE')) )and dtype ='AmortisationCashFlow' and cashflowtype = 'Principal'
group by contract_id
--- Step 3
select V.contract_id , (V.SumOfdecucted + P.Amount) Total into #Total from #VATDEDUCTED V
join #Principal P on  V.contract_id = P.contract_id
--- Step 4
select  lv.deal_id, lv.amount, Total  from t_trn_loan_valuation lv 
join #Total v on substring (lv.deal_id,6,7) = v.contract_id
where lv.valuation_type ='PREPAYMENT' and entity = 'MX_IPFD' and total !=amount



