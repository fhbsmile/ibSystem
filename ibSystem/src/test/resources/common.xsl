<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
	<xsl:variable name="opera" select="IMFRoot/SysInfo/OperationMode" />
	<xsl:template match="IMFRoot">
		<xsl:copy>
			<xsl:apply-templates select="SysInfo" />
			<xsl:if test="Data">
				<xsl:apply-templates select="Data" />
			</xsl:if>
			<xsl:if test="Operation">
				<xsl:apply-templates select="Operation" />
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="SysInfo">
		<xsl:copy>
			<xsl:copy-of select="./*" />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Data">
		<xsl:copy>
			<xsl:apply-templates select="PrimaryKey" />
			<xsl:apply-templates select="FlightData" />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="PrimaryKey">
		<xsl:copy>
			<xsl:copy-of select="./*" />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Operation">
		<xsl:copy>
			<xsl:copy-of select="./*" />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*">
		<xsl:if test="$opera='NEW'">
			<xsl:copy>
				<xsl:copy-of select="./@*[not(name()='OldValue')]" />
				<xsl:apply-templates />
			</xsl:copy>
		</xsl:if>
		<xsl:if test="$opera!='NEW'">
			<xsl:copy>
				<xsl:copy-of select="./@*" />
				<xsl:apply-templates />
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	<xsl:template match="IMFRoot/Data/FlightData/OperationalDateTime/FlyTime"/>
	<xsl:template match="IMFRoot/Data/FlightData/General/FreeTextComment/CreateReason "/>
</xsl:stylesheet>