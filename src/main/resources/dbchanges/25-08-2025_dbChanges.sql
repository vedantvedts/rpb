
/*    ibas_dbupdates    */

DROP TABLE IF EXISTS `rpb_dbupdates`;

CREATE TABLE `rpb_dbupdates` (  
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `filename` VARCHAR(255),
  `updateDate` DATETIME,
  PRIMARY KEY (`id`) 
);

INSERT INTO rpb_dbupdates(filename,UpdateDate) VALUES('25-08-2025dbChanges.sql', NOW());
