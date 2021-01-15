with main_table as
    (select prod,
            cust,
            round(avg(quant)) as avg_q,
            sum(quant) as total,
            count(quant) as count
     from sales
     group by prod,
              cust
     ORDER by prod,
              cust)
select m.prod,
       m.cust,
       round(avg(s1.quant)) as CT_AVG,
       round(avg(s1.quant)) as NJ_AVG,
       round(avg(s1.quant)) as NY_AVG,
       round(avg(s1.quant)) as PA_AVG,
       m.avg_q,
       m.total,
       m.count
from main_table m,
     sales s1,
     sales s2,
     sales s3,
     sales s4
where m.cust = s1.cust
    and m.cust = s2.cust
    and m.cust = s3.cust
    and m.cust = s4.cust
    and m.prod = s1.prod
    and m.prod = s2.prod
    and m.prod = s3.prod
    and m.prod = s4.prod
    and s1.state = 'CT'
    and s2.state = 'NJ'
    and s3.state = 'NY'
    and s4.state = 'PA'
group by m.prod,
         m.cust,
         m.avg_q,
         m.total,
         m.count