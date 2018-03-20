/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.message
 * FileName  ImfMessageUtil.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月12日 下午3:30:11
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月12日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.message;

import java.util.Date;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tsystems.si.aviation.imf.ibSystem.db.domain.LogImfMessage;

/**
  * ClassName ImfMessageUtil<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月12日 下午3:30:11
  *
  */

public class ImfMessageUtil {
	private static final Logger     logger               = LoggerFactory.getLogger(ImfMessageUtil.class);
	public static final String ADAPTOR_TO_IB_SS2_QUEUE  = "AQ.ADAPTOR.IB_SS2";
	public static final String ADAPTOR_TO_IB_US_QUEUE   = "AQ.ADAPTOR.IB_US";
	public static final String ADAPTOR_TO_IB_SS1_QUEUE   = "AQ.ADAPTOR.IB_SS1";
	public static String getDestinationByImfMessage(LogImfMessage logImfMessage){
		String destination =null;
		String serviceType = logImfMessage.getImfServiceType();
		if(StringUtils.isBlank(serviceType)){
			
		}else{
			if(serviceType.endsWith("SS2")){
				destination= ADAPTOR_TO_IB_SS2_QUEUE;
			}else if(serviceType.endsWith("US")){
				destination=ADAPTOR_TO_IB_US_QUEUE;
			}else if(serviceType.endsWith("SS1")){
				destination=ADAPTOR_TO_IB_SS1_QUEUE;
			}
		}
		
		
		return destination;
	}
	 public static LogImfMessage parseImfXmlMessage(String message){
		 LogImfMessage logImfMessage = new LogImfMessage();
   	     String imfMessageId = StringUtils.substringBetween(message, "<MessageSequenceID>", "</MessageSequenceID>");
   	     
	   	String imfMessageType = StringUtils.substringBetween(message, "<MessageType>", "</MessageType>");
	   	String imfServiceType = StringUtils.substringBetween(message, "<ServiceType>", "</ServiceType>");
	   	String imfOperationMode = StringUtils.substringBetween(message, "<OperationMode>", "</OperationMode>");
	   	String imfOrgCreatetime = StringUtils.substringBetween(message, "<CreateDateTime>", "</CreateDateTime>");
	   	String imfReceiver = StringUtils.substringBetween(message, "<Receiver>", "</Receiver>");
	   	String imfSender = StringUtils.substringBetween(message, "<Sender>", "</Sender>");
	   	String imfOwner = StringUtils.substringBetween(message, "<Owner>", "</Owner>");
	   	String imfFlightScheduledDate = StringUtils.substringBetween(message, "<FlightScheduledDate>", "</FlightScheduledDate>");
	   	String imfFlightDirection = StringUtils.substringBetween(message, "<FlightDirection>", "</FlightDirection>");
	   	String imfFlightNumber = StringUtils.substringBetween(message, "<FlightIdentity>", "</FlightIdentity>");
	   	String imfFlightScheduledDatetime = StringUtils.substringBetween(message, "<FlightScheduledDateTime>", "</FlightScheduledDateTime>");
	   	String imfResourceCategory = StringUtils.substringBetween(message, "<ResourceCategory>", "</ResourceCategory>");
	   	String imfResourceId = StringUtils.substringBetween(message, "<ResourceID>", "</ResourceID>");
	   	String imfBasicDataCategory = StringUtils.substringBetween(message, "<BasicDataCategory>", "</BasicDataCategory>");
	   	String imfBasicDataId = StringUtils.substringBetween(message, "<BasicDataID>", "</BasicDataID>");
	   	String imfFlightInternalId = StringUtils.substringBetween(message, "<InternalID>", "</InternalID>");
	   	logImfMessage.setImfMessageId(imfMessageId);
	   	logImfMessage.setImfMessageType(imfMessageType);
	   	logImfMessage.setImfServiceType(imfServiceType);
	   	logImfMessage.setImfOperationMode(imfOperationMode);
	   	//logImfMessage.setImfOrgCreatetime(imfOrgCreatetime);
	   	logImfMessage.setImfReceiver(imfReceiver);
	   	logImfMessage.setImfSender(imfSender);
	   	logImfMessage.setImfOwner(imfOwner);
	   	logImfMessage.setImfFlightScheduledDate(imfFlightScheduledDate);
	   	logImfMessage.setImfFlightScheduledDatetime(imfFlightScheduledDatetime);
	   	logImfMessage.setImfFlightDirection(imfFlightDirection);
	   	logImfMessage.setImfFlightNumber(imfFlightNumber);
	   	logImfMessage.setImfFlightInternalId(imfFlightInternalId);
	   	logImfMessage.setImfResourceCategory(imfResourceCategory);
	   	logImfMessage.setImfResourceId(imfResourceId);
	   	logImfMessage.setImfBasicDataCategory(imfBasicDataCategory);
	   	logImfMessage.setImfBasicDataId(imfBasicDataId);
	   	logImfMessage.setImfCreateTime(new Date()); 
	   	logImfMessage.setImfContent(message);
	   	
   	  return logImfMessage;
   	  
     }
}
