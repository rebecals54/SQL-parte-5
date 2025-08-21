--Subquery: Servem para consultar dados de outras consultas
--Tipos: WHERE, WITH, FROM, SELECT

--Exemplo 1: Subquery no WHERE. Informe qual é o veículo mais barato da tabela products:

select *
from sales.products
where price = (select min(price) from sales.products)
--sempre que utilizar a subquery no where, ela só poderá
-- retornar um único valor.


--Exemplo 2: Subquery with. Calcule a idade médias dos clientes por status profissional
with alguma_tabela as (select
	professional_status,
	(current_date-birth_date)/365 as idade
from sales.customers)

select	
	professional_status,
	avg (idade) as idade_media
from alguma_tabela
group by professional_status 
-- nesse caso, alguma_tabela é a subquery

select
	professional_status,
	(current_date-birth_date)/365 as idade
from sales.customers

--Exemplo 3: Subquery from .Calcule a média de idade dos
-- por status profissional:

select	
	professional_status,
	avg (idade) as idade_media
from (select
	professional_status,
	(current_date-birth_date)/365 as idade
from sales.customers)

group by professional_status 

--Exemplo 4: Subquery no select. Na Tabela sales.funnel
-- crie uma coluna que informe o n° de visitas acumuladas
-- que a loja visitada recebeu até o momento:

select
	fun.visit_id,
	fun.visit_page_date,
	sto.store_name,
	(select count(*)  from sales.funnel as fun2
	where fun2.visit_page_date <= fun.visit_page_date
		and fun2.store_id = fun.store_id
	) as visitas_acumuladas
from sales.funnel as fun
left join sales.stores as sto
	on fun.store_id = sto.store_id
order by sto.store_name, fun.visit_page_date

-- Subquery no select é pesada, por isso demora a rodar.
--rodando linha por linha , entender melhor. Obs: só podem retornar um dado

--RESUMO:
--(1)Servem para consultar dados de outras consultas.
--(2)Para que as subqueries no WHERE e no SELECT funcionem, elas devem 
-- retornar apenas um único valor.
--(3)Não é recomendado utilizar subqueries diretamente dentro do FROM  pois 
-- dificulta a legibilidade da query.
--obs: não recomendado a subquery no from por motivos de organização.

