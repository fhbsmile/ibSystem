package com.tsystems.si.aviation.imf.ibSystem.message;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.jms.BytesMessage;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.TextMessage;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;



/**
 * Build messages, for example, HeartBeat message. Since all the methods in class ImfMessageBuilder are clarified as
 * static,so you can use ImfMessageBuilder.Methodname() to invoke a method, for example, you can invoke method
 * buildHbMessage(String serviceType) like this:ImfMessageBuilder.buildHbMessage(ImfServiceType.FSS1)

 */
/**
  * ClassName ImfMessageBuilder<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月2日 下午3:27:07
  *
  */
public class ImfMessageBuilder {

    /**
     * define and initialize SimpleDateFormat object to generate particular format date
     */
    private static final String         FORMAT_PATTERN = "yyyy-MM-dd'T'HH:mm:ss.SSS";

    /**
     * define ImfSequenceGenerator object pg1 to generate sequence number
     */
    private static ImfSequenceGenerator pg1            = new ImfSequenceGenerator();

    /**
     * define ImfSequenceGenerator object pg2 to generate sequence number
     */
    private static ImfSequenceGenerator pg2            = new ImfSequenceGenerator();

    // private static ImfSequenceGenerator pg3 = new ImfSequenceGenerator();

    /**
     * define Logger object to log exception message
     */
    private static final Logger         logger         = LoggerFactory.getLogger(ImfMessageBuilder.class);
    private static String heartbeat_responseTemplate =null;
    private static String exception_responseTemplate =null;
    private static String subscription_responseTemplate =null;
    private static String unsubscription_responseTemplate =null;
    private static String ss2_requestTemplate =null;
    private static String operationTemplate =null;
    static{
        
        try {
           Resource heartbeat_responseTemplateResource =   new ClassPathResource("heartbeat_response.xml");
           InputStream heartbeat_responseTemplateInputStream = heartbeat_responseTemplateResource.getInputStream();
           heartbeat_responseTemplate =  IOUtils.toString(heartbeat_responseTemplateInputStream, "UTF-8");
            logger.info("Init heartbeat_responseTemplate:\n{}", heartbeat_responseTemplate);
        } catch (IOException ex) {
           logger.error("heartbeat_response.xml not found, system exit!", ex);
           System.exit(0);
        }
        
        try {
            Resource exception_responseTemplateResource =   new ClassPathResource("exception_response.xml");
            InputStream exception_responseTemplateInputStream = exception_responseTemplateResource.getInputStream();
            exception_responseTemplate =  IOUtils.toString(exception_responseTemplateInputStream, "UTF-8");
             logger.info("Init exception_responseTemplate:\n{}", exception_responseTemplate);
         } catch (IOException ex) {
            logger.error("exception_response.xml not found, system exit!", ex);
            System.exit(0);
         }
        
        
        try {
            Resource subscription_responseTemplateResource =   new ClassPathResource("subscription_response.xml");
            InputStream subscription_responseTemplateInputStream = subscription_responseTemplateResource.getInputStream();
            subscription_responseTemplate =  IOUtils.toString(subscription_responseTemplateInputStream, "UTF-8");
             logger.info("Init subscription_responseTemplate:\n{}", subscription_responseTemplate);
         } catch (IOException ex) {
            logger.error("subscription_response.xml not found, system exit!", ex);
            System.exit(0);
         }
        
        try {
            Resource unsubscription_responseTemplateResource =   new ClassPathResource("unsubscription_response.xml");
            InputStream unsubscription_responseTemplateInputStream = unsubscription_responseTemplateResource.getInputStream();
            unsubscription_responseTemplate =  IOUtils.toString(unsubscription_responseTemplateInputStream, "UTF-8");
             logger.info("Init unsubscription_responseTemplate:\n{}", unsubscription_responseTemplate);
         } catch (IOException ex) {
            logger.error("unsubscription_response.xml not found, system exit!", ex);
            System.exit(0);
         }
        
        try {
            Resource ss2_requestTemplateResource =   new ClassPathResource("ss2_request.xml");
            InputStream ss2_requestTemplateInputStream = ss2_requestTemplateResource.getInputStream();
            ss2_requestTemplate =  IOUtils.toString(ss2_requestTemplateInputStream, "UTF-8");
             logger.info("Init ss2_requestTemplate:\n{}", ss2_requestTemplate);
         } catch (IOException ex) {
            logger.error("ss2_request.xml not found, system exit!", ex);
            System.exit(0);
         }
        
        try {
            Resource operation_templateResource =   new ClassPathResource("operation_template.xml");
            InputStream operation_templateInputStream = operation_templateResource.getInputStream();
            operationTemplate =  IOUtils.toString(operation_templateInputStream, "UTF-8");
             logger.info("Init operation_template:\n{}", operationTemplate);
         } catch (IOException ex) {
            logger.error("ss2_request.xml not found, system exit!", ex);
            System.exit(0);
         }
    }
    
    public static String buildOperationTemplateMessage(String receiver,String messageType,String serviceType) {

        if (serviceType == null) {
            return null;
        }

        String msg = operationTemplate;
        String seqId = null;


            seqId = pg1.generateNextNumber();
            //msg = load("heartbeat_response.xml");
            msg = StringUtils.replaceOnce(msg, "@seqId@", seqId);
            msg = StringUtils.replaceOnce(msg, "@messageType@", messageType);
            msg = StringUtils.replaceOnce(msg, "@serviceType@", serviceType);
            msg = StringUtils.replaceOnce(msg, "@sendTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@createTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@originalTime@",new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@receiver@", receiver);
            msg = StringUtils.replaceOnce(msg, "@sender@", "IB");
            msg = StringUtils.replaceOnce(msg, "@owner@", "IB");

        return msg;
    }
    /**
     * Build HeartBeat request message.You can invoke the method like this:ImfMessageBuilder.buildHbMessage(ImfServiceType.FSS1)
     * 
     * @param serviceType service type like <code>FSS1</code>
     * @return msg xml format HeartBeat message that need to send to IMF server
     */
    public static String buildHbResponseMessage(String receiver,String serviceType,String serviceStatus,String heartBeatRequestID) {

        if (serviceType == null) {
            return null;
        }

        String msg = heartbeat_responseTemplate;
        String seqId = null;


            seqId = pg1.generateNextNumber();
            //msg = load("heartbeat_response.xml");
            msg = StringUtils.replaceOnce(msg, "@seqId@", seqId);
            msg = StringUtils.replaceOnce(msg, "@serviceType@", serviceType);
            msg = StringUtils.replaceOnce(msg, "@sendTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@createTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@originalTime@",new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@receiver@", receiver);
            msg = StringUtils.replaceOnce(msg, "@sender@", "IB");
            msg = StringUtils.replaceOnce(msg, "@owner@", "IB");
            msg = StringUtils.replaceOnce(msg, "@ServiceStatus@", serviceStatus);
            msg = StringUtils.replaceOnce(msg, "@HeartBeatRequestID@", heartBeatRequestID);

        return msg;
    }
    public static String buildExcptionResponseMessage(String receiver,String serviceType,String exceptionCode,String exceptionMessage) {

        if (serviceType == null) {
            return null;
        }

        String msg = exception_responseTemplate;
        String seqId = null;
            seqId = pg1.generateNextNumber();
            //msg = load("exceptio_response.xml");
            msg = StringUtils.replaceOnce(msg, "@seqId@", seqId);
            msg = StringUtils.replaceOnce(msg, "@serviceType@", serviceType);
            msg = StringUtils.replaceOnce(msg, "@sendTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@createTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@originalTime@",new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@receiver@", receiver);
            msg = StringUtils.replaceOnce(msg, "@sender@", "IB");
            msg = StringUtils.replaceOnce(msg, "@owner@", "IB");
            msg = StringUtils.replaceOnce(msg, "@ExceptionCode@", "01");
            msg = StringUtils.replaceOnce(msg, "@ExceptionMessage@", exceptionMessage);

        return msg;
    }
    public static String buildSubscribeResponseMessage(String receiver,String serviceType,String subscriptionStatus,String subscriptionRequestID) {

        if (serviceType == null) {
            return null;
        }

        String msg = subscription_responseTemplate;
        String seqId = null;
            seqId = pg1.generateNextNumber();
            //msg = load("subscription_response.xml");
            msg = StringUtils.replaceOnce(msg, "@seqId@", seqId);
            msg = StringUtils.replaceOnce(msg, "@serviceType@", serviceType);
            msg = StringUtils.replaceOnce(msg, "@sendTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@createTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@originalTime@",new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@receiver@", receiver);
            msg = StringUtils.replaceOnce(msg, "@sender@", "IB");
            msg = StringUtils.replaceOnce(msg, "@owner@", "IB");
            msg = StringUtils.replaceOnce(msg, "@SubscriptionStatus@", subscriptionStatus);
            msg = StringUtils.replaceOnce(msg, "@SubscriptionRequestID@", subscriptionRequestID);
        return msg;
    }
    /**
     * Build Subscribe request message.You can invoke the method like this:ImfMessageBuilder.buildSubscribeMessage(ImfServiceType.FSS1)
     * 
     * @param serviceType service type like <code>FSS1</code>
     * @return msg xml format Subscribe message that need to send to IMF server
     */
    public static String buildUnsubscribeMessage(String receiver,String serviceType,String unsubscriptionStatus,String unsubscriptionRequestID) {

        if (serviceType == null) {
            return null;
        }

        String msg = unsubscription_responseTemplate;
        String seqId = null;

            seqId = pg1.generateNextNumber();
           // msg = load("unsubscription_response.xml");
            msg = StringUtils.replaceOnce(msg, "@seqId@", seqId);
            msg = StringUtils.replaceOnce(msg, "@serviceType@", serviceType);
            msg = StringUtils.replaceOnce(msg, "@sendTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@createTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@originalTime@",new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@receiver@", receiver);
            msg = StringUtils.replaceOnce(msg, "@sender@", "IB");
            msg = StringUtils.replaceOnce(msg, "@owner@", "IB");
            msg = StringUtils.replaceOnce(msg, "@UnsubscriptionRequestID@", unsubscriptionRequestID);
            msg = StringUtils.replaceOnce(msg, "@UnsubscriptionStatus@", unsubscriptionStatus);
        return msg;
    }
    public static String buildXss2RequestMessage(String receiver,String serviceType,String requestStatus,String requestID) {

        if (serviceType == null) {
            return null;
        }

        String msg = unsubscription_responseTemplate;
        String seqId = null;

            seqId = pg1.generateNextNumber();
           // msg = load("unsubscription_response.xml");
            msg = StringUtils.replaceOnce(msg, "@seqId@", seqId);
            msg = StringUtils.replaceOnce(msg, "@serviceType@", serviceType);
            msg = StringUtils.replaceOnce(msg, "@sendTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@createTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@originalTime@",new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@receiver@", receiver);
            msg = StringUtils.replaceOnce(msg, "@sender@", "IB");
            msg = StringUtils.replaceOnce(msg, "@owner@", "IB");
        return msg;
    }
    public static String buildXss2RequestResponseMessage(String receiver,String serviceType,String requestStatus,String requestID) {

        if (serviceType == null) {
            return null;
        }

        String msg = unsubscription_responseTemplate;
        String seqId = null;

            seqId = pg1.generateNextNumber();
           // msg = load("unsubscription_response.xml");
            msg = StringUtils.replaceOnce(msg, "@seqId@", seqId);
            msg = StringUtils.replaceOnce(msg, "@serviceType@", serviceType);
            msg = StringUtils.replaceOnce(msg, "@sendTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@createTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@originalTime@",new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@receiver@", receiver);
            msg = StringUtils.replaceOnce(msg, "@sender@", "IB");
            msg = StringUtils.replaceOnce(msg, "@owner@", "IB");
            msg = StringUtils.replaceOnce(msg, "@SubscriptionRequestID@", requestID);
            msg = StringUtils.replaceOnce(msg, "@SubscriptionStatus@", requestStatus);
        return msg;
    }

    /**
     * Build end message as end flag when AODB sends response business messages to IMF.You can invoke the
     * method like this:ImfMessageBuilder.buildBatchEndMessage(ImfServiceType.FSS2,"IMF",3)
     * 
     * @param serviceType service type like <code>FSS2</code>
     * @param receiver message receiver like "IMF"
     * @param correlationId message sequence id in synchronization request message
     * @param count the count of response business messages from IMF
     * @return xml format end message that need to send to IMF server
     */
    public static String buildBatchEndMessage(String serviceType, String  owner, String receiver, String correlationId,int count) {

        if (serviceType == null) {
            return null;
        }

        String msg = null;
        String seqId = null;

            seqId = pg1.generateNextNumber();
            //msg = load(serviceType.getTypeSeries() + "/" + "end.xml");
            msg = StringUtils.replaceOnce(msg, "@seqId@", seqId);
            msg = StringUtils.replaceOnce(msg, "@serviceType@", serviceType);
            msg = StringUtils.replaceOnce(msg, "@sendTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@createTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@originalTime@",
                                          new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@receiver@", receiver);
            msg = StringUtils.replaceOnce(msg, "@sender@", "IB");
            msg = StringUtils.replaceOnce(msg, "@owner@", owner);
            if (serviceType.contains("SS")) {
                msg = StringUtils.replaceOnce(msg, "@subRequestId@", correlationId);
                // @@subRequestId @@msgCount
                msg = StringUtils.replaceOnce(msg, "@msgCount@", count + "");
            } else if (serviceType.contains("RS")) {
                msg = StringUtils.replaceOnce(msg, "@reqMsgCount@", count + "");
            }

        return msg;
    }

    /**
     * Build start message as start flag when AODB sends response business messages to IMF.You can invoke
     * the method like this:ImfMessageBuilder.buildBatchStartMessage(ImfServiceType.FSS2,"IMF")
     * 
     * @param serviceType service type like <code>FSS2</code>
     * @param receiver message receiver like "IMF"
     * @param correlationId message sequence id in synchronization request message
     * @return xml format start message that need to send to IMF server
     */
    public static String buildBatchStartMessage(String serviceType, String  owner, String receiver, String correlationId) {

        if (serviceType == null) {
            return null;
        }

        String msg = null;
        String seqId = null;
        String repRequestId = null;

            seqId = pg1.generateNextNumber();
            repRequestId = pg2.generateNextNumber();
            // subRequestId = pg3.generateNextNumber();
            //msg = load(serviceType.getTypeSeries() + "/" + "start.xml");
            msg = StringUtils.replaceOnce(msg, "@seqId@", seqId);
            msg = StringUtils.replaceOnce(msg, "@serviceType@", serviceType);
            msg = StringUtils.replaceOnce(msg, "@sendTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@createTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@originalTime@",
                                          new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@receiver@", receiver);
            msg = StringUtils.replaceOnce(msg, "@sender@", "IB");
            msg = StringUtils.replaceOnce(msg, "@owner@",owner);
            if (serviceType.contains("SS")) {

                // @@subRequestId
                msg = StringUtils.replaceOnce(msg, "@subRequestId@", correlationId);
            } else if (serviceType.contains("RS")) {
                msg = StringUtils.replaceOnce(msg, "@repRequestId@", repRequestId);
            }
            logger.debug("the " + serviceType + " start message is " + StringUtils.deleteWhitespace(msg));


        return msg;
    }

    /**
     * Build synchronization request message to request all or period time message from AODB
     * 
     * @param serviceType service type like <code>FSS2</code>
     * @return xml format synchronization request message that need to send to IMF server
     */
    public static String buildSyncRequestMessage(String serviceType, String  owner) {

        Date syncTime = null;
/*        try {
           // syncTime = ImfFileUtil.loadHbTimeStamp(serviceType);
        } catch (ParseException e) {
            logger.error("FSS2 start message build failed: ", e);
        }*/

        return buildSyncRequestMessageForManual(serviceType, owner,syncTime);
    }

    /**
     * Build synchronization request message to request period time from syncStart to current message from AODB
     * 
     * @param serviceType service type like <code>FSS2</code>
     * @param syncStart synchronization start time
     * @return xml format synchronization request message that need to send to IMF server
     */
    public static String buildSyncRequestMessageForManual(String serviceType, String  owner, Date syncStart) {
        return buildSyncRequestMessageForManual( serviceType,   owner, syncStart, null, null);
    }

    /**
     * Build synchronization message or flight schedule period request message.
     * 
     * @param serviceType service type like <code>FSS2</code>
     * @param syncStart synchronization start time
     * @param periodStart flight schedule period start time
     * @param periodEnd flight schedule period end time
     * @return xml format synchronization and flight schedule period request message that need to send to IMF server
     */
    public static String buildSyncRequestMessageForManual(String serviceType, String  owner, Date syncStart, Date periodStart,Date periodEnd) {

        if (serviceType == null) {
            return null;
        }

        String msg = ss2_requestTemplate;
        String seqId = null;
        String subRequestId = null;

            seqId = owner+"@"+pg1.generateNextNumber();
            subRequestId = pg2.generateNextNumber();

           // msg = load(serviceType.getTypeSeries() + "/" + serviceType.getTypeSeries() + "2.xml");
            msg = StringUtils.replaceOnce(msg, "@seqId@", seqId);
            msg = StringUtils.replaceOnce(msg, "@serviceType@", serviceType);
            msg = StringUtils.replaceOnce(msg, "@sendTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@createTime@", new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@originalTime@",new SimpleDateFormat(FORMAT_PATTERN).format(new Date()));
            msg = StringUtils.replaceOnce(msg, "@receiver@", "AODB");
            msg = StringUtils.replaceOnce(msg, "@sender@", "IB");
            msg = StringUtils.replaceOnce(msg, "@owner@", owner);
            // @@subRequestId
            msg = StringUtils.replaceOnce(msg, "@subRequestId@", subRequestId);

            if (syncStart != null) {
                String syncString = "<SyncPeriodRequest><SyncUpdateFromDateTime>"
                                    + new SimpleDateFormat(FORMAT_PATTERN).format(syncStart)
                                    + "</SyncUpdateFromDateTime>" + "</SyncPeriodRequest>";
                msg = StringUtils.replaceOnce(msg, "@sync@", syncString);
            }

            if (periodStart != null || periodEnd != null) {
                String start = "<FlightPeriodRequest>";
                String end = "</FlightPeriodRequest>";
                String periodStartStr = "";
                if (periodStart != null) {
                    periodStartStr = "<FlightScheduleFromDateTime>"
                                     + new SimpleDateFormat(FORMAT_PATTERN).format(periodStart)
                                     + "</FlightScheduleFromDateTime>";
                }
                String periodEndStr = "";
                if (periodEnd != null) {
                    periodEndStr = "<FlightScheduleEndDateTime>"
                                   + new SimpleDateFormat(FORMAT_PATTERN).format(periodEnd)
                                   + "</FlightScheduleEndDateTime>";
                }
                msg = StringUtils.replaceOnce(msg, "@period@", start + periodStartStr + periodEndStr + end);
            }

            // request all XSS2 datas
            msg = StringUtils.replaceOnce(msg, "@sync@", "");
            msg = StringUtils.replaceOnce(msg, "@period@", "");


        return msg;
    }

    /**
     * Convert a BytesMessage into TextMessage
     * 
     * @param msg Bytes format message
     * @return message text format message
     */
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
                message = new String(buff, "UTF-8");
            } catch (Exception e) {
                logger.error("convert message failed:", e);
            }
        }

        String p = "<IMFRoot";
        if (StringUtils.isNotEmpty(message) && StringUtils.containsIgnoreCase(message, p)
            && !StringUtils.startsWithIgnoreCase(message, p)) {
            message = p + StringUtils.substringAfter(message, p);
        }

        return message;
    }

    /**
     * Load particular path file to String
     * 
     * @param path file storage path
     * @return file that has been converted to String type
     * @throws IOException if the file path is not correct or the file is not exist, the method will throw a IOException
     */
    private static String load(String path) throws IOException {
        if (StringUtils.isEmpty(path)) {
            return null;
        }

        Resource resource =   new ClassPathResource("path");
        InputStream resourceInputStream = resource.getInputStream();
        String result =  IOUtils.toString(resourceInputStream, "UTF-8");

        return result;
    }

    /**
     * Get message receiver name
     * 
     * @param message message that send out
     * @return message receiver name
     */
    public static String getReceiver(String message) {
        return StringUtils.substringBetween(message, "<Receiver>", "</Receiver>");
    }
}
