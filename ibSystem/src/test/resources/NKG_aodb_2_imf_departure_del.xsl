<!-- Version 1.0 2014-08-11 create by zzhao; -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:aodb="urn:com.tsystems.ac.aodb"
	xmlns:javacode="com.tsystems.aviation.mqif.adapter.util.MqifXsltUtil"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0"
	exclude-result-prefixes="aodb soap-env javacode">
	<xsl:output method="xml" indent="yes" />
	<xsl:param name="aodb_servicetype" />
	<xsl:template match="/">
		<xsl:variable name="dataType"
			select="name(/soap-env:Envelope/soap-env:Body/*[1])"></xsl:variable>
		<IMFRoot>
			<xsl:variable name="Date" select="javacode:getDate()"></xsl:variable>
			<!-- The next is to do the general SysInfo part , all the service will 
				call this part to fill the Sysinfo -->				
			<xsl:for-each select="/soap-env:Envelope/soap-env:Body">
				<SysInfo>
					<MessageSequenceID>
						<xsl:value-of select="javacode:generateSequence('FSS1')" />
					</MessageSequenceID>
					<MessageType>FlightData</MessageType>
					<ServiceType>FSS1</ServiceType>
					<OperationMode>DEL</OperationMode>
					<SendDateTime>
						<xsl:value-of select="$Date" />
					</SendDateTime>
					<CreateDateTime>
						<xsl:value-of select="$Date" />
					</CreateDateTime>
					<OriginalDateTime>
					<xsl:value-of select="pl_turn/pt_pa_arrival/pl_arrival/pa_modtime" />
					</OriginalDateTime>
					<Receiver>IMF</Receiver>
					<Sender>AODB</Sender>
					<Owner>AODB</Owner>
					<Priority>4</Priority>
				</SysInfo>
				<xsl:for-each select="pl_turn">
				    <xsl:variable name="pa_ral_airline">
						<xsl:value-of select="normalize-space(pt_pa_arrival/pl_arrival/pa_ral_airline/text())"/>
					</xsl:variable>
					<xsl:variable name="pd_ral_airline">					
					    <xsl:value-of select="normalize-space(pt_pd_departure/pl_departure/pd_ral_airline/text())"/>
					</xsl:variable>					
					<Data>						
						<!--Start of departure del mapping  -->
						<xsl:for-each select="pt_pd_departure/pl_departure">
							<PrimaryKey>				
								<FlightKey>
									<FlightScheduledDate>																			
										<xsl:value-of select="substring(pd_srtd,1,10)" />
									</FlightScheduledDate>
									<FlightIdentity>
									<xsl:value-of select="pd_flightnumber" />						
									</FlightIdentity>
									<FlightDirection>D</FlightDirection>
									<BaseAirport>
										<AirportIATACode>NKG</AirportIATACode>
										<AirportICAOCode>ZSNJ</AirportICAOCode>
									</BaseAirport>
																		
									<xsl:for-each select="pd_ral_airline/ref_airline">
										<DetailedIdentity>
											<AirlineIATACode>
												<xsl:value-of select="normalize-space(ral_2lc/text())" />
											</AirlineIATACode>
											<AirlineICAOCode>
													<xsl:value-of select="normalize-space(ral_3lc/text())" />
											</AirlineICAOCode>
											<!-- change flightnumber mapping rule as flightnumber= flightidentity-pa_ral_airline -->
											<FlightNumber>
												<xsl:variable name="flightNumber" select="../../pd_flightnumber" />												
												<xsl:value-of
													select="javacode:getFlightNumber($flightNumber, $pd_ral_airline)" />
											</FlightNumber>
											<FlightSuffix>
												<xsl:variable name="flightNumber" select="../../pd_flightnumber" />											
												<xsl:value-of select="javacode:getFlightSuffix($flightNumber)" />
											</FlightSuffix>
										</DetailedIdentity>
									</xsl:for-each>
								</FlightKey>
							</PrimaryKey>
						</xsl:for-each>
						<!--End of departure del mapping  -->
					</Data>
				</xsl:for-each>
			</xsl:for-each>
		</IMFRoot>
	</xsl:template>
</xsl:stylesheet>