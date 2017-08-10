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

public class AdapterImfXmlTransformerTest {
	private static final Logger     logger               = LoggerFactory.getLogger(AdapterImfXmlTransformerTest.class);
	public AdapterXmlTransformer cgkAdapterImfXmlTransformer = new AdapterXmlTransformer();
	public String cgkImfXml_FSSSyncRequest;
	public String cgkImfXmlDeparture;
	public String cgkImfXmlBSS;
	public String xmlIMF;
	@Before
	public void init(){
		cgkAdapterImfXmlTransformer.setXslPath("CGK_imf_2_aodb.xsl");
		cgkAdapterImfXmlTransformer.initialize();


	}
	@Test
	public void testTransformerFSSSyncRequest(){
		File cgkImfXml_FSSSyncRequestFile = new File("file/Imf_FSS_SYNC_request.xml");
		try {
			cgkImfXml_FSSSyncRequest = FileUtils.readFileToString(cgkImfXml_FSSSyncRequestFile, "utf-8");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		boolean result = XmlValidator.validate(cgkImfXml_FSSSyncRequest);
		logger.info("validate:\n{}",result);
		String newXml = cgkAdapterImfXmlTransformer.transform(cgkImfXml_FSSSyncRequest);
		logger.info("New Mqif Xml:\n{}",newXml);
		
		
		
	}
	
	@Test
	public void testTransformerBSSDatasetRequest(){
		File cgkImfXml_BSSDatasetRequestFile = new File("file/Imf_BSS_Dataset_request.xml");
		String cgkImfXml_BSSDatasetRequest =null;
		try {
			cgkImfXml_BSSDatasetRequest = FileUtils.readFileToString(cgkImfXml_BSSDatasetRequestFile, "utf-8");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		boolean result = XmlValidator.validate(cgkImfXml_BSSDatasetRequest);
		logger.info("validate:\n{}",result);
		String newXml = cgkAdapterImfXmlTransformer.transform(cgkImfXml_BSSDatasetRequest);
		logger.info("New Mqif Xml:\n{}",newXml);
		
		
		
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
