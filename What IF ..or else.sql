
DECLARE kursor CURSOR FOR 
	select lv.deal_id,  lv.amount , ld.char_cust_element1 from dbo.t_trn_loan_default ld
	join dbo.t_trn_loan_valuation lv
	on lv.deal_id = ld.deal_id
	where lv.valuation_type ='DAYS PAST DUE'  and ld.default_type = 'NA'
DECLARE @ID VARCHAR (40) , @amount int , @char1 nvarchar(10)

OPEN kursor
	
	FETCH NEXT FROM kursor into @ID , @amount , @char1
while @@FETCH_STATUS = 0 
Begin
IF (@amount = 0 and @char1 != '0')
	Begin
		Print cast (@ID as VARCHAR) + ' ' + cast (@amount as Varchar) + ' ' + @char1
	end
  else
IF (@amount >= 1 and @amount <= 10 and @char1 != '1-10')
	Begin
		Print cast (@ID as VARCHAR) + ' ' + cast (@amount as Varchar) + ' ' + @char1
	end
  else		
IF (@amount >= 11 and @amount <= 30 and  @char1 != '11-30')
	Begin
		Print cast (@ID as VARCHAR) + ' ' + cast (@amount as Varchar) + ' ' + @char1
	end
  else
IF ( @amount >= 31 and @amount <= 60 and  @char1 != '31-60' )
	Begin
		Print cast (@ID as VARCHAR) + ' ' + cast (@amount as Varchar) + ' ' + @char1
	end
  else
IF ( @amount >= 61  and  @char1 != '60+' )
	Begin
		Print cast (@ID as VARCHAR) + ' ' + cast (@amount as Varchar) + ' ' + @char1
	
	end
	FETCH NEXT FROM kursor into @ID , @amount , @char1
END

CLOSE kursor
DEALLOCATE kursor 
