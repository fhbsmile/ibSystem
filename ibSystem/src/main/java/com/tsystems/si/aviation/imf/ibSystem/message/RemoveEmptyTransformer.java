package com.tsystems.si.aviation.imf.ibSystem.message;


import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

public class RemoveEmptyTransformer {
	private static final Logger     logger               = LoggerFactory.getLogger(RemoveEmptyTransformer.class);
	
	private static String xslName ="remove_empty_nodes.xsl";
	private static Transformer transformer;
	private static String xsl;
	private static Source xslSource;
	static{

	 try {
         Resource xslResource =   new ClassPathResource(xslName);
         InputStream xslInputStream = xslResource.getInputStream();
         xsl =  IOUtils.toString(xslInputStream, "UTF-8");
          logger.info("xsl:\n{}",xsl);
      } catch (IOException ex) {
         logger.error("xsl not found, system exit!", ex);
         System.exit(0);
      }

	 xslSource = new StreamSource(new StringReader(xsl));
	try {
		transformer = TransformerFactory.newInstance().newTransformer(xslSource);
		transformer.setOutputProperty(OutputKeys.INDENT, "yes");
	} catch (TransformerConfigurationException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		System.exit(0);
	} catch (TransformerFactoryConfigurationError e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		System.exit(0);
	}
	
	}
	public static String xmlFilter(String xml){
		String result = xml;
		Source xmlInput = new StreamSource(new StringReader(xml));
		StringWriter stringWriter = new StringWriter();
        StreamResult xmlOutput = new StreamResult(stringWriter);
        try {
        	transformer.transform(xmlInput, xmlOutput);
        } catch (Exception e) {
        	logger.error(e.getMessage(), e);
            return result;
        }
        result=xmlOutput.getWriter().toString();
        logger.info("After filter: \n{}",result);
        return result;

	}
}
