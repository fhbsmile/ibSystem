package com.tsystems.si.aviation.imf.ibSystem.message;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class XsltUtil {

	private static int i = 0;
	private static final Logger logger = LoggerFactory.getLogger(XsltUtil.class);

	private static final String FORMAT_PATTERN = "yyyy-MM-dd'T'HH:mm:ss.SSS";
	private static final String UTC_FORMAT_PATTERN = "yyyy-MM-dd'T'HH:mm:ss'Z'";
	private static final String LOCAL_FORMAT_PATTERN = "yyyy-MM-dd'T'HH:mm:ss";
	private static DateFormat utcformat = new SimpleDateFormat(UTC_FORMAT_PATTERN);
	private static DateFormat localformat = new SimpleDateFormat(LOCAL_FORMAT_PATTERN);
	static {
		utcformat.setTimeZone(TimeZone.getTimeZone("GMT"));
	}

	public static Boolean compareString(String arg1, String arg2) {
		return arg1.equals(arg2);
	}

	public static String getDate() {
		SimpleDateFormat dateformat = new SimpleDateFormat(FORMAT_PATTERN);
		return dateformat.format(new Date());
	}

	public static String dateToDatetime(String date) {
		if (StringUtils.isNotEmpty(date)) {
			date = date + "T00:00:00";
		}
		return date;
	}

	public static String buildRequestUTCTime(String str) {
		java.util.Calendar cal = java.util.Calendar.getInstance();
		int zoneOffset = cal.get(java.util.Calendar.ZONE_OFFSET);
		int Utc = zoneOffset / 60 / 60 / 1000;
		String subStr = "Z";
		// String st = str.substring(str.length()-1);
		i++;
		if (StringUtils.isNotBlank(str) && str.contains(subStr) && str.length() >= 20) {
			logger.info("时间：" + str);
			str = str.replace("T", " ");
			str = str.replace("Z", "");
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date = null;
			try {
				date = sdf.parse(str);
				logger.info("转换后的时间：" + str);
			} catch (ParseException e) {

				e.printStackTrace();
			}
			Calendar ca = Calendar.getInstance();
			ca.setTime(date);
			ca.add(Calendar.HOUR_OF_DAY, Utc);
			str = sdf.format(ca.getTime());
			str = str.replace(" ", "T");
			logger.info(str);
		}
		return str;
	}

	public static String convertUTC2Time(String utcDateTime) {
		Date UTCDate = null;
		String localTimeStr = utcDateTime;
		if (StringUtils.isNotBlank(utcDateTime) && utcDateTime.contains("Z") && utcDateTime.length() >= 20) {
			try {
				UTCDate = utcformat.parse(utcDateTime);
				// logger.info("UTCDate:{}",UTCDate);
				// logger.info("TimeZone:{}",utcformat.getTimeZone());
				localTimeStr = localformat.format(UTCDate);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		return localTimeStr;
	}

	/**
	 * Method <code>getMessageType</code> is used to get the message
	 * type(Operation,FlightData,BasicData,ResourceData) for the XSLT file
	 * through the service type and message type
	 * 
	 * @param serviceType
	 *            service type such as FSS1,FSS2,FUS,BSS,RSS
	 * @param messageType
	 *            message type in source XML file
	 * @return String the message type that XSLT file needs
	 */
	public static String getImfMessageTypeByMqif(String imfServiceType, String aodbMessageType) {
		String messageTypeReturn = null;
		if ("ACK".equalsIgnoreCase(aodbMessageType) || "NACK".equalsIgnoreCase(aodbMessageType)) {
			messageTypeReturn = "Operation";
		}else {
				if (imfServiceType.contains("FSS")) {
					messageTypeReturn = "FlightData";
				} else if (imfServiceType.contains("BSS")) {
					messageTypeReturn = "BasicData";
				} else if (imfServiceType.contains("RSS")) {
					messageTypeReturn = "ResourceData";
				} else if (imfServiceType.contains("FUS") || imfServiceType.contains("RUS") || imfServiceType.contains("GUS")) {
					messageTypeReturn = "Operation";
				} else if (imfServiceType.contains("GSS")) {
					messageTypeReturn = "GroundServiceData";
				}
		}
		return messageTypeReturn;
	}

	/**
	 * The method <code>getServiceType</code> is used to call by the xslt file,
	 * it should be static type. It is used to get the service type through
	 * calculating with the param: messageType, dataType, correlationId,
	 * aodb_servicetype
	 * 
	 * @param messageType
	 *            the message type in the xml file
	 * @param dataType
	 *            the message type in the xml file: ref_***, pl_turn_***, rm_***
	 * @param correlationId
	 *            the correlation id in the xml file
	 * @param aodb_servicetype
	 *            the aodb_servicetype is the service type in the xml which is
	 *            will be transformed, it should be: SUBSCRIBE,DATASET,UPDATE
	 */
	public static String getImfServiceTypeByMqif(String aodbMessageType, String aodbOrgMessageType, String dataType,String aodbBodyDataType,String aodbCorrelationId) {
		logger.info("XSLT JavaCode>>>>>>aodbMessageType:{} aodbOrgMessageType:{} dataType:{} aodbBodyDataType:{} aodbCorrelationId:{}",new Object[]{aodbMessageType,aodbOrgMessageType,dataType,aodbBodyDataType,aodbCorrelationId});
		String aodbDataType =aodbBodyDataType;
		if(StringUtils.isBlank(aodbDataType)){
			aodbDataType = dataType;
		}
		String imfServiceType = null;
		// Used to judge the XSS1 service type
		if (MqifMessageTypeRecognizer.SUBSCRIBE.equalsIgnoreCase(aodbMessageType) || MqifMessageTypeRecognizer.UPDATE.equalsIgnoreCase(aodbMessageType)) {
				if (MqifMessageTypeRecognizer.isFlightMessage(aodbDataType)) {
					imfServiceType = "FSS1";
				} else if (MqifMessageTypeRecognizer.isBasicMessage(aodbDataType)) {
					imfServiceType = "BSS1";
				} else if (MqifMessageTypeRecognizer.isReferenceMessage(aodbDataType)) {
					imfServiceType = "RSS1";
				} else if (MqifMessageTypeRecognizer.isGroundServiceMessage(aodbDataType)) {
					imfServiceType = "GSS1";
				}
		}else if (MqifMessageTypeRecognizer.DATASET.equalsIgnoreCase(aodbMessageType)) {

				if (MqifMessageTypeRecognizer.isFlightMessage(aodbDataType)) {
					imfServiceType = "FSS2";
				} else if (MqifMessageTypeRecognizer.isBasicMessage(aodbDataType)) {
					imfServiceType = "BSS2";
				} else if (MqifMessageTypeRecognizer.isReferenceMessage(aodbDataType)) {
					imfServiceType = "RSS2";
				} else if (MqifMessageTypeRecognizer.isGroundServiceMessage(aodbDataType)) {
					imfServiceType = "GSS2";
				}
		}else if( MqifMessageTypeRecognizer.ACK.equalsIgnoreCase(aodbMessageType) || MqifMessageTypeRecognizer.NACK.equalsIgnoreCase(aodbMessageType)){
				if(aodbOrgMessageType!=null && aodbOrgMessageType.equalsIgnoreCase("UPDATE")){
					if (MqifMessageTypeRecognizer.isFlightMessage(aodbDataType)) {
						imfServiceType = "FUS";
					} else if (MqifMessageTypeRecognizer.isBasicMessage(aodbDataType)) {
						imfServiceType = "BUS";
					} else if (MqifMessageTypeRecognizer.isReferenceMessage(aodbDataType)) {
						imfServiceType = "RUS";
					} else if (MqifMessageTypeRecognizer.isGroundServiceMessage(aodbDataType)) {
						imfServiceType = "GUS";
					}
				}else if(aodbOrgMessageType!=null && aodbOrgMessageType.equalsIgnoreCase("DATASET")){
					if (MqifMessageTypeRecognizer.isFlightMessage(aodbDataType)) {
						imfServiceType = "FSS2";
					} else if (MqifMessageTypeRecognizer.isBasicMessage(aodbDataType)) {
						imfServiceType = "BSS2";
					} else if (MqifMessageTypeRecognizer.isReferenceMessage(aodbDataType)) {
						imfServiceType = "RSS2";
					} else if (MqifMessageTypeRecognizer.isGroundServiceMessage(aodbDataType)) {
						imfServiceType = "GSS2";
					}
				}
			
		}
		logger.info("Get imfServiceType {}" + imfServiceType);
		return imfServiceType;
	}
	
	public static String getReceiverByMqifCorrelationId(String aodbCorrelationId) {
		String receiver = "IMF";
		if(aodbCorrelationId!=null && aodbCorrelationId.contains("@")){
			receiver = StringUtils.substringBefore(aodbCorrelationId, "@");
        }
		
		return receiver;
	}
	public static String buildRequestFilter(String value, String prefix) {
		String[] values = StringUtils.split(value, ",");
		String[] prefixs = StringUtils.split(prefix, ",");
		String returnStr = "( ";

		if (StringUtils.isEmpty(value)) {
			for (int i = 0; i < prefixs.length; i++) {
				if (i > 0) {
					returnStr += " or ";
				}
				returnStr += prefixs[i] + " is not null";
			}
		}

		else {
			for (int i = 0; i < values.length; i++) {
				for (int j = 0; j < prefixs.length; j++) {
					if (i > 0 || j > 0) {
						returnStr += " or ";
					}
					returnStr += prefixs[j] + "=''" + values[i] + "''";
				}
			}
		}
		return returnStr + " )";
	}
	
	public static int getPriority(String key, String sender) {
		//return MqifMsgPriorityConfUtil.getPriority(key, sender);
		return 0;
	}
}