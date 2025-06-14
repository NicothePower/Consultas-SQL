--1. Crea el esquema de la BBDD.
--2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
--Este enunciado está mal hecho, he puesto un comentario en el proyecto para que resuelvan mi duda pero aún asi, está mal redactado. No hay ninguna clasificación por edades.
--3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
SELECT
	CONCAT("first_name", ' ', "last_name") AS "Actor_name",
	"actor_id"
FROM
	"actor"
WHERE
	"actor_id" > 30
	AND "actor_id" < 40;

--4. Obtén las películas cuyo idioma coincide con el idioma original.
SELECT
	*
FROM
	"film"
WHERE
	"language_id" = "original_language_id";

--5. Ordena las películas por duración de forma ascendente.
SELECT
	*
FROM
	"film"
ORDER BY
	"length" DESC;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
SELECT
	CONCAT ("first_name", ' ', "last_name") AS "Actor_name"
FROM
	"actor"
WHERE
	"last_name" ilike '%Allen%';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
--Al no existir una clasificacion en la tabla fil, utilizo la columna rating
SELECT
	"rating",
	COUNT("film_id") AS "total_films"
FROM
	"film"
GROUP BY
	"rating"
ORDER BY
	"total_films" DESC;

--8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
SELECT
	"title",
	"rating",
	"length"
FROM
	"film"
WHERE
	"rating" = 'PG-13'
	OR "length" > 180;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT
	ROUND(VARIANCE ("replacement_cost"), 2) as "Varianza_remplazo_peliculas" --mantengo solo dos decimales
from
	"film";

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT
	MIN("length") AS "Duración_minima",
	MAX("length") AS "Duración_maxima"
FROM
	"film";

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT
	"rental_rate",
	"rental_date"
FROM
	(
		-- Creo una subconsulta uniendo las tres tablas film, inventory y rental
		SELECT
			f."rental_rate",
			i."film_id",
			r."rental_date"
		FROM
			"film" f
			INNER JOIN "inventory" i ON f."film_id" = i."film_id"
			INNER JOIN "rental" r ON i."inventory_id" = r."inventory_id"
	)
ORDER BY
	"rental_date" DESC OFFSET 2
LIMIT
	1;

--12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.
SELECT
	"title"
FROM
	"film"
WHERE
	"rating" NOT IN ('NC-17', 'G');

/*13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y 
 muestra la clasificación junto con el promedio de duración.*/
SELECT
	"rating",
	AVG("length") AS "duracion_promedio"
FROM
	"film"
GROUP BY
	"rating"
ORDER BY
	"duracion_promedio" DESC;

--les ordeno por promedio más alto para que sea más facil analizar resultados
--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
SELECT
	"title",
	"length" --Agrego el titulo y la duracion
FROM
	"film"
WHERE
	"length" > 180
ORDER BY
	"length" DESC;

--Ordeno para que sea más facil analizar de mas a menos
--15. ¿Cuánto dinero ha generado en total la empresa?--
select
	SUM("Total") AS "Dinero_total"
FROM
	"Invoice";

--16. Muestra los 10 clientes con mayor valor de id.--
SELECT
	"CustomerId" AS "Mayor_ids"
FROM
	"Invoice"
GROUP BY
	"CustomerId" -- Añado esto para evitar tener clientes duplicados, pus pueden tener mas de una invoice
ORDER BY
	"CustomerId" DESC
LIMIT
	10;

--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.--
SELECT
	"Nombre_actor",
	"title"
FROM
	(
		SELECT
			f."title",
			fa."actor_id",
			CONCAT(a."first_name", ' ', a."last_name") AS "Nombre_actor"
		FROM
			"film" f
			JOIN "film_actor" fa ON f."film_id" = fa."film_id"
			JOIN "actor" a ON fa."actor_id" = a."actor_id"
	) AS sub
WHERE
	UPPER ("title") = UPPER ('Egg Igby');

--Convierto en mayuscula para que me de el valor exacto
--18. Selecciona todos los nombres de las películas únicos.--
SELECT
	DISTINCT "title"
FROM
	"film";

/*19. Encuentra el título de las películas que son comedias y tienen una
 duración mayor a 180 minutos en la tabla “film”.*/
SELECT
	"title",
	"name",
	"length"
FROM
	(
		-- Subconsulta que une film, film_category y category
		SELECT
			f."title",
			f."length",
			fc."category_id",
			c."name"
		FROM
			"film" f
			JOIN "film_category" fc ON f."film_id" = fc."film_id"
			JOIN "category" c ON fc."category_id" = c."category_id"
	) AS sub
