with total_quant AS
    (select month,
            prod,
            sum(quant) as sum_q
     from sales
     group by month,
              prod
     order by MONTH),
     min_max AS
    (select month,
            max(sum_q) as Most_popular_total_q,
            min(sum_q) as least_popular_total_q
     from total_quant
     group by month)
select m.month,
       s1.prod as most_popular_prod,
       m.Most_popular_total_q,
       s2.prod as least_popular_prod,
       m.least_popular_total_q
from min_max m,
     total_quant s1,
     total_quant s2
where m.month = s1.month
    and m.month = s2.MONTH
    and m.Most_popular_total_q = s1.sum_q
    and m.least_popular_total_q = s2.sum_q