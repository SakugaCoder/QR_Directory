-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-03-2020 a las 18:51:38
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

--
-- Volcado de datos para la tabla `hojas_mantenimiento`
--

INSERT INTO `hojas_mantenimiento` (`id`, `id_material`, `anio`) VALUES
(1, '1234-001-ABCD', 2020),
(2, '1234-001-ABCD', 2019),
(12, '1234-001-ABCD', 2021),
(13, '1234-001-ABCD', 2020),
(14, 'PELA-001-CABL', 2020),
(15, 'PELA-001-CABL', 2020),
(16, 'PELA-001-CABL', 2020),
(17, 'PELA-001-CABL', 2020);

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

--
-- Volcado de datos para la tabla `lista_actividades`
--

INSERT INTO `lista_actividades` (`id`, `nombre`) VALUES
(1, 'Lista para maquinas R'),
(2, 'Lista actividades #1'),
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
(14, '2020-03-10', 'diego', 'jaime', 'NINGUNO', 13),
(15, '2020-04-20', 'diego', 'jaime', 'NINGUNO', 13),
(16, '2020-03-11', 'diego', 'jaime', 'NINGUNO', 14),
(17, '2020-03-21', 'diego', 'jaime', 'NINGUNO', 14),
(18, '2020-04-08', 'diego', 'jaime', 'NINGUNO', 14),
(19, '2020-04-18', 'diego', 'jaime', 'NINGUNO', 14),
(20, '2020-05-13', 'diego', 'jaime', 'NINGUNO', 14),
(21, '2020-05-16', 'diego', 'jaime', 'NINGUNO', 14),
(22, '2020-06-16', 'diego', 'jaime', 'NINGUNO', 14),
(23, '2020-06-19', 'diego', 'jaime', 'NINGUNO', 14),
(24, '2020-07-14', 'diego', 'jaime', 'NINGUNO', 14),
(25, '2020-07-18', 'diego', 'jaime', 'NINGUNO', 14),
(26, '2020-08-11', 'diego', 'jaime', 'NINGUNO', 14),
(27, '2020-08-15', 'diego', 'jaime', 'NINGUNO', 14),
(28, '2020-09-15', 'diego', 'jaime', 'NINGUNO', 14),
(29, '2020-09-19', 'diego', 'jaime', 'NINGUNO', 14),
(30, '2020-10-13', 'diego', 'jaime', 'NINGUNO', 14),
(31, '2020-10-17', 'diego', 'jaime', 'NINGUNO', 14),
(32, '2020-11-09', 'diego', 'jaime', 'NINGUNO', 14),
(33, '2020-11-14', 'diego', 'jaime', 'NINGUNO', 14),
(34, '2020-03-11', 'diego', 'jaime', 'NINGUNO', 15),
(35, '2020-03-13', 'diego', 'jaime', 'NINGUNO', 15),
(36, '2020-03-11', 'fernando', 'nadie', 'NINGUNO', 16),
(37, '2020-03-13', 'diego', 'jaime', 'NINGUNO', 16),
(38, '2020-03-20', 'diego', 'jaime', 'NINGUNO', 16),
(39, '2020-03-17', 'diego', 'jaime', 'NINGUNO', 16),
(40, '2020-03-25', 'diego', 'jaime', 'NINGUNO', 16),
(41, '2020-03-28', 'diego', 'jaime', 'NINGUNO', 16),
(42, '2020-05-06', '', '', '', 17),
(43, '2020-05-09', '', '', '', 17);

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
(26, 14, 39, 1),
(27, 14, 40, 1),
(28, 14, 41, 0),
(29, 14, 42, 0),
(30, 14, 43, 0),
(31, 14, 44, 0),
(32, 14, 45, 0),
(33, 14, 46, 0),
(34, 14, 47, 0),
(35, 15, 39, 0),
(36, 15, 40, 0),
(37, 15, 41, 0),
(38, 15, 42, 0),
(39, 15, 43, 0),
(40, 15, 44, 0),
(41, 15, 45, 0),
(42, 15, 46, 0),
(43, 15, 47, 0),
(44, 16, 4, 0),
(45, 16, 5, 0),
(46, 16, 6, 0),
(47, 17, 4, 0),
(48, 17, 5, 0),
(49, 17, 6, 0),
(50, 18, 4, 0),
(51, 18, 5, 0),
(52, 18, 6, 0),
(53, 19, 4, 0),
(54, 19, 5, 0),
(55, 19, 6, 0),
(56, 20, 4, 0),
(57, 20, 5, 0),
(58, 20, 6, 0),
(59, 21, 4, 0),
(60, 21, 5, 0),
(61, 21, 6, 0),
(62, 22, 4, 0),
(63, 22, 5, 0),
(64, 22, 6, 0),
(65, 23, 4, 0),
(66, 23, 5, 0),
(67, 23, 6, 0),
(68, 24, 4, 0),
(69, 24, 5, 0),
(70, 24, 6, 0),
(71, 25, 4, 0),
(72, 25, 5, 0),
(73, 25, 6, 0),
(74, 26, 4, 0),
(75, 26, 5, 0),
(76, 26, 6, 0),
(77, 27, 4, 0),
(78, 27, 5, 0),
(79, 27, 6, 0),
(80, 28, 4, 0),
(81, 28, 5, 0),
(82, 28, 6, 0),
(83, 29, 4, 0),
(84, 29, 5, 0),
(85, 29, 6, 0),
(86, 30, 4, 0),
(87, 30, 5, 0),
(88, 30, 6, 0),
(89, 31, 4, 0),
(90, 31, 5, 0),
(91, 31, 6, 0),
(92, 32, 4, 0),
(93, 32, 5, 0),
(94, 32, 6, 0),
(95, 33, 4, 0),
(96, 33, 5, 0),
(97, 33, 6, 0),
(98, 34, 7, 0),
(99, 34, 8, 0),
(100, 34, 9, 0),
(101, 34, 10, 0),
(102, 35, 7, 0),
(103, 35, 8, 0),
(104, 35, 9, 0),
(105, 35, 10, 0),
(106, 36, 39, 1),
(107, 36, 40, 1),
(108, 36, 41, 1),
(109, 36, 42, 1),
(110, 36, 43, 0),
(111, 36, 44, 0),
(112, 36, 45, 0),
(113, 36, 46, 0),
(114, 36, 47, 1),
(115, 37, 39, 0),
(116, 37, 40, 0),
(117, 37, 41, 0),
(118, 37, 42, 0),
(119, 37, 43, 0),
(120, 37, 44, 0),
(121, 37, 45, 0),
(122, 37, 46, 0),
(123, 37, 47, 0),
(124, 38, 39, 0),
(125, 38, 40, 0),
(126, 38, 41, 0),
(127, 38, 42, 0),
(128, 38, 43, 0),
(129, 38, 44, 0),
(130, 38, 45, 0),
(131, 38, 46, 0),
(132, 38, 47, 0),
(133, 39, 39, 0),
(134, 39, 40, 0),
(135, 39, 41, 0),
(136, 39, 42, 0),
(137, 39, 43, 0),
(138, 39, 44, 0),
(139, 39, 45, 0),
(140, 39, 46, 0),
(141, 39, 47, 0),
(142, 40, 39, 0),
(143, 40, 40, 0),
(144, 40, 41, 0),
(145, 40, 42, 0),
(146, 40, 43, 0),
(147, 40, 44, 0),
(148, 40, 45, 0),
(149, 40, 46, 0),
(150, 40, 47, 0),
(151, 41, 39, 0),
(152, 41, 40, 0),
(153, 41, 41, 0),
(154, 41, 42, 0),
(155, 41, 43, 0),
(156, 41, 44, 0),
(157, 41, 45, 0),
(158, 41, 46, 0),
(159, 41, 47, 0),
(160, 42, 4, 1),
(161, 42, 5, 0),
(162, 42, 6, 0),
(163, 43, 4, 0),
(164, 43, 5, 0),
(165, 43, 6, 0);

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
  `hoja_mantenimiento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `material`
--

INSERT INTO `material` (`id`, `descripcion`, `marca`, `modelo`, `cantidad`, `no_pieza`, `habilitadas`, `img`, `ruta_manual`, `tipo_material`, `laboratorio`, `hoja_mantenimiento`) VALUES
('1234-001-ABCD', 'No desc', 'nobrand', '1fbsd', 2, 1, 2, NULL, NULL, 1, 1, 13),
('ASDF-001-GHIJ', 'Ociloscopio', 'ProsKit', 'PK-01', 3, 1, 2, 'assets/images/Captura de pantalla de 2020-01-16 14-18-43.png', NULL, 2, 1, NULL),
('MULT-001-TRUP', 'Multimetro truper', 'TRUPER', 'TRDS1', 10, 1, 8, 'assets/images/61QPb8o2bwL._SX425_.jpg', NULL, 3, 1, NULL),
('PELA-001-CABL', 'Pelacables', 'SAR', 'CD-01', 3, 2, 3, 'assets/images/612wjZohgJL._SY355_.jpg', 'assets/datasheets/A1dmEoq+26S.pdf', 3, 1, 17),
('TORN-001-BANC', 'Torno de Banco', 'MEC', '001', 2, 2, 2, 'assets/images/mec001-cel.jpg', 'assets/datasheets/A1dmEoq+26S.pdf', 1, 6, NULL);

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
