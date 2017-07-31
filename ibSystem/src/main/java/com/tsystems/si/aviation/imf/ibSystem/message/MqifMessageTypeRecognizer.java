package com.tsystems.si.aviation.imf.ibSystem.message;

import java.util.HashMap;
import java.util.Map;

import javax.jms.BytesMessage;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.TextMessage;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



/**
 * class MqifXslLocator.java's description on implement
 *
 * @author cchen2 2013-2-5 9:58:51 AM
 */
public class MqifMessageTypeRecognizer {

    private static final Logger        logger    = LoggerFactory.getLogger(MqifMessageTypeRecognizer.class);

    private static Map<String, String> mapping   = new HashMap<String, String>();

    public static final String         SUBSCRIBE = "SUBSCRIBE";
    public static final String         DATASET   = "DATASET";
    public static final String         UPDATE    = "UPDATE";
    public static final String         REQUEST   = "REQUEST";
    public static final String         ACK       = "ACK";
    public static final String         NACK      = "NACK";

    static {
        mapping.put(SUBSCRIBE, "XSS1");
        mapping.put(DATASET, "XSS2");
        mapping.put(UPDATE, "XUS");
        mapping.put(REQUEST, "XRS");
        
/*        mapping.put(MqifConfUtil.getIB_SS1_TO_Q(), SUBSCRIBE);
        mapping.put(MqifConfUtil.getIB_US_TO_Q(), UPDATE);
        mapping.put(MqifConfUtil.getIB_RS_TO_Q(), REQUEST);
        
        String[] ss2out = MqifConfUtil.getIB_SS2_TO_Q().split(";");
        for (int i = 0; i < ss2out.length; i++) {
            mapping.put(ss2out[i], DATASET);
        }*/
    }

    public static String analyseAodbMessage(String message) {
        String operationType = StringUtils.substringBetween(message, "<aodb:org-message-type>", "</aodb:org-message-type>");
        if (StringUtils.isEmpty(operationType)) {
            operationType = StringUtils.substringBetween(message, "<aodb:message-type>", "</aodb:message-type>");
        }

        return mapping.get(StringUtils.upperCase(operationType));
    }

    public static String analyseAodbMessageType(String qName) {
        return mapping.get(StringUtils.upperCase(qName));
    }

    public static String analyseAodbDataType(String aodbMessage) {
        String _objectType = StringUtils.substringBetween(aodbMessage, "<soap-env:Body>", ">");
        String objectType = StringUtils.substringBetween(_objectType, "<", " ");

        return objectType;
    }

    public static String getAodbCorrelationId(String message) {
        String correlationId = StringUtils.substringBetween(message, "<aodb:correlation-id>", "</aodb:correlation-id>");
        if (StringUtils.isEmpty(correlationId)) {
            return null;
        }
        return correlationId;
    }

/*    public static ImfServiceType getImfMessageType(String message) {
        String servicetype = StringUtils.substringBetween(message, "<ServiceType>", "</ServiceType>");
        if (StringUtils.isEmpty(servicetype)) {
            return null;
        }
        return ImfServiceType.valueOf(servicetype);
    }

    public static String getImfMessageTypeString(String message) {
        String servicetype = StringUtils.substringBetween(message, "<ServiceType>", "</ServiceType>");
        if (StringUtils.isEmpty(servicetype)) {
            return null;
        }
        return ImfServiceType.valueOf(servicetype).name();
    }*/

    public static String getImfMessageSender(String message) {
        String sender = StringUtils.substringBetween(message, "<Sender>", "</Sender>");
        if (StringUtils.isEmpty(sender)) {
            return null;
        }
        return sender;
    }

    public static String getImfMessageOwner(String message) {
        String sender = StringUtils.substringBetween(message, "<Owner>", "</Owner>");
        if (StringUtils.isEmpty(sender)) {
            return null;
        }
        return sender;
    }    
    
    public static String getImfMessageOwener(String message) {
        String owner = StringUtils.substringBetween(message, "<Owner>", "</Owener>");
        if (StringUtils.isEmpty(owner)) {
            return null;
        }
        return owner;
    }

    public static String getImfMessageReceiver(String message) {
        String receiver = StringUtils.substringBetween(message, "<Receiver>", "</Receiver>");
        if (StringUtils.isEmpty(receiver)) {
            return null;
        }
        return receiver;
    }    
    
