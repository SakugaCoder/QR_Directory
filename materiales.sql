-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-03-2020 a las 17:09:26
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `asignar_actividades` (IN `id_mat` VARCHAR(30), IN `anio` INT, IN `la` INT, IN `lista_fechas` TEXT(200))  BEGIN
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
    INSERT INTO lista_actividades_programadas VALUES (NULL,fecha_final,"diego","jaime","NINGUNO",@id_hoja_mantenimiento);
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

--
-- Volcado de datos para la tabla `hojas_mantenimiento`
--

INSERT INTO `hojas_mantenimiento` (`id`, `id_material`, `anio`) VALUES
(1, '1234-001-ABCD', 2020),
(2, '1234-001-ABCD', 2019),
(12, '1234-001-ABCD', 2021);

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
(1, 'LT1 - LABORATORIO DE MANUFACTURA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lista_actividades`
--

CREATE TABLE `lista_actividades` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `lista_actividades`
--

INSERT INTO `lista_actividades` (`id`, `nombre`) VALUES
(1, 'Lista para maquinas R'),
(2, 'Lista actividades #1'),
(4, 'ListaPrueba'),
(5, 'Nolist'),
(6, 'Test2'),
(7, 'Test3'),
(8, 'Test4'),
(9, 'Test5'),
(10, 'Test6'),
(11, 'Test7'),
(12, 'Nombre lista 1'),
(13, 'NL10'),
(14, 'Lista14'),
(15, 'Rectificadora');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lista_actividades_detalle`
--

CREATE TABLE `lista_actividades_detalle` (
  `id` bigint(20) NOT NULL,
  `lista_actividades` int(11) NOT NULL,
  `actividad` tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `lista_actividades_detalle`
--

INSERT INTO `lista_actividades_detalle` (`id`, `lista_actividades`, `actividad`) VALUES
(4, 1, 'Tornillos limpios'),
(5, 1, 'Engranes funcionando'),
(6, 1, 'Maquina limpia'),
(7, 2, 'act1'),
(8, 2, 'act2'),
(9, 2, 'act3'),
(10, 2, 'act4'),
(15, 4, 'A1'),
(16, 4, 'A2'),
(17, 4, 'A3'),
(18, 5, 'na 11'),
(19, 5, 'na 12'),
(20, 5, 'na 13'),
(21, 5, 'na 14'),
(22, 6, 'activity 1'),
(23, 6, 'activity 2'),
(24, 7, 'actidsavity as'),
(25, 7, 'ascads 2'),
(26, 8, 'actidsavity as'),
(27, 9, 'gasgasdasd'),
(28, 10, 'a1'),
(29, 11, 'a1'),
(30, 11, 'a2'),
(31, 12, 'Des a 1'),
(32, 12, 'Des a 2'),
(33, 13, 'da1'),
(34, 13, 'da2'),
(35, 13, 'da3'),
(36, 14, 'd1'),
(37, 14, 'd2'),
(38, 14, 'd3'),
(39, 15, 'Tapa de contenedor de refrigerante se encuentra en buenas condiciones'),
(40, 15, 'Contenedor cuenta con refrigerante a nivel'),
(41, 15, 'Contenedor de refrigerante se encuentra limpio'),
(42, 15, 'Parte Exterior de maquina limpio'),
(43, 15, 'Modulo de controladores y botoneras en buenas condiciones'),
(44, 15, 'Piedra de rectificado se encuentra en buenas condiciones'),
(45, 15, 'Tapon de contenedor de aceite se encuentra en buenas condiciones'),
(46, 15, 'Tablero Electrico y conexiones en buenas condiciones'),
(47, 15, 'El nivel de aceite hidraulico se encuentra dentro del parametro de nivel');

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

--
-- Volcado de datos para la tabla `lista_actividades_programadas`
--

INSERT INTO `lista_actividades_programadas` (`id`, `fecha`, `realizo`, `revizo`, `comentarios`, `hoja_mantenimiento`) VALUES
(10, '2020-02-11', 'Realizo', 'Revizo', 'ninguno', 12),
(11, '2020-03-11', 'nulo realizo', 'nulo revizo', 'nulo comentarios', 12),
(12, '2020-04-11', 'v2', 'v1', 'v3', 12),
(13, '2020-05-11', NULL, NULL, NULL, 12);

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

--
-- Volcado de datos para la tabla `lista_actividades_programadas_detalle`
--

INSERT INTO `lista_actividades_programadas_detalle` (`id`, `lista_actividades_programadas`, `actividad_detalle`, `terminada`) VALUES
(10, 10, 7, 1),
(11, 10, 8, 1),
(12, 10, 9, 0),
(13, 10, 10, 0),
(14, 11, 7, 1),
(15, 11, 8, 1),
(16, 11, 9, 1),
(17, 11, 10, 1),
(18, 12, 7, 0),
(19, 12, 8, 1),
(20, 12, 9, 1),
(21, 12, 10, 0),
(22, 13, 7, 1),
(23, 13, 8, 1),
(24, 13, 9, 1),
(25, 13, 10, 1);

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
  `habilitadas` int(11) DEFAULT NULL,
  `img` text DEFAULT NULL,
  `ruta_manual` text DEFAULT NULL,
  `tipo_material` int(11) DEFAULT NULL,
  `laboratorio` int(11) DEFAULT NULL,
  `hoja_mantenimiento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `material`
--

INSERT INTO `material` (`id`, `descripcion`, `marca`, `modelo`, `cantidad`, `habilitadas`, `img`, `ruta_manual`, `tipo_material`, `laboratorio`, `hoja_mantenimiento`) VALUES
('1234-001-ABCD', 'No desc', 'nobrand', '1fbsd', 2, 2, NULL, NULL, 1, 1, 12),
('ASDF-001-GHIJ', 'Ociloscopio', 'ProsKit', 'PK-01', 3, 2, 'assets/images/Captura de pantalla de 2020-01-16 14-18-43.png', NULL, 2, 1, NULL),
('MUL-001-TIMET', 'Multimetro truper', 'TRUPER', 'TRDS1', 10, 8, 'assets/images/61QPb8o2bwL._SX425_.jpg', NULL, 3, 1, NULL),
('PELA-001-CABL', 'Pelacables', 'SAR', 'CD-01', 3, 3, 'assets/images/612wjZohgJL._SY355_.jpg', NULL, 3, 1, NULL);

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
  ADD KEY `lista_actividades` (`lista_actividades`);

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
  ADD KEY `lista_actividades_programadas` (`lista_actividades_programadas`),
  ADD KEY `actividad_detalle` (`actividad_detalle`);

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
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `hojas_mantenimiento`
--
ALTER TABLE `hojas_mantenimiento`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `laboratorio`
--
ALTER TABLE `laboratorio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `lista_actividades_programadas_detalle`
--
ALTER TABLE `lista_actividades_programadas_detalle`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `tipo_material`
--
ALTER TABLE `tipo_material`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
  ADD CONSTRAINT `lista_actividades_detalle_ibfk_1` FOREIGN KEY (`lista_actividades`) REFERENCES `lista_actividades` (`id`);

--
-- Filtros para la tabla `lista_actividades_programadas`
--
ALTER TABLE `lista_actividades_programadas`
  ADD CONSTRAINT `lista_actividades_programadas_ibfk_1` FOREIGN KEY (`hoja_mantenimiento`) REFERENCES `hojas_mantenimiento` (`id`);

--
-- Filtros para la tabla `lista_actividades_programadas_detalle`
--
ALTER TABLE `lista_actividades_programadas_detalle`
  ADD CONSTRAINT `lista_actividades_programadas_detalle_ibfk_1` FOREIGN KEY (`lista_actividades_programadas`) REFERENCES `lista_actividades_programadas` (`id`),
  ADD CONSTRAINT `lista_actividades_programadas_detalle_ibfk_2` FOREIGN KEY (`actividad_detalle`) REFERENCES `lista_actividades_detalle` (`id`);

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
