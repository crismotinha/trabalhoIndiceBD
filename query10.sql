select c_custkey,
	c_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue,
	c_acctbal,
	n_name,
	c_address,
	c_phone,
	c_comment
from
	CUSTOMER,
	ORDERS,
	LINEITEM,
	NATION
where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate >= date '1993-08-01'
	and o_orderdate < date '1993-08-01' + interval '3' month
	and l_returnflag = 'R'
	and c_nationkey = n_nationkey
group by
	c_custkey,
	c_name,
	c_acctbal,
	c_phone,
	n_name,
	c_address,
	c_comment
order by
	revenue desc
limit 20;

-- tempo antes do índice: 7,583 sec 
-- faz full scan na tabela orders
-- não foi criado índice em cima de returnflag, pois ia agregar muitos dados e ia ter que iterar sobre todas essas
-- rows (na mesma ideia de criar um indice pra sexo [M/F]).

CREATE INDEX o_orderdate_idx ON ORDERS(O_ORDERDATE);
-- com índice em O_ORDERDATE, faz um index range scan
-- tempo depois do índice: 6,348 sec.