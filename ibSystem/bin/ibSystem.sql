-- MySQL Script generated by MySQL Workbench
-- Wed Jul 12 14:42:54 2017
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema ibSystem
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ibSystem
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ibSystem` DEFAULT CHARACTER SET utf8 ;
USE `ibSystem` ;

-- -----------------------------------------------------
-- Table `ibSystem`.`sys_interface`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ibSystem`.`sys_interface` ;

CREATE TABLE IF NOT EXISTS `ibSystem`.`sys_interface` (
  `int_id` INT NOT NULL AUTO_INCREMENT,
  `int_name` VARCHAR(45) NOT NULL,
  `int_type` VARCHAR(45) NULL,
  `int_status` VARCHAR(45) NULL,
  `int_InitializationTime` DATETIME NULL,
  `int_InitializationStatus` VARCHAR(45) NULL,
  `int_InitializationReason` VARCHAR(45) NULL,
  `int_fssParameter` VARCHAR(300) NULL,
  `int_bssParameter` VARCHAR(300) NULL,
  `int_rssParameter` VARCHAR(300) NULL,
  `int_fssFilterXsl` LONGTEXT NULL,
  `int_fusFilterXsl` LONGTEXT NULL,
  `int_statusChangeTime` DATETIME NULL,
  `int_createUser` VARCHAR(45) NULL,
  `int_CreateTime` DATETIME NULL,
  `int_modUser` VARCHAR(45) NULL,
  `int_modTime` DATETIME NULL,
  PRIMARY KEY (`int_id`))
ENGINE = InnoDB
COMMENT = 'for interface';


-- -----------------------------------------------------
-- Table `ibSystem`.`sys_request`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ibSystem`.`sys_request` ;

CREATE TABLE IF NOT EXISTS `ibSystem`.`sys_request` (
  `req_id` INT NOT NULL,
  `req_status` VARCHAR(45) NULL,
  `req_starttime` DATETIME NULL,
  `req_endtime` DATETIME NULL,
  `req_modificationstarttime` DATETIME NULL,
  `req_requestID` VARCHAR(100) NULL,
  `req_imfmessage` LONGTEXT NULL,
  `req_mqifmessage` LONGTEXT NULL,
  `req_interfaceID` INT NULL,
  `req_interfacename` VARCHAR(45) NULL,
  `req_interfacetype` VARCHAR(45) NULL,
  `req_createTime` DATETIME NULL,
  `req_modtime` DATETIME NULL,
  `req_createuser` VARCHAR(100) NULL,
  `req_moduser` VARCHAR(100) NULL,
  PRIMARY KEY (`req_id`),
  INDEX `FK_REQ_INTERFACEID_idx` (`req_interfaceID` ASC),
  INDEX `REQ_IDX_INTERFACENAME` (`req_interfacename` ASC),
  CONSTRAINT `FK_REQ_INTERFACEID`
    FOREIGN KEY (`req_interfaceID`)
    REFERENCES `ibSystem`.`sys_interface` (`int_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ibSystem`.`log_mqifMessage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ibSystem`.`log_mqifMessage` ;

CREATE TABLE IF NOT EXISTS `ibSystem`.`log_mqifMessage` (
  `mqif_id` INT NOT NULL,
  `mqif_messageId` VARCHAR(45) NULL,
  `mqif_messageType` VARCHAR(45) NULL,
  `mqif_orgMessageType` VARCHAR(45) NULL,
  `mqif_dataType` VARCHAR(45) NULL,
  `mqif_orignator` VARCHAR(45) NULL,
  `mqif_correlationId` VARCHAR(45) NULL,
  `mqif_sender` VARCHAR(45) NULL,
  `mqif_receiver` VARCHAR(45) NULL,
  `mqif_station` VARCHAR(45) NULL,
  `mqif_internalId` VARCHAR(100) NULL,
  `mqif_createtime` DATETIME NULL,
  `mqif_content` LONGTEXT NULL,
  `mqif_turnId` VARCHAR(100) NULL,
  `mqif_arrivalId` VARCHAR(100) NULL,
  `mqif_departureId` VARCHAR(100) NULL,
  PRIMARY KEY (`mqif_id`),
  INDEX `MQIF_IDX_CORRELATIONID` (`mqif_correlationId` ASC),
  INDEX `MQIF_IDX_MESSAGEID` (`mqif_messageId` ASC),
  INDEX `MQIF_IDX_SENDER` (`mqif_sender` ASC),
  INDEX `MQIF_IDX_CREATETIME` (`mqif_createtime` ASC),
  INDEX `MQIF_IDX_INTERNALID` (`mqif_internalId` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ibSystem`.`log_imfMessage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ibSystem`.`log_imfMessage` ;

CREATE TABLE IF NOT EXISTS `ibSystem`.`log_imfMessage` (
  `imf_id` INT NOT NULL,
  `imf_messageId` VARCHAR(45) NULL,
  `imf_messageType` VARCHAR(45) NULL,
  `imf_serviceType` VARCHAR(45) NULL,
  `imf_operationMode` VARCHAR(45) NULL,
  `imf_orgCreatetime` DATETIME NULL,
  `imf_createtime` DATETIME NULL,
  `imf_receiver` VARCHAR(45) NULL,
  `imf_sender` VARCHAR(45) NULL,
  `imf_owner` VARCHAR(45) NULL,
  `imf_flightNumber` VARCHAR(45) NULL,
  `imf_flightScheduledDate` VARCHAR(45) NULL,
  `imf_flightDirection` VARCHAR(45) NULL,
  `imf_flightInternalId` VARCHAR(100) NULL,
  `imf_flightScheduledDatetime` VARCHAR(45) NULL,
  `imf_basicDataCategory` VARCHAR(45) NULL,
  `imf_basicDataId` VARCHAR(100) NULL,
  `imf_resourceCategory` VARCHAR(45) NULL,
  `imf_resourceId` VARCHAR(45) NULL,
  `IMF_mqifId` VARCHAR(100) NULL,
  `imf_content` LONGTEXT NULL,
  PRIMARY KEY (`imf_id`),
  INDEX `IMF_IDX_CREATETIME` (`imf_createtime` ASC),
  INDEX `IMF_IDX_FLIGHTNUMBER` (`imf_flightNumber` ASC),
  INDEX `IMF_IDX_FLIGHTSCHEDULEDDATE` (`imf_flightScheduledDate` ASC),
  INDEX `IMF_IDX_FLIGHTINTERNALID` (`imf_flightInternalId` ASC),
  INDEX `IMF_IDX_BASICDATAID` (`imf_basicDataId` ASC),
  INDEX `IMF_IDX_RESOURCEID` (`imf_resourceId` ASC),
  INDEX `IMF_IDX_FLIGHTDIRECTION` (`imf_flightDirection` ASC),
  INDEX `IMF_IDX_RECEIVER` (`imf_sender` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ibSystem`.`sys_parameter`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ibSystem`.`sys_parameter` ;

CREATE TABLE IF NOT EXISTS `ibSystem`.`sys_parameter` (
  `SpName` VARCHAR(100) NOT NULL,
  `SpDescription` VARCHAR(100) NULL,
  `SpValue1` VARCHAR(100) NULL,
  `SpValue2` VARCHAR(100) NULL,
  `SpValue3` VARCHAR(100) NULL,
  `SpValue4` VARCHAR(100) NULL,
  `SpValue5` DATETIME NULL,
  `SpValue6` DATETIME NULL,
  `CreateUser` VARCHAR(100) NULL,
  `UpdateUser` VARCHAR(100) NULL,
  `CreateDateTime` DATETIME NULL,
  `UpdateDateTime` DATETIME NULL,
  PRIMARY KEY (`SpName`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
