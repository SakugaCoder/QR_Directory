-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-03-2020 a las 21:56:04
-- Versión del servidor: 10.4.11-MariaDB
-- Versión de PHP: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `materiales`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `almacenar_nuevas_actividades` (IN `Value` LONGTEXT, IN `nl` VARCHAR(100))  BEGIN
DECLARE front TEXT DEFAULT NULL;
DECLARE frontlen INT DEFAULT NULL;
DECLARE TempValue TEXT DEFAULT NULL;
DECLARE id_lista_actividades INT DEFAULT 0;

INSERT INTO lista_actividades VALUES(NULL, nl);

SET @id_lista_actividades := (SELECT MAX(id) from lista_actividades WHERE nombre = nl);

iterator:
    LOOP 
    IF LENGTH(TRIM(Value)) = 0 OR Value IS NULL THEN
    LEAVE iterator;
    END IF;
    SET front = SUBSTRING_INDEX(Value,',',1);
    SET frontlen = LENGTH(front);
    SET TempValue = TRIM(front);
    INSERT INTO lista_actividades_detalle VALUES (NULL,@id_lista_actividades,TempValue);
    SET Value = INSERT(Value,1,frontlen + 1,'');
    END LOOP;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `asignar_actividades` (IN `id_mat` VARCHAR(30), IN `anio` INT, IN `la` INT, IN `lista_fechas` TEXT)  BEGIN
  DECLARE id_hoja_mantenimiento INT;
  DECLARE id_lap INT;
  DECLARE total_actividaes INT  DEFAULT 0;
  DECLARE contador INT;
  DECLARE id_actividad_inicial INT;
  DECLARE id_actividad_final INT;

  DECLARE fecha_parcial TEXT;
  DECLARE fecha_parcial_tamanio INT;
  DECLARE fecha_final TEXT;


  INSERT INTO hojas_mantenimiento VALUES (null,id_mat,anio);
  SET @id_hoja_mantenimiento := (SELECT max(id) FROM hojas_mantenimiento WHERE id_material = id_mat);
  UPDATE material SET hoja_mantenimiento = @id_hoja_mantenimiento WHERE id = id_mat;

WHILE LENGTH(TRIM(lista_fechas)) > 0 DO
    SET fecha_parcial = SUBSTRING_INDEX(lista_fechas,",",1);
    SET fecha_parcial_tamanio = LENGTH(fecha_parcial);
    SET fecha_final = TRIM(fecha_parcial);
    INSERT INTO lista_actividades_programadas VALUES (NULL,fecha_final,"","","",@id_hoja_mantenimiento);
    SET @id_lap := (SELECT MAX(id) from lista_actividades_programadas where hoja_mantenimiento = @id_hoja_mantenimiento);
    SET @total_actividaes := (SELECT count(id) from lista_actividades_detalle WHERE lista_actividades = la);
    SET @id_actividad_inicial := (SELECT min(id) from lista_actividades_detalle WHERE lista_actividades = la);
    SET @id_actividad_final := (@id_actividad_inicial + @total_actividaes - 1);
    SET @contador := @id_actividad_inicial;

    
    WHILE @contador <= @id_actividad_final DO
      INSERT INTO lista_actividades_programadas_detalle VALUES(null,@id_lap,@contador,0);
      SET @contador = @contador + 1;
    END WHILE;

    SET lista_fechas = INSERT(lista_fechas,1,fecha_parcial_tamanio + 1, "");
  
  END WHILE;
  /*FIn creación actividades programadas*/

  SELECT @id_hoja_mantenimiento,@id_lap,@total_actividaes,@id_actividad_inicial,@id_actividad_final,@contador;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hojas_mantenimiento`
--

CREATE TABLE `hojas_mantenimiento` (
  `id` bigint(20) NOT NULL,
  `id_material` varchar(30) DEFAULT NULL,
  `anio` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `laboratorio`
--

CREATE TABLE `laboratorio` (
  `id` int(11) NOT NULL,
  `nombre_laboratorio` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `laboratorio`
--

INSERT INTO `laboratorio` (`id`, `nombre_laboratorio`) VALUES
(1, 'LT1 - LABORATORIO DE MANUFACTURA'),
(2, 'LT1 - LABORATORIO DE ELECTRONICA'),
(3, 'EDIFICIO A - LABORATORIO DE QUIMICA'),
(4, 'EDIFICIO A - LABORATORIO MULTIDICIPLINARIO'),
(5, 'LT2 - TALLER AUTOMOTRIZ'),
(6, 'EDIFICIO C - OFICINA'),
(7, 'EDIFICIO C - LABORATORIO DE REDES'),
(8, 'EDIFICIO C - LABORATORIO TELEMATICA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lista_actividades`
--

CREATE TABLE `lista_actividades` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lista_actividades_detalle`
--

CREATE TABLE `lista_actividades_detalle` (
  `id` bigint(20) NOT NULL,
  `lista_actividades` int(11) NOT NULL,
  `actividad` tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lista_actividades_programadas`
--

