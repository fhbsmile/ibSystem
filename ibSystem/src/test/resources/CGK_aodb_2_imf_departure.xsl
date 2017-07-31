<!-- Version 2.0j 2014-06-23 mod by zzhao mod mapping rule of "flightnumber"; Version 2.0i 2014-05-27 mod by zzhao add node mapping of "CreateReason"; 
	 Version 2.0h 2014-05-22 mod by zzhao add node mapping of "FlyTime/EstimatedFlyTime"; 
	 Version 2.0g 2014-05-19 mod by zzhao change mapping rule of node "ScheduledPreviousAirportDepartureDateTime" and node "EstimatedPreviousAirportDepartureDateTime" 
	 Version 2.0f 2014-05-16 mod by zzhao add mapping rule for node "DiversionAirport/AirportIATACode",node "DiversionAirport/AirportICAOCode", node "ChangeLandingAirport/AirportIATACode" and node "ChangeLandingAirport/AirportICAOCode"; 
	 Version 2.0e 2014-05-16 mod by zzhao change mapping rule of node "ScheduledPreviousAirportDepartureDateTime" and node "EstimatedPreviousAirportDepartureDateTime" 
	 version 2.0d 2014-05-08 mod by zzhao add node mapping of "ScheduledPreviousAirportDepartureDateTime" and "EstimatedPreviousAirportDepartureDateTime". 
	 Version 2.0c 2014-02-26 mod by zzhao add node "IsVIPFlight", "VIPComment" and remove node "IsCashFlight"; -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:aodb="urn:com.tsystems.ac.aodb"
	xmlns:javacode="com.tsystems.si.aviation.imf.ibSystem.message.XsltUtil" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0"
	exclude-result-prefixes="aodb soap-env javacode">
	<xsl:output method="xml" indent="yes" />
	<xsl:template match="/">
		<xsl:variable name="aodbBodyDataType" select="name(/soap-env:Envelope/soap-env:Body/*[1])"></xsl:variable>
		<xsl:variable name="aodbDataType" select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:datatype"></xsl:variable>
		<!-- <xsl:choose> if on fss1 and there is no action arrtibute in the aodb message, then ignore it. <xsl:when test="$aodbBodyDataType ='pl_turn' and not(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/@action[1]) 
			and $aodb_servicetype='SUBSCRIBE' and (not(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_srtd or /soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_flightnumber) 
			or (/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_srtd and not(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_srtd/@old[1])) 
			or (/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_flightnumber and not(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_flightnumber/@old[1])))"></xsl:when> 
			<xsl:otherwise> -->
		<IMFRoot>
		    <xsl:variable name="aodbMessageId" select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:message-id"></xsl:variable>
			<xsl:variable name="aodbMessageType" select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:message-type"></xsl:variable>
			<xsl:variable name="aodbOrgMessageType" select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:org-message-type"></xsl:variable>
			<xsl:variable name="aodbCorrelationId" select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:correlation-id"></xsl:variable>
			<xsl:variable name="imfServiceType" select="javacode:getImfServiceTypeByMqif($aodbMessageType,$aodbOrgMessageType,$aodbBodyDataType,$aodbBodyDataType,$aodbCorrelationId)"></xsl:variable>
			<xsl:variable name="imfMessageType" select="javacode:getImfMessageTypeByMqif($imfServiceType,$aodbMessageType)"></xsl:variable>
			<xsl:variable name="receiver" select="javacode:getReceiverByMqifCorrelationId($aodbCorrelationId)"></xsl:variable>
			<xsl:variable name="Date" select="javacode:getDate()"></xsl:variable>
			<!-- The next is to do the general SysInfo part , all the service will call this part to fill the Sysinfo -->
			<xsl:for-each select="/soap-env:Envelope/soap-env:Body">
				<SysInfo>
					<MessageSequenceID>
						<xsl:value-of select="$aodbMessageId" />
					</MessageSequenceID>
					<MessageType>
						<xsl:value-of select="$imfMessageType" />
					</MessageType>
					<ServiceType>
						<xsl:value-of select="$imfServiceType" />
					</ServiceType>
					<OperationMode>
						<xsl:call-template name="operation">
							<xsl:with-param name="imfServiceType" select="$imfServiceType" />
							<xsl:with-param name="aodbMessageType" select="$aodbMessageType" />
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
							<xsl:when test="$aodbMessageType='ACK' or $aodbMessageType='NACK'">
								<xsl:value-of select="$Date" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType = 'pl_turn'">
								<xsl:value-of select="pl_turn/pt_pa_arrival/pl_arrival/pa_modtime" />
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
				<xsl:if test="$aodbMessageType!='ACK' and $aodbMessageType!='NACK'">
					<xsl:if test="$aodbBodyDataType='pl_turn'">
						<xsl:variable name="iataOrigAirport" select="pl_turn/pt_pa_arrival/pl_arrival/pa_rap_originairport/ref_airport/rap_iata3lc" />
						<xsl:variable name="icaoOrigAirport" select="pl_turn/pt_pa_arrival/pl_arrival/pa_rap_originairport/ref_airport/rap_icao4lc" />
						<!-- change flightnumber mapping rule as flightnumber= flightidentity-ral_2lc -->
						<xsl:variable name="ral_2lc">
							<xsl:if test="pl_turn/pt_pa_arrival/pl_arrival/@action='delete'">
								<xsl:value-of select="normalize-space(pl_turn/pt_pa_arrival/pl_arrival/pa_ral_airline/ref_airline/ral_2lc/@old)" />
							</xsl:if>
							<xsl:if test="not(pl_turn/pt_pa_arrival/pl_arrival/@action) or pl_turn/pt_pa_arrival/pl_arrival/@action!='delete'">
								<xsl:value-of select="normalize-space(pl_turn/pt_pa_arrival/pl_arrival/pa_ral_airline/ref_airline/ral_2lc/text())" />
							</xsl:if>
						</xsl:variable>
						<xsl:for-each select="pl_turn/pt_pd_departure/pl_departure">
							<Data>
								<xsl:variable name="internaid">
									<xsl:value-of select="pd_idseq"></xsl:value-of>
								</xsl:variable>
								<PrimaryKey>
									<FlightKey>
										<FlightScheduledDate>
											<xsl:if test="pd_sobt/@xsi:nil='true' or not(pd_sobt)">
												<xsl:attribute name="xsi:nil">true</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="substring(pd_sobt,1,10)" />
										</FlightScheduledDate>
										<FlightIdentity>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pd_flightnumber" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</FlightIdentity>
										<FlightDirection>D</FlightDirection>
										<BaseAirport>
											<AirportIATACode>CGK</AirportIATACode>
											<AirportICAOCode>WIII</AirportICAOCode>
										</BaseAirport>
										<DetailedIdentity>
											<AirlineIATACode>
												<xsl:value-of select="$ral_2lc" />
											</AirlineIATACode>
											<AirlineICAOCode>
												<xsl:if test="./@action='delete'">
													<xsl:value-of
														select="normalize-space(pd_ral_airline/ref_airline/ral_3lc/@old)" />
												</xsl:if>
												<xsl:if test="not(./@action) or ./@action!='delete'">
													<xsl:value-of
														select="normalize-space(pd_ral_airline/ref_airline/ral_3lc/text())" />
												</xsl:if>
											</AirlineICAOCode>

										</DetailedIdentity>
										<xsl:for-each select="pd_idseq">
											<InternalID>
												<xsl:value-of select="$internaid" />
											</InternalID>
										</xsl:for-each>
									</FlightKey>
								</PrimaryKey>
								<xsl:if test="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure">
								<FlightData>
									<General>
										<FlightScheduledDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pd_sobt" />
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
											<FlightIATAServiceType>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_rstc_servicetypecode" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</FlightIATAServiceType>
										</FlightServiceType>

										<FlightRoute>
											<IATARoute>
											<IATAFullRoute>
												<xsl:for-each select="pl_routing_list/pl_routing">
													<xsl:sort select="prt_numberinleg" />
													<xsl:variable name="legNo" select="prt_numberinleg" />
													<xsl:variable name="viaAirport" select="prt_rap_airport" />
													<AirportIATACode>
														<xsl:attribute name="LegNo"><xsl:value-of select="$legNo" /></xsl:attribute>
														<xsl:if test="prt_rap_airport/@old">
															<xsl:attribute name="OldValue">
															<xsl:value-of select="prt_rap_airport/@old" />
														   </xsl:attribute>
														</xsl:if>
														<xsl:value-of select="$viaAirport" />
													</AirportIATACode>
												</xsl:for-each>
											</IATAFullRoute>
												<IATANextAirport>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement"
															select="pd_rap_nextairport" />
														<xsl:with-param name="needAddNil" select="false()" />
													</xsl:call-template>
												</IATANextAirport>
												<IATADestinationAirport>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement"
															select="pd_rap_destinationairport" />
														<xsl:with-param name="needAddNil" select="false()" />
													</xsl:call-template>
												</IATADestinationAirport>
											</IATARoute>
											<ICAORoute>
												<ICAOFullRoute>
												<xsl:for-each select="pl_routing_list/pl_routing">
													<!-- add by zzhao 2014-01-21 -->
													<xsl:sort select="prt_numberinleg" />
													<xsl:variable name="legNo" select="prt_numberinleg" />
													<!-- udpate by zzhao 2013-09-06 -->
													<xsl:variable name="viaAirport"
														select="prt_rap_refairport.ref_airport.rap_icao4lc" />
													<AirportICAOCode>
														<xsl:attribute name="LegNo"><xsl:value-of select="$legNo" /></xsl:attribute>
														<!--oldvalue1 -->
														<xsl:if test="prt_rap_refairport.ref_airport.rap_icao4lc/@old">
                                                             <xsl:attribute name="OldValue"> <xsl:value-of select="prt_rap_refairport.ref_airport.rap_icao4lc/@old" />
												             </xsl:attribute>
														</xsl:if>
														<xsl:value-of select="$viaAirport" />
													</AirportICAOCode>
												</xsl:for-each>
											</ICAOFullRoute>
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
													select="pd_rctt_countrytype/ref_countrytype" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</FlightCountryType>
										<xsl:choose>
											<xsl:when test="../../pt_pa_arrival/pl_arrival/pa_idseq">
												<LinkFlight>
													<xsl:for-each select="../../pt_pa_arrival/pl_arrival">
														<xsl:choose>
															<xsl:when test="pa_sibt">
																<FlightScheduledDate>
																	<xsl:if test="pa_sibt/@xsi:nil='true' or not(pa_sibt)">
																		<xsl:attribute name="xsi:nil">true</xsl:attribute>
																	</xsl:if>
																	<xsl:if test="pa_sibt/@old">
																		<xsl:attribute name="OldValue"><xsl:value-of
																			select="pa_sibt/@old" />
															</xsl:attribute>
																	</xsl:if>
																	<xsl:value-of select="substring(pa_sibt,1,10)" />
																</FlightScheduledDate>
																<FlightIdentity>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pa_flightnumber" />
																		<xsl:with-param name="needAddNil"
																			select="false()" />
																	</xsl:call-template>
																</FlightIdentity>
																<FlightDirection>A</FlightDirection>
																<BaseAirport>
																	<AirportIATACode />
																	<AirportICAOCode />
																</BaseAirport>
																<DetailedIdentity>
																	<AirlineIATACode>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="pa_ral_airline/ref_airline/ral_2lc" />
																			<xsl:with-param name="needAddNil"
																				select="false()" />
																		</xsl:call-template>
																	</AirlineIATACode>
																	<AirlineICAOCode>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="pa_ral_airline/ref_airline/ral_3lc" />
																			<xsl:with-param name="needAddNil"
																				select="false()" />
																		</xsl:call-template>
																	</AirlineICAOCode>
																</DetailedIdentity>
																<InternalID>
																	<xsl:value-of
																		select="normalize-space(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_idseq)" />
																</InternalID>
															</xsl:when>
														</xsl:choose>
													</xsl:for-each>
												</LinkFlight>
											</xsl:when>
										</xsl:choose>

										<xsl:choose>
											<!-- <xsl:when test="pd_pd_mainflight/text()">
												<SlaveFlight>
													<FlightIdentity>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="pd_pd_mainflight" />
															<xsl:with-param name="needAddNil" select="false()" />
														</xsl:call-template>
													</FlightIdentity>
												</SlaveFlight>
											</xsl:when>-->
											<xsl:when test="pl_departure_list/pl_departure">
												<xsl:for-each select="pl_departure_list/pl_departure">
													<SlaveFlight>
														<FlightIdentity>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pd_flightnumber" />
																<xsl:with-param name="needAddNil" select="false()" />
															</xsl:call-template>
														</FlightIdentity>

													</SlaveFlight>
												</xsl:for-each>
											</xsl:when>
										</xsl:choose>
										<FreeTextComment>
											<PublicTextComment>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_opscomment" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</PublicTextComment>
											<CreateReason>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_createreason" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</CreateReason>
										</FreeTextComment>
									</General>
									<OperationalDateTime>
										<OffBlockDateTime>
											<ScheduledOffBlockDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_sobt" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</ScheduledOffBlockDateTime>
											<EstimatedOffBlockDateTime>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_eobt" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
											</EstimatedOffBlockDateTime>
											<EstimatedOffBlockDateTimeATC>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_eobtatc" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
											</EstimatedOffBlockDateTimeATC>
											<EstimatedOffBlockDateTimeLocal>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_eobtlocal" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
											</EstimatedOffBlockDateTimeLocal>
											<TargetOffBlockDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_tobt" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</TargetOffBlockDateTime>
											<ActualOffBlockDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_aobt" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</ActualOffBlockDateTime>
										</OffBlockDateTime>
										<StartupDateTime>
											<TargetStartupApprovedDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_tsat" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</TargetStartupApprovedDateTime>
											<ActualStartupRequestDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_asrt" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</ActualStartupRequestDateTime>
											<ActualStartupApprovedDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_asat" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</ActualStartupApprovedDateTime>
										</StartupDateTime>
										<TakeOffDateTime>
											<ScheduledTakeOffDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_sobt" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</ScheduledTakeOffDateTime>
											<EstimatedTakeOffDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_etot" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</EstimatedTakeOffDateTime>
											<TargetTakeOffDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_ttot" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</TargetTakeOffDateTime>
											<ConfirmedTakeOffDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_ctot" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</ConfirmedTakeOffDateTime>
											<ActualTakeOffDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_atot" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</ActualTakeOffDateTime>
										</TakeOffDateTime>
										<DoorCloseDateTime>
											<EstimatedDoorCloseDateTime>
											<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_estimateddoorclosetime" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</EstimatedDoorCloseDateTime>
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
										<xsl:variable name="nextairport" select="pd_rap_nextairport" />
										<NextAirportArrivalDateTime>
											<xsl:if test="$nextairport=''">
												<ScheduledNextAirportArrivalDateTime xsi:nil="true" />
											</xsl:if>
											<xsl:for-each select="pl_routing_list/pl_routing">
												<xsl:sort select="prt_numberinleg" />
												<xsl:variable name="routing_airport" select="prt_rap_airport" />
												<xsl:if test="$nextairport=$routing_airport and $nextairport!='' and position()=1">
													<ScheduledNextAirportArrivalDateTime>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="prt_stastation" />
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
										<GroundHandleDateTime>
											<ActualGroundHandleStartDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_acgt" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</ActualGroundHandleStartDateTime>
											<ActualGroundHandleEndDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_aegt" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</ActualGroundHandleEndDateTime>
										</GroundHandleDateTime>
										<!--  <BestKnownDateTime xsi:nil="true" /> -->
									</OperationalDateTime>
									<Status>
										<OperationStatus>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pd_rrmk_remark" />
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
											<DelayCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pl_delayreason_list/pl_delayreason/pdlr_rdlr_delayreason" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</DelayCode>
											<DelayFreeText>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="pl_delayreason_list/pl_delayreason/pdlr_pdlr_comment1" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</DelayFreeText>
										</DelayReason>
										<DisplayCode>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pd_displaycode" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</DisplayCode>
										<IsTransitFlight xsi:nil="true" />
										<IsOverNightFlight>
											<xsl:variable name="paSibt"
													select="substring('/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_sibt',1,10)"></xsl:variable>
											<xsl:variable name="pdSobt"
													select="substring('/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pd_sobt',1,10)"></xsl:variable>
											<xsl:choose>
												<xsl:when test="$paSibt=$pdSobt">N</xsl:when>
												<xsl:otherwise>Y</xsl:otherwise>
											</xsl:choose>
										</IsOverNightFlight>
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
									</Status>
									<Payload>
										<xsl:if
											test="pt_pd_departure/pl_departure/pl_departureloadstatistics_list">
											<xsl:for-each
												select="pt_pd_departure/pl_departure/pl_departureloadstatistics_list">
												<xsl:if test="pl_departureloadstatistics">
													<xsl:for-each select="pl_departureloadstatistics">
														<DepartureAirport>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="pdls_rap_airportfrom" />
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
																		<xsl:with-param name="inElement"
																			select="pdls_pax" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</TotalPassengersNumber>
																<FirstClassPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_paxf" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</FirstClassPassengersNumber>
																<BusinessClassPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_paxc" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</BusinessClassPassengersNumber>
																<EconomicClassPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_paxy" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</EconomicClassPassengersNumber>
															</PassengersNumber>

															<AdultPassengers>
																<TotalAdultPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_adult" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</TotalAdultPassengersNumber>
																<FirstClassAdultPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_adultf" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</FirstClassAdultPassengersNumber>
																<BusinessClassAdultPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_adultc" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</BusinessClassAdultPassengersNumber>
																<EconomicClassAdultPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_adulty" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</EconomicClassAdultPassengersNumber>
															</AdultPassengers>
															<ChildPassengers>
																<TotalChildPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_child" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</TotalChildPassengersNumber>
																<FirstClassChildPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_childf" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</FirstClassChildPassengersNumber>
																<BusinessClassChildPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_childc" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</BusinessClassChildPassengersNumber>
																<EconomicClassChildPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_childy" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</EconomicClassChildPassengersNumber>
															</ChildPassengers>
															<InfantPassengers>
																<TotalInfantPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_infant" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</TotalInfantPassengersNumber>
																<FirstClassInfantPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_infantf" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</FirstClassInfantPassengersNumber>
																<BusinessClassInfantPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_infantc" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</BusinessClassInfantPassengersNumber>
																<EconomicClassInfantPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pdls_infanty" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</EconomicClassInfantPassengersNumber>
															</InfantPassengers>
														</Passenger>
														<Weight>
															<TotalWeight>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdls_totalweight" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</TotalWeight>
															<BaggageWeight>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="pdls_baggageweight" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</BaggageWeight>
															<CargoWeight>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdls_cargoweight" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</CargoWeight>
															<MailWeight>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pdls_mailweight" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</MailWeight>
														</Weight>

													</xsl:for-each>
												</xsl:if>
											</xsl:for-each>
										</xsl:if>
									</Payload>
									<Airport>
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
											<Airbridge>
											<Airbridges>
											<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pd_airbridges" />
														<xsl:with-param name="needAddNil" select="false()" />
													</xsl:call-template>
											</Airbridges>
											
											</Airbridge>
										<Stand>
										   <StandID>
										       <xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_rsta_stand" />
													<xsl:with-param name="needAddNil"
														select="false()" />
											   </xsl:call-template>
										   </StandID>
										</Stand>

										<xsl:for-each select="/soap-env:Envelope/soap-env:Body/pl_turn/pl_stand_list">
											<xsl:choose>
												<xsl:when test="pl_stand">
													<xsl:for-each select="pl_stand">									
														<GroundMovement>														
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
														</GroundMovement>
													</xsl:for-each>
												</xsl:when>
											</xsl:choose>
										</xsl:for-each>

										<xsl:for-each select="pl_departurebelt_list">
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
											</xsl:choose>
										</xsl:for-each>

										<xsl:for-each
											select="pl_departuregate_list">
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
																	<xsl:with-param name="inElement" select="../../pd_asbt" />
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
											</xsl:choose>
										</xsl:for-each>

										<!-- <xsl:for-each select="pl_desk_list">
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
											</xsl:choose>
										</xsl:for-each> -->
										<!-- add mapping for PassengerStatus 2013-11-26-->
										<xsl:for-each select="pl_departureaddinfo_list/pl_departureaddinfo">
											<PassengerStatus>
												<CheckInPassengerCount>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pdai_actualcheckedin" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</CheckInPassengerCount>
												<LateCheckInPassengerCount>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pdai_latecheckedin" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</LateCheckInPassengerCount>
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
										<PassengerAmount>
											<TotalPassengers>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_totalpax" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</TotalPassengers>
											<TransferPassengers>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_transferpax" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</TransferPassengers>
											<TransitPassengers>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_transitpax" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</TransitPassengers>
											<TotalCrews>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_totalcrew" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</TotalCrews>
											<TotalExtraCrews>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pd_totalextracrew" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</TotalExtraCrews>
									   </PassengerAmount>
									</Airport>							
								</FlightData>
								</xsl:if>
							</Data>
						</xsl:for-each>				
					</xsl:if>
					<!--RUS rm_closing request mapping work -->
				</xsl:if>
				<xsl:if test="$aodbMessageType='ACK'  and $aodbOrgMessageType='UPDATE'">
					<Operation>
						<Update>
							<UpdateResponse>
								<UpdateRequestID>
									<xsl:value-of select="$aodbCorrelationId" />
								</UpdateRequestID>
								<UpdateStatus>Success</UpdateStatus>
							</UpdateResponse>
						</Update>
					</Operation>
				</xsl:if>
				<xsl:if test="$aodbMessageType='NACK' and $aodbOrgMessageType = 'UPDATE'">
					<Operation>
						<Update>
							<UpdateResponse>
								<UpdateRequestID>
									<xsl:value-of select="$aodbCorrelationId" />
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
		<!-- </xsl:otherwise> </xsl:choose> -->
	</xsl:template>
	<xsl:template name="xsltTemplate">
		<xsl:param name="inElement" />
		<xsl:param name="needAddNil" />
		<xsl:if test="$inElement/@old">
			<xsl:attribute name="OldValue"><xsl:value-of select="normalize-space(javacode:convertUTC2Time($inElement/@old))" />
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
	<!-- <xsl:value-of select="normalize-space($inElement/text())" /> -->	
	    <xsl:value-of select="normalize-space(javacode:convertUTC2Time($inElement/text()))"  />
	</xsl:template>
	
	<xsl:template name="xsltTemplate4Date">
		<xsl:param name="inElement" />
		<xsl:param name="needAddNil" />
		<xsl:if test="$inElement/@old">
			<xsl:attribute name="OldValue">
				<xsl:value-of select="substring($inElement/@old,1,10)" />
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
		<xsl:value-of select="substring(normalize-space($inElement/text()),1,10)" />
	</xsl:template>
	
	<xsl:template name="operation">
		<xsl:param name="imfServiceType" />
		<xsl:param name="aodbMessageType" />
		<xsl:variable name="action">
			<xsl:choose>
				<!-- update by zzhao 2013-08-27 -->
				<xsl:when test="contains($imfServiceType,'FSS')">
					<xsl:value-of select="pl_turn/pt_pa_arrival/pl_arrival/@action[1]" />
				</xsl:when>
				<xsl:when test="contains($imfServiceType,'BSS') or contains($imfServiceType, 'RSS')">
					<xsl:value-of select="*[1]//@action[1]" />
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$aodbMessageType='ACK' or $aodbMessageType='NACK'">SYS</xsl:when>
			<xsl:when test="$action='insert'">NEW</xsl:when>
			<xsl:when test="$action='update'">MOD</xsl:when>
			<xsl:when test="$action='delete'">DEL</xsl:when>
			<xsl:when test="contains($imfServiceType,'FSS1')">MOD</xsl:when>
			<xsl:when test="contains($imfServiceType,'FSS2')">NEW</xsl:when>
			<xsl:when test="contains($imfServiceType,'BSS') or contains($imfServiceType,'RSS') or contains($imfServiceType,'GSS')">NEW</xsl:when>
			<xsl:otherwise>SYS</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="resourceTypeConvert">
		<xsl:param name="resourceType" />
		<xsl:if test="$resourceType='RSTA'">
			Stand
		</xsl:if>
		<xsl:if test="$resourceType='RBB'">
			BaggageReclaim
		</xsl:if>
		<xsl:if test="$resourceType='RGT'">
			Gate
		</xsl:if>
		<xsl:if test="$resourceType='RCNT'">
			CheckInDesk
		</xsl:if>
		<xsl:if test="$resourceType='RDB'">
			BaggageMakeup
		</xsl:if>
		<xsl:if test="$resourceType='RAB'">
			BoardingBridge
		</xsl:if>
	</xsl:template>
	
	<!--update to fix subsystem can not receive the stand update information for some special operation -->
	<xsl:template name="updateStandID">
		<xsl:param name="inElement" />
		<xsl:param name="needAddNil" />
		<xsl:param name="ref_standid" />
		<xsl:choose>
			<xsl:when test="$inElement/@old">
				<xsl:attribute name="OldValue"><xsl:value-of select="$inElement/@old" />
        	  </xsl:attribute>
			</xsl:when>
			<!--check whether the current stand have old value ,if do, map it to the corresponding stand -->
			<xsl:when test="/soap-env:Envelope/soap-env:Body/pl_turn/pt_rsta_currentstand/@old">
				<xsl:if test="/soap-env:Envelope/soap-env:Body/pl_turn/pt_rsta_currentstand=$inElement">
					<xsl:attribute name="OldValue"><xsl:value-of select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_rsta_currentstand/@old" />
        	     </xsl:attribute>
				</xsl:if>
			</xsl:when>
			<!--if refstand have old value then neeed to map oldvalue to the stand which have the same id -->
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
	
	<!--update to fix subsystem can not update ISOVERNIGHT flag since we did not send the oldvalue to the subsystem check if the operation is MOD then insert 
		Oldvalue="" -->
	<xsl:template name="updateISOVERNIGHT">
		<xsl:param name="imfServiceType" />
		<xsl:param name="aodbMessageType" />
		<xsl:variable name="action">
			<xsl:choose>
				<!-- update by zzhao 2013-08-27 -->
				<xsl:when test="contains($imfServiceType,'FSS1') and /soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/@action[1]">
					<xsl:value-of select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/@action[1]" />
				</xsl:when>
				<xsl:otherwise>
					update
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when
				test="$action='update' and contains($imfServiceType,'FSS1') and /soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_flightnumber/@old">
				<xsl:attribute name="OldValue"></xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>