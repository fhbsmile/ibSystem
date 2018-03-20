/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  ImfMessageAdapterProcessor.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月31日 下午1:55:56
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月31日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.camels;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.camel.Exchange;
import org.apache.camel.Message;
import org.apache.camel.Processor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tsystems.si.aviation.imf.ibSystem.db.domain.LogImfMessage;
import com.tsystems.si.aviation.imf.ibSystem.db.domain.LogMqifMessage;
import com.tsystems.si.aviation.imf.ibSystem.message.ImfMessageUtil;
import com.tsystems.si.aviation.imf.ibSystem.message.MqifMessageUtil;
import com.tsystems.si.aviation.imf.ibSystem.message.XmlTransformer;
import com.tsystems.si.aviation.imf.ibSystem.message.XmlValidator;

/**
  * ClassName ImfMessageAdapterProcessor<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月31日 下午1:55:56
  *
  */

public class ImfMessageAdapterProcessor implements Processor {
	private static final Logger     logger               = LoggerFactory.getLogger(ImfMessageAdapterProcessor.class);
	private XmlTransformer xmlTransformer;
	private String processMode ="T";
	private boolean validateIMFMessageindcator;
	/**
	  *<p> 
	  * Overriding_Method: process<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年7月31日 下午1:55:57<BR></p>
	  * @param exchange
	  * @throws Exception ImfMessageAdapterProcessor
	  * @see org.apache.camel.Processor#process(org.apache.camel.Exchange)
	  */

	@Override
	public void process(Exchange exchange) throws Exception {
		Message msg = exchange.getIn();
		Map<String, Object> map = msg.getHeaders();
		 for (Entry<String, Object> entry : map.entrySet()) {
			 logger.debug("key:{}, value:{}",new Object[]{entry.getKey(),entry.getValue()});
			  }
		 String message = msg.getBody(String.class);
		 logger.info("received Mqif:{}",message.replaceAll("\r\n", "").replaceAll("\n", ""));

			boolean validate =true;
			if(validateIMFMessageindcator){
				validate = XmlValidator.validate(message);
			}
            
		if(validate){
			
            LogMqifMessage logMqifMessage = MqifMessageUtil.parseMqifXmlMessage(message);
            String destination = MqifMessageUtil.getDestinationByMqifMessage(logMqifMessage);
			msg.setHeader("JMSDestination", destination);
			 logger.info("Set Header JMSDestination:{}",destination);
			msg.setBody(message);
		}

	}
	
	public List<String> processImf(String message){
		logger.info("Received Imf:{}",message);
		List<String> messageList = new ArrayList<String>();
		boolean validate =true;
		if(validateIMFMessageindcator){
			validate = XmlValidator.validate(message);
		}
        if(validate){
        	String mqifStyleMessage =	xmlTransformer.transform(message);
        	LogImfMessage logImfMessage = ImfMessageUtil.parseImfXmlMessage(message);
        	List<String> requests = MqifMessageUtil.splitXssRequest(mqifStyleMessage, logImfMessage.getImfServiceType(), message);
        	messageList.addAll(requests);
        }
	   return messageList;
	}
	public XmlTransformer getXmlTransformer() {
		return xmlTransformer;
	}
	public void setXmlTransformer(XmlTransformer xmlTransformer) {
		this.xmlTransformer = xmlTransformer;
	}
	public String getProcessMode() {
		return processMode;
	}
	public void setProcessMode(String processMode) {
		this.processMode = processMode;
	}
	public boolean isValidateIMFMessageindcator() {
		return validateIMFMessageindcator;
	}
	public void setValidateIMFMessageindcator(boolean validateIMFMessageindcator) {
		this.validateIMFMessageindcator = validateIMFMessageindcator;
	}
	
	
	

}
