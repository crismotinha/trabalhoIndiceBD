select supp_nation, 
		cust_nation, 
        l_year, 
        sum(volume) as revenue 
from ( select n1.n_name as supp_nation, 
			n2.n_name as cust_nation, 
			extract(year from l_shipdate) as l_year, 
			l_extendedprice * (1 - l_discount) as volume
        from SUPPLIER, LINEITEM, ORDERS, CUSTOMER, NATION n1, NATION n2 
        where s_suppkey = l_suppkey 
			and o_orderkey = l_orderkey 
            and c_custkey = o_custkey 
            and s_nationkey = n1.n_nationkey 
            and c_nationkey = n2.n_nationkey 
            and ((n1.n_name = 'JAPAN' and n2.n_name = 'INDIA') or (n1.n_name = 'INDIA' and n2.n_name = 'JAPAN')) 
            and l_shipdate between date '1995-01-01' and date '1996-12-31') as shipping
group by supp_nation, cust_nation, l_year 
order by supp_nation, cust_nation, l_year;

-- tempo sem índice: 8,316 sec
-- faz full table scan em n1, com o index em N_NAME ele pula para um index range scan.
-- o tempo de execução é 8,442. aumenta um pouco, mas em questão de poucos milissegundos; pode ajudar em uma outra query.
-- foi criado em n_name pois haviam duas tabelas que proucuravam registros por nome (n1 e n2), o que deixava o acesso lento.
-- a criação de índices em l_shipdate não alterou em nada, ja que o índice de fk foi usado. 
CREATE INDEX n_name_idx ON NATION(N_NAME);