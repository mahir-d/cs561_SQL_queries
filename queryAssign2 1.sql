-- Query1
with mainTable as
(select cust, prod, month, state, round(avg(quant)) as cust_avg 
from sales
group by cust, prod, month, state
order by cust, prod, month),
otherProd as 
(select m1.cust, m1.prod, m1.month, m1.state, round(avg(m2.quant)) as other_prod_avg
from mainTable as m1, sales as m2
where m1.cust = m2.cust and m1.month = m2.month and m1.state = m2.state and m1.prod != m2.prod
Group by m1.cust, m1.prod, m1.month, m1.state
),
otherMonth as 
(select m1.cust, m1.prod, m1.month, m1.state, round(avg(m2.quant)) as other_month_avg
from mainTable as m1, sales as m2
where m1.cust = m2.cust and m1.month != m2.month and m1.state = m2.state and m1.prod = m2.prod
Group by m1.cust, m1.prod, m1.month, m1.state
),
otherState as
(select m1.cust, m1.prod, m1.month, m1.state, round(avg(m2.quant)) as other_state_avg
from mainTable as m1, sales as m2
where m1.cust = m2.cust and m1.month = m2.month and m1.state != m2.state and m1.prod = m2.prod
Group by m1.cust, m1.prod, m1.month, m1.state
)

select cust as customer, prod as product, month, state, cust_avg, other_prod_avg, other_month_avg, other_state_avg
from mainTable Natural full outer join otherProd Natural full outer join otherMonth Natural full outer join otherState
