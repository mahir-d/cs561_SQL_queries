with min_quant AS
    (SELECT cust,
            min(quant) as min_value
     from sales
     group by cust),
     max_quant AS
    (SELECT cust,
            max(quant) as max_value
     from sales
     group by cust),
     part1 as
    (select s.cust as CUSTOMER,
            m_q.min_value as MIN_Q,
            s.prod MIN_PROD,
            s.month || '/' || s.day || '/' || s.year as MIN_DATE,
            s.state as ST
     from sales s,
          min_quant as m_q
     where s.cust = m_q.cust
         and s.quant = m_q.min_value),
     part2 as
    (select s.cust as CUSTOMER,
            m_q.max_value as MAX_Q,
            s.prod MAX_PROD,
            s.month || '/' || s.day || '/' || s.year as MAX_DATE,
            s.state as ST
     from sales s,
          max_quant as m_q
     where s.cust = m_q.cust
         and s.quant = m_q.max_value),
     cust_avg as
    (SELECT cust,
            round(avg(quant)) as avg_q
     from sales
     GROUP BY cust)
select *
from part1,
     part2,
     cust_avg
where part1.CUSTOMER = part2.CUSTOMER
    and part1.CUSTOMER = cust_avg.cust