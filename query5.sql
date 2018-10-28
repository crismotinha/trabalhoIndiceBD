select n_name, 
		sum(l_extendedprice * (1 - l_discount)) as revenue 
from CUSTOMER, ORDERS, LINEITEM, SUPPLIER, NATION, REGION 
where c_custkey = o_custkey 
		and l_orderkey = o_orderkey 
        and l_suppkey = s_suppkey 
        and c_nationkey = s_nationkey 
        and s_nationkey = n_nationkey 
        and n_regionkey = r_regionkey 
        and r_name = 'MIDDLE EAST' 
        and o_orderdate >= date '1994-01-01' 
        and o_orderdate < date '1994-01-01' + interval '1' year 
group by n_name 
order by revenue desc;

-- tempo sem índices: 25,421
-- ao criar um índice em cima da O_ORDERDATE não fez diferença, pois a tabela ORDER utilizou um índice de fk.

-- criar um índice na tabela REGION para R_NAME, pulou de um full table scan para um non-unique key lookup
CREATE INDEX r_name_idx ON REGION(R_NAME);
-- tempo com índice: 13,415 sec 
