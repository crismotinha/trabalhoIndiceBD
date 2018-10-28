select o_orderpriority, count(*) as order_count from ORDERS where o_orderdate >= date '1995-01-01' and o_orderdate < date '1995-01-01' + interval '3' month and exists (select * from LINEITEM where l_orderkey = o_orderkey and l_commitdate < l_receiptdate) group by o_orderpriority order by o_orderpriority;
-- tempo anterior: 0:00:0,81727314
create index o_orderdate_idx on ORDERS(o_orderdate) -- foi de full table scan pra index range scan
-- tempo depois: 0:00:0,37728715
-- o indice "o_orderpriority_idx on ORDERS(o_orderpriority)" melhorou o group by, porém continuava fazendo full table scan
-- Quando o "o_orderdate_idx on ORDERS(o_orderdate)" foi criado, foi de full table scan para index range scan
-- e o group by voltou a ficar ruim, mas ele estava agrupando muito menos resultado agora, então compensou ficar somente com o indice pela orderdate mesmo.
