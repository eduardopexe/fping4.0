-- MySQL dump 10.11
--
-- Host: 10.98.22.7    Database: noc
-- ------------------------------------------------------
-- Server version	5.0.51b

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
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `devices` (
  `cod` int(11) NOT NULL auto_increment,
  `cod_fping` varchar(255) NOT NULL default '-',
  `cod_iris` varchar(255) NOT NULL default '-',
  `igxa` varchar(255) NOT NULL default '-',
  `igxa_porta` varchar(255) NOT NULL default '-',
  `igxb` varchar(255) NOT NULL default '-',
  `igxb_portb` varchar(255) NOT NULL default '-',
  `origem` varchar(255) NOT NULL default '-',
  `hostname` varchar(255) default NULL,
  `interface` varchar(255) default NULL,
  `ip` varchar(50) default NULL,
  `mfr_a` varchar(255) NOT NULL,
  `housing_a` varchar(255) NOT NULL,
  `hostname_remoto` varchar(255) NOT NULL default '-',
  `interface_remoto` varchar(255) NOT NULL default '-',
  `ip_remoto` varchar(255) NOT NULL default '-',
  `mfr_b` varchar(255) NOT NULL,
  `housing_b` varchar(255) NOT NULL,
  `descricao` varchar(255) default NULL,
  `servico` varchar(50) default NULL,
  `envia_email` varchar(255) NOT NULL,
  `user_up` varchar(255) NOT NULL,
  `data_up` datetime NOT NULL,
  `user_inc` varchar(255) NOT NULL,
  `obs` varchar(255) NOT NULL,
  `endereco_b` varchar(255) NOT NULL,
  `endereco_a` varchar(255) NOT NULL,
  `vel` varchar(255) NOT NULL,
  `designacao_link` varchar(255) NOT NULL,
  `designacao_link_b` varchar(255) NOT NULL,
  `tipo_link` varchar(255) NOT NULL,
  `operadora` varchar(255) NOT NULL,
  `operadora_b` varchar(255) NOT NULL,
  `cli` varchar(50) default NULL,
  `ativo` varchar(50) default NULL,
  `data_alm` varchar(50) default NULL,
  `st_alm` varchar(50) default NULL,
  `site` varchar(5) default NULL,
  `site_b` varchar(50) NOT NULL default '-',
  `uf` char(2) default NULL,
  `uf_b` varchar(50) NOT NULL default '-',
  `data_inc` datetime NOT NULL default '0000-00-00 00:00:00',
  `atualizado_por` varchar(250) NOT NULL default '',
  `ip_loopback_host` varchar(80) NOT NULL default '-.-.-.-',
  `ip_loopback_host_b` varchar(80) NOT NULL default '-',
  `ipdest` varchar(80) NOT NULL default '-.-.-.-',
  `ipdest_b` varchar(80) NOT NULL default '-',
  `ipdest_hex` varchar(80) NOT NULL default '-',
  `ipdest_hex_b` varchar(80) NOT NULL default '-',
  `id_int` int(5) default '1',
  `pings` int(5) default '100',
  `tam_pct` int(5) default '100',
  `lim_rtt_avg` int(5) default '100',
  `lim_rtt_max` int(5) default '200',
  `lim_descartes` int(5) default '5',
  `ping_snmp` char(2) NOT NULL default 'n',
  `atualizar_snmp_ping` char(2) NOT NULL default 'y',
  `fping` varchar(255) NOT NULL default '-',
  `rtt` varchar(255) NOT NULL default '-',
  `mnemo_hostname` varchar(50) NOT NULL default '-',
  `mnemo_hostname_remoto` varchar(50) NOT NULL default '-',
  `id_int_b` int(5) NOT NULL default '1',
  `e1_a` varchar(255) NOT NULL default '-',
  `e1_b` varchar(255) NOT NULL default '-',
  `nome_cliente` varchar(255) NOT NULL default '-',
  `nsr` varchar(80) NOT NULL default '-',
  `vrf` varchar(80) NOT NULL default '-',
  `inf_cadastro` varchar(80) NOT NULL default 'nover',
  `turno_resp_a` varchar(5) NOT NULL default 'todos',
  `turno_resp_b` varchar(5) NOT NULL default 'todos',
  PRIMARY KEY  (`cod`)
) ENGINE=MyISAM AUTO_INCREMENT=16608 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-07-29 21:22:24
