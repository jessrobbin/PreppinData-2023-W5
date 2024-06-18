with cte as (
select
 split_part(transaction_code, '-', 1) as bank_code
, (DATE_PART('month', TO_DATE(TRANSACTION_DATE, 'dd/mm/yyyy hh24:mi:ss'))) as Transaction_month
, sum(VALUE) as Value
, RANK() over(PARTITION BY Transaction_Month ORDER BY SUM(VALUE) DESC) as Ranking
FROM pd2023_wk01
group by bank_code, Transaction_month
)
, avg_rank as (
select
bank_code
,round(avg(Ranking),2) as Avg_Rank_Per_Bank
from cte
group by bank_code

), avg_value as (
select
Ranking
,round(avg(Value),2) as Avg_Value_Per_Rank
from cte
group by Ranking
)
select * from
cte
join avg_rank on avg_rank.bank_code = cte.bank_code
join avg_value on avg_value.Ranking = cte.Ranking
