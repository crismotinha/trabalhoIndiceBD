select ps_partkey, sum(ps_supplycost * ps_availqty) as value from PARTSUPP, SUPPLIER, NATION where ps_suppkey = s_suppkey and s_nationkey = n_nationkey and n_name = 'MOZAMBIQUE' group by ps_partkey having sum(ps_supplycost * ps_availqty) > (select sum(ps_supplycost * ps_availqty) * 0.0001000000 from PARTSUPP, SUPPLIER, NATION where ps_suppkey = s_suppkey and s_nationkey = n_nationkey and n_name = 'MOZAMBIQUE') order by value desc;

-- tempo antes: 0:00:0,32083988
create index n_name_idx on NATION(n_name) -- foi de full table scan pra non-unique key lookup que nem o resto :)
-- tempo depois: 0:00:0,22201896