    public static String getImfMessageSequenceID(String message) {
        String seqId = StringUtils.substringBetween(message, "<MessageSequenceID>", "</MessageSequenceID>");
        if (StringUtils.isEmpty(seqId)) {
            return null;
        }
        return seqId;
    }

    public static boolean isBasicMessage(String dataType) {
        return StringUtils.startsWithIgnoreCase(dataType, "ref_");
    }

    public static boolean isReferenceMessage(String dataType) {
        return StringUtils.equalsIgnoreCase(dataType, "rm_closing")||StringUtils.equalsIgnoreCase(dataType, "pl_desk");
    }

    public static boolean isFlightMessage(String dataType) {
        return StringUtils.equalsIgnoreCase(dataType, "pl_turn");
    }    
    
    public static boolean isGroundServiceMessage(String dataType){
        return StringUtils.startsWith(dataType, "et_gs_");
    }
    
    public static String convertMessage(Message msg) {

        if (msg == null) {
            return null;
        }

        String message = null;
        if (msg instanceof TextMessage) {
            try {
                message = ((TextMessage) msg).getText();
            } catch (JMSException e) {
                logger.error("convert message failed:", e);
            }
        }

        else if (msg instanceof BytesMessage) {
            BytesMessage bmsg = (BytesMessage) msg;
            byte[] buff = null;
            try {
                long length = bmsg.getBodyLength();
                buff = new byte[(int) length];
                bmsg.readBytes(buff);
                message = new String(buff, "utf-8");
            } catch (Exception e) {
                logger.error("convert message failed:", e);
            }
        }

        return message;
    }
    
    public static void main(String[] args) {
        String str = "<soap-env:Envelope xmlns:soap-env='http://schemas.xmlsoap.org/soap/envelope/' xmlns:aodb='urn:com.tsystems.ac.aodb' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>       <soap-env:Header>               <aodb:control>                  <aodb:message-id>aodbhost:3544f7d5:13e4976b95f:43d2</aodb:message-id>                   <aodb:message-version>1.4</aodb:message-version>                        <aodb:message-type>SUBSCRIBE</aodb:message-type>                        <aodb:correlation-id>1</aodb:correlation-id>                    <aodb:timestamp>2013-04-27T15:55:40.449</aodb:timestamp>                        <aodb:sender>AODB</aodb:sender>                 </aodb:control>         </soap-env:Header>      <soap-env:Body>                 <rm_closing id='11055' action='delete'>                         <rcl_idseq action='delete'>11055</rcl_idseq>                    <rcl_autoactualind action='delete'>N</rcl_autoactualind>                        <rcl_beginactual action='delete'>2012-07-01T10:00:00</rcl_beginactual>                  <rcl_beginplantime action='delete'>2012-07-01T10:00:00</rcl_beginplantime>                      <rcl_capacityreduction action='delete'>-1</rcl_capacityreduction>                       <rcl_closingtype action='delete'>S</rcl_closingtype>                    <rcl_createtime action='delete'>2013-04-09T20:41:14</rcl_createtime>                    <rcl_endactual action='delete'>2012-07-01T11:20:00</rcl_endactual>                      <rcl_endplantime action='delete'>2012-07-01T11:00:00</rcl_endplantime>                  <rcl_modtime action='delete'>2013-04-10T15:22:46</rcl_modtime>                  <rcl_moduser action='delete'>NKG_AODB</rcl_moduser>                     <rcl_opsdays xsi:nil='true'/>                   <rcl_rcl_cyclicclosing xsi:nil='true'/>                         <rcl_reason action='delete'>Regular maintenance</rcl_reason>                    <rcl_resourcename action='delete'>11</rcl_resourcename>                         <rcl_resourcetype action='delete'>RGT</rcl_resourcetype>                        <rcl_rmsc_scenario action='delete'>1</rcl_rmsc_scenario>                        <rcl_validfrom action='delete'>2012-07-01T10:00:00</rcl_validfrom>                      <rcl_validto action='delete'>2012-07-01T11:00:00</rcl_validto>          </rm_closing>   </soap-env:Body> </soap-env:Envelope>";
        
        System.out.println(analyseAodbDataType(str));
    }
}