/**
 * Project	 ibSystem
 * Package   com.tsystems.si.aviation.imf.ibSystem.message
 * FileName  ImfXmlTransformer.java
 * Description TODO
 * Company	
 * Copyright 2017 
 * All rights Reserved, Designed By Bolo Fang
 * 
 * @author Bolo Fang
 * @version V1.0
 * Email 342067200@qq.com
 * Createdate 2017年7月6日 下午2:17:40
 *
 * Modification  History
 * Date          Author        Version        Description
 * -----------------------------------------------------------------------------------
 * 2017年7月6日       方红波          1.0             1.0
 * Why & What is modified
 */

package com.tsystems.si.aviation.imf.ibSystem.message;


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


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
  * ClassName ImfXmlTransformer<BR>
  * Description TODO<BR>
  * @author Bolo Fang
  * @date 2017年7月6日 下午2:17:40
  *
  */

public class ImfXmlTransformer implements XmlTransformer {
	private static final Logger     logger               = LoggerFactory.getLogger(AdapterXmlTransformer.class);
	//public String xslPath;
	public String xsl;
	public Transformer transformer;
	
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
        if(xsl==null){
        	logger.warn("xsl is null!");
        	logger.warn("No filter!");
        }else{
        	
        	try {
				transformer = TransformerFactory.newInstance().newTransformer(new StreamSource(new StringReader(xsl)));
			} catch (TransformerConfigurationException | TransformerFactoryConfigurationError e) {
				// TODO Auto-generated catch block
				logger.error(e.getMessage(), e);
				return false;
			}
        	transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        }
		
		return true;
		
	}
}
