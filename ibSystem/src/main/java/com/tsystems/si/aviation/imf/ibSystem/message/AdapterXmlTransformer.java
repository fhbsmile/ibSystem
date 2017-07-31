/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.message
 * FileName  AdapterXmlTransformer.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月5日 下午3:51:56
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月5日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.message;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

/**
  * ClassName AdapterXmlTransformer<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月5日 下午3:51:56
  *
  */

public class AdapterXmlTransformer implements XmlTransformer {
	private static final Logger     logger               = LoggerFactory.getLogger(AdapterXmlTransformer.class);
	public String xslPath;
	public String xsl;
	private Transformer transformer;
	
	public String transform(String xml){
		
		Source xmlInput = new StreamSource(new StringReader(xml));
        StringWriter stringWriter = new StringWriter();
        StreamResult xmlOutput = new StreamResult(stringWriter);
        	try {
				transformer.transform(xmlInput, xmlOutput);
			} catch (TransformerException e) {
				logger.error(e.getMessage(), e);
			}
        String result = xmlOutput.getWriter().toString();
        return result;
	}
	
	public boolean initialize(){

		if(xslPath!=null){
			Resource resource =   new ClassPathResource(xslPath);
			InputStream xslStream=null;
			try {
				xslStream = resource.getInputStream();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				logger.error(e.getMessage(), e);
				logger.error("System exit!");
				System.exit(0);
			}
			try {
				xsl =  IOUtils.toString(xslStream, "UTF-8");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				logger.error(e.getMessage(), e);
				logger.error("System exit!");
				System.exit(0);
			}
		}
        if(xsl==null){
        	logger.error("xsl is null!");
        }else{
        	
        	try {
				transformer = TransformerFactory.newInstance().newTransformer(new StreamSource(new StringReader(xsl)));
			} catch (TransformerConfigurationException | TransformerFactoryConfigurationError e) {
				// TODO Auto-generated catch block
				logger.error(e.getMessage(), e);
				logger.error("System exit!");
				System.exit(0);
			}
        	transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        }
		
		return true;
		
	}

	public String getXslPath() {
		return xslPath;
	}

	public void setXslPath(String xslPath) {
		this.xslPath = xslPath;
	}

	public String getXsl() {
		return xsl;
	}

	public void setXsl(String xsl) {
		this.xsl = xsl;
	}
	
	
	
}
