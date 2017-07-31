/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.adapter.us
 * FileName  USAodb2ibMessageProcesser.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月22日 下午5:02:25
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月22日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.adapter.us;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tsystems.si.aviation.imf.ibSystem.adapter.MessageProcesser;
import com.tsystems.si.aviation.imf.ibSystem.adapter.bss2.BSS2Aodb2ibMessageProcesser;
import com.tsystems.si.aviation.imf.ibSystem.db.domain.LogImfMessage;
import com.tsystems.si.aviation.imf.ibSystem.db.domain.LogMqifMessage;
import com.tsystems.si.aviation.imf.ibSystem.message.ImfMessageUtil;
import com.tsystems.si.aviation.imf.ibSystem.message.MqifMessageUtil;
import com.tsystems.si.aviation.imf.ibSystem.message.XmlTransformer;
import com.tsystems.si.aviation.imf.ibSystem.message.XmlValidator;
import com.tsystems.si.aviation.imf.ibSystem.mq.ActiveMQSender;

/**
  * ClassName USAodb2ibMessageProcesser<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月22日 下午5:02:25
  *
  */

public class USAodb2ibMessageProcesser implements MessageProcesser {
	private static final Logger     logger               = LoggerFactory.getLogger(USAodb2ibMessageProcesser.class);
	private XmlTransformer xmlTransformer;
	private XmlTransformer xmlDepatureTransformer;
	private ActiveMQSender activeMQSender;
	private String processMode ="T";
	private boolean validateIMFMessageindcator;
	/**
	  *<p> 
	  * Overriding_Method: process<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年7月22日 下午5:02:25<BR></p>
	  * @param message
	  * @return USAodb2ibMessageProcesser
	  * @see com.tsystems.si.aviation.imf.ibSystem.adapter.MessageProcesser#process(java.lang.String)
	  */

	@Override
	public String process(String message) {
		List<String> messageList = new ArrayList<String>();
		boolean validate =true;
		if(validateIMFMessageindcator){
			validate = XmlValidator.validate(message);
		}
        if(validate){
        	 LogMqifMessage logMqifMessage = MqifMessageUtil.parseMqifXmlMessage(message);
        	 if(MqifMessageUtil.hasPlturn(message)){
        		 if(MqifMessageUtil.hasPlarrival(message)){
        			 String imfArrivalMessage =	xmlTransformer.transform(message);
        			 logger.info("Transform pl_turn arrival part result:{}",imfArrivalMessage);
        			 messageList.add(imfArrivalMessage);
        		 }
        		 if(MqifMessageUtil.hasPldeparture(message)){
        			 String imfDepartureMessage =	xmlDepatureTransformer.transform(message);
        			 logger.info("Transform pl_turn departure part result:{}",imfDepartureMessage);
        			 messageList.add(imfDepartureMessage);
        		 }
        	 }else{
        		 String imfMessage =	xmlTransformer.transform(message);
        		 logger.info("Transform Mqif Message result:{}",imfMessage);
    			 messageList.add(imfMessage);
        	 }

             for(String imfMessage : messageList){
            	 LogImfMessage logImfMessage = ImfMessageUtil.parseImfXmlMessage(imfMessage);
                 String destination = ImfMessageUtil.getDestinationByImfMessage(logImfMessage);
                 if(processMode.equalsIgnoreCase("P")){
                	 activeMQSender.send(destination, imfMessage);
                 }else{
                	 logger.debug("Send to:{} \n{}",new Object[]{destination,imfMessage});
                 }
                 
             }
             
        	      
        }
        
        return null;
	}

	/**
	  *<p> 
	  * Overriding_Method: initialize<BR>
	  * Description:<BR>
	  * Overriding_Date: 2017年7月22日 下午5:02:25<BR></p> USAodb2ibMessageProcesser
	  * @see com.tsystems.si.aviation.imf.ibSystem.adapter.MessageProcesser#initialize()
	  */

	@Override
	public void initialize() {
		// TODO Auto-generated method stub

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

	public ActiveMQSender getActiveMQSender() {
		return activeMQSender;
	}

	public void setActiveMQSender(ActiveMQSender activeMQSender) {
		this.activeMQSender = activeMQSender;
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
