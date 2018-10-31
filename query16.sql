select p_brand, p_type, p_size, count(distinct ps_suppkey) as supplier_cnt from PARTSUPP, PART where p_partkey = ps_partkey and p_brand <> 'Brand#34' and p_type not like 'LARGE BRUSHED%' and p_size in (48, 19, 12, 4, 41, 7, 21, 39) and ps_suppkey not in (select s_suppkey from SUPPLIER where s_comment like '%Customer%Complaints%') group by p_brand, p_type, p_size order by supplier_cnt desc, p_brand, p_type, p_size;

-- Tempo anterior: 0:00:0,42224002
create index p_size_idx on PART(p_size); -- foi de full table scan pra index range scan
-- Tempo depois: 0:00:0,39575887

-- Indice em p_type e p_brand não adiantaram porque ele tem que varrer toda a tabela pra ver quem é diferente (se fosse ser igual, tinha dado certo provavelmente).
-- Indice também em s_comment não adiantou porque começa com '%', então ele tem que varrer toda a tabela pra comparar tudo