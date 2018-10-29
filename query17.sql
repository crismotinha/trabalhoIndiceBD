select sum(l_extendedprice) / 7.0 as avg_yearly 
from LINEITEM, PART 
where p_partkey = l_partkey 
	and p_brand = 'Brand#44' 
    and p_container = 'WRAP PKG' 
    and l_quantity < (select 0.2 * avg(l_quantity) 
						from LINEITEM 
                        where l_partkey = p_partkey);
                        
-- tempo sem índice: 5,054 sec
-- full table scan em PART, utiliza índice LINEITEM_FK2 para a tabela de LINEITEM.

CREATE INDEX p_brand_idx ON PART(P_BRAND); -- pulou de full table scan para non-unique key lookup
-- tempo de execução: 4,965 sec

CREATE INDEX p_container_idx ON PART(P_CONTAINER); -- também vai pra non-unique key lookup
-- tempo de execução: 4,451 sec
-- as duas otimizam a query.
-- como outras querys tambem podem usam a p_brand, acho que manter esse índice é mais interessante, embora o outro tenha executado mais rápido.