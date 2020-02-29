-- MySQL dump 10.13  Distrib 5.7.29, for Linux (x86_64)
--
-- Host: localhost    Database: materiales
-- ------------------------------------------------------
-- Server version	5.7.29-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `actividades_mantenimiento`
--

DROP TABLE IF EXISTS `actividades_mantenimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actividades_mantenimiento` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `descripcion_revision` text,
  `semana_mantenimiento` varchar(30) DEFAULT NULL,
  `comentarios` text,
  `revizo` tinyint(1) DEFAULT NULL,
  `hoja_mantenimiento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hoja_mantenimiento` (`hoja_mantenimiento`),
  CONSTRAINT `actividades_mantenimiento_ibfk_1` FOREIGN KEY (`hoja_mantenimiento`) REFERENCES `hoja_mantenimiento` (`anio`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actividades_mantenimiento`
--

LOCK TABLES `actividades_mantenimiento` WRITE;
/*!40000 ALTER TABLE `actividades_mantenimiento` DISABLE KEYS */;
/*!40000 ALTER TABLE `actividades_mantenimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hoja_mantenimiento`
--

DROP TABLE IF EXISTS `hoja_mantenimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hoja_mantenimiento` (
  `anio` int(11) NOT NULL,
  `fecha_creacion` date DEFAULT NULL,
  PRIMARY KEY (`anio`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hoja_mantenimiento`
--

LOCK TABLES `hoja_mantenimiento` WRITE;
/*!40000 ALTER TABLE `hoja_mantenimiento` DISABLE KEYS */;
/*!40000 ALTER TABLE `hoja_mantenimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `laboratorio`
--

DROP TABLE IF EXISTS `laboratorio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `laboratorio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_laboratorio` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `laboratorio`
--

LOCK TABLES `laboratorio` WRITE;
/*!40000 ALTER TABLE `laboratorio` DISABLE KEYS */;
INSERT INTO `laboratorio` VALUES (1,'LT1 - LABORATORIO DE MANUFACTURA');
/*!40000 ALTER TABLE `laboratorio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material`
--

DROP TABLE IF EXISTS `material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `material` (
  `id` varchar(30) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  `marca` varchar(80) DEFAULT NULL,
  `modelo` varchar(80) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `habilitadas` int(11) DEFAULT NULL,
  `img` text,
  `ruta_manual` text,
  `tipo_material` int(11) DEFAULT NULL,
  `laboratorio` int(11) DEFAULT NULL,
  `hoja_mantenimiento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tipo_material` (`tipo_material`),
  KEY `laboratorio` (`laboratorio`),
  CONSTRAINT `material_ibfk_1` FOREIGN KEY (`tipo_material`) REFERENCES `tipo_material` (`id`),
  CONSTRAINT `material_ibfk_2` FOREIGN KEY (`laboratorio`) REFERENCES `laboratorio` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material`
--

LOCK TABLES `material` WRITE;
/*!40000 ALTER TABLE `material` DISABLE KEYS */;
INSERT INTO `material` VALUES ('1234-001-ABCD','No desc','nobrand','1fbsd',2,2,NULL,NULL,1,1,NULL),('ASDF-001-GHIJ','Ociloscopio','ProsKit','PK-01',3,2,'assets/images/Captura de pantalla de 2020-01-16 14-18-43.png',NULL,2,1,NULL);
/*!40000 ALTER TABLE `material` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_material`
--

DROP TABLE IF EXISTS `tipo_material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipo_material` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_material` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_material`
--

LOCK TABLES `tipo_material` WRITE;
/*!40000 ALTER TABLE `tipo_material` DISABLE KEYS */;
INSERT INTO `tipo_material` VALUES (1,'Maquinaria'),(2,'Equipo'),(3,'Herramienta');
/*!40000 ALTER TABLE `tipo_material` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-02-19 16:34:14