CREATE TABLE `lista_actividades_programadas` (
  `id` int(11) NOT NULL,
  `fecha` date DEFAULT NULL,
  `realizo` varchar(60) DEFAULT NULL,
  `revizo` varchar(60) DEFAULT NULL,
  `comentarios` tinytext DEFAULT NULL,
  `hoja_mantenimiento` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lista_actividades_programadas_detalle`
--

CREATE TABLE `lista_actividades_programadas_detalle` (
  `id` bigint(20) NOT NULL,
  `lista_actividades_programadas` int(11) NOT NULL,
  `actividad_detalle` bigint(20) NOT NULL,
  `terminada` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `material`
--

CREATE TABLE `material` (
  `id` varchar(30) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  `marca` varchar(80) DEFAULT NULL,
  `modelo` varchar(80) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `no_pieza` int(100) NOT NULL,
  `habilitadas` int(11) DEFAULT NULL,
  `img` text DEFAULT NULL,
  `ruta_manual` text DEFAULT NULL,
  `tipo_material` int(11) DEFAULT NULL,
  `laboratorio` int(11) DEFAULT NULL,
  `hoja_mantenimiento` int(11) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_material`
--

CREATE TABLE `tipo_material` (
  `id` int(11) NOT NULL,
  `nombre_material` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tipo_material`
--

INSERT INTO `tipo_material` (`id`, `nombre_material`) VALUES
(1, 'Maquinaria'),
(2, 'Equipo'),
(3, 'Herramienta');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `password`) VALUES
(1, 'AdminQRDir', '$2y$10$iGbW2qUHqT7/G0cuFWcvJuyKg7Dju.VtZXhs82auZhRUvN9L5ZkRm');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `hojas_mantenimiento`
--
ALTER TABLE `hojas_mantenimiento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_material` (`id_material`);

--
-- Indices de la tabla `laboratorio`
--
ALTER TABLE `laboratorio`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `lista_actividades`
--
ALTER TABLE `lista_actividades`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `lista_actividades_detalle`
--
ALTER TABLE `lista_actividades_detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lista_actividades_detalle_ibfk_1` (`lista_actividades`);

--
-- Indices de la tabla `lista_actividades_programadas`
--
ALTER TABLE `lista_actividades_programadas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hoja_mantenimiento` (`hoja_mantenimiento`);

--
-- Indices de la tabla `lista_actividades_programadas_detalle`
--
ALTER TABLE `lista_actividades_programadas_detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lista_actividades_programadas_detalle_ibfk_1` (`lista_actividades_programadas`),
  ADD KEY `lista_actividades_programadas_detalle_ibfk_2` (`actividad_detalle`);

--
-- Indices de la tabla `material`
--
ALTER TABLE `material`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tipo_material` (`tipo_material`),
  ADD KEY `laboratorio` (`laboratorio`),
  ADD KEY `hoja_mantenimiento` (`hoja_mantenimiento`);

--
-- Indices de la tabla `tipo_material`
--
ALTER TABLE `tipo_material`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `hojas_mantenimiento`
--
ALTER TABLE `hojas_mantenimiento`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `laboratorio`
--
ALTER TABLE `laboratorio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `lista_actividades`
--
ALTER TABLE `lista_actividades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `lista_actividades_detalle`
--
ALTER TABLE `lista_actividades_detalle`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT de la tabla `lista_actividades_programadas`
--
ALTER TABLE `lista_actividades_programadas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT de la tabla `lista_actividades_programadas_detalle`
--
ALTER TABLE `lista_actividades_programadas_detalle`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=166;

--
-- AUTO_INCREMENT de la tabla `tipo_material`
--
ALTER TABLE `tipo_material`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `hojas_mantenimiento`
--
ALTER TABLE `hojas_mantenimiento`
  ADD CONSTRAINT `hojas_mantenimiento_ibfk_1` FOREIGN KEY (`id_material`) REFERENCES `material` (`id`);

--
-- Filtros para la tabla `lista_actividades_detalle`
--
ALTER TABLE `lista_actividades_detalle`
  ADD CONSTRAINT `lista_actividades_detalle_ibfk_1` FOREIGN KEY (`lista_actividades`) REFERENCES `lista_actividades` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `lista_actividades_programadas`
--
ALTER TABLE `lista_actividades_programadas`
  ADD CONSTRAINT `lista_actividades_programadas_ibfk_1` FOREIGN KEY (`hoja_mantenimiento`) REFERENCES `hojas_mantenimiento` (`id`);

--
-- Filtros para la tabla `lista_actividades_programadas_detalle`
--
ALTER TABLE `lista_actividades_programadas_detalle`
  ADD CONSTRAINT `lista_actividades_programadas_detalle_ibfk_1` FOREIGN KEY (`lista_actividades_programadas`) REFERENCES `lista_actividades_programadas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `lista_actividades_programadas_detalle_ibfk_2` FOREIGN KEY (`actividad_detalle`) REFERENCES `lista_actividades_detalle` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `material`
--
ALTER TABLE `material`
  ADD CONSTRAINT `material_ibfk_1` FOREIGN KEY (`tipo_material`) REFERENCES `tipo_material` (`id`),
  ADD CONSTRAINT `material_ibfk_2` FOREIGN KEY (`laboratorio`) REFERENCES `laboratorio` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
