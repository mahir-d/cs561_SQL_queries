with total_quant AS
    (select month,
            prod,
            sum(quant) as sum_q
     from sales
     group by month,
              prod
     order by MONTH),
     min_max as
    (select prod,
            max(sum_q) max_q,
            min(sum_q) min_q
     from total_quant
     group by prod)
SELECT m.prod,
       t1.MONTH as most_fav_mo,
       t2.MONTH as LEAST_fav_mo
from min_max m,
     total_quant t1,
     total_quant t2
where m.prod = t1.prod
    and m.prod = t2.prod
    and m.max_q = t1.sum_q
    and m.min_q = t2.sum_q
order by m.prod