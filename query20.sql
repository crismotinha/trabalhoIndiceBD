select s_name, s_address from SUPPLIER, NATION where s_suppkey in ( select ps_suppkey from PARTSUPP where ps_partkey in (select p_partkey from PART where p_name like 'green%') and ps_availqty > (select 0.5 * sum(l_quantity) from LINEITEM where l_partkey = ps_partkey and l_suppkey = ps_suppkey and l_shipdate >= date '1993-01-01' and l_shipdate < date '1993-01-01' + interval '1' year)) and s_nationkey = n_nationkey and n_name = 'ALGERIA' order by s_name;
-- tempo antes: 0:00:0,74853492
create index n_name_idx on NATION(n_name) -- foi de full table scan pra non unique key lookup
-- tempo depois: 0:00:0,43307495

-- criar indice pro order by não fez diferença, ele já estava usando filesort (https://www.percona.com/blog/2009/03/05/what-does-using-filesort-mean-in-mysql/)