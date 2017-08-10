<?xml version="1.0" encoding="UTF-8"?>
<!-- 
 * $Id: remove_empty_nodes.xsl,v 1.2 2014/05/23 09:41:39 jac Exp $
 * $Source: /u01/CVS_Repositories/RAT/src/config/ALL/stylesheets/remove_empty_nodes.xsl,v $
 * $Revision: 1.2 $
 * $Date: 2014/05/23 09:41:39 $
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                version="1.0">

  <xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>

  <xsl:template match="*[string-length(normalize-space())>0 or @xsi:nil or string-length(normalize-space(.//*))>0 or .//@xsi:nil]">
    <xsl:element name="{name(.)}">
      <xsl:copy-of select="./@*"/>
      <xsl:value-of select="text()" />
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text()|*"/>

</xsl:stylesheet>
