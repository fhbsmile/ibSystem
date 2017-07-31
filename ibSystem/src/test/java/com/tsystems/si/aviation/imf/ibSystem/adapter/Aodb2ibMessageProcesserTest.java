/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.adapter
 * FileName  Aodb2ibMessageProcesserTest.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月14日 下午2:11:31
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月14日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.adapter;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.junit.Before;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tsystems.si.aviation.imf.ibSystem.message.AdapterXmlTransformer;

/**
  * ClassName Aodb2ibMessageProcesserTest<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月14日 下午2:11:31
  *
  */

public class Aodb2ibMessageProcesserTest {
	private static final Logger     logger               = LoggerFactory.getLogger(Aodb2ibMessageProcesserTest.class);
	public Aodb2ibMessageProcesser aodb2ibMessageProcesser = new Aodb2ibMessageProcesser();
	public AdapterXmlTransformer xmlTransformer = new AdapterXmlTransformer();
	public AdapterXmlTransformer xmlDepatureTransformer = new AdapterXmlTransformer();
	public String mqifMessage;
	
	@Before
	public void init(){
		xmlTransformer.setXslPath("CGK_aodb_2_imf.xsl");
		xmlTransformer.initialize();
		xmlDepatureTransformer.setXslPath("CGK_aodb_2_imf_departure.xsl");
		xmlDepatureTransformer.initialize();
		aodb2ibMessageProcesser.setXmlTransformer(xmlTransformer);
		aodb2ibMessageProcesser.setXmlDepatureTransformer(xmlDepatureTransformer);
		File xmlFileArrival = new File("file/Mqif_pl_turn_dataset_Response_turn_FIDS4.xml");
		//File xmlFileArrival = new File("file/Mqif_pl_turn_dataset_Response_turn_FIDS3.xml");
		try {
			mqifMessage = FileUtils.readFileToString(xmlFileArrival, "utf-8");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@Test
	public void processTest(){
		aodb2ibMessageProcesser.process(mqifMessage);
	}
}