WHERE
	"name" = 'Comedy'
	AND "length" > 180;

/*20. Encuentra las categorías de películas que tienen un promedio de
 duración superior a 110 minutos y muestra el nombre de la categoría
 junto con el promedio de duración.*/
SELECT
	c."name",
	AVG(f."length") AS "duracion_promedio"
FROM
	"film" f
	JOIN "film_category" fc ON f."film_id" = fc."film_id"
	JOIN "category" c ON fc."category_id" = c."category_id"
GROUP BY
	c."name"
HAVING
	AVG(f."length") > 110;

/* 21. ¿Cuál es la media de duración del alquiler de las películas? */
SELECT
	AVG("rental_duration") AS "duracion_promedio_alquiler"
FROM
	"film";

/* 22. Crea una columna con el nombre y apellidos de todos los actores y actrices. */
SELECT
	CONCAT("first_name", ' ', "last_name") as "Nombre_y_Apellido"
FROM
	"actor";

/* 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente. */
SELECT
	"rental_date",
	COUNT("rental_id") as "Total_alquileres"
FROM
	"rental"
GROUP BY
	"rental_date"
ORDER BY
	"Total_alquileres" DESC;

/* 24. Encuentra las películas con una duración superior al promedio. */
SELECT
	"title",
	"length" --Agrego el titulo y la duracion
FROM
	"film"
WHERE
	"length" > (
		--uso una subconsulta con WHERE
		SELECT
			AVG("length")
		FROM
			"film"
	);

/* 25. Averigua el número de alquileres registrados por mes. */
SELECT
	DATE_TRUNC('month', "rental_date") AS "Mes",
	--Utilizo DATE_TRUC para sacar el mes de la fecha
	TO_CHAR("rental_date", 'MonthYYYY') AS "Mes_nombre",
	-- Tambie nquiero ver el nombre del mes
	COUNT("rental_id") AS "Total_alquileres"
FROM
	"rental"
GROUP BY
	1,
	2
ORDER BY
	"Mes";

/* 26. Encuentra el promedio, la desviación estándar y varianza del total pagado. */
SELECT
	AVG("amount") AS "Promedio",
	STDDEV("amount") AS "Desviacion",
	VARIANCE("amount") AS "Varianza"
FROM
	"payment";

/* 27. ¿Qué películas se alquilan por encima del precio medio? */
SELECT
	f."film_id",
	f."title",
	AVG(p."amount") AS "precio_medio"
FROM
	"film" f
	JOIN "inventory" i ON f."film_id" = i."film_id"
	JOIN "rental" r ON i."inventory_id" = r."inventory_id"
	JOIN "payment" p ON r."rental_id" = p."rental_id"
WHERE
	EXISTS (
		-- Uso EXISTS primero para agrupar las peliculas que tienen al menos un alquiler superior al precio medio
		SELECT
			1
		FROM
			"payment" p2
		WHERE
			p2."rental_id" = r."rental_id"
			AND p2."amount" > (
				SELECT
					AVG("amount")
				FROM
					"payment"
			)
	)
GROUP BY
	f."film_id",
	f."title"
ORDER BY
	"precio_medio" DESC;

/* 28. Muestra el id de los actores que hayan participado en más de 40 películas. */
SELECT
	"actor_id",
	COUNT("film_id") AS "Total_peliculas"
FROM
	"film_actor"
GROUP BY
	"actor_id"
HAVING
	COUNT("film_id") > 40;

/* 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible. */
SELECT
	f."title",
	f."film_id",
	COUNT(i."inventory_id") AS "cantidad_disponible"
FROM
	"film" f
	LEFT JOIN "inventory" i ON f."film_id" = i."film_id"
GROUP BY
	f."title",
	f."film_id";

/* 30. Obtener los actores y el número de películas en las que ha actuado. */
--En este caso puedo usar una subconsulta con select
select
	CONCAT ("first_name", ' ', "last_name") AS "nombre_actor",
	"actor_id",
	(
		select
			count("film_id") --Obtengo aqui el numero de peliculas por cada actor
		from
			"film_actor"
		where
			"actor"."actor_id" = "film_actor"."actor_id"
	) as "peliculas_por_artista"
from
	"actor"
order by
	"peliculas_por_artista" DESC;

/* 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados. */
SELECT
	f."title",
	f."film_id",
	CONCAT (a."first_name", ' ', a."last_name") AS "nombre_actor",
	fa."actor_id"
