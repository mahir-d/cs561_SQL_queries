-- Query 2
with mainTable as
(select cust, prod, state, (month/4)+1 as quarter, round(avg(quant)) as during_avg
from sales
group by cust, prod, state, quarter
order by cust, prod, state, quarter
),
beforeAvgTable as 
(
select m1.cust, m1.prod, m1.state, m1.quarter as Q1, m2.during_avg as Before_avg
from mainTable as m1 join  mainTable as m2 on m1.cust = m2.cust and m1.prod = m2.prod and m1.state = m2.state and m1.quarter - 1 = m2.quarter),

afterAvgTable as
(select m1.cust, m1.prod, m1.state, m1.quarter as Q1, m2.during_avg as After_avg
from mainTable as m1 join mainTable as m2 on m1.cust = m2.cust and m1.prod = m2.prod and m1.state = m2.state and m1.quarter + 1 = m2.quarter)

select cust as customer, prod as product, state, Q1, Before_avg, After_avg
from beforeAvgTable natural full outer join afterAvgTable
order by customer, product, state, Q1

