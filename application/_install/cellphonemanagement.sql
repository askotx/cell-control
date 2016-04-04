-- phpMyAdmin SQL Dump
-- version 4.5.5.1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 04-04-2016 a las 03:08:48
-- Versión del servidor: 5.7.11-log
-- Versión de PHP: 7.0.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `cellphonemanagement`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCellphonesReport` (IN `reportId` INT)  BEGIN
SELECT
  vw_cellphoneslog.*, report_detailed.ReportId
FROM
  report_detailed INNER JOIN
  vw_cellphoneslog
   ON report_detailed.CellPhoneId = vw_cellphoneslog.CellPhoneId
WHERE
  vw_cellphoneslog.CellStatusId = 1 AND report_detailed.ReportId = reportId
ORDER BY report_detailed.CellPhoneId ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getContactsByTerm` (IN `term` VARCHAR(64), IN `userType` INT)  BEGIN
SELECT * FROM vw_availablecontacts 
WHERE ContactName LIKE CONCAT('%', term, '%') AND RelationId = userType;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getReport` (IN `reportId` INT)  BEGIN
	SELECT * FROM vw_reports WHERE ReportId = reportId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `setCreateReport` (IN `preventerId` INT, IN `externalSellerId` INT, IN `associatedId` INT, IN `cellCompanyId` INT, IN `reportTypeId` INT)  MODIFIES SQL DATA
BEGIN
INSERT INTO reports (PreventerId,ExternalSellerId,AssociatedId,ReportTypeId,ReportStatusId) 
VALUES(preventerId,externalSellerId,associatedId,reportTypeId,1);

SET @reportId = LAST_INSERT_ID();

INSERT INTO report_detailed (ReportId,CellPhoneId) SELECT @reportId, cellphones.CellPhoneId
FROM cellphones INNER JOIN cellmovements ON cellphones.CellPhoneId = cellmovements.CellPhoneId
WHERE cellphones.CompanyId = cellCompanyId AND cellmovements.CellStatusId = 1 ORDER BY cellphones.CellPhoneId; 
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `brands`
--

CREATE TABLE `brands` (
  `BrandId` int(11) NOT NULL,
  `BrandName` varchar(24) NOT NULL DEFAULT '""'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `brands`
--

INSERT INTO `brands` (`BrandId`, `BrandName`) VALUES
(1, 'SAMSUNG'),
(2, 'LG'),
(3, 'ALCALTEL'),
(4, 'HUAWEI'),
(5, 'BMOBILE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cellmovements`
--

