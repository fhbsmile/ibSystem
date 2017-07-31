<!--
Version 2.0k 2014-06-23 mod by zzhao mod mapping rule of "flightnumber";
Version 2.0j 2014-05-27 mod by zzhao add node mapping of "CreateReason";
Version 2.0i 2014-05-19 mod by zzhao change mapping rule of "EstimatedOffBlockDateTime" from "pd_eobt"  to "pd_eobtlocal" and "ActualOffBlockDateTime" from "pd_eobtlocal" to "pd_aobt";
version 2.0h 2014-05-15 mod by zzhao change mapping rule for node "ScheduledNextAirportArrivalDateTime" and "ActualNextAirportArrivalDateTime"
version 2.0g 2014-04-30 mod by zzhao "EstimatedOffBlockDateTime" mapping node change from "pd_eobtlocal" to "pd_eobt";
"ActualOffBlockDateTime" mapping node change from "pd_aobt" to "pd_eobtlocal"; "FlightData.OperationalDateTime.GoundHandlelDateTime.ActualGoundHandleStartDateTime" change to "pl_turn.pt_pd_departure.pl_departure.pd_acgt";
"FlightData.OperationalDateTime.GoundHandlelDateTime.ActualGoundHandleEndDateTime" change to "pl_turn.pt_pd_departure.pl_departure.pd_aegt";
Version 2.0f 2014-03-31 mod by zzhao fix bugs on mapping rule about LinkFlight
Version 2.0e 2014-03-24 mod by zzhao 
mod ScheduledGateStartDateTime departure pdg_begingateplan mapping
Version 2.0d 2014-03-04 mod by zzhao
mod CheckInType mapping
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:aodb="urn:com.tsystems.ac.aodb"
	xmlns:javacode="com.tsystems.aviation.mqif.adapter.util.MqifXsltUtil"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0"
	exclude-result-prefixes="aodb soap-env javacode">
	<xsl:output method="xml" indent="yes" />
	<xsl:param name="aodb_servicetype" />
	<xsl:template match="/">
	<xsl:variable name="dataType" select="name(/soap-env:Envelope/soap-env:Body/*[1])"></xsl:variable>
