with cust_prod as
    (select distinct cust,
                     prod
     from sales
     order by cust),
     jan_min_table as
    (select sales.cust as customer,
            sales.prod as prod,
            min(quant) as jan_min
     from cust_prod,
          sales
     where cust_prod.cust = sales.cust
         and cust_prod.prod = sales.prod
         and sales.year > 1999
         and sales.month = 1
     group by sales.cust,
              sales.prod),
     feb_max as
    (SELECT s.cust as customer,
            s.prod,
            max(quant) as max_q
     from sales s,
          cust_prod cp
     where s.cust = cp.cust
         and s.prod = cp.prod
         and s.month = 2
     group by s.cust,
              s.prod),
     march_max as
    (SELECT s.cust as customer,
            s.prod,
            max(quant) as max_q
     from sales s,
          cust_prod cp
     where s.cust = cp.cust
         and s.prod = cp.prod
         and s.month = 3
     group by s.cust,
              s.prod),
     part1 as
    (select customer,
            s.prod,
            jan_min,
            s.month || '/' ||s.day || '/' ||s.year as jan_date
     from jan_min_table,
          sales as s
     where jan_min_table.customer = s.cust
         and jan_min_table.prod = s.prod
         and jan_min_table.jan_min = s.quant
         and s.year > 1999
         and s.month = 1
     ORDER BY customer,
              s.prod),
     part2 as
    (select customer,
            s.prod,
            fm.max_q as feb_max_Q,
            s.month || '/' ||s.day || '/' ||s.year as feb_date
     from sales s,
          feb_max fm
     where s.cust = fm.customer
         and s.prod = fm.prod
         and s.quant = fm.max_q
         and s.month = 2
     order by customer,
              s.prod),
     part3 as
    (select customer,
            s.prod,
            mx.max_q as march_max_Q,
            s.month || '/' ||s.day || '/' ||s.year as march_date
     from sales s,
          march_max mx
     where s.cust = mx.customer
         and s.prod = mx.prod
         and s.quant = mx.max_q
         and s.month = 3
     order by customer,
              s.prod), --  final as
 -- (select part1.customer,
 --         part1.prod as product,
 --         part1.jan_min,
 --         part1.jan_date,
 --         part2.feb_max_Q,
 --         part2.feb_date,
 --         part3.march_max_Q,
 --         part3.march_date
 --  from cust_prod natural
 --  full outer join part1 natural
 --  full outer
 --   join part2 natural
 --  full outer
 --  join part3),
--  final1 AS
--     (select cust,
--             cust_prod.prod,
--             jan_min,
--             jan_date
--      from cust_prod
--      left outer join part1 on cust = customer
--      and cust_prod.prod = part1.prod),
 final2 as
    (SELECT customer,
            part1.prod,
            jan_min,
            jan_date,
            feb_max_Q,
            feb_date
     from part1
     full outer JOIN part2 on part1.customer = part2.customer
     and part1.prod = part2.prod) -- select final2.customer,
--        final2.prod,
--        jan_min,
--        jan_date,
--        feb_max_Q,
--        feb_date,
--        march_max_Q,
--        march_date
-- from final2
-- full outer join part3 on final2.customer = part3.customer
-- and final2.prod = part3.prod

SELECT *
from final2