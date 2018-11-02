select l_shipmode, 
		sum(case when o_orderpriority = '1-URGENT' or o_orderpriority = '2-HIGH' then 1 else 0 end) as high_line_count, 
        sum(case when o_orderpriority <> '1-URGENT' and o_orderpriority <> '2-HIGH' then 1 else 0 end) as low_line_count 
from ORDERS, LINEITEM 
where o_orderkey = l_orderkey 
		and l_shipmode in ('RAIL', 'FOB') 
        and l_commitdate < l_receiptdate 
        and l_shipdate < l_commitdate 
        and l_receiptdate >= date '1997-01-01'
        and l_receiptdate < date '1997-01-01' + interval '1' year 
group by l_shipmode 
order by l_shipmode;

-- query12: tempo sem indice: 12,215 sec
-- faz full table scan em lineitem e unique key lookup em orders

-- CREATE INDEX l_receiptdate_idx ON LINEITEM(L_RECEIPTDATE); -- não mudou tb
-- CREATE INDEX l_shipmode_idx ON LINEITEM(L_SHIPMODE); -- não mudou nada, o flow não usou e continuou fazendo fts
-- CREATE INDEX l_shipdate_idx ON LINEITEM(L_SHIPDATE); -- não mudou
-- CREATE INDEX l_orderkey_idx ON LINEITEM(L_ORDERKEY); -- não mudou
-- CREATE INDEX l_commitdate_idx ON LINEITEM(L_COMMITDATE); -- tbm não

-- os índices criados foram ignorados pela execução, fazendo full table scan em todas as vezes.
-- isso é tbm por que as condições são com datas e intervalos (1 year) e também pelo IN do l_shipmode (se fosse = provavelmente funcionaria).
-- a orders usa índice de pk.