/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  SubsystemProcessor.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月2日 下午2:48:04
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月2日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.camels;

import java.io.IOException;

import org.apache.camel.Exchange;
import org.apache.camel.Message;
import org.apache.camel.Processor;
import org.apache.commons.lang3.StringUtils;
import org.dom4j.DocumentException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.SAXException;

import com.tsystems.si.aviation.imf.ibSystem.bean.SubProcessResult;
import com.tsystems.si.aviation.imf.ibSystem.db.domain.LogImfMessage;
import com.tsystems.si.aviation.imf.ibSystem.db.domain.SysInterface;
import com.tsystems.si.aviation.imf.ibSystem.message.ImfMessageBuilder;
import com.tsystems.si.aviation.imf.ibSystem.message.ImfMessageUtil;
import com.tsystems.si.aviation.imf.ibSystem.message.XMLHelper;
import com.tsystems.si.aviation.imf.ibSystem.message.XmlValidator;

/**
  * ClassName SubsystemProcessor<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月2日 下午2:48:04
  *
  */

public class SubsystemProcessor implements Processor {
	 private static final Logger     logger               = LoggerFactory.getLogger(SubsystemProcessor.class);
     private String interfaceName;
     private SysInterface sysInterface;
	/**
	  *<p> 
	  * Overriding_Method: process<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年8月2日 下午2:48:05<BR></p>
	  * @param exchange
	  * @throws Exception SubsystemProcessor
	  * @see org.apache.camel.Processor#process(org.apache.camel.Exchange)
	  */

	@Override
	public void process(Exchange exchange) throws Exception {
		String subsystemMessage = exchange.getIn().getBody(String.class);	
		logger.info("received ImfFromSub:{}",subsystemMessage);
		 SubProcessResult  subProcessResult =subsystemMessageProcess(subsystemMessage);
	    Message msg = exchange.getOut();
	       // LogImfMessage logImfMessage = ImfMessageUtil.parseImfXmlMessage(exceptionResponse);
			msg.setHeader("JMSDestination", subProcessResult.getDestination());
			logger.info("Set Header JMSDestination:{}",subProcessResult.getMessage());
			msg.setBody(subProcessResult.getMessage());
		
	}
	
	public boolean isMatchInterface(String interfaceName,LogImfMessage logImfMessage){
		
		return interfaceName.equals(logImfMessage.getImfOwner());
		
	}
   public SubProcessResult subsystemMessageProcess(String subsystemMessage){
	   SubProcessResult subProcessResult= new SubProcessResult();
	   subProcessResult.setDestination(interfaceName);
	   boolean validate =true;
		String response =null;
		try{
		     XmlValidator.validateNoReturn(subsystemMessage);
		} catch (SAXException | IOException e) {
			logger.error(e.getMessage(),e);
			validate = false;
			response =e.getMessage();
		}
	   if(!validate){
		   response = ImfMessageBuilder.buildExcptionResponseMessage("", interfaceName, "01", response);
		   subProcessResult.setMessage(response);
		   
	   }else{
		   LogImfMessage logImfMessage = ImfMessageUtil.parseImfXmlMessage(subsystemMessage);
	       if(!isMatchInterface(interfaceName,logImfMessage)){
	    	   response = ImfMessageBuilder.buildExcptionResponseMessage("", interfaceName, "01", "Tne message owner does not equal to the interface name.");
	    	   subProcessResult.setMessage(response);
	       }else{
	    	   String messageType = getMessageType(subsystemMessage);
	    	   if(messageType.contentEquals("BSS1HB")){
	    		   subProcessResult =  handleHBRequest(sysInterface,"BSS1",logImfMessage.getImfMessageId());
	    	   }else if(messageType.contentEquals("FSS1HB")){
	    		   subProcessResult =  handleHBRequest(sysInterface,"FSS1",logImfMessage.getImfMessageId());
	    	   }else if(messageType.contentEquals("RSS1HB")){
	    		   subProcessResult =  handleHBRequest(sysInterface,"RSS1",logImfMessage.getImfMessageId());
	    	   }else if(messageType.contentEquals("FUSHB")){
	    		   subProcessResult =  handleHBRequest(sysInterface,"FUS",logImfMessage.getImfMessageId());
	    	   }else if(messageType.contentEquals("BSS1Subscription")){
	    		   subProcessResult = handleXss1Subscription(sysInterface,"BSS1",logImfMessage.getImfMessageId());
	    	   }else if(messageType.contentEquals("BSS2Request")){
	    		   
	    	   }else if(messageType.contentEquals("FSS1Subscription")){
	    		   
	    	   }else if(messageType.contentEquals("FSS2Request")){
	    		   
	    	   }else if(messageType.contentEquals("RSS1Subscription")){
	    		   
	    	   }else if(messageType.contentEquals("RSS2Request")){
	    		   
	    	   }else{
	    		   response = ImfMessageBuilder.buildExcptionResponseMessage("", interfaceName, "01", "Unknow Message type!");
	    	   }
	       }
		    
	   }
	   
	   return subProcessResult;
   }
   
  
   public String getMessageType(String message){
	   String serviceType = StringUtils.substringBetween(message, "<ServiceType>", "</ServiceType>");
	   if(StringUtils.contains(message, "<HeartBeatRequest/>")){
		   if("BSS1".equalsIgnoreCase(StringUtils.trim(serviceType))){
			   return "BSS1HB";
		   }else if("FSS1".equalsIgnoreCase(StringUtils.trim(serviceType))){
			   return "FSS1HB";
		   }else if("RSS1".equalsIgnoreCase(StringUtils.trim(serviceType))){
			   return "RSS1HB";
		   }else if("FUS".equalsIgnoreCase(StringUtils.trim(serviceType))){
			   return "FUSHB";
		   }else{
			   return "UNKNOW";
		   }
	   }else if(StringUtils.contains(message, "<Subscription")){
		   if("BSS1".equalsIgnoreCase(StringUtils.trim(serviceType))){
			   return "BSS1Subscription";
		   }else if("BSS2".equalsIgnoreCase(StringUtils.trim(serviceType))){
			   return "BSS2Request";
		   }else if("FSS1".equalsIgnoreCase(StringUtils.trim(serviceType))){
			   return "FSS1Subscription";
		   }else if("FSS2".equalsIgnoreCase(StringUtils.trim(serviceType))){
			   return "FSS2Request";
		   }else if("RSS1".equalsIgnoreCase(StringUtils.trim(serviceType))){
			   return "RSS1Subscription";
		   }else if("RSS2".equalsIgnoreCase(StringUtils.trim(serviceType))){
			   return "RSS2Request";
		   }else if("FUS".equalsIgnoreCase(StringUtils.trim(serviceType))){
			   return "FUSRequest";
		   }else{
			   return "UNKNOW";
		   }
	   }else{
		   return "UNKNOW";
	   }
   }
   
   public SubProcessResult handleHBRequest(SysInterface sysInterface,String serviceType,String heartBeatRequestID){
	   SubProcessResult subProcessResult= new SubProcessResult();
	   String status="Offline";
	   if(serviceType.contentEquals("BSS1")){
		   status = sysInterface.getIntStatus();
	   }else if(serviceType.contentEquals("FSS1")){
		   status = sysInterface.getIntStatus();
	   }else if(serviceType.contentEquals("RSS1")){
		   status = sysInterface.getIntStatus();
	   }else if(serviceType.contentEquals("FUS")){
		   status = sysInterface.getIntStatus();
	   }
	   String msg = ImfMessageBuilder.buildHbResponseMessage(sysInterface.getIntName(),serviceType,status, heartBeatRequestID);	  
	   subProcessResult.setDestination(sysInterface.getIntName());
	   subProcessResult.setMessage(msg);
	   return subProcessResult;
   }
   public SubProcessResult handleXss1Subscription(SysInterface sysInterface,String serviceType,String subscriptionRequestID){
	   SubProcessResult subProcessResult= new SubProcessResult();
	   String msg =ImfMessageBuilder.buildOperationTemplateMessage(sysInterface.getIntName(), serviceType, serviceType);
	   if(sysInterface.getIntStatus().contentEquals("Enable")){
		   String status="Accept";
		   if(serviceType.contentEquals("BSS1")){
			   status = sysInterface.getIntStatus();
			   if(status.contentEquals("Disable")){
				   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Error");
				   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
				   msg=StringUtils.replace(msg, "@ExceptionCode@", "001");
				   msg=StringUtils.replace(msg, "@ExceptionMessage@", "Service BSS is disabled!");
			   }else{
				   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Accept");
				   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
			   }
		   }else if(serviceType.contentEquals("FSS1")){
			   status = sysInterface.getIntStatus();
			   if(status.contentEquals("Disable")){
				   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Error");
				   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
				   msg=StringUtils.replace(msg, "@ExceptionCode@", "001");
				   msg=StringUtils.replace(msg, "@ExceptionMessage@", "Service FSS is disabled!");
			   }else{
				   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Accept");
				   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
			   }
		   }else if(serviceType.contentEquals("RSS1")){
			   status = sysInterface.getIntStatus();
			   if(status.contentEquals("Disable")){
				   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Error");
				   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
				   msg=StringUtils.replace(msg, "@ExceptionCode@", "001");
				   msg=StringUtils.replace(msg, "@ExceptionMessage@", "Service RSS is disabled!");
			   }else{
				   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Accept");
				   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
			   }
		   }else if(serviceType.contentEquals("FUS")){
			   status = sysInterface.getIntStatus();
			   if(status.contentEquals("Disable")){
				   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Error");
				   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
				   msg=StringUtils.replace(msg, "@ExceptionCode@", "001");
				   msg=StringUtils.replace(msg, "@ExceptionMessage@", "Service FUS is disabled!");
			   }else{
				   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Accept");
				   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
			   }
		   }
		   msg = ImfMessageBuilder.buildSubscribeResponseMessage(serviceType, interfaceName, "Accept/Reject", subscriptionRequestID);
	   }else{
		   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Error");
		   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
		   msg=StringUtils.replace(msg, "@ExceptionCode@", "001");
		   msg=StringUtils.replace(msg, "@ExceptionMessage@", "Interface is disabled!");
	   }
	   msg=msg.replaceAll(">(@.*@)<", "><");
	   //去掉空节点
	   
	   subProcessResult.setDestination(sysInterface.getIntName());
	   subProcessResult.setMessage(msg);
	   return subProcessResult;
   }
   public String handleBSS2Request(SysInterface sysInterface,String serviceType,String subscriptionRequestID,String subReq) throws DocumentException{
	   String msg =ImfMessageBuilder.buildOperationTemplateMessage(sysInterface.getIntName(), serviceType, serviceType);
	   String status = sysInterface.getIntStatus();
	   if(sysInterface.getIntStatus().contentEquals("Enable")){
		   if(status.contentEquals("Disable")){
			   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Error");
			   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
			   msg=StringUtils.replace(msg, "@ExceptionCode@", "001");
			   msg=StringUtils.replace(msg, "@ExceptionMessage@", "Service BSS is disabled!");
		   }else{
			   String bssParameterofDB = sysInterface.getIntBssParameter();
			   String bssParameterofSub = StringUtils.substringBetween(subReq, "", "");
			   String pa= getParameterValueByKey(bssParameterofDB,"");
			   if(StringUtils.isBlank(pa)){
				   pa = "AllCatagory";
			   }
			   StringBuffer sb = new StringBuffer();
			   if(StringUtils.isBlank(bssParameterofSub)){
				   msg=StringUtils.replace(msg, "@BasicDataCategory@", pa);
			   }else{
				   String[] catagories = bssParameterofSub.split(",");
					   for(int i=0;i<catagories.length;i++){
						   if(pa.contains(catagories[i])){
							   if(sb.length()==0){
								   sb.append(catagories[i]);
							   }else{
								   sb.append(",").append(catagories[i]);
							   }
							   
						   }					   
				       }
					   
					   msg=StringUtils.replace(msg, "@BasicDataCategory@", sb.toString());  
			   }
		   }
	   }else{
		   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Error");
		   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
		   msg=StringUtils.replace(msg, "@ExceptionCode@", "001");
		   msg=StringUtils.replace(msg, "@ExceptionMessage@", "Interface is disabled!");
	   }
	   
	   msg=msg.replaceAll(">(@.*@)<", "><");
	   //去掉空节点
	   return msg;   
	   
   }
   public String handleFSS2Request(SysInterface sysInterface,String serviceType,String subscriptionRequestID,String subReq) throws DocumentException{
	   String msg =ImfMessageBuilder.buildOperationTemplateMessage(sysInterface.getIntName(), serviceType, serviceType);
	   String status = sysInterface.getIntStatus();
	   if(sysInterface.getIntStatus().contentEquals("Enable")){
		   if(status.contentEquals("Disable")){
			   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Error");
			   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
			   msg=StringUtils.replace(msg, "@ExceptionCode@", "001");
			   msg=StringUtils.replace(msg, "@ExceptionMessage@", "Service FSS is disabled!");
		   }else{
			   String fssParameterofDB = sysInterface.getIntFssParameter();
			   String fssParameterofSub = StringUtils.substringBetween(subReq, "", "");
			   String pa= getParameterValueByKey(fssParameterofDB,"");
			   if(StringUtils.isBlank(pa)){
				   pa = "AllCatagory";
			   }
			   StringBuffer sb = new StringBuffer();
			   if(StringUtils.isBlank(fssParameterofSub)){
				   msg=StringUtils.replace(msg, "@BasicDataCategory@", pa);
			   }else{
				   String[] catagories = fssParameterofSub.split(",");
					   for(int i=0;i<catagories.length;i++){
						   if(pa.contains(catagories[i])){
							   if(sb.length()==0){
								   sb.append(catagories[i]);
							   }else{
								   sb.append(",").append(catagories[i]);
							   }
							   
						   }					   
				       }
					   
					   msg=StringUtils.replace(msg, "@BasicDataCategory@", sb.toString());  
			   }
		   }
	   }else{
		   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Error");
		   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
		   msg=StringUtils.replace(msg, "@ExceptionCode@", "001");
		   msg=StringUtils.replace(msg, "@ExceptionMessage@", "Interface is disabled!");
	   }
	   
	   msg=msg.replaceAll(">(@.*@)<", "><");
	   //去掉空节点
	   return msg;   
/*	   String category = XMLHelper.parseValue(subReq, "IMFRoot/Data/PrimaryKey/BasicDataKey/BasicDataCategory");
	   String syncUpdateFromDateTime = XMLHelper.parseValue(subReq, "IMFRoot/Operation/Subscription/SyncPeriodRequest/SyncUpdateFromDateTime");	   
	   return null;	*/   
	   
   }
   public String handleRSS2Request(SysInterface sysInterface,String serviceType,String subscriptionRequestID,String subReq) throws DocumentException{
	   String msg =ImfMessageBuilder.buildOperationTemplateMessage(sysInterface.getIntName(), serviceType, serviceType);
	   String status = sysInterface.getIntStatus();
	   if(sysInterface.getIntStatus().contentEquals("Enable")){
		   if(status.contentEquals("Disable")){
			   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Error");
			   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
			   msg=StringUtils.replace(msg, "@ExceptionCode@", "001");
			   msg=StringUtils.replace(msg, "@ExceptionMessage@", "Service RSS is disabled!");
		   }else{
			   //考虑节点为空会被过滤的情况
			   /*String fssParameterofDB = sysInterface.getIntFssParameter();
			   String fssParameterofSub = StringUtils.substringBetween(subReq, "", "");
			   String pa= getParameterValueByKey(fssParameterofDB,"");
			   if(StringUtils.isBlank(pa)){
				   pa = "AllCatagory";
			   }
			   StringBuffer sb = new StringBuffer();
			   if(StringUtils.isBlank(fssParameterofSub)){
				   msg=StringUtils.replace(msg, "@BasicDataCategory@", pa);
			   }else{
				   String[] catagories = fssParameterofSub.split(",");
					   for(int i=0;i<catagories.length;i++){
						   if(pa.contains(catagories[i])){
							   if(sb.length()==0){
								   sb.append(catagories[i]);
							   }else{
								   sb.append(",").append(catagories[i]);
							   }
							   
						   }					   
				       }
					   
					   msg=StringUtils.replace(msg, "@BasicDataCategory@", sb.toString());  
			   }*/
			   String syncUpdateFromDateTime =StringUtils.substringBetween(subReq, "<SyncUpdateFromDateTime>", "</SyncUpdateFromDateTime>");
			   if(!StringUtils.isBlank(syncUpdateFromDateTime)){
				   msg=StringUtils.replace(msg, "@SyncUpdateFromDateTime@", syncUpdateFromDateTime.trim());  
			   }
		   }
	   }else{
		   msg=StringUtils.replace(msg, "@SubscriptionStatus@", "Error");
		   msg=StringUtils.replace(msg, "@SubscriptionRequestID@", subscriptionRequestID);
		   msg=StringUtils.replace(msg, "@ExceptionCode@", "001");
		   msg=StringUtils.replace(msg, "@ExceptionMessage@", "Interface is disabled!");
	   }
	   
	   msg=msg.replaceAll(">(@.*@)<", "><");
	   //去掉空节点
	   return msg;   
/*	   String category = XMLHelper.parseValue(subReq, "IMFRoot/Data/PrimaryKey/BasicDataKey/BasicDataCategory");
	   String syncUpdateFromDateTime = XMLHelper.parseValue(subReq, "IMFRoot/Operation/Subscription/SyncPeriodRequest/SyncUpdateFromDateTime");	   
	   return null;	   
	   */
   }
   public String handleFUSRequest(SysInterface sysInterface,String serviceType,String subscriptionRequestID,String subReq) throws DocumentException{
	   String msg = StringUtils.replace(subReq, ">"+subscriptionRequestID+"<", ">"+sysInterface.getIntName()+"@"+subscriptionRequestID+"<");
       //xsl过滤  
	   return msg;	   
	   
   }
   
  public String getParameterValueByKey(String parameter,String key){
	  String result=null;
	  if(StringUtils.isBlank(parameter)){
		  
	  }else{
		  String[] parameters=parameter.split("|");
		  for(int i=0;i<parameters.length;i++){
			  if(!StringUtils.isBlank(parameters[i])||parameters[i].contains(key.trim()+"=")){
				  result =StringUtils.substringAfter( parameters[i], key.trim()+"=");
			  }
		  }
	  }
	  return result;
  }
}