FROM
	"film" f
	LEFT JOIN "film_actor" fa ON f."film_id" = fa."film_id"
	LEFT JOIN "actor" a ON fa."actor_id" = a."actor_id"
ORDER BY
	f."film_id";

--Para ver cada pelicula con la lista de actores a su derecha
/* 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película. */
SELECT
	a."actor_id",
	CONCAT (a."first_name", ' ', a."last_name") AS "nombre_actor",
	fa."film_id",
	f."title"
FROM
	"actor" a
	LEFT JOIN "film_actor" fa ON a."actor_id" = fa."actor_id"
	LEFT JOIN "film" f ON fa."film_id" = f."film_id"
ORDER BY
	a."actor_id";

--Para ver cada actor con la lista de peliculas a su derecha
/* 33. Obtener todas las películas que tenemos y todos los registros de alquiler. */
SELECT
	f."title",
	f."film_id",
	r."rental_id",
	r."rental_date" --Agrego tambien la fecha para ver cuando se alquilo
FROM
	"film" f
	JOIN "inventory" i ON f."film_id" = i."film_id"
	LEFT JOIN "rental" r ON i."inventory_id" = r."inventory_id"
ORDER BY
	f."film_id",
	r."rental_id";

/* 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros. */
SELECT
	"customer_id",
	SUM("amount") AS "gasto_total"
FROM
	"payment"
GROUP BY
	"customer_id"
ORDER BY
	"gasto_total" DESC
LIMIT
	5;

/* 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'. */
SELECT
	CONCAT ("first_name", ' ', "last_name") AS "nombre_actor",
	"actor_id"
FROM
	"actor"
WHERE
	"first_name" ILIKE 'Johnny';

-- Uso ILIKE para incluir mayusculas y minusculas
/* 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido. */
SELECT
	"first_name" AS "Nombre",
	"last_name" AS "Apellido",
	"actor_id"
FROM
	"actor";

/* 37. Encuentra el ID del actor más bajo y más alto en la tabla actor. */
SELECT
	MAX("actor_id") AS "ID_mas_alto",
	MIN("actor_id") AS "ID_mas_bajo"
FROM
	"actor";

/* 38. Cuenta cuántos actores hay en la tabla “actor”. */
SELECT
	COUNT("actor_id") AS "Total_actores"
FROM
	"actor";

/* 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente. */
SELECT
	"first_name",
	"last_name"
FROM
	"actor"
ORDER BY
	"last_name" ASC;

/* 40. Selecciona las primeras 5 películas de la tabla “film”. */
SELECT
	"title",
	"film_id"
FROM
	"film"
LIMIT
	5;

/* 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el 
 mismo nombre. ¿Cuál es el nombre más repetido? */
--Hay cuatro nombres más repetidos: KENNETH, PENELOPE Y JULIA con 4 repeticiones
SELECT
	"first_name",
	COUNT("actor_id") AS "Total"
FROM
	"actor"
GROUP BY
	"first_name"
ORDER BY
	"Total" DESC;

/* 42. Encuentra todos los alquileres y los nombres de los clientes que los
 realizaron. */
SELECT
	r."rental_id",
	r."customer_id",
	CONCAT(c."first_name", ' ', c."last_name") AS "Nombres_clientes"
FROM
	"rental" r
	JOIN "customer" c ON r."customer_id" = c."customer_id";

/* 43. Muestra todos los clientes y sus alquileres si existen, incluyendo
 aquellos que no tienen alquileres. */
SELECT
	CONCAT(c."first_name", ' ', c."last_name") AS "Nombres_clientes",
	r."customer_id",
	r."rental_id",
	r."rental_date" --Agrego fecha para tener un diferenciador mas claro
FROM
	"customer" c
	LEFT JOIN "rental" r ON c."customer_id" = r."customer_id"
ORDER BY
	"Nombres_clientes";

--Ordeno por cliente para ver los alquileres de cada uno mas ordenadamente
/* 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor
 esta consulta? ¿Por qué? Deja después de la consulta la contestación. */
SELECT
	*
FROM
	"film" f
	CROSS JOIN "category" c;

/*Esto no aporta valor alguno porque es un tipo de join que devuelve el producto cartesiano de las dos tablas. 
 Esto significa que cada fila de la primera tabla se combina con cada fila de la segunda tabla, 
 sin ninguna condición que relacione las tablas.
 
 Lo que nos interesaría es tner una tabla intermedia que relaciona las dos tablas en nuestro esquema, es oya lo tenemos con film_category, 
 lo cual es mucho más util para buscar relaciones en las películas y categories,  por lo que un cross join no nos aporta nada extra
 
 */
/* 45. Encuentra los actores que han participado en películas de la categoría
 'Action'. */
--En este caso voy a usar una Vista temporal--
CREATE VIEW Artista_de_accion AS
SELECT
	c."name" AS "categoria",
	fc."film_id",
	fa."actor_id",
	a."first_name",
	a."last_name"
FROM
	"category" c
	JOIN "film_category" fc ON c."category_id" = fc."category_id"
	JOIN "film_actor" fa ON fc."film_id" = fa."film_id"
	JOIN "actor" a ON fa."actor_id" = a."actor_id";

/*Despues de crear la view, de ahi obtengo los actores en la categoria acción*/
SELECT
	DISTINCT -- Para NO repetir el nombre si uno actuo en más d euna pelicula de accion
	"first_name",
	"last_name"
FROM
	"Artista_de_accion"
WHERE
	"categoria" ILIKE 'Action';

/* 46. Encuentra todos los actores que no han participado en películas. */
SELECT
	"first_name",
	"last_name"
FROM
	"actor"
WHERE
	NOT EXISTS (
		-- Uso una subconsulta NO exist para ver los que NO tengan una pelicula asociada
		SELECT
			1
		FROM
			"film_actor"
		WHERE
			"film_actor"."actor_id" = "actor"."actor_id"
	);

/* 47. Selecciona el nombre de los actores y la cantidad de películas en las
 que han participado. */
SELECT
	"first_name",
	"last_name",
	(
		SELECT
			COUNT("film_id") -- Uso una subconsulta con SELECT para contar el total de peliculas por actor
		FROM
			"film_actor"
		WHERE
			"film_actor"."actor_id" = "actor"."actor_id"
	) AS "Total_peliculas"
FROM
	"actor"
ORDER BY
	"Total_peliculas" DESC;

/* 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres
 de los actores y el número de películas en las que han participado. */
CREATE VIEW actor_num_peliculas AS
SELECT
	"first_name",
	"last_name",
	(
		SELECT
			COUNT("film_id") -- Uso una subconsulta con SELECT para contar el total de peliculas por actor
		FROM
			"film_actor"
		WHERE
			"film_actor"."actor_id" = "actor"."actor_id"
	) AS "Total_peliculas"
FROM
	"actor";

/*Luego veo que hay dentro de la view*/
SELECT
	*
FROM
	"actor_num_peliculas";

/* 49. Calcula el número total de alquileres realizados por cada cliente. */
SELECT
	c."first_name",
	c."last_name",
	c."customer_id",
	COUNT(r."rental_id") AS "Total_alquileres"
FROM
	"customer" c
	JOIN "rental" r ON c."customer_id" = r."customer_id"
GROUP BY
	c."first_name",
	c."last_name",
	c."customer_id"
ORDER BY
	"Total_alquileres" DESC;

/* 50. Calcula la duración total de las películas en la categoría 'Action'. */
--En este caso voy a usar una CTE para tener los datos de las peliculas, su duración y categoria--
WITH Peliculas_por_categoria AS (
	SELECT
		f."film_id",
		f."title",
		f."length",
		fc."category_id",
		c."name" AS "category"
	FROM
		"film" f
		JOIN "film_category" fc ON f."film_id" = fc."film_id"
		JOIN "category" c ON c."category_id" = fc."category_id"
)
/* Después de crear la CTE, obtengo la duración total de las películas de la categoría 'Action' */
SELECT
	"category",
	SUM("length") AS "Duracion_total"
FROM
	"Peliculas_por_categoria"
WHERE
	"category" ILIKE 'Action'
GROUP BY
	"category";

/* 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para
 almacenar el total de alquileres por cliente. */
WITH cliente_rentas_temporal AS (
	SELECT
		CONCAT(c."first_name", ' ', c."last_name") AS "nombre_cliente",
		c."customer_id",
		COUNT(r."rental_id") AS "Total_alquileres"
	FROM
		"customer" c
		JOIN "rental" r ON c."customer_id" = r."customer_id"
	GROUP BY
		c."customer_id"
)
/* Después de crear la CTE, veo lo que incluye*/
SELECT
	*
FROM
	"cliente_rentas_temporal"
ORDER BY
	"Total_alquileres" DESC;

/* 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las
 películas que han sido alquiladas al menos 10 veces. */
WITH peliculas_alquiladas AS (
	SELECT
		f."title",
		f."film_id",
		COUNT(r."rental_id") AS "Total_alquileres"
	FROM
		"rental" r
		JOIN "inventory" i ON r."inventory_id" = i."inventory_id"
		JOIN "film" f ON i."film_id" = f."film_id"
	GROUP BY
		f."film_id"
	HAVING
		COUNT(r."rental_id") > 10
)
/* Después de crear la CTE, veo lo que incluye*/
SELECT
	*
FROM
	"peliculas_alquiladas"
ORDER BY
	"Total_alquileres" DESC;

/* 53. Encuentra el título de las películas que han sido alquiladas por el cliente
 con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
 los resultados alfabéticamente por título de película. */
/*Creo una tabla temporal primero con las peliculas alquiladas no devueltas*/
WITH peliculas_no_devueltas AS (
	SELECT
		f."title",
		f."film_id",
		r."return_date",
		r."customer_id"
	FROM
		"rental" r
		JOIN "inventory" i ON r."inventory_id" = i."inventory_id"
		JOIN "film" f ON i."film_id" = f."film_id"
	WHERE
		r."return_date" IS NULL
)
/*Luego junto la tabla temporal creada con la de customer para buscar el nombre del cliente y las peliculas no devueltas*/
SELECT
	CONCAT(c."first_name", ' ', c."last_name") AS "Nombre_cliente",
	p."title",
	p."return_date"
FROM
	"customer" c
	JOIN peliculas_no_devueltas p ON c."customer_id" = p."customer_id"
WHERE
	CONCAT(c."first_name", ' ', c."last_name") ILIKE 'Tammy Sanders'
ORDER BY
	p."title" ASC;

/* 54. Encuentra los nombres de los actores que han actuado en al menos una
 película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
 alfabéticamente por apellido */
--En este caso voy a usar una Vista temporal--
CREATE VIEW Actor_de_SciFi AS
SELECT
	c."name" AS "categoria",
	fc."film_id",
	fa."actor_id",
	a."first_name",
	a."last_name"
FROM
	"category" c
	JOIN "film_category" fc ON c."category_id" = fc."category_id"
	JOIN "film_actor" fa ON fc."film_id" = fa."film_id"
	JOIN "actor" a ON fa."actor_id" = a."actor_id";

/*Despues de crear la view, de ahi obtengo los actores en la categoria acción*/
SELECT
	DISTINCT -- Para NO repetir el nombre si uno actuo en más de una pelicula de Sci-Fi
	"first_name",
	"last_name"
FROM
	"Actor_de_SciFi"
WHERE
	"categoria" ILIKE 'Sci-Fi'
ORDER BY
	"last_name";

-- Ordenar alfabéticamente por apellido;
/* 55. Encuentra el nombre y apellido de los actores que han actuado en
 películas que se alquilaron después de que la película ‘Spartacus
 Cheaper’ se alquilara por primera vez. Ordena los resultados
 alfabéticamente por apellido. */
/*---Utilizo en este caso dos CTE y las cruzo para encontra rlso resultados*/
WITH peliculas_alquiladas AS (
	--CTE para crear una tabla con todos los campos necesarios unidos
	SELECT
		a."first_name",
		a."last_name",
		fa."actor_id",
		f."title",
		f."film_id",
		r."rental_date"
	FROM
		"rental" r
		JOIN "inventory" i ON r."inventory_id" = i."inventory_id"
		JOIN "film" f ON i."film_id" = f."film_id"
		JOIN "film_actor" fa ON f."film_id" = fa."film_id"
		JOIN "actor" a ON fa."actor_id" = a."actor_id"
),
fecha_spartacus AS (
	--CTE para saber la fecha minima en la que se alquilo 'Spartacus Cheaper'
	SELECT
		MIN(r."rental_date") AS "primera_fecha"
	FROM
		"rental" r
		JOIN "inventory" i ON r."inventory_id" = i."inventory_id"
		JOIN "film" f ON i."film_id" = f."film_id"
	WHERE
		f."title" = 'Spartacus Cheaper'
)
SELECT
	DISTINCT pa."first_name",
	pa."last_name"
FROM
	peliculas_alquiladas pa
	JOIN fecha_spartacus fs ON pa."rental_date" > fs."primera_fecha"
ORDER BY
	pa."last_name" DESC;

/* 56. Encuentra el nombre y apellido de los actores que no han actuado en
 ninguna película de la categoría ‘Music’. */
SELECT
	"first_name",
	"last_name"
FROM
	"actor" a
WHERE
	NOT EXISTS (
		--Con NOT EXISTS excluyo aquellos para los que existe al menos una película asociada cuya categoría es 'Music'
		SELECT
			1
		FROM
			"film_actor" fa
			JOIN "film_category" fc ON fa."film_id" = fc."film_id"
			JOIN "category" c ON fc."category_id" = c."category_id"
		WHERE
			fa."actor_id" = a."actor_id"
			AND c."name" ILIKE 'Music'
	);

/* 57. Encuentra el título de todas las películas que fueron alquiladas por más
 de 8 días. */
SELECT
	f."title",
	EXTRACT(
		DAY
		FROM
			r."return_date" - r."rental_date"
	) AS "dias_alquiler"
FROM
	"rental" r
	JOIN "inventory" i ON r."inventory_id" = i."inventory_id"
	JOIN "film" f ON i."film_id" = f."film_id"
WHERE
	r."rental_id" IN(
		-- Utilizo una subconsulta con WHERE de las peliculas que fueron alquiladas por mas de 8 dias
		SELECT
			"rental_id"
		FROM
			"rental"
		WHERE
			EXTRACT(
				DAY
				FROM
					"return_date" - "rental_date"
			) > 8
	);

/* 58. Encuentra el título de todas las películas que son de la misma categoría
 que ‘Animation’. */
SELECT
	"title",
	"name" AS "category"
FROM
	"film" f
	JOIN "film_category" fc ON f."film_id" = f."film_id"
	JOIN "category" c ON fc."category_id" = c."category_id"
WHERE
	"name" ILIKE 'Animation'
	/* 59. Encuentra los nombres de las películas que tienen la misma duración
	 que la película con el título ‘Dancing Fever’. Ordena los resultados
	 alfabéticamente por título de película. */
SELECT
	"title",
	"length"
FROM
	"film"
WHERE
	"length" > (
		SELECT
			"length"
		FROM
			"film"
		WHERE
			"title" ILIKE 'Dancing Fever'
	);

/* 60. Encuentra los nombres de los clientes que han alquilado al menos 7
 películas distintas. Ordena los resultados alfabéticamente por apellido. */
SELECT
	c."first_name",
	c."last_name",
	COUNT(DISTINCT i."film_id") AS "peliculas_distintas"
FROM
	"rental" r
	JOIN "customer" c ON r."customer_id" = c."customer_id"
	JOIN "inventory" i ON r."inventory_id" = i."inventory_id"
GROUP BY
	c."customer_id",
	c."first_name",
	c."last_name"
HAVING
	COUNT(DISTINCT i."film_id") >= 7
ORDER BY
	c."last_name" ASC;

/* 61. Encuentra la cantidad total de películas alquiladas por categoría y
 muestra el nombre de la categoría junto con el recuento de alquileres. */
SELECT
	c."name" AS "category",
	COUNT(r."rental_id") AS "recuento_alquileres"
FROM
	"rental" r
	JOIN "inventory" i ON r."inventory_id" = i."inventory_id"
	JOIN "film" f ON i."film_id" = f."film_id"
	JOIN "film_category" fc ON f."film_id" = fc."film_id"
	JOIN "category" c ON fc."category_id" = c."category_id"
GROUP BY
	"category";

/* 62. Encuentra el número de películas por categoría estrenadas en 2006. */
SELECT
	c."name" AS "category",
	COUNT(f."film_id") AS "recuento_peliculas"
FROM
	"film" f
	JOIN "film_category" fc ON f."film_id" = fc."film_id"
	JOIN "category" c ON fc."category_id" = c."category_id"
WHERE
	f."release_year" = 2006
GROUP BY
	"category";

/* 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas
 que tenemos. */
--USO UN CROOS JOIN que me da el producto cartesiano de las dos tablas
select
	*
from
	"staff"
	cross join "store";

/* 64. Encuentra la cantidad total de películas alquiladas por cada cliente y
 muestra el ID del cliente, su nombre y apellido junto con la cantidad de
 películas alquiladas. */
SELECT
	c."first_name",
	c."last_name",
	c."customer_id",
	COUNT(r."rental_id") AS "Total_alquileres"
FROM
	"customer" c
	JOIN "rental" r ON c."customer_id" = r."customer_id"
GROUP BY
	c."first_name",
	c."last_name",
	c."customer_id"
ORDER BY
	"Total_alquileres" DESC;