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

public class XmlTransformerTest {
	private static final Logger     logger               = LoggerFactory.getLogger(XmlTransformerTest.class);
	public AdapterXmlTransformer adapterXmlTransformerArrival = new AdapterXmlTransformer();
	public String xmlIMF;
	@Before
	public void init(){
		adapterXmlTransformerArrival.setXslPath("fssfuel2.xsl");
		adapterXmlTransformerArrival.initialize();
		//File xmlFileArrival = new File("file/Mqif_pl_turn_dataset_Response_turn_FIDS2.xml");
		//File xmlFileArrival = new File("file/Mqif_pl_turn_turn_ArrivalBelt_FIDS.xml");
		File xmlFileArrival = new File("file/FUEL2.xml");
		try {
			xmlIMF = FileUtils.readFileToString(xmlFileArrival, "utf-8");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Test
	public void testTransformerArrival(){
		String newXml = adapterXmlTransformerArrival.transform(xmlIMF);
		logger.info("New IMF Xml:\n{}",newXml);
		
/*		boolean result = XmlValidator.validate(newXml);
		logger.info("validate:\n{}",result);*/
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
