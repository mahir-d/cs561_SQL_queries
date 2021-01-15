-- Query 3
with table1 as
(select prod, quant 
from sales
order by prod,quant),
totalQuant as (
    select prod, count(quant) as total_q
    from sales
    group by prod
),
rankingTable as (
select t1.prod, t1.quant, count(t2.quant) as ranking
from table1 as t1, table1 as t2
where t1.prod = t2.prod and t1.quant >= t2.quant
group by t1.prod, t1.quant
order by t1.prod, t1.quant, ranking),
medTable as
(select prod, (total_q+1)/2 as median
from totalQuant)

select r.prod as product, r.quant as median_quant
from rankingTable as r, medTable as m 
where r.prod = m.prod and r.ranking = m.median

