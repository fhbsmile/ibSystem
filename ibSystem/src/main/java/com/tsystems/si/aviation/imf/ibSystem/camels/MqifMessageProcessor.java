/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  MqifMessageProcessor.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月27日 下午2:35:08
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月27日       方红波          1.0             1.0
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
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tsystems.si.aviation.imf.ibSystem.db.domain.LogImfMessage;
import com.tsystems.si.aviation.imf.ibSystem.db.domain.LogMqifMessage;
import com.tsystems.si.aviation.imf.ibSystem.message.ImfMessageUtil;
import com.tsystems.si.aviation.imf.ibSystem.message.MqifMessageUtil;
import com.tsystems.si.aviation.imf.ibSystem.message.XmlTransformer;
import com.tsystems.si.aviation.imf.ibSystem.message.XmlValidator;

/**
  * ClassName MqifMessageProcessor<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月27日 下午2:35:08
  *
  */

public class MqifMessageProcessor implements Processor {
	private static final Logger     logger               = LoggerFactory.getLogger(MqifMessageProcessor.class);
	private XmlTransformer xmlTransformer;
	private XmlTransformer xmlDepatureTransformer;
	private String processMode ="T";
	private boolean validateIMFMessageindcator;
	
	/**
	  *<p> 
	  * Overriding_Method: process<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年7月27日 下午2:35:08<BR></p>
	  * @param exchange
	  * @throws Exception MqifMessageProcessor
	  * @see org.apache.camel.Processor#process(org.apache.camel.Exchange)
	  */

	@Override
	public void process(Exchange exchange) throws Exception {
		Map<String, Object> map = exchange.getIn().getHeaders();
		 for (Entry<String, Object> entry : map.entrySet()) {
			 logger.debug("key:{}, value:{}",new Object[]{entry.getKey(),entry.getValue()});
			  }
		 String message = exchange.getIn().getBody(String.class);
		 logger.info("received Imf:{}",message.replaceAll("\r\n", "").replaceAll("\n", ""));

			boolean validate =true;
			if(validateIMFMessageindcator){
				validate = XmlValidator.validate(message);
			}
             
		if(validate){
			Message msg = exchange.getOut();
       	    LogImfMessage logImfMessage = ImfMessageUtil.parseImfXmlMessage(message);
            String destination = ImfMessageUtil.getDestinationByImfMessage(logImfMessage);
			msg.setHeader("JMSDestination", destination);
			 logger.info("Set Header JMSDestination:{}",destination);
			msg.setBody(message);
		}



	}
	public List<String> processMqif(String message){
		logger.info("Received Mqif:{}",message);
		List<String> messageList = new ArrayList<String>();
		boolean validate =true;
		if(validateIMFMessageindcator){
			validate = XmlValidator.validate(message);
		}
        if(validate){
        	 if(MqifMessageUtil.hasPlturn(message)){
        		 if(MqifMessageUtil.hasPlarrival(message)){
        			 String imfArrivalMessage =	xmlTransformer.transform(message);
        			 logger.info("Transform arrival result:{}",imfArrivalMessage.replaceAll("\r\n", "").replaceAll("\n", ""));
        			 messageList.add(imfArrivalMessage);
        		 }
        		 if(MqifMessageUtil.hasPldeparture(message)){
        			 String imfDepartureMessage =	xmlDepatureTransformer.transform(message);
        			 logger.info("Transform departure result:{}",imfDepartureMessage.replaceAll("\r\n", "").replaceAll("\n", ""));
        			 messageList.add(imfDepartureMessage);
        		 }
        	 }else{
        		 String imfMessage =	xmlTransformer.transform(message);
        		 logger.info("Transform Mqif Message result:{}",imfMessage.replaceAll("\r\n", "").replaceAll("\n", ""));
    			 messageList.add(imfMessage);
        	 }
                    	      
        }
        
        return messageList;
	}
	public XmlTransformer getXmlTransformer() {
		return xmlTransformer;
	}

	public void setXmlTransformer(XmlTransformer xmlTransformer) {
		this.xmlTransformer = xmlTransformer;
	}

	public XmlTransformer getXmlDepatureTransformer() {
		return xmlDepatureTransformer;
	}

	public void setXmlDepatureTransformer(XmlTransformer xmlDepatureTransformer) {
		this.xmlDepatureTransformer = xmlDepatureTransformer;
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
