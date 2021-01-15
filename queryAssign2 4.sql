-- query 4
with totalQuant as
(select cust,prod, sum(quant) as total_sales
from sales
group by cust, prod
),
quantFraction as
(select cust,prod, round(total_sales * 0.75) as fraction
from totalQuant
),
monthTotalSales as
(select cust,prod, month,sum(quant) as month_sum
from sales
group by cust,prod,month
),
cumulativeSum as(
select m1.cust, m1.prod, m1.month, sum(m2.month_sum) as cumuSum
from monthTotalSales as m1, monthTotalSales as m2
where m1.cust = m2.cust and m1.prod = m2.prod and m1.month >= m2.month
group by m1.cust, m1.prod, m1.month
order by m1.cust, m1.prod, m1.month)

select c.cust, c.prod, min(c.month)
from cumulativeSum as c, quantFraction as q
where c.cust = q.cust and c.prod = q.prod and c.cumuSum >= q.fraction
group by c.cust, c.prod
order by c.cust, c.prod

