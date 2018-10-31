select nation, o_year, sum(amount) as sum_profit 
from (select n_name as nation, 
			extract(year from o_orderdate) as o_year, 
			l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity as amount 
		from PART, SUPPLIER, LINEITEM, PARTSUPP, ORDERS, NATION 
        where s_suppkey = l_suppkey 
				and ps_suppkey = l_suppkey 
                and ps_partkey = l_partkey 
                and p_partkey = l_partkey 
                and o_orderkey = l_orderkey 
                and s_nationkey = n_nationkey 
                and p_name like '%dim%') as profit 
group by nation, o_year 
order by nation, o_year desc;

-- tempo sem index: 32,048 sec

-- não foi possível otimizar a query pois, embora há o uso de índices em outras tabelas, na tabela PART
-- ele faz um full table scan por causa da condição "p_name like '%dim%'". logo, para atender essa condição,
-- é preciso que seja escaneado todos os registros da tabela.
-- para as outras tabelas, foram utilizados índices de chave primária e chave estrangeira. 