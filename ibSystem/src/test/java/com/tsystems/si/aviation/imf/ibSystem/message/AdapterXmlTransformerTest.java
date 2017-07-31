/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.message
 * FileName  AdapterXmlTransformerTest.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月6日 下午2:26:09
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月6日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.message;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.junit.Before;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
  * ClassName AdapterXmlTransformerTest<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月6日 下午2:26:09
  *
  */

public class AdapterXmlTransformerTest {
	private static final Logger     logger               = LoggerFactory.getLogger(AdapterXmlTransformerTest.class);
	public AdapterXmlTransformer adapterXmlTransformerArrival = new AdapterXmlTransformer();
	public AdapterXmlTransformer adapterXmlTransformerDeparture = new AdapterXmlTransformer();
	public AdapterXmlTransformer adapterXmlTransformerBSS = new AdapterXmlTransformer();
	public AdapterXmlTransformer cgkAdapterXmlTransformer = new AdapterXmlTransformer();
	public AdapterXmlTransformer cgkAdapterXmlTransformerDeparture = new AdapterXmlTransformer();
	public String MqifXmlArrival;
	public String MqifXmlDeparture;
	public String MqifXmlBSS;
	public String cgkMqifXml;
	public String cgkMqifXmlDeparture;
	public String cgkMqifXmlBSS;
	public String xmlIMF;
	@Before
	public void init(){
		adapterXmlTransformerArrival.setXslPath("aodb_2_ib_fss_arr.xsl");
		adapterXmlTransformerArrival.initialize();
		//File xmlFileArrival = new File("file/Mqif_pl_turn_dataset_Response_turn_FIDS2.xml");
		//File xmlFileArrival = new File("file/Mqif_pl_turn_turn_ArrivalBelt_FIDS.xml");
		File xmlFileArrival = new File("file/Mqif_pl_turn_dataset_Response_turn_FIDS3.xml");
		try {
			MqifXmlArrival = FileUtils.readFileToString(xmlFileArrival, "utf-8");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		adapterXmlTransformerDeparture.setXslPath("aodb_2_ib_fss_dep.xsl");
		adapterXmlTransformerDeparture.initialize();
		File xmlFileDeparture = new File("file/Mqif_pl_turn_turn_Actual_Checkin_Security_Boarding_ATC.xml");
		try {
			MqifXmlDeparture = FileUtils.readFileToString(xmlFileDeparture, "utf-8");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		adapterXmlTransformerBSS.setXslPath("aodb_2_ib_bss.xsl");
		adapterXmlTransformerBSS.initialize();
		File xmlFileBSS = new File("file/Mqif_ref_servicetypecode_dataset_Response_ATC1.xml");
		try {
			MqifXmlBSS = FileUtils.readFileToString(xmlFileBSS, "utf-8");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		cgkAdapterXmlTransformer.setXslPath("CGK_aodb_2_imf.xsl");
		cgkAdapterXmlTransformer.initialize();
		//File xmlFileArrival = new File("file/Mqif_pl_turn_dataset_Response_turn_FIDS2.xml");
		//File xmlFileArrival = new File("file/Mqif_pl_turn_turn_ArrivalBelt_FIDS.xml");
		File cgkXmlFileArrival = new File("file/Mqif_pl_turn_dataset_Response_turn_FIDS3.xml");
		try {
			cgkMqifXml = FileUtils.readFileToString(cgkXmlFileArrival, "utf-8");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		cgkAdapterXmlTransformerDeparture.setXslPath("CGK_aodb_2_imf_departure.xsl");
		cgkAdapterXmlTransformerDeparture.initialize();
		//File xmlFileArrival = new File("file/Mqif_pl_turn_dataset_Response_turn_FIDS2.xml");
		//File xmlFileArrival = new File("file/Mqif_pl_turn_turn_ArrivalBelt_FIDS.xml");
		File cgkXmlFileDeparture = new File("file/Mqif_pl_turn_dataset_Response_turn_FIDS4.xml");
		try {
			cgkMqifXmlDeparture = FileUtils.readFileToString(cgkXmlFileDeparture, "utf-8");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testTransformerArrival(){
		String newXml = adapterXmlTransformerArrival.transform(MqifXmlArrival);
		logger.info("New IMF Xml:\n{}",newXml);
		
		boolean result = XmlValidator.validate(newXml);
		logger.info("validate:\n{}",result);
	}
	
	@Test
	public void testTransformerDeparture(){
		String newXml = adapterXmlTransformerDeparture.transform(MqifXmlDeparture);
		logger.info("New IMF Xml:\n{}",newXml);
		
		boolean result = XmlValidator.validate(newXml);
		logger.info("validate:\n{}",result);
	}
	
	@Test
	public void testTransformerBSS(){
		String newXml = adapterXmlTransformerBSS.transform(MqifXmlBSS);
		logger.info("New BSS IMF Xml:\n{}",newXml);
		
		boolean result = XmlValidator.validate(newXml);
		logger.info("validate:\n{}",result);
	}
	@Test
	public void testCgkTransformer(){
		String newXml = cgkAdapterXmlTransformer.transform(cgkMqifXml);
		logger.info("New IMF Xml:\n{}",newXml);
		
		boolean result = XmlValidator.validate(newXml);
		logger.info("validate:\n{}",result);
	}
	
	@Test
	public void testCgkTransformerDeparture(){
		String newXml = cgkAdapterXmlTransformerDeparture.transform(cgkMqifXmlDeparture);
		logger.info("New IMF Xml:\n{}",newXml);
		
		boolean result = XmlValidator.validate(newXml);
		logger.info("validate:\n{}",result);
	}
	
	@Test
	public void testXmlValidator(){
		File xmlIMFFile = new File("file/IMF_US_ArrivalBelt.xml");
		try {
			 xmlIMF = FileUtils.readFileToString(xmlIMFFile, "utf-8");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		boolean result = XmlValidator.validate(xmlIMF);
		logger.info("validate:\n{}",result);
	}
	
	
}
