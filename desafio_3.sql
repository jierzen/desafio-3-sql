--1. SETUP: Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido. (1 Punto)

CREATE DATABASE desafio3_jorge_espinoza_001;

\c desafio3_jorge_espinoza_001;

CREATE TABLE usuario(
	id SERIAL,
	email VARCHAR,
	nombre VARCHAR,
	apellido VARCHAR,
	rol VARCHAR
);

INSERT INTO usuario (email,nombre,apellido,rol) VALUES 
('jorge.espinoza@gmail.com','Jorge','Espinoza','admin'),
('oddjamie@gmail.com','Jamie','Odd','developer'),
('lenny_fuix@gmail.com','Lenny','Fuix','developer'),
('gerkepi12@gmail.com','Gerard','Kepi','developer'),
('fgril99@gmail.com','Fernando','Gril','junior');

CREATE TABLE post(
	id SERIAL,
	titulo VARCHAR,
	contenido TEXT,
	fecha_creacion TIMESTAMP,
	fecha_actualizacion TIMESTAMP,
	destacado BOOLEAN,
	usuario_id BIGINT
);

INSERT INTO post (titulo,contenido,fecha_creacion,fecha_actualizacion,destacado,usuario_id) VALUES 
('Introducción a Docker','Aprende a utilizar Docker desde cero.','2024-04-10 10:00:00','2024-04-10 10:30:00',true,2),
('Desarrollo Web con Flask','Construye aplicaciones web rápidas con Flask.','2024-03-15 09:20:00','2024-03-15 09:45:00',false,3),
('Inteligencia Artificial explicada','Entender los conceptos básicos de la IA.','2024-02-20 08:15:00','2024-02-20 08:45:00',true,4),
('Fundamentos de Machine Learning','Introducción a los modelos de Machine Learning.','2024-01-25 14:00:00','2024-01-25 14:30:00',true,1),
('Blockchain y sus aplicaciones','Cómo Blockchain está revolucionando el mundo.','2024-05-05 16:00:00','2024-05-05 16:25:00',false,2),
('Principios de la programación funcional','Aprende programación funcional con ejemplos.','2024-06-10 11:00:00','2024-06-10 11:20:00',true,3),
('Guía de GIT para principiantes','Control de versiones con GIT.','2024-07-15 09:00:00','2024-07-15 09:30:00',false,4),
('SEO y Marketing Digital','Optimiza tu sitio web para motores de búsqueda.','2024-08-20 15:00:00','2024-08-20 15:30:00',true,1),
('Desarrollo de videojuegos con Unity','Crea tu primer juego con Unity.','2024-09-25 17:00:00','2024-09-25 17:30:00',false,2),
('Seguridad Informática básica','Protege tu información en línea.','2024-10-30 12:00:00','2024-10-30 12:30:00',true,3);

CREATE TABLE comentario(
	id SERIAL,
	contenido TEXT,
	fecha_creacion TIMESTAMP,
	usuario_id BIGINT,
	post_id BIGINT
);

INSERT INTO comentario(contenido,fecha_creacion,usuario_id,post_id) VALUES
('El Docker es una herramienta esencial hoy en día.','2024-04-11 08:20:00',4,6),
('Me encanta Flask por su simplicidad.','2024-03-16 10:15:00',1,7),
('La IA es el futuro.','2024-02-21 07:45:00',2,8),
('Machine Learning cambia la forma en que vemos la tecnología.','2024-01-26 13:50:00',3,9),
('Blockchain podría ser más disruptivo que el internet.','2024-05-06 15:35:00',1,10),
('La programación funcional hace que el código sea más limpio.','2024-06-11 10:50:00',4,11),
('GIT es fundamental para el trabajo en equipo.','2024-07-16 08:30:00',2,12),
('Sin SEO, tu sitio web es invisible para el mundo.','2024-08-21 14:10:00',3,13),
('Unity es increíblemente poderoso para desarrolladores independientes.','2024-09-26 16:45:00',1,14),
('La seguridad informática no debe tomarse a la ligera.','2024-10-31 11:30:00',4,15),
('Creo que Machine Learning es el futuro.','2024-01-27 13:50:00',2,9);

--2.Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: 
--nombre y email del usuario junto al título y contenido del post. (1 Punto)

SELECT u.nombre, u.email, p.titulo, p.contenido 
FROM usuario u 
INNER JOIN post p ON u.id = p.usuario_id;


--3. Muestra el id, título y contenido de los posts de los administradores. El administrador puede ser cualquier id. (1 Punto)

SELECT p.id, p.titulo, p.contenido 
FROM usuario u 
INNER JOIN post p ON u.id = p.usuario_id
WHERE u.rol = 'admin';


--4. Cuenta la cantidad de posts de cada usuario. (1 Punto)
--La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.
--Hint: Aquí hay diferencia entre utilizar inner join, left join o right join, prueba con todas y con eso determina 
--cuál es la correcta. No da lo mismo la tabla desde la que se parte.

SELECT u.id, u.email, COUNT(p.id) cantidad_posts
FROM usuario u 
INNER JOIN post p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

--PRUEBA con LEFT JOIN (Correcto porque incluye a usuarios sin posts)
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuario u 
LEFT JOIN post p ON u.id = p.usuario_id
GROUP BY u.id;


--PRUEBA CON RIGHT JOIN (incorrecto)
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuario u 
LEFT JOIN post p ON u.id = p.usuario_id
GROUP BY u.id;

--5. Muestra el email del usuario que ha creado más posts. (1 Punto)
--Aquí la tabla resultante tiene un único registro y muestra solo el email. 

SELECT u.email
FROM usuario u
JOIN post p ON u.id = p.usuario_id
GROUP BY u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;


--6. Muestra la fecha del último post de cada usuario. (1 Punto)
--Hint: Utiliza la función de agregado MAX sobre la fecha de creación.

SELECT u.email, MAX(p.fecha_creacion) AS fecha_ultimo_post
FROM usuario u 
LEFT JOIN post p ON u.id = p.usuario_id
GROUP BY u.email;


--7. Muestra el título y contenido del post (artículo) con más comentarios. (1 Punto) 

SELECT p.titulo, p.contenido
FROM post p
JOIN comentario c ON p.id = c.post_id
GROUP BY p.id, p.titulo, p.contenido
ORDER BY COUNT(c.id) DESC
LIMIT 1;


--8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, 
--junto con el email del usuario que lo escribió. (1 Punto) 

SELECT p.titulo, p.contenido AS post_contenido, c.contenido AS comentario_contenido, u.email
FROM post p
LEFT JOIN comentario c ON p.id = c.post_id
JOIN usuario u ON p.usuario_id = u.id;


--9. Muestra el contenido del último comentario de cada usuario. (1 Punto) 

SELECT u.email, c.contenido
FROM comentario c
JOIN usuario u ON c.usuario_id = u.id
WHERE c.fecha_creacion IN (
    SELECT MAX(c2.fecha_creacion)
    FROM comentario c2
    WHERE c2.usuario_id = c.usuario_id
)
GROUP BY u.email, c.contenido;

--10. Muestra los emails de los usuarios que no han escrito ningún comentario. 
--Hint: Recuerda el uso de Having (1 Punto)

SELECT u.email
FROM usuario u
LEFT JOIN comentario c ON u.id = c.usuario_id
GROUP BY u.email
HAVING COUNT(c.id) = 0;