<!-- 	<xsl:choose>
	if on fss1 and there is no action arrtibute in the aodb message, then ignore it.
		<xsl:when test="$dataType ='pl_turn' and not(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/@action[1]) and $aodb_servicetype='SUBSCRIBE' and (not(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_srta or /soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_flightnumber) or (/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_srta and not(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_srta/@old[1])) or (/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_flightnumber and not(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_flightnumber/@old[1])))"></xsl:when>
		<xsl:otherwise> -->
		<IMFRoot>
			<xsl:variable name="messageType"
				select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:message-type"></xsl:variable>
			<xsl:variable name="orgmessageType"
				select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:originator"></xsl:variable>
			<xsl:variable name="internalcorreId"
				select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:correlation-id"></xsl:variable>
			<xsl:variable name="correlationId"
				select="javacode:getRequestId($internalcorreId, $aodb_servicetype)"></xsl:variable>

			<xsl:variable name="serviceTypeReturn"
				select="javacode:getServiceType($messageType,$dataType,$internalcorreId,$aodb_servicetype)"></xsl:variable>
			<xsl:variable name="messageTypeReturn"
				select="javacode:getMessageType($serviceTypeReturn,$messageType)"></xsl:variable>
			<xsl:variable name="receiver"
				select="javacode:getReceiver($internalcorreId,$serviceTypeReturn,$messageType)"></xsl:variable>
			<xsl:variable name="Date" select="javacode:getDate()"></xsl:variable>

			<!-- The next is to do the general SysInfo part , all the service will 
				call this part to fill the Sysinfo -->
			<xsl:for-each select="/soap-env:Envelope/soap-env:Body">
				<SysInfo>
					<!-- <xsl:choose> <xsl:when test="starts-with($dataType,'pl_')"> <MessageSequenceID> 
						<xsl:value-of select="pl_turn/@id" /> </MessageSequenceID> </xsl:when> <xsl:when 
						test="starts-with($dataType,ref_)"> <MessageSequenceID> <xsl:value-of select="*[1]/@id" 
						/> </MessageSequenceID> </xsl:when> </xsl:choose> -->

					<MessageSequenceID>
						<xsl:value-of select="javacode:generateSequence($serviceTypeReturn)" />
					</MessageSequenceID>
					<MessageType>
						<xsl:value-of select="$messageTypeReturn" />
					</MessageType>
					<ServiceType>
						<xsl:value-of select="$serviceTypeReturn" />
					</ServiceType>
					<OperationMode>
						<xsl:call-template name="operation">
							<xsl:with-param name="serviceType" select="$serviceTypeReturn" />
						</xsl:call-template>
					</OperationMode>
					<SendDateTime>
						<xsl:value-of select="$Date" />
					</SendDateTime>
					<CreateDateTime>
						<xsl:value-of select="$Date" />
					</CreateDateTime>
					<OriginalDateTime>
					   <xsl:choose>
							<xsl:when test="$messageType='ACK' or $messageType='NACK'">
								<xsl:value-of select="$Date" />
							</xsl:when>
							<xsl:when test="$dataType = 'pl_turn'">
								<xsl:value-of select="pl_turn/pt_pd_departure/pl_departure/pd_modtime" />
							</xsl:when>
					    </xsl:choose>						
					</OriginalDateTime>
					<Receiver>
						<xsl:value-of select="$receiver"></xsl:value-of>
					</Receiver>
					<Sender>AODB</Sender>
					<Owner>AODB</Owner>
                    <Priority>4</Priority>
				</SysInfo>

				<xsl:if test="$messageType!='ACK' and $messageType!='NACK'">
					<!--The next will judge the the fss1 depature -->
					<xsl:if test="pl_turn">
						<xsl:variable name="iataDestAirport" select="pl_turn/pt_pd_departure/pl_departure/pd_rap_destinationairport/ref_airport/rap_iata3lc" />
						<xsl:variable name="icaoDestAirport" select="pl_turn/pt_pd_departure/pl_departure/pd_rap_destinationairport/ref_airport/rap_icao4lc" />
						<!-- change flightnumber mapping rule as flightnumber= flightidentity-pa_ral_airline  -->
						<xsl:variable name="ral_2lc">
								<xsl:if test="pl_turn/pt_pd_departure/pl_departure/@action='delete'">
								  <xsl:value-of select="normalize-space(pl_turn/pt_pd_departure/pl_departure/pd_ral_airline/ref_airline/ral_2lc/@old)"/>
								</xsl:if>
								<xsl:if test="not(pl_turn/pt_pd_departure/pl_departure/@action) or pl_turn/pt_pd_departure/pl_departure/@action!='delete'">
								  <xsl:value-of select="normalize-space(pl_turn/pt_pd_departure/pl_departure/pd_ral_airline/ref_airline/ral_2lc/text())"/>
								</xsl:if>
						</xsl:variable>
						<xsl:variable name="pd_ral_airline">
						  		<xsl:if test="pl_turn/pt_pd_departure/pl_departure/@action='delete'">
								  <xsl:value-of select="normalize-space(pl_turn/pt_pd_departure/pl_departure/pd_ral_airline/@old)"/>
								</xsl:if>
								<xsl:if test="not(pl_turn/pt_pd_departure/pl_departure/@action) or pl_turn/pt_pd_departure/pl_departure/@action!='delete'">
								  <xsl:value-of select="normalize-space(pl_turn/pt_pd_departure/pl_departure/pd_ral_airline/text())"/>
								</xsl:if>
						</xsl:variable>
						<xsl:variable name="pa_ral_airline">
						  <xsl:if test="pl_turn/pt_pa_arrival/pl_arrival/@action='delete'">
								  <xsl:value-of select="normalize-space(pl_turn/pt_pa_arrival/pl_arrival/pa_ral_airline/@old)"/>
								</xsl:if>
								<xsl:if test="not(pl_turn/pt_pa_arrival/pl_arrival/@action) or pl_turn/pt_pa_arrival/pl_arrival/@action!='delete'">
								  <xsl:value-of select="normalize-space(pl_turn/pt_pa_arrival/pl_arrival/pa_ral_airline/text())"/>
								</xsl:if>
						</xsl:variable>	
						<xsl:for-each select="pl_turn">
							<Data>
								<xsl:for-each select="pt_pd_departure/pl_departure">
									<PrimaryKey>
										<FlightKey>
											<FlightScheduledDate>
												<xsl:if test="pd_srtd/@xsi:nil='true' or not(pd_srtd)">
													<xsl:attribute name="xsi:nil">true</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="substring(pd_srtd,1,10)" />
											</FlightScheduledDate>
											<FlightIdentity>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_flightnumber" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</FlightIdentity>
											<FlightDirection>D</FlightDirection>
											<BaseAirport>
												<AirportIATACode>NKG</AirportIATACode>
												<AirportICAOCode>ZSNJ</AirportICAOCode>
											</BaseAirport>
											<DetailedIdentity>											     
												 <AirlineIATACode>
											       <xsl:value-of select="$ral_2lc" />												
												</AirlineIATACode>												
												<AirlineICAOCode>
												    <xsl:if test="./@action='delete'">
													<xsl:value-of select="normalize-space(pd_ral_airline/ref_airline/ral_3lc/@old)"/>
													</xsl:if>
													<xsl:if test="not(./@action) or ./@action!='delete'">
													<xsl:value-of select="normalize-space(pd_ral_airline/ref_airline/ral_3lc/text())"/>
													</xsl:if>
												</AirlineICAOCode>
												<!-- change flightnumber mapping rule as flightnumber= flightidentity-pa_ral_airline  -->
												<FlightNumber>
													<xsl:variable name="flightNumber" select="pd_flightnumber" />
													<xsl:if test="pd_flightnumber/@old">
													<xsl:attribute name="OldValue">
														<xsl:value-of select="javacode:getFlightNumber($flightNumber/@old, $pd_ral_airline)" />
													</xsl:attribute>
													</xsl:if>
													<xsl:value-of select="javacode:getFlightNumber($flightNumber, $pd_ral_airline)" />
												</FlightNumber>
												<FlightSuffix>
													<xsl:variable name="flightNumber" select="pd_flightnumber" />
													<xsl:if test="pd_flightnumber/@old">
													<xsl:attribute name="OldValue">
														<xsl:value-of select="javacode:getFlightSuffix($flightNumber/@old)" />
													</xsl:attribute>
													</xsl:if>
													<xsl:value-of select="javacode:getFlightSuffix($flightNumber)" />
												</FlightSuffix>
											</DetailedIdentity>
										</FlightKey>
									</PrimaryKey>
								</xsl:for-each>

								<FlightData>
									<General>
										<xsl:for-each select="pt_pd_departure/pl_departure">
											<FlightScheduledDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_srtd" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</FlightScheduledDateTime>
											<Registration>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_registration" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</Registration>
											<CallSign>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_callsign" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</CallSign>
											<AircraftType>
												<xsl:for-each select="pd_ract_aircrafttype/ref_aircrafttype">
													<AircraftIATACode>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="ract_iatatype" />
															<xsl:with-param name="needAddNil" select="false()" />
														</xsl:call-template>
													</AircraftIATACode>
													<AircraftICAOCode>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="ract_icaotype" />
															<xsl:with-param name="needAddNil" select="false()" />
														</xsl:call-template>
													</AircraftICAOCode>
												</xsl:for-each>
											</AircraftType>

											<FlightServiceType>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pd_rstc_servicetypecode" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</FlightServiceType>

											<FlightRoute>
												<IATARoute>
													<xsl:for-each
														select="pl_routing_list/pl_routing">
														<!-- add by zzhao 2014-01-21 -->
														<xsl:sort select="prt_numberinleg"/>
														<!-- udpate by zzhao 2013-09-06 -->	
														<xsl:variable name="viaAirport" select="prt_rap_airport/ref_airport/rap_iata3lc" />														
														<xsl:if test="$iataDestAirport!=$viaAirport">
														<IATAViaAirport>
														    <!--oldvalue1  -->
														    <xsl:if test="prt_rap_airport/ref_airport/rap_iata3lc/@old">														    
															   <xsl:attribute name="OldValue">
																<xsl:value-of select="prt_rap_airport/ref_airport/rap_iata3lc/@old" />
															   </xsl:attribute>
														    </xsl:if>
															<xsl:value-of select="$viaAirport" />
														</IATAViaAirport>
														</xsl:if>
													</xsl:for-each>
													<IATANextAirport>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="pd_rap_nextairport/ref_airport/rap_iata3lc" />
															<xsl:with-param name="needAddNil" select="false()" />
														</xsl:call-template>
													</IATANextAirport>
													<IATADestinationAirport>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="pd_rap_destinationairport/ref_airport/rap_iata3lc" />
															<xsl:with-param name="needAddNil" select="false()" />
														</xsl:call-template>
													</IATADestinationAirport>
												</IATARoute>
												<ICAORoute>
													<xsl:for-each
														select="pl_routing_list/pl_routing/prt_rap_airport/ref_airport">
														<!-- add by zzhao 2014-01-21 -->
														<xsl:sort select="../../prt_numberinleg"/>
														<!-- udpate by zzhao 2013-09-06 -->	
														<xsl:variable name="viaAirport" select="rap_icao4lc" />
														<xsl:if test="$icaoDestAirport!=$viaAirport">
														<ICAOViaAirport>
														<!--oldvalue2  -->
														    <xsl:if test="rap_icao4lc/@old">
															   <xsl:attribute name="OldValue">
																<xsl:value-of select="rap_icao4lc/@old" />
															   </xsl:attribute>
														    </xsl:if>
															<xsl:value-of select="$viaAirport" />
														</ICAOViaAirport>
														</xsl:if>
													</xsl:for-each>
													<ICAONextAirport>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="pd_rap_nextairport/ref_airport/rap_icao4lc" />
															<xsl:with-param name="needAddNil" select="false()" />
														</xsl:call-template>
													</ICAONextAirport>
													<ICAODestinationAirport>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="pd_rap_destinationairport/ref_airport/rap_icao4lc" />
															<xsl:with-param name="needAddNil" select="false()" />
														</xsl:call-template>
													</ICAODestinationAirport>
												</ICAORoute>
											</FlightRoute>

											<FlightCountryType>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pd_rctt_countrytype/ref_countrytype/rctt_code" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</FlightCountryType>
											
											<!-- mod by zzhao 2014-03-31 -->
											<xsl:choose>
											<xsl:when test="../../pt_pa_arrival/pl_arrival/pa_idseq">
											<LinkFlight>
												<xsl:for-each select="../../pt_pa_arrival/pl_arrival">
												<xsl:choose>
													<xsl:when test="pa_srta">
													<FlightScheduledDate>
														<xsl:if test="pa_srta/@xsi:nil='true' or not(pa_srta)">
															<xsl:attribute name="xsi:nil">true</xsl:attribute>
														</xsl:if>
														<xsl:if test="pa_srta/@old">
															<xsl:attribute name="OldValue"><xsl:value-of
																select="pa_srta/@old" />
															</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="substring(pa_srta,1,10)" />
													</FlightScheduledDate>
													<FlightIdentity>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="pa_flightnumber" />
															<xsl:with-param name="needAddNil" select="false()" />
														</xsl:call-template>
													</FlightIdentity>
													<FlightDirection>A</FlightDirection>
													<BaseAirport>
														<AirportIATACode>NKG</AirportIATACode>
														<AirportICAOCode>ZSNJ</AirportICAOCode>
													</BaseAirport>
													<DetailedIdentity>
														<AirlineIATACode>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="pa_ral_airline/ref_airline/ral_2lc" />
																<xsl:with-param name="needAddNil" select="false()" />
															</xsl:call-template>
														</AirlineIATACode>
														<AirlineICAOCode>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="pa_ral_airline/ref_airline/ral_3lc" />
																<xsl:with-param name="needAddNil" select="false()" />
															</xsl:call-template>
														</AirlineICAOCode>
														<xsl:variable name="flightNumber" select="pa_flightnumber" />
														<!-- change flightnumber mapping rule as flightnumber= flightidentity-pa_ral_airline  -->
														<FlightNumber>
															<xsl:if test="pa_flightnumber/@old">
																<xsl:attribute name="OldValue">
																<xsl:value-of select="javacode:getFlightNumber($flightNumber/@old, $pa_ral_airline)" />
																</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="javacode:getFlightNumber($flightNumber, $pa_ral_airline)" />
														</FlightNumber>
														<FlightSuffix>
															<xsl:if test="pa_flightnumber/@old">
																<xsl:attribute name="OldValue">
																<xsl:value-of select="javacode:getFlightSuffix($flightNumber/@old)" />
																</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="javacode:getFlightSuffix($flightNumber)" />
														</FlightSuffix>
													</DetailedIdentity>
													</xsl:when>
													<xsl:otherwise>
													<FlightScheduledDate xsi:nil="true"/>
													<FlightIdentity />
													<FlightDirection>A</FlightDirection>
														<BaseAirport>
															<AirportIATACode />
															<AirportICAOCode />
														</BaseAirport>
													 <DetailedIdentity>
														<AirlineIATACode />
														<AirlineICAOCode />
														<FlightNumber />
														<FlightSuffix />
													</DetailedIdentity>
													</xsl:otherwise>
													</xsl:choose>
												</xsl:for-each>
											</LinkFlight>
											</xsl:when>
											<xsl:otherwise>
											     <LinkFlight>
                                                 	<FlightScheduledDate xsi:nil="true" />
                                                 	<FlightIdentity />
                                                 	<FlightDirection>A</FlightDirection>
                                                 	<BaseAirport>
                                                 		<AirportIATACode>NKG</AirportIATACode>
                                                 		<AirportICAOCode>ZSNJ</AirportICAOCode>
                                                 	</BaseAirport>
                                                 	<DetailedIdentity>
                                                 		<AirlineIATACode />
                                                 		<AirlineICAOCode />
                                                 		<FlightNumber />
                                                 		<FlightSuffix />
                                                 	</DetailedIdentity>
                                                 </LinkFlight>
											</xsl:otherwise>
											</xsl:choose>

											<IsMasterFlight>
												<xsl:if test="pd_pd_mainflight/@old">
													<xsl:attribute name="OldValue">
													<xsl:choose>
														<xsl:when test="pd_pd_mainflight/@old=''">Y</xsl:when>
														<xsl:otherwise>N</xsl:otherwise>
													</xsl:choose>
        											</xsl:attribute>
												</xsl:if>
												<xsl:choose>
													<xsl:when test="pd_pd_mainflight/text()">N</xsl:when>
													<xsl:otherwise>Y</xsl:otherwise>
												</xsl:choose>
											</IsMasterFlight>

											<xsl:choose>
												<xsl:when test="pd_pd_mainflight/text()">
													<MasterOrSlaveFlight>
														<FlightIdentity>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pd_pd_mainflight" />
																<xsl:with-param name="needAddNil" select="false()" />
															</xsl:call-template>
														</FlightIdentity>
														<FlightScheduledDate>
															<xsl:if test="pd_srtd/@xsi:nil='true' or not(pd_srtd)">
																<xsl:attribute name="xsi:nil">true</xsl:attribute>
															</xsl:if>
															<xsl:if test="pd_srtd/@old">
																<xsl:attribute name="OldValue"><xsl:value-of
																	select="pd_srtd/@old" />
															</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="substring(pd_srtd,1,10)" />
														</FlightScheduledDate>
														<FlightDirection>D</FlightDirection>
													</MasterOrSlaveFlight>
												</xsl:when>
												<xsl:when test="pl_departure_list/pl_departure">
													<xsl:for-each select="pl_departure_list/pl_departure">
														<MasterOrSlaveFlight>
															<FlightIdentity>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="pd_flightnumber" />
																	<xsl:with-param name="needAddNil" select="false()" />
																</xsl:call-template>
															</FlightIdentity>
															<FlightScheduledDate>
																<xsl:if test="pd_srtd/@xsi:nil='true' or not(pd_srtd)">
																	<xsl:attribute name="xsi:nil">true</xsl:attribute>
																</xsl:if>
																<xsl:if test="pd_srtd/@old">
																	<xsl:attribute name="OldValue"><xsl:value-of
																		select="pd_srtd/@old" />
																	</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="substring(pd_srtd,1,10)" />
															</FlightScheduledDate>
															<FlightDirection>D</FlightDirection>
														</MasterOrSlaveFlight>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<MasterOrSlaveFlight>
														<FlightIdentity />
														<FlightScheduledDate xsi:nil="true" />
														<FlightDirection />
													</MasterOrSlaveFlight>
												</xsl:otherwise>
											</xsl:choose>
											
											<!-- Add by zzhao 2013-06-20 -->
											<FreeTextComment>
											    <PublicTextComment>
											         <xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement"
																	select="pd_opscomment" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
											    </PublicTextComment>
											    <!--Add by zzhao 2014-05-27  -->
											    <CreateReason>
											       <xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement"
																	select="pd_createreason" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
											    </CreateReason>
											</FreeTextComment>
										</xsl:for-each>
									</General>

									<OperationalDateTime>
										<xsl:for-each select="pt_pd_departure/pl_departure">											
											<OffBlockDateTime>
												<ScheduledOffBlockDateTime>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_sobt" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</ScheduledOffBlockDateTime>
												<!--根据steven邮件由 pd_eobtlocal变更为pd_eobt-->
												<!--根据steven邮件由pd_eobt改为若pd_eobtatc不为空，则取pd_eobtatc，否则取pd_eobt201410122  -->
												<EstimatedOffBlockDateTime>
												   <xsl:choose>
												    <xsl:when test="pd_eobtatc!=''">
													<xsl:call-template name="xsltTemplate">

														<xsl:with-param name="inElement" select="pd_eobtatc" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
													</xsl:when>
													<xsl:otherwise>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_eobt" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>													
													</xsl:otherwise>
													</xsl:choose>
												</EstimatedOffBlockDateTime>
												<ActualOffBlockDateTime>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_aobt" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</ActualOffBlockDateTime>
											</OffBlockDateTime>
											
											<TakeOffDateTime>
											    <!--mod by zzhao 2013-10-11  -->
												<ScheduledTakeOffDateTime>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_srtd" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</ScheduledTakeOffDateTime>
												<EstimatedTakeOffDateTime>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_etot" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</EstimatedTakeOffDateTime>
												<ActualTakeOffDateTime>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_atot" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</ActualTakeOffDateTime>
											</TakeOffDateTime>
											<!-- Add by zzhao 2013-06-20 -->
											<DoorCloseDateTime>
											    <ActualDoorCloseDateTime>
											    	<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_doorclosetime" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
											    </ActualDoorCloseDateTime>
											</DoorCloseDateTime>
											<OffBridgeDateTime>
											    <ActualOffBridgeDateTime>
											    	<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_offbridge" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
											    </ActualOffBridgeDateTime>
											</OffBridgeDateTime>
											<!--mod by zzhao 2014-05-14  -->
											<xsl:variable name="nextairport" select="pd_rap_nextairport/ref_airport/rap_iata3lc" />											
											<NextAirportArrivalDateTime>
											<xsl:if test="$nextairport=''">
											<ScheduledNextAirportArrivalDateTime xsi:nil="true" />
											</xsl:if>
											<xsl:for-each select="pl_routing_list/pl_routing/prt_rap_airport/ref_airport">
											<xsl:sort select="../../prt_numberinleg"/>																					
											<xsl:variable name="routing_airport" select="rap_iata3lc"/>																					
											<xsl:if test="$nextairport=$routing_airport and $nextairport!='' and position()=1">
											<!-- ScheduledNextAirportArrivalDateTime is got in the condition that $nextairport=$routing_airport and min($prt_numberinleg) -->																						   
												<ScheduledNextAirportArrivalDateTime>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="../../prt_stastation" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</ScheduledNextAirportArrivalDateTime>																						
											</xsl:if>											
											</xsl:for-each>
												<EstimatedNextAirportArrivalDateTime xsi:nil="true" />
												<ActualNextAirportArrivalDateTime>
												    <xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_aldtnext" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</ActualNextAirportArrivalDateTime>
											</NextAirportArrivalDateTime>
											<!--add by zzhao 2014-02-26  -->
											<!-- mod by zzhao 2014-04-28 pd_acgt/pd_aegt mapping rule change -->
											<GroundHandleDateTime>
											<ActualGroundHandleStartDateTime>
											   <xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pd_acgt" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</ActualGroundHandleStartDateTime>
											<ActualGroundHandleEndDateTime>
											    <xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pd_aegt" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</ActualGroundHandleEndDateTime>
											</GroundHandleDateTime>
											<BestKnownDateTime xsi:nil="true" />
										</xsl:for-each>
									</OperationalDateTime>

									<Status>
										<xsl:for-each select="pt_pd_departure/pl_departure">
											<OperationStatus>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pd_rrmk_remark" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</OperationStatus>
											<FlightStatus>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_rfst_flightstatus" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</FlightStatus>
											                                                                                                <DelayReason>
											   <!--mod by zzhao 2013-10-09  -->
												<DelayCode>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pl_delayreason_list/pl_delayreason/pdlr_rdlr_delayreason" />
														<xsl:with-param name="needAddNil" select="false()" />
													</xsl:call-template>
												</DelayCode>
												<DelayFreeText />
											</DelayReason>
											<DisplayCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_displaycode" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</DisplayCode>
											<IsTransitFlight xsi:nil="true" />

											<xsl:variable name="srtaDate"
												select="substring(../../pt_pa_arrival/pl_arrival/pa_srta,1,10)" />
											<xsl:variable name="srtdDate" select="substring(pd_srtd,1,10)" />
											<IsOverNightFlight>
											    <xsl:call-template name="updateISOVERNIGHT">
													<xsl:with-param name="serviceType" select="$serviceTypeReturn" />
													<xsl:with-param name="messageType" select="$messageType" />
												</xsl:call-template>
												<xsl:choose>
													<xsl:when test="javacode:compareString($srtaDate,$srtdDate)
													or $srtaDate='' or $srtdDate=''">N</xsl:when>
													<xsl:otherwise>Y</xsl:otherwise>
												</xsl:choose>
											</IsOverNightFlight>
											<!-- add by zzhao 2014-02-26 -->
											<IsVIPFlight>
											    <xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_vipind" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</IsVIPFlight>
											<VIPComment>
											    <xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_vipcomment" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</VIPComment>
											<!--
 											<IsCashFlight>
												<xsl:if test="pd_paymentmode/@old">
													<xsl:attribute name="OldValue">
													<xsl:choose>
														<xsl:when test="pd_paymentmode/@old='C'">Y</xsl:when>
														<xsl:otherwise>N</xsl:otherwise>
													</xsl:choose>
        											</xsl:attribute>
												</xsl:if>
												<xsl:choose>
													<xsl:when test="pd_paymentmode='C'">Y</xsl:when>
													<xsl:otherwise>N</xsl:otherwise>
												</xsl:choose>
											</IsCashFlight> mod by zzhao 2014-02-26-->
										</xsl:for-each>
									</Status>

									<xsl:if test="pt_pd_departure/pl_departure/pl_departureloadstatistics_list">
										<xsl:for-each select="pt_pd_departure/pl_departure/pl_departureloadstatistics_list">																							
													<xsl:if test="pl_departureloadstatistics">
												        <xsl:for-each select="pl_departureloadstatistics">
												   <!--Add by zzhao 2013-06-20  -->	
												   <Payload>											   
												   <DepartureAirport>
												       <xsl:call-template name="xsltTemplate">
													      <xsl:with-param name="inElement" select="pdls_rap_airportfrom" />
													      <xsl:with-param name="needAddNil" select="false()" />
												       </xsl:call-template>
												   </DepartureAirport>
												   <DestinationAirport>
												       <xsl:call-template name="xsltTemplate">
													      <xsl:with-param name="inElement" select="pdls_rap_airportto" />
													      <xsl:with-param name="needAddNil" select="false()" />
												       </xsl:call-template>
												   </DestinationAirport>												
													<Passenger>
														<PassengersNumber>
															<TotalPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_pax" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</TotalPassengersNumber>
															<FirstClassPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_paxf" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</FirstClassPassengersNumber>
															<BusinessClassPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_paxc" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</BusinessClassPassengersNumber>
															<EconomicClassPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_paxy" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</EconomicClassPassengersNumber>
														</PassengersNumber>

														<AdultPassengers>
															<TotalAdultPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_adult" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</TotalAdultPassengersNumber>
															<FirstClassAdultPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_adultf" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</FirstClassAdultPassengersNumber>
															<BusinessClassAdultPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_adultc" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</BusinessClassAdultPassengersNumber>
															<EconomicClassAdultPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_adulty" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</EconomicClassAdultPassengersNumber>
														</AdultPassengers>
														<ChildPassengers>
															<TotalChildPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_child" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</TotalChildPassengersNumber>
															<FirstClassChildPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_childf" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</FirstClassChildPassengersNumber>
															<BusinessClassChildPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_childc" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</BusinessClassChildPassengersNumber>
															<EconomicClassChildPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_childy" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</EconomicClassChildPassengersNumber>
														</ChildPassengers>
														<InfantPassengers>
															<TotalInfantPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_infant" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</TotalInfantPassengersNumber>
															<FirstClassInfantPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_infantf" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</FirstClassInfantPassengersNumber>
															<BusinessClassInfantPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_infantc" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</BusinessClassInfantPassengersNumber>
															<EconomicClassInfantPassengersNumber>
															<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_infanty" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>																
															</EconomicClassInfantPassengersNumber>
														</InfantPassengers>
													</Passenger>
													<Weight>
														<TotalWeight>
														<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_totalweight" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>															
														</TotalWeight>
														<BaggageWeight>
														<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_baggageweight" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>															
														</BaggageWeight>
														<CargoWeight>
														<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_cargoweight" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>															
														</CargoWeight>
														<MailWeight>
														<xsl:call-template name="xsltTemplate">
													          <xsl:with-param name="inElement" select="pdls_mailweight" />
													          <xsl:with-param name="needAddNil" select="true()" />
												            </xsl:call-template>															
														</MailWeight>
													</Weight>
													</Payload>
													</xsl:for-each>
												</xsl:if>
											</xsl:for-each>
											</xsl:if>

									<Airport>
										<xsl:for-each select="pt_pd_departure/pl_departure">
											<Terminal>
												<FlightTerminalID>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_rtrm_terminal" />
														<xsl:with-param name="needAddNil" select="false()" />
													</xsl:call-template>
												</FlightTerminalID>
												<AircraftTerminalID />
											</Terminal>
											<Runway>
												<RunwayID>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_rrwy_runway" />
														<xsl:with-param name="needAddNil" select="false()" />
													</xsl:call-template>
												</RunwayID>
											</Runway>
										</xsl:for-each>

										<xsl:for-each select="pl_stand_list">
											<xsl:choose>
												<xsl:when test="pl_stand">
													<xsl:for-each select="pl_stand">									
														<Stand>														
															<StandID>
																<xsl:call-template name="updateStandID">
																	<xsl:with-param name="inElement" select="pst_rsta_stand" />
																	<xsl:with-param name="ref_standid" select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_rsta_refstand/ref_stand/rsta_code"/>																	
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</StandID>
															<ScheduledStandStartDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pst_beginplan" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ScheduledStandStartDateTime>
															<ScheduledStandEndDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pst_endplan" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ScheduledStandEndDateTime>
															<ActualStandStartDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pst_beginactual" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ActualStandStartDateTime>
															<ActualStandEndDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pst_endactual" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ActualStandEndDateTime>
														</Stand>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<Stand>
														<StandID xsi:nil="true" />
														<ScheduledStandStartDateTime
															xsi:nil="true" />
														<ScheduledStandEndDateTime
															xsi:nil="true" />
														<ActualStandStartDateTime
															xsi:nil="true" />
														<ActualStandEndDateTime xsi:nil="true" />
													</Stand>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>

										<xsl:for-each
											select="pt_pd_departure/pl_departure/pl_departurebelt_list">
											<xsl:choose>
												<xsl:when test="pl_departurebelt">
													<xsl:for-each select="pl_departurebelt">
														<BaggageMakeup>
															<BaggageBeltID>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="pdb_rdb_departurebelt" />
																	<xsl:with-param name="needAddNil"
																		select="false()" />
																</xsl:call-template>
															</BaggageBeltID>
															<BaggageBeltStatus>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdb_status" />
																	<xsl:with-param name="needAddNil"
																		select="false()" />
																</xsl:call-template>
															</BaggageBeltStatus>
															<ScheduledMakeupStartDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdb_beginplan" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ScheduledMakeupStartDateTime>
															<ScheduledMakeupEndDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdb_endplan" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ScheduledMakeupEndDateTime>
															<ActualMakeupStartDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdb_beginactual" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ActualMakeupStartDateTime>
															<ActualMakeupEndDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdb_endactual" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ActualMakeupEndDateTime>
														</BaggageMakeup>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<BaggageMakeup>
														<BaggageBeltID />
														<BaggageBeltStatus xsi:nil="true" />
														<ScheduledMakeupStartDateTime
															xsi:nil="true" />
														<ScheduledMakeupEndDateTime
															xsi:nil="true" />
														<ActualMakeupStartDateTime
															xsi:nil="true" />
														<ActualMakeupEndDateTime xsi:nil="true" />
													</BaggageMakeup>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>

										<xsl:for-each
											select="pt_pd_departure/pl_departure/pl_departuregate_list">
											<xsl:choose>
												<xsl:when test="pl_departuregate">
													<xsl:for-each select="pl_departuregate">
														<Gate>
															<GateID>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdg_rgt_gate" />
																	<xsl:with-param name="needAddNil"
																		select="false()" />
																</xsl:call-template>
															</GateID>
															<GateStatus>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdg_status" />
																	<xsl:with-param name="needAddNil"
																		select="false()" />
																</xsl:call-template>
															</GateStatus>
															<!--  mod by zzhao 2014-03-24-->
															<ScheduledGateStartDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdg_begingateplan" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ScheduledGateStartDateTime>
															<ScheduledGateEndDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdg_endplan" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ScheduledGateEndDateTime>
															<!--  mod by zzhao 2014-03-24-->
															<ActualGateStartDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdg_begingateactual" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ActualGateStartDateTime>
															<!--mod by zzhao 2014-03-24  -->															
															<ActualGateEndDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdg_endactual" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ActualGateEndDateTime>
															<BoardingStartDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="../../pd_gotogate" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</BoardingStartDateTime>
															<LastCallDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="../../pd_secondcall" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</LastCallDateTime>
															<BoardingEndDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="../../pd_aebt" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</BoardingEndDateTime>															
														</Gate>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<Gate>
														<GateID />
														<GateStatus xsi:nil="true" />
														<ScheduledGateStartDateTime
															xsi:nil="true" />
														<ScheduledGateEndDateTime
															xsi:nil="true" />
														<ActualGateStartDateTime xsi:nil="true" />
														<ActualGateEndDateTime xsi:nil="true" />
														<BoardingStartDateTime xsi:nil="true"/>
                                                        <LastCallDateTime xsi:nil="true"/>
                                                        <BoardingEndDateTime xsi:nil="true"/>
													</Gate>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>

										<xsl:for-each select="pt_pd_departure/pl_departure/pl_desk_list">
											<xsl:choose>
												<xsl:when test="pl_desk">
													<xsl:for-each select="pl_desk">
														<CheckInDesk>
															<CheckInDeskID>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdk_rcnt_counter" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</CheckInDeskID>
															<xsl:variable name="checkinType" select="pdk_rcnt_refcounter/ref_counter/rcnt_type" />
															<xsl:variable name="checkinTypeOld" select="pdk_rcnt_refcounter/ref_counter/rcnt_type/@old" />															
															<xsl:choose>
															<xsl:when test="$checkinType='C'">
															<CheckInType>
															<xsl:if test="pdk_rcnt_refcounter/ref_counter/rcnt_type/@old and $checkinTypeOld='C'">
			                                                <xsl:attribute name="OldValue">Y</xsl:attribute>
		                                                    </xsl:if>		                                                    
		                                                    <xsl:if test="pdk_rcnt_refcounter/ref_counter/rcnt_type/@old and $checkinTypeOld!='C'">
			                                                <xsl:attribute name="OldValue">N</xsl:attribute>
		                                                    </xsl:if>Y</CheckInType>
															</xsl:when>
															<xsl:when test="$checkinType=''">
															<CheckInType>
															<xsl:if test="pdk_rcnt_refcounter/ref_counter/rcnt_type/@old and $checkinTypeOld='C'">
			                                                <xsl:attribute name="OldValue">Y</xsl:attribute>			                                                
		                                                    </xsl:if>		                                                    
		                                                    <xsl:if test="pdk_rcnt_refcounter/ref_counter/rcnt_type/@old and $checkinTypeOld!='C'">
			                                                <xsl:attribute name="OldValue">N</xsl:attribute>		                                                
		                                                    </xsl:if><xsl:attribute name="xsi:nil">true</xsl:attribute></CheckInType>
															</xsl:when>
															<xsl:otherwise>
															<CheckInType>
															<xsl:if test="pdk_rcnt_refcounter/ref_counter/rcnt_type/@old and $checkinTypeOld='C'">
			                                                <xsl:attribute name="OldValue">Y</xsl:attribute>
		                                                    </xsl:if>		                                                    
		                                                    <xsl:if test="pdk_rcnt_refcounter/ref_counter/rcnt_type/@old and $checkinTypeOld!='C'">
			                                                <xsl:attribute name="OldValue">N</xsl:attribute>
		                                                    </xsl:if>N</CheckInType>
															</xsl:otherwise>
															</xsl:choose>															   														
															<CheckInStatus>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdk_status" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</CheckInStatus>
															<CheckInClassService>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="pdk_checkinclassid" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</CheckInClassService>
															<ScheduledCheckInBeginDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdk_beginplan" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ScheduledCheckInBeginDateTime>
															<ScheduledCheckInEndDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdk_endplan" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ScheduledCheckInEndDateTime>
															<ActualCheckInBeginDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdk_beginactual" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ActualCheckInBeginDateTime>
															<ActualCheckInEndDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdk_endactual" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ActualCheckInEndDateTime> 
														</CheckInDesk>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<CheckInDesk>
														<CheckInDeskID xsi:nil="true" />
														<CheckInType xsi:nil="true" />
														<CheckInStatus xsi:nil="true" />
														<CheckInClassService xsi:nil="true" />
														<ScheduledCheckInBeginDateTime
															xsi:nil="true" />
														<ScheduledCheckInEndDateTime
															xsi:nil="true" />
														<ActualCheckInBeginDateTime
															xsi:nil="true" />
														<ActualCheckInEndDateTime
															xsi:nil="true" />
													</CheckInDesk>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
										<!-- add mapping for PassengerStatus 2013-11-26-->
										<xsl:for-each select="pt_pd_departure/pl_departure/pl_departureaddinfo_list/pl_departureaddinfo">
											<PassengerStatus>
												<CheckInPassengerCount>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pdai_actualcheckedin" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</CheckInPassengerCount>
												<SecurityCheckPassengerCount>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pdai_actualsecurity" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</SecurityCheckPassengerCount>
												<OnboardPassengerCount>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pdai_actualboarding" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</OnboardPassengerCount>
											</PassengerStatus>									
										</xsl:for-each>
										
									</Airport>
								</FlightData>
							</Data>
						</xsl:for-each>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$messageType='ACK' and $aodb_servicetype='UPDATE'">
					<Operation>
						<Update>
							<UpdateResponse>
								<UpdateRequestID>
									<xsl:value-of select="$correlationId" />
								</UpdateRequestID>
								<UpdateStatus>Success</UpdateStatus>
							</UpdateResponse>
						</Update>
					</Operation>
				</xsl:if>
				<xsl:if test="$messageType='NACK' and $aodb_servicetype = 'UPDATE'">
					<Operation>
						<Update>
							<UpdateResponse>
								<UpdateRequestID>
									<xsl:value-of select="$correlationId" />
								</UpdateRequestID>
								<UpdateStatus>Failure</UpdateStatus>
							</UpdateResponse>
						</Update>
						<SystemException>
							<ExceptionCode>001</ExceptionCode>
							<ExceptionMessage>
								<xsl:value-of select="soap-env:Fault/detail" />
							</ExceptionMessage>
						</SystemException>
					</Operation>
				</xsl:if>
			</xsl:for-each>
		</IMFRoot>
<!-- 		</xsl:otherwise>
	</xsl:choose> -->
	</xsl:template>
	<xsl:template name="xsltTemplate">
		<xsl:param name="inElement" />
		<xsl:param name="needAddNil" />
		<xsl:if test="$inElement/@old">
			<xsl:attribute name="OldValue"><xsl:value-of select="$inElement/@old" />
        	</xsl:attribute>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$needAddNil">
				<xsl:if test="$inElement/@xsi:nil">
					<xsl:attribute name="xsi:nil">true</xsl:attribute>
				</xsl:if>
				<xsl:if test="not($inElement)">
					<xsl:attribute name="xsi:nil">true</xsl:attribute>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<xsl:value-of select="normalize-space($inElement/text())"></xsl:value-of>
	</xsl:template>

	<xsl:template name="operation">
		<xsl:param name="serviceType" />
		<xsl:param name="messageType" />
		<xsl:variable name="action">
			<xsl:choose>
			    <!-- update by zzhao 2013-08-27 -->
				<xsl:when test="contains($serviceType,'FSS')">
					<xsl:value-of select="pl_turn/pt_pd_departure/pl_departure/@action[1]" />
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$messageType='ACK' or $messageType='NACK'">SYS</xsl:when>
			<xsl:when test="$action='insert'">NEW</xsl:when>
			<xsl:when test="$action='update'">MOD</xsl:when>
			<xsl:when test="$action='delete'">DEL</xsl:when>
			<xsl:when test="contains($serviceType,'FSS1')">MOD</xsl:when>
			<xsl:when test="contains($serviceType,'FSS2')">NEW</xsl:when>
			<xsl:when
				test="contains($serviceType,'BSS')
			or contains($serviceType,'RSS')
			or contains($serviceType,'GSS')">NEW</xsl:when>
			<xsl:otherwise>SYS</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="updateStandID">
	    <xsl:param name="inElement" />
		<xsl:param name="needAddNil" />
	    <xsl:param name="ref_standid"/>
	   
	   <xsl:choose>
	       <xsl:when test="$inElement/@old">
		      <xsl:attribute name="OldValue"><xsl:value-of select="$inElement/@old" />
        	  </xsl:attribute>
		   </xsl:when>
		   <!--check whether the current stand have old value ,if do, map it to the corresponding stand-->
		   <xsl:when test="/soap-env:Envelope/soap-env:Body/pl_turn/pt_rsta_currentstand/@old">
		      <xsl:if test="/soap-env:Envelope/soap-env:Body/pl_turn/pt_rsta_currentstand=$inElement">
			     <xsl:attribute name="OldValue"><xsl:value-of select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_rsta_currentstand/@old" />
        	     </xsl:attribute>
			  </xsl:if>
		   </xsl:when>
		   <!--if refstand have old value then neeed to map oldvalue to the stand which have the same id-->
		   <xsl:when test="$ref_standid/@old">
		    <xsl:if test="$ref_standid=$inElement">
			     <xsl:attribute name="OldValue"><xsl:value-of select="$ref_standid/@old" />
        	     </xsl:attribute>
			</xsl:if>
		   </xsl:when>
	   </xsl:choose>
	   <xsl:choose>
			<xsl:when test="$needAddNil">
				<xsl:if test="$inElement/@xsi:nil">
					<xsl:attribute name="xsi:nil">true</xsl:attribute>
				</xsl:if>
				<xsl:if test="not($inElement)">
					<xsl:attribute name="xsi:nil">true</xsl:attribute>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<xsl:value-of select="normalize-space($inElement/text())"></xsl:value-of>
	</xsl:template>
	
	<!--update to fix subsystem can not update ISOVERNIGHT flag since we did not send the oldvalue to the subsystem check if the operation is MOD then insert Oldvalue=""-->
	<xsl:template name="updateISOVERNIGHT">
	    <xsl:param name="serviceType" />
		<xsl:param name="messageType" />
		<xsl:variable name="action">
			<xsl:choose>
			    <!-- update by zzhao 2013-08-27 -->
				<xsl:when test="contains($serviceType,'FSS1') and /soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/@action[1]">
					<xsl:value-of select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/@action[1]" />
				</xsl:when>
				<xsl:otherwise>update</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$action='update' and contains($serviceType,'FSS1') and /soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_flightnumber/@old"><xsl:attribute name="OldValue"></xsl:attribute></xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>