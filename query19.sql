select sum(l_extendedprice* (1 - l_discount)) as revenue 
from LINEITEM, PART
where 	(p_partkey = l_partkey 
			and p_brand = 'Brand#52' 
            and p_container in ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG') 
            and l_quantity >= 4 
            and l_quantity <= 4 + 10 
            and p_size between 1 and 5 
            and l_shipmode in ('AIR', 'AIR REG') 
            and l_shipinstruct = 'DELIVER IN PERSON') 
		or (p_partkey = l_partkey 
			and p_brand = 'Brand#11' 
            and p_container in ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK') 
            and l_quantity >= 18 
            and l_quantity <= 18 + 10 
            and p_size between 1 and 10
            and l_shipmode in ('AIR', 'AIR REG') 
            and l_shipinstruct = 'DELIVER IN PERSON' ) 
		or (p_partkey = l_partkey 
			and p_brand = 'Brand#51' 
            and p_container in ('LG CASE', 'LG BOX', 'LG PACK', 'LG PKG') 
            and l_quantity >= 29 
            and l_quantity <= 29 + 10
            and p_size between 1 and 15 
            and l_shipmode in ('AIR', 'AIR REG') 
            and l_shipinstruct = 'DELIVER IN PERSON');
            
-- tempo sem índices: 0,914 sec
-- faz full scan em PART e non-unique key lookup scan em LINEITEM
-- a criação de índices em cima da tabela LINEITEM não fez diferença, já que faz o non-unique lookup scan pela fk.
-- todos os índices em PART tiveram que ser forçados, e nenhum deles alterou o plano de execução.

-- forçando índex em P_SIZE, faz index range scan, o tempo de execução é 0,994 sec.
-- forçando índex em P_CONTAINER, faz index range scan, e o tempo de execução é 1,003 sec.
-- forçando índex em P_BRAND, faz index range scan, e o tempo de execução é 0,755 sec.
-- como é force index, não adianta para o propósito do trabalho
-- CREATE INDEX p_brand_idx ON PART(P_BRAND);

