select c_count, count(*) as custdist from (select c_custkey, count(o_orderkey) as c_count from CUSTOMER left outer join ORDERS on c_custkey = o_custkey and o_comment not like '%pending%deposits%' group by c_custkey) c_orders group by c_count order by custdist desc, c_count desc;
-- tempo anterior: 0:00:2,85282803


-- Nenhum indice ajudou nesse caso. Indice sobre o_comment não ajudou porque não era um "=", e porque começava com %. 
-- O indice em cima de c_custkey não fez diferença, o plano de execução já fazia um full index scan em cima da chave primaria,
-- pra ele usar esse criado tive que usar o force index e não fez modificação nenhuma no tempo nem no plano de execução
-- O indice em cima de o_orderkey também não fez diferença porque já estava fazendo um non-unique key lookup na tabela orders usando a FK