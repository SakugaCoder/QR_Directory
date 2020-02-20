

CREATE DATABASE materiales;


CREATE TABLE tipo_material(
    id INT PRIMARY KEY,
    nombre_material VARCHAr(100)
);

CREATE TABLE laboratorio(
    id INT PRIMARY KEY,
    nombre_laboratorio VARCHAR(150)
);

CREATE TABLE material(
    id VARCHAR(20) PRIMARY KEY,
    descripcion VARCHAR(150),
    marca VARCHAR(80),
    modelo VARCHAR(80),
    cantidad INT,
    habilitadas INT,
    img text(400),
    manual_ text(400),
    tipo_material INT,
    laboratorio INT,
    hoja_mantenimiento INT,
    FOREIGN KEY(tipo_material) REFERENCES tipo_material(id),
    FOREIGN KEY(laboratorio) REFERENCES laboratorio(id)
);

CREATE TABLE hoja_mantenimiento(
    anio BIGINT PRIMARY KEY,
    fecha_creacion DATE,
);

CREATE TABLE actividades_mantenimiento(
    id INT PRIMARY KEY,
    descripcion_revision TEXT(300),
    semana_mantenimiento VARCHAR(30),
    comentarios TEXT(300),
    revizo VARCHAR(100),
    realizada BOOLEAN,
    hoja_mantenimiento INT,
    FOREIGN KEY hoja_mantenimiento REFERENCES hoja_mantenimiento(anio)
);

create table actividades_mantenimiento( id bigint primary key auto_increment, descripcion_revision text(300), semana_mantenimiento varchar(30), comentarios text(300), revizo boolean, hoja_mantenimiento int, foreign key(hoja_mantenimiento) references hoja_mantenimiento(anio));