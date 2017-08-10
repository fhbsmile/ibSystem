/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.camels
 * FileName  ImfMessageAdapterProcessorTest.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年8月1日 下午2:42:16
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年8月1日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.camels;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.junit.Before;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tsystems.si.aviation.imf.ibSystem.message.AdapterXmlTransformer;

/**
  * ClassName ImfMessageAdapterProcessorTest<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年8月1日 下午2:42:16
  *
  */

public class ImfMessageAdapterProcessorTest {
	private static final Logger     logger               = LoggerFactory.getLogger(ImfMessageAdapterProcessorTest.class);
	private ImfMessageAdapterProcessor imfMessageAdapterProcessor = new ImfMessageAdapterProcessor();
	private AdapterXmlTransformer cgkAdapterImfXmlTransformer = new AdapterXmlTransformer();
	
	@Before
	public void init(){
		cgkAdapterImfXmlTransformer.setXslPath("CGK_imf_2_aodb.xsl");
		cgkAdapterImfXmlTransformer.initialize();
		imfMessageAdapterProcessor.setXmlTransformer(cgkAdapterImfXmlTransformer);

	}
	
	@Test
	public void testTransformerFSSSyncRequest(){
		File cgkImfXml_FSSSyncRequestFile = new File("file/Imf_FSS_SYNC_request.xml");
		String cgkImfXml_FSSSyncRequest=null;
		try {
			cgkImfXml_FSSSyncRequest = FileUtils.readFileToString(cgkImfXml_FSSSyncRequestFile, "utf-8");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		imfMessageAdapterProcessor.processImf(cgkImfXml_FSSSyncRequest);
		
		
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
		imfMessageAdapterProcessor.processImf(cgkImfXml_BSSDatasetRequest);		
	}
	
	@Test
	public void testTransformerUsUpdateRequest(){
		File cgkImfXml_UsUpdateRequestFile = new File("file/Imf_US_ArrivalBelt.xml");
		String cgkImfXml_UsUpdateRequest =null;
		try {
			cgkImfXml_UsUpdateRequest = FileUtils.readFileToString(cgkImfXml_UsUpdateRequestFile, "utf-8");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		imfMessageAdapterProcessor.processImf(cgkImfXml_UsUpdateRequest);		
	}
}
