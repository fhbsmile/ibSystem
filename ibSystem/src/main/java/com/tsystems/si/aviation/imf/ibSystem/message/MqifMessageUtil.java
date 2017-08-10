/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.message
 * FileName  MqifMessageUtil.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月12日 下午1:35:30
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月12日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.message;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tsystems.si.aviation.imf.ibSystem.db.domain.LogMqifMessage;

/**
  * ClassName MqifMessageUtil<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月12日 下午1:35:30
  *
  */

public class MqifMessageUtil {
	private static final Logger     logger               = LoggerFactory.getLogger(MqifMessageUtil.class);
	  public static final String ADAPTOR_TO_AODB_US_QUEUE  = "AQ.IB_US.AODB";
	  public static final String ADAPTOR_TO_AODB_BSS2_QUEUE= "AQ.IB_BSS2.AODB";
	  public static final String ADAPTOR_TO_AODB_FSS2_QUEUE= "AQ.IB_FSS2.AODB";
	  public static final String ADAPTOR_TO_AODB_RSS2_QUEUE= "AQ.IB_RSS2.AODB";
	  public static final String ADAPTOR_TO_AODB_SS1_QUEUE= "AQ.IB_SS1.AODB";
      public static String getDestinationByMqifMessage(LogMqifMessage LogMqifMessage){
    	  String destination = null;
    	  String mqifMessagetype = LogMqifMessage.getMqifMessageType();
    	  String mqifDateType = LogMqifMessage.getMqifDataType();
    	  if(mqifMessagetype!=null && mqifMessagetype.equalsIgnoreCase("UPDATE")){
    		   destination=ADAPTOR_TO_AODB_US_QUEUE;
    	  }else if(mqifMessagetype!=null && mqifMessagetype.equalsIgnoreCase("DATASET") && mqifDateType!=null ){
    		  if(mqifDateType.equalsIgnoreCase("pl_turn")){
    			  destination=ADAPTOR_TO_AODB_FSS2_QUEUE;
    		  }else if(mqifDateType.startsWith("ref")){
    			  destination=ADAPTOR_TO_AODB_BSS2_QUEUE;
    		  }else if(mqifDateType.equalsIgnoreCase("pl_desk") ||mqifDateType.equalsIgnoreCase("rm_closing")){
    			  destination=ADAPTOR_TO_AODB_RSS2_QUEUE;
    		  }
    	  }
    	  return destination;
      }
      
      public static LogMqifMessage parseMqifXmlMessage(String message){
    	  LogMqifMessage logMqifMessage = new LogMqifMessage();
    	  
    	  return logMqifMessage;
    	  
      }
      
      public static Boolean hasPlturn(String message){
    	  Boolean hasPlturn =  StringUtils.containsIgnoreCase(message, "</pl_turn>");
    	  
    	  return hasPlturn;    	  
      }
      
      public static Boolean hasPlarrival(String message){
    	  Boolean hasPlarrival =  StringUtils.containsIgnoreCase(message, "</pl_arrival>");
    	  
    	  return hasPlarrival;    	  
      }
      
      public static Boolean hasPldeparture(String message){
    	  Boolean hasPldeparture =  StringUtils.containsIgnoreCase(message, "</pl_departure>");
    	  
    	  return hasPldeparture;    	  
      }
      public static Boolean hasCK(String message){
    	  Boolean hasCK =  StringUtils.containsIgnoreCase(message, "<aodb:message-type>ACK</aodb:message-type>") || StringUtils.containsIgnoreCase(message, "<aodb:message-type>NACK</aodb:message-type>");
    	  
    	  return hasCK;    	  
      }
      
  	public static List<String> splitXssRequest(String aodbMessage,String servicetype, String imfMessage) {

		List<String> aodbMessages = new ArrayList<String>();
		if (servicetype.equalsIgnoreCase("BSS2")) {
			//没有的话取全集
			List<String> datatypes = Imf2AodbSs2CategoryMapping.getSs2Category(imfMessage, servicetype);

			for (String datatype : datatypes) {
				 String msg = StringUtils.replaceOnce(aodbMessage,
						"<aodb:datatype>BSSDATATYPE</aodb:datatype>",
						"<aodb:datatype>" + datatype + "</aodb:datatype>");
				 logger.info("Add request:{}",msg);
				aodbMessages.add(msg);
			}
		}else if (servicetype.equalsIgnoreCase("RSS2")) {
			List<String> datatypes = Imf2AodbSs2CategoryMapping.getSs2Category(imfMessage, servicetype);
			for (String datatype : datatypes) {
				 String msg = StringUtils.replaceOnce(aodbMessage,
						"<aodb:datatype>RSSDATATYPE</aodb:datatype>",
						"<aodb:datatype>" + datatype + "</aodb:datatype>");
				 logger.info("Add request:{}",msg);
				aodbMessages.add(msg);
			}
		}else if (servicetype.equalsIgnoreCase("GSS2")) {
			for (String datatype : new String[]{}) {
				 String msg = StringUtils.replaceOnce(aodbMessage,
						"<aodb:datatype>GSSDATATYPE</aodb:datatype>",
						"<aodb:datatype>" + datatype + "</aodb:datatype>");
				 logger.info("Add request:{}",msg);
				aodbMessages.add(msg);
			}
		}else {
			 logger.info("Add request:{}",aodbMessage);
			aodbMessages.add(aodbMessage);
		}

		return aodbMessages;
	}
  	
  	public static String buildSS1Subscribe(){
  		
  		String msg="hello SSS1";
  		logger.info(">>>>>>>>>>>>>>>>>>>>>>>>>"+msg);
  		return msg;
  	}
}
