

# Aprendendo Subqueries em SQL

As **subqueries** são consultas dentro de outras consultas. Elas permitem extrair dados de uma tabela e usar os resultados em outra operação SQL. Existem diferentes formas de utilizá-las: **WHERE, WITH, FROM e SELECT**.

---

## Tipos de Subquery

### 1️⃣ Subquery no WHERE

Retorna apenas um valor e é usada para filtrar resultados.

**Exemplo:** Encontrar o veículo mais barato na tabela `products`

```sql
select *
from sales.products
where price = (select min(price) from sales.products);
```

> ⚠️ Subqueries no WHERE devem retornar **apenas um valor**.

---

### 2️⃣ Subquery WITH

Permite criar tabelas temporárias para organizar melhor as consultas.

**Exemplo:** Calcular a idade média dos clientes por status profissional

```sql
with alguma_tabela as (
    select
        professional_status,
        (current_date - birth_date)/365 as idade
    from sales.customers
)
select
    professional_status,
    avg(idade) as idade_media
from alguma_tabela
group by professional_status;
```

---

### 3️⃣ Subquery FROM

Cria uma tabela derivada diretamente na cláusula FROM.

**Exemplo:** Calcular a idade média dos clientes por status profissional

```sql
select
    professional_status,
    avg(idade) as idade_media
from (
    select
        professional_status,
        (current_date - birth_date)/365 as idade
    from sales.customers
) as sub
group by professional_status;
```

> ⚠️ Não é recomendado abusar desse tipo, pois dificulta a leitura da query.

---

### 4️⃣ Subquery no SELECT

Cria colunas calculadas a partir de outras consultas.

**Exemplo:** Número de visitas acumuladas por loja na tabela `funnel`

```sql
select
    fun.visit_id,
    fun.visit_page_date,
    sto.store_name,
    (select count(*)
     from sales.funnel as fun2
     where fun2.visit_page_date <= fun.visit_page_date
       and fun2.store_id = fun.store_id
    ) as visitas_acumuladas
from sales.funnel as fun
left join sales.stores as sto
    on fun.store_id = sto.store_id
order by sto.store_name, fun.visit_page_date;
```

> ⚠️ Subqueries no SELECT podem ser **pesadas e lentas**, pois são executadas linha a linha.

---

## ✅ Resumo sobre Subqueries

1. Servem para consultar dados de outras consultas.
2. Subqueries no **WHERE** e **SELECT** devem retornar apenas **um valor**.
3. Evite usar subqueries diretamente no **FROM**, pois prejudica a legibilidade.