CREATE TABLE `cellmovements` (
  `MovementId` int(11) NOT NULL,
  `CellPhoneId` int(11) NOT NULL DEFAULT '0',
  `CellStatusId` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `cellmovements`
--

INSERT INTO `cellmovements` (`MovementId`, `CellPhoneId`, `CellStatusId`) VALUES
(1, 3, 1),
(2, 3, 2),
(3, 2, 1),
(4, 1, 1),
(5, 4, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cellphones`
--

CREATE TABLE `cellphones` (
  `CellPhoneId` int(11) NOT NULL,
  `BrandId` int(11) NOT NULL DEFAULT '0',
  `CompanyId` int(11) NOT NULL DEFAULT '0',
  `ColorId` int(11) NOT NULL DEFAULT '0',
  `Description` varchar(256) NOT NULL DEFAULT '""',
  `BarCode` varchar(16) NOT NULL DEFAULT '""'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `cellphones`
--

INSERT INTO `cellphones` (`CellPhoneId`, `BrandId`, `CompanyId`, `ColorId`, `Description`, `BarCode`) VALUES
(1, 3, 2, 2, '0T4009A', '48944612304'),
(2, 2, 2, 2, 'Neon', '750201256781'),
(3, 4, 2, 2, 'Y530', '750201256731');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `colors`
--

CREATE TABLE `colors` (
  `ColorId` int(11) NOT NULL,
  `ColorName` varchar(16) NOT NULL DEFAULT '""'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `colors`
--

INSERT INTO `colors` (`ColorId`, `ColorName`) VALUES
(1, 'Blanco'),
(2, 'Negro'),
(3, 'Dorado'),
(4, 'Azul');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contacts`
--

CREATE TABLE `contacts` (
  `ContactId` int(11) NOT NULL,
  `ContactName` varchar(32) NOT NULL DEFAULT '""',
  `Type` int(11) NOT NULL DEFAULT '0',
  `StatusId` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `contacts`
--

INSERT INTO `contacts` (`ContactId`, `ContactName`, `Type`, `StatusId`) VALUES
(1, 'Administrador', 1, 1),
(2, 'María', 1, 1),
(3, 'Minerva', 1, 1),
(4, 'Sandra', 1, 1),
(5, 'Kareli', 1, 1),
(6, 'Laura', 1, 1),
(7, 'Andrea', 1, 1),
(8, 'Tadeo', 1, 1),
(9, 'Víctor', 1, 1),
(10, 'Mayday', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `external_companies`
--

CREATE TABLE `external_companies` (
  `CompanyId` int(11) NOT NULL,
  `CompanyName` varchar(32) NOT NULL DEFAULT '""'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `external_companies`
--

INSERT INTO `external_companies` (`CompanyId`, `CompanyName`) VALUES
(1, 'Telcel'),
(2, 'Movistar');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `relations`
--

CREATE TABLE `relations` (
  `RelationId` int(11) NOT NULL,
  `RelationShortDescription` varchar(64) NOT NULL DEFAULT '""',
  `RelationLongDescription` varchar(256) NOT NULL DEFAULT '""',
  `RelationStatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `relations`
--

INSERT INTO `relations` (`RelationId`, `RelationShortDescription`, `RelationLongDescription`, `RelationStatus`) VALUES
(1, 'System.Manager', 'Administrador de Sistema', 1),
(2, 'System.Internal.Electronic', 'Departamento de Electrónica', 1),
(3, 'System.Internal.Grosery', 'Departamento de Abarrotes', 1),
(4, 'System.Internal.Toys', 'Departamento de Juguetería', 1),
(5, 'System.Internal.Security', 'Departamento de Prevencion', 1),
(6, 'System.External.CellCompany.Seller', 'Vendedor Externo de Telefonía', 1),
(7, 'System.External.Store', 'Empresa Externa', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `relations_assignments`
--

CREATE TABLE `relations_assignments` (
  `RelationsAssignmentId` int(11) NOT NULL,
  `RelationId` int(11) NOT NULL DEFAULT '0',
  `ContactId` int(11) NOT NULL DEFAULT '0',
  `AssignmentStatus` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `relations_assignments`
--

INSERT INTO `relations_assignments` (`RelationsAssignmentId`, `RelationId`, `ContactId`, `AssignmentStatus`) VALUES
(1, 5, 2, 1),
(2, 5, 3, 1),
(3, 5, 4, 1),
(4, 6, 5, 1),
(5, 6, 6, 1),
(6, 2, 7, 1),
(7, 2, 8, 1),
(8, 2, 9, 1),
(9, 2, 10, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reports`
--

CREATE TABLE `reports` (
  `ReportId` int(11) NOT NULL,
  `PreventerId` int(11) NOT NULL DEFAULT '0',
  `ExternalSellerId` int(11) NOT NULL DEFAULT '0',
  `AssociatedId` int(11) NOT NULL DEFAULT '0',
  `ReportTypeId` int(11) NOT NULL DEFAULT '0',
  `ReportStatusId` int(11) NOT NULL DEFAULT '0',
  `ReportDateInit` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ReportDateFinish` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `reports`
--

INSERT INTO `reports` (`ReportId`, `PreventerId`, `ExternalSellerId`, `AssociatedId`, `ReportTypeId`, `ReportStatusId`, `ReportDateInit`, `ReportDateFinish`) VALUES
(1, 2, 6, 7, 1, 1, '2016-03-13 22:08:42', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `report_detailed`
--

CREATE TABLE `report_detailed` (
  `ReportDetailedId` int(11) NOT NULL,
  `ReportId` int(11) NOT NULL DEFAULT '0',
  `CellPhoneId` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `report_detailed`
--

INSERT INTO `report_detailed` (`ReportDetailedId`, `ReportId`, `CellPhoneId`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `request_query`
--

CREATE TABLE `request_query` (
  `QueryId` int(11) NOT NULL,
  `QueryName` varchar(64) NOT NULL DEFAULT '""',
  `KeyField` varchar(16) NOT NULL DEFAULT '""'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `request_query`
--

INSERT INTO `request_query` (`QueryId`, `QueryName`, `KeyField`) VALUES
(1, 'vw_reports', 'ReportId');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `status_types`
--

CREATE TABLE `status_types` (
  `StatusId` int(11) NOT NULL,
  `TypeId` int(11) NOT NULL DEFAULT '0',
  `SubType` int(11) NOT NULL DEFAULT '0',
  `Description` varchar(16) NOT NULL DEFAULT '""'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `status_types`
--

INSERT INTO `status_types` (`StatusId`, `TypeId`, `SubType`, `Description`) VALUES
(1, 1, 1, 'Disponible'),
(2, 2, 1, 'Vendido'),
(3, 3, 1, 'Robado'),
(4, 1, 2, 'Activo'),
(5, 2, 2, 'Inactivo'),
(6, 3, 2, 'Suspendido'),
(7, 1, 3, 'Entrega'),
(8, 2, 3, 'Recepción'),
(9, 3, 3, 'Forzado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `UserId` int(11) NOT NULL,
  `UserNickname` varchar(16) NOT NULL DEFAULT '""',
  `UserPassword` varchar(16) NOT NULL DEFAULT '""',
  `UserComments` varchar(32) NOT NULL DEFAULT '""',
  `UserStatus` int(11) NOT NULL DEFAULT '0',
  `CreateDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `PasswordExpirationDate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ContactId` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_availablecontacts`
--
CREATE TABLE `vw_availablecontacts` (
`ContactName` varchar(32)
,`RelationLongDescription` varchar(256)
,`ContactId` int(11)
,`RelationId` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_cellphoneslog`
--
CREATE TABLE `vw_cellphoneslog` (
`BrandName` varchar(24)
,`CompanyName` varchar(32)
,`ColorName` varchar(16)
,`Description` varchar(256)
,`StatusDescription` varchar(16)
,`BarCode` varchar(16)
,`CellPhoneId` int(11)
,`BrandId` int(11)
,`CompanyId` int(11)
,`ColorId` int(11)
,`MovementId` int(11)
,`CellStatusId` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_phonemodels`
--
CREATE TABLE `vw_phonemodels` (
`BrandName` varchar(24)
,`CompanyName` varchar(32)
,`ColorName` varchar(16)
,`Description` varchar(256)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_reports`
--
CREATE TABLE `vw_reports` (
`ReportId` int(11)
,`PreventerName` varchar(32)
,`ElectronicAssociateName` varchar(32)
,`ExternalSellerName` varchar(32)
,`ReporType` varchar(16)
,`ReportTypeId` int(11)
,`PreventerId` int(11)
,`ExternalSellerId` int(11)
,`AssociatedId` int(11)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_availablecontacts`
--
DROP TABLE IF EXISTS `vw_availablecontacts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_availablecontacts`  AS  select `contacts`.`ContactName` AS `ContactName`,`relations`.`RelationLongDescription` AS `RelationLongDescription`,`contacts`.`ContactId` AS `ContactId`,`relations`.`RelationId` AS `RelationId` from ((`contacts` join `relations_assignments` on((`relations_assignments`.`ContactId` = `contacts`.`ContactId`))) join `relations` on((`relations_assignments`.`RelationId` = `relations`.`RelationId`))) where ((`contacts`.`StatusId` = 1) and (`relations_assignments`.`AssignmentStatus` = 1) and (`relations`.`RelationStatus` = 1)) order by `relations`.`RelationId`,`contacts`.`ContactId` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_cellphoneslog`
--
DROP TABLE IF EXISTS `vw_cellphoneslog`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_cellphoneslog`  AS  select `brands`.`BrandName` AS `BrandName`,`external_companies`.`CompanyName` AS `CompanyName`,`colors`.`ColorName` AS `ColorName`,`cellphones`.`Description` AS `Description`,`status_types`.`Description` AS `StatusDescription`,`cellphones`.`BarCode` AS `BarCode`,`cellphones`.`CellPhoneId` AS `CellPhoneId`,`cellphones`.`BrandId` AS `BrandId`,`cellphones`.`CompanyId` AS `CompanyId`,`cellphones`.`ColorId` AS `ColorId`,`cellmovements`.`MovementId` AS `MovementId`,`cellmovements`.`CellStatusId` AS `CellStatusId` from (((((`cellphones` join `brands` on((`cellphones`.`BrandId` = `brands`.`BrandId`))) join `external_companies` on((`external_companies`.`CompanyId` = `cellphones`.`CompanyId`))) join `colors` on((`colors`.`ColorId` = `cellphones`.`ColorId`))) join `cellmovements` on((`cellphones`.`CellPhoneId` = `cellmovements`.`CellPhoneId`))) join `status_types` on((`cellmovements`.`CellStatusId` = `status_types`.`TypeId`))) where (`status_types`.`SubType` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_phonemodels`
--
DROP TABLE IF EXISTS `vw_phonemodels`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_phonemodels`  AS  select `brands`.`BrandName` AS `BrandName`,`external_companies`.`CompanyName` AS `CompanyName`,`colors`.`ColorName` AS `ColorName`,`cellphones`.`Description` AS `Description` from (((`cellphones` join `brands` on((`cellphones`.`BrandId` = `brands`.`BrandId`))) join `external_companies` on((`external_companies`.`CompanyId` = `cellphones`.`CompanyId`))) join `colors` on((`colors`.`ColorId` = `cellphones`.`ColorId`))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_reports`
--
DROP TABLE IF EXISTS `vw_reports`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_reports`  AS  select `reports`.`ReportId` AS `ReportId`,`preventers`.`ContactName` AS `PreventerName`,`electronicdeptassociates`.`ContactName` AS `ElectronicAssociateName`,`externalsellers`.`ContactName` AS `ExternalSellerName`,`status_types`.`Description` AS `ReporType`,`reports`.`ReportTypeId` AS `ReportTypeId`,`reports`.`PreventerId` AS `PreventerId`,`reports`.`ExternalSellerId` AS `ExternalSellerId`,`reports`.`AssociatedId` AS `AssociatedId` from ((((`reports` join `contacts` `preventers` on((`reports`.`PreventerId` = `preventers`.`ContactId`))) join `contacts` `externalsellers` on((`externalsellers`.`ContactId` = `reports`.`ExternalSellerId`))) join `contacts` `electronicdeptassociates` on((`reports`.`AssociatedId` = `electronicdeptassociates`.`ContactId`))) join `status_types` on((`reports`.`ReportTypeId` = `status_types`.`TypeId`))) where (`status_types`.`SubType` = 3) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`BrandId`);

--
-- Indices de la tabla `cellmovements`
--
ALTER TABLE `cellmovements`
  ADD PRIMARY KEY (`MovementId`);

--
-- Indices de la tabla `cellphones`
--
ALTER TABLE `cellphones`
  ADD PRIMARY KEY (`CellPhoneId`);

--
-- Indices de la tabla `colors`
--
ALTER TABLE `colors`
  ADD PRIMARY KEY (`ColorId`);

--
-- Indices de la tabla `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`ContactId`);

--
-- Indices de la tabla `external_companies`
--
ALTER TABLE `external_companies`
  ADD PRIMARY KEY (`CompanyId`);

--
-- Indices de la tabla `relations`
--
ALTER TABLE `relations`
  ADD PRIMARY KEY (`RelationId`);

--
-- Indices de la tabla `relations_assignments`
--
ALTER TABLE `relations_assignments`
  ADD PRIMARY KEY (`RelationsAssignmentId`);

--
-- Indices de la tabla `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`ReportId`);

--
-- Indices de la tabla `report_detailed`
--
ALTER TABLE `report_detailed`
  ADD PRIMARY KEY (`ReportDetailedId`);

--
-- Indices de la tabla `request_query`
--
ALTER TABLE `request_query`
  ADD PRIMARY KEY (`QueryId`);

--
-- Indices de la tabla `status_types`
--
ALTER TABLE `status_types`
  ADD PRIMARY KEY (`StatusId`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserId`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `brands`
--
ALTER TABLE `brands`
  MODIFY `BrandId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `cellmovements`
--
ALTER TABLE `cellmovements`
  MODIFY `MovementId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `cellphones`
--
ALTER TABLE `cellphones`
  MODIFY `CellPhoneId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `colors`
--
ALTER TABLE `colors`
  MODIFY `ColorId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT de la tabla `contacts`
--
ALTER TABLE `contacts`
  MODIFY `ContactId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT de la tabla `external_companies`
--
ALTER TABLE `external_companies`
  MODIFY `CompanyId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `relations`
--
ALTER TABLE `relations`
  MODIFY `RelationId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT de la tabla `relations_assignments`
--
ALTER TABLE `relations_assignments`
  MODIFY `RelationsAssignmentId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT de la tabla `reports`
--
ALTER TABLE `reports`
  MODIFY `ReportId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `report_detailed`
--
ALTER TABLE `report_detailed`
  MODIFY `ReportDetailedId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `request_query`
--
ALTER TABLE `request_query`
  MODIFY `QueryId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `status_types`
--
ALTER TABLE `status_types`
  MODIFY `StatusId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `UserId` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
