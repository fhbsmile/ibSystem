<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:aodb="urn:com.tsystems.ac.aodb" xmlns:javacode="com.tsystems.si.aviation.imf.ibSystem.message.XsltUtil"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="aodb soap-env javacode">
	<xsl:output method="xml" indent="yes" />
	<xsl:template match="/">
		<xsl:variable name="aodbMessageType"
			select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:message-type"></xsl:variable>
		<xsl:variable name="correlationID"
			select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:correlation-id"></xsl:variable>
		<xsl:variable name="receiver"
			select="substring-before(substring-after($correlationID,'|' ), '|')"></xsl:variable>
		<IMFRoot>
			<xsl:if test="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival != '' and (/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival//*[@action] or $aodbMessageType = 'DATASET')">						
				<xsl:for-each select="/soap-env:Envelope/soap-env:Body">
					<SysInfo>
						<MessageSequenceID>
							<xsl:value-of
								select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:message-id" />
						</MessageSequenceID>
						<MessageType>
							<xsl:choose>
								<xsl:when test="$aodbMessageType='ACK'">Operation</xsl:when>
								<xsl:otherwise>FlightData</xsl:otherwise>
							</xsl:choose>
						</MessageType>
						<ServiceType>
							<xsl:choose>
								<xsl:when test="$aodbMessageType='DATASET'">FSS2</xsl:when>
								<xsl:otherwise>FSS1</xsl:otherwise>
							</xsl:choose>
						</ServiceType>
						<OperationMode>
							<xsl:call-template name="operation" />
						</OperationMode>
						<SendDateTime>
<xsl:value-of select="pl_turn/pt_pa_arrival/pl_arrival/pa_modtime" />
						</SendDateTime>
						<CreateDateTime>
<xsl:value-of select="pl_turn/pt_pa_arrival/pl_arrival/pa_modtime" />
						</CreateDateTime>
						<OriginalDateTime>
<xsl:value-of select="pl_turn/pt_pa_arrival/pl_arrival/pa_modtime" />
							  <!-- 
							<xsl:value-of select="pl_turn/pt_pa_arrival/pl_arrival/pa_modtime" />
							 -->
						</OriginalDateTime>
						<Receiver>
							<xsl:choose>
								<xsl:when test="$aodbMessageType='DATASET' or $aodbMessageType='ACK'">
									<xsl:value-of select="$receiver" />
								</xsl:when>
							<xsl:otherwise>IMF</xsl:otherwise>
							</xsl:choose>
						</Receiver>	
						<Sender>AODB</Sender>
						<Owner>AODB</Owner>
						<Priority>4</Priority>
					</SysInfo>
					<xsl:variable name="ral_2lc">
						<xsl:if test="pl_turn/pt_pa_arrival/pl_arrival/@action='delete'">
							<xsl:value-of
								select="normalize-space(pl_turn/pt_pa_arrival/pl_arrival/pa_ral_airline/ref_airline/ral_2lc/@old)" />
						</xsl:if>
						<xsl:if
							test="not(pl_turn/pt_pa_arrival/pl_arrival/@action) or pl_turn/pt_pa_arrival/pl_arrival/@action!='delete'">
							<xsl:value-of
								select="normalize-space(pl_turn/pt_pa_arrival/pl_arrival/pa_ral_airline/ref_airline/ral_2lc/text())" />
						</xsl:if>
					</xsl:variable>
					<xsl:for-each select="pl_turn/pt_pa_arrival/pl_arrival">
						<Data>
							<PrimaryKey>
								<FlightKey>
									<FlightScheduledDate>
										<xsl:if test="pa_sibt/@xsi:nil='true' or not(pa_sibt)">
											<xsl:attribute name="xsi:nil">true</xsl:attribute>
										</xsl:if>
										<xsl:value-of select="substring(pa_sibt,1,10)" />
									</FlightScheduledDate>
									<FlightIdentity>
										<xsl:call-template name="xsltTemplate">
											<xsl:with-param name="inElement" select="pa_flightnumber" />
											<xsl:with-param name="needAddNil" select="false()" />
										</xsl:call-template>
									</FlightIdentity>
									<FlightDirection>A</FlightDirection>
									<BaseAirport>
										<AirportIATACode>CGK</AirportIATACode>
										<AirportICAOCode>WIII</AirportICAOCode>
									</BaseAirport>
									<xsl:for-each select="pa_ral_airline/ref_airline">
										<DetailedIdentity>
											<AirlineIATACode>
												<xsl:value-of select="$ral_2lc" />
											</AirlineIATACode>
											<AirlineICAOCode>
												<xsl:if test="../../@action='delete'">
													<xsl:value-of select="normalize-space(ral_3lc/@old)" />
												</xsl:if>
												<xsl:if test="not(../../@action) or ../../@action!='delete'">
													<xsl:value-of select="normalize-space(ral_3lc/text())" />
												</xsl:if>
											</AirlineICAOCode>
										</DetailedIdentity>
									</xsl:for-each>
									<InternalID>
										<xsl:value-of select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_idseq"></xsl:value-of>
									</InternalID>
								</FlightKey>
							</PrimaryKey>
							<xsl:if test="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/@action !='delete'">
							<FlightData>
								<General>
									<FlightScheduledDateTime>
										<xsl:call-template name="xsltTemplate">
											<xsl:with-param name="inElement" select="pa_sibt" />
											<xsl:with-param name="needAddNil" select="true()" />
										</xsl:call-template>
									</FlightScheduledDateTime>
									<Registration>
										<xsl:call-template name="xsltTemplate">
											<xsl:with-param name="inElement" select="pa_registration" />
											<xsl:with-param name="needAddNil" select="false()" />
										</xsl:call-template>
									</Registration>
									<CallSign>
										<xsl:call-template name="xsltTemplate">
											<xsl:with-param name="inElement" select="pa_callsign" />
											<xsl:with-param name="needAddNil" select="false()" />
										</xsl:call-template>
									</CallSign>
									<AircraftType>
										<xsl:for-each select="pa_ract_aircrafttype/ref_aircrafttype">
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
													select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_rstc_servicetypecode" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</FlightIATAServiceType>
									</FlightServiceType>
									<FlightRoute>
										<IATARoute>
											<IATAOriginAirport>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pa_rap_originairport/ref_airport/rap_iata3lc" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</IATAOriginAirport>
											<IATAPreviousAirport>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pa_rap_previousairport/ref_airport/rap_iata3lc" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</IATAPreviousAirport>
											<IATAFullRoute>
												<xsl:for-each select="pl_routing_list/pl_routing">
													<xsl:sort select="prt_numberinleg" />
													<xsl:variable name="legNo" select="prt_numberinleg" />
													<xsl:variable name="viaAirport"
														select="prt_rap_airport/ref_airport/rap_iata3lc" />
													<AirportIATACode>
														<xsl:attribute name="LegNo">
													<xsl:value-of select="$legNo" />
														</xsl:attribute>
														<xsl:if test="prt_rap_airport/ref_airport/rap_iata3lc/@old">

															<xsl:attribute name="OldValue">
															<xsl:value-of
																select="prt_rap_airport/ref_airport/rap_iata3lc/@old" />
														   </xsl:attribute>
														</xsl:if>
														<xsl:value-of select="$viaAirport" />
													</AirportIATACode>
												</xsl:for-each>
											</IATAFullRoute>
										</IATARoute>
										<ICAORoute>
											<ICAOOriginAirport>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pa_rap_originairport/ref_airport/rap_icao4lc" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</ICAOOriginAirport>
											<ICAOPreviousAirport>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pa_rap_previousairport/ref_airport/rap_icao4lc" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</ICAOPreviousAirport>
											<ICAOFullRoute>
												<xsl:for-each
													select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pl_routing_list/pl_routing">
													<!-- add by zzhao 2014-01-21 -->
													<xsl:sort select="prt_numberinleg" />
													<xsl:variable name="legNo" select="prt_numberinleg" />
													<!-- udpate by zzhao 2013-09-06 -->
													<xsl:variable name="viaAirport"
														select="prt_rap_airport/ref_airport/rap_icao4lc" />

													<AirportICAOCode>
														<xsl:attribute name="LegNo">
													<xsl:value-of select="$legNo" />
												 </xsl:attribute>
														<!--oldvalue1 -->
														<xsl:if test="prt_rap_airport/ref_airport/rap_icao4lc/@old">

															<xsl:attribute name="OldValue">
													<xsl:value-of
																select="prt_rap_airport/ref_airport/rap_icao4lc/@old" />
												   </xsl:attribute>
														</xsl:if>
														<xsl:value-of select="$viaAirport" />
													</AirportICAOCode>

												</xsl:for-each>
											</ICAOFullRoute>
										</ICAORoute>
									</FlightRoute>
									<FlightCountryType>
										<xsl:call-template name="xsltTemplate">
											<xsl:with-param name="inElement" select="pa_rctt_countrytype" />
											<xsl:with-param name="needAddNil" select="false()" />
										</xsl:call-template>
									</FlightCountryType>
									<xsl:choose>
										<xsl:when test="../../pt_pd_departure/pl_departure/pd_idseq">
											<LinkFlight>
												<xsl:for-each select="../../pt_pd_departure/pl_departure">
													<FlightScheduledDate>
														<xsl:call-template name="xsltTemplate4Date">
															<xsl:with-param name="inElement" select="pd_sobt" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</FlightScheduledDate>
													<FlightIdentity>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="pd_flightnumber" />
															<xsl:with-param name="needAddNil" select="false()" />
														</xsl:call-template>
													</FlightIdentity>
													<FlightDirection>D</FlightDirection>
													<BaseAirport>
														<AirportIATACode/>
														<AirportICAOCode/>
													</BaseAirport>
													<DetailedIdentity>
														<AirlineIATACode>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="pd_ral_airline/ref_airline/ral_2lc" />
																<xsl:with-param name="needAddNil" select="false()" />
															</xsl:call-template>
														</AirlineIATACode>
														<AirlineICAOCode>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="pd_ral_airline/ref_airline/ral_3lc" />
																<xsl:with-param name="needAddNil" select="false()" />
															</xsl:call-template>
														</AirlineICAOCode>
													</DetailedIdentity>
													<InternalID>
														<xsl:value-of
															select="normalize-space(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_idseq)" />
													</InternalID>
												</xsl:for-each>
											</LinkFlight>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
									<!-- <xsl:when test="pa_pa_mainflight/text()">
											<SlaveFlight>
												<FlightIdentity>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pa_pa_mainflight" />
														<xsl:with-param name="needAddNil" select="false()" />
													</xsl:call-template>
												</FlightIdentity>
											</SlaveFlight>
										</xsl:when> -->	
										<xsl:when test="pl_arrival_list/pl_arrival">
											<xsl:for-each select="pl_arrival_list/pl_arrival">
												<SlaveFlight>
													<FlightIdentity>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="pa_flightnumber" />
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
												<xsl:with-param name="inElement" select="pa_opscomment" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</PublicTextComment>
										<CreateReason>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_createreason" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</CreateReason>
									</FreeTextComment>
								</General>
								<OperationalDateTime>
									<PreviousAirportDepartureDateTime>
										<ScheduledPreviousAirportDepartureDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_stotoutstation" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ScheduledPreviousAirportDepartureDateTime>
										<EstimatedPreviousAirportDepartureDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_etotoutstation" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</EstimatedPreviousAirportDepartureDateTime>
										<ActualPreviousAirportDepartureDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_atotoutstation" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ActualPreviousAirportDepartureDateTime>
									</PreviousAirportDepartureDateTime>
									<TenMilesDateTime>
										<xsl:call-template name="xsltTemplate">
											<xsl:with-param name="inElement" select="pa_fnlt" />
											<xsl:with-param name="needAddNil" select="true()" />
										</xsl:call-template>
									</TenMilesDateTime>

									<FinalApproachTime>
										<xsl:call-template name="xsltTemplate">
											<xsl:with-param name="inElement" select="pa_firt" />
											<xsl:with-param name="needAddNil" select="true()" />
										</xsl:call-template>
									</FinalApproachTime>

									<LandingDateTime>
										<ScheduledLandingDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_sibt" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ScheduledLandingDateTime>
										<EstimatedLandingDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_eldt" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</EstimatedLandingDateTime>
										<TargetLandingDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_tldt" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TargetLandingDateTime>
										<ActualLandingDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_aldt" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ActualLandingDateTime>
									</LandingDateTime>

									<OnBlockDateTime>
										<ScheduledOnBlockDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_sibt" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ScheduledOnBlockDateTime>
										<EstimatedOnBlockDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_eibt" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</EstimatedOnBlockDateTime>
										<ActualOnBlockDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_aibt" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ActualOnBlockDateTime>
									</OnBlockDateTime>
									<FlyTime>
										<ScheduledFlyTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_sflt" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ScheduledFlyTime>
										<EstimatedFlyTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_eflt" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</EstimatedFlyTime>
									</FlyTime>
									<DoorOpenDateTime>
										<ActualDoorOpenDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_dooropentime" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ActualDoorOpenDateTime>
									</DoorOpenDateTime>
									<OnBridgeDateTime>
										<ActualOnBridgeDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_onbridge" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ActualOnBridgeDateTime>
									</OnBridgeDateTime>
									<!-- 
									<BestKnownDateTime> 
										<BestKnownOnBlockDateTime>
										<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pa_bibt" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</BestKnownOnBlockDateTime>
									</BestKnownDateTime>
									-->
								</OperationalDateTime>
								<Status>
									<OperationStatus>
										<xsl:call-template name="xsltTemplate">
											<xsl:with-param name="inElement" select="pa_rrmk_remark" />
											<xsl:with-param name="needAddNil" select="false()" />
										</xsl:call-template>
									</OperationStatus>
									<FlightStatus>
										<xsl:call-template name="xsltTemplate">
											<xsl:with-param name="inElement" select="pa_rfst_flightstatus" />
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
													select="pl_delayreason_list/pl_delayreason/pdlr_comment1" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</DelayFreeText>
									</DelayReason>
									<xsl:variable name="remark" select="pa_rrmk_remark" />
									<DiversionAirport>
										<AirportIATACode>
											<xsl:if test="$remark='DIVAL'">
												<xsl:value-of
													select="pa_rap_diversionairport/ref_airport/rap_iata3lc" />
											</xsl:if>
										</AirportIATACode>
										<AirportICAOCode>
											<xsl:if test="$remark='DIVAL'">
												<xsl:value-of
													select="pa_rap_diversionairport/ref_airport/rap_icao4lc" />
											</xsl:if>
										</AirportICAOCode>
									</DiversionAirport>
									<ChangeLandingAirport>
										<AirportIATACode>
											<xsl:if test="$remark='DIVCH'">
												<xsl:value-of
													select="pa_rap_diversionairport/ref_airport/rap_iata3lc" />
											</xsl:if>
										</AirportIATACode>
										<AirportICAOCode>
											<xsl:if test="$remark='DIVCH'">
												<xsl:value-of
													select="pa_rap_diversionairport/ref_airport/rap_icao4lc" />
											</xsl:if>
										</AirportICAOCode>
									</ChangeLandingAirport>
									<DisplayCode>
										<xsl:call-template name="xsltTemplate">
											<xsl:with-param name="inElement" select="pa_displaycode" />
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
											<xsl:with-param name="inElement" select="pa_vipind" />
											<xsl:with-param name="needAddNil" select="true()" />
										</xsl:call-template>
									</IsVIPFlight>
									<VIPComment>
										<xsl:call-template name="xsltTemplate">
											<xsl:with-param name="inElement" select="pa_vipcomment" />
											<xsl:with-param name="needAddNil" select="true()" />
										</xsl:call-template>
									</VIPComment>
								</Status>
									<xsl:for-each
										select="pl_arrivalloadstatistics_list">
										<xsl:if test="pl_arrivalloadstatistics">
											<xsl:for-each select="pl_arrivalloadstatistics">
												<Payload>
													<DepartureAirport>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="pals_rap_airportfrom" />
															<xsl:with-param name="needAddNil" select="false()" />
														</xsl:call-template>
													</DepartureAirport>
													<DestinationAirport>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="pals_rap_airportto" />
															<xsl:with-param name="needAddNil" select="false()" />
														</xsl:call-template>
													</DestinationAirport>
													<Passenger>
														<PassengersNumber>
															<TotalPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_pax" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</TotalPassengersNumber>
															<FirstClassPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_paxf" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</FirstClassPassengersNumber>
															<BusinessClassPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_paxc" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</BusinessClassPassengersNumber>
															<EconomicClassPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_paxy" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</EconomicClassPassengersNumber>
														</PassengersNumber>

														<AdultPassengers>
															<TotalAdultPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_adult" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</TotalAdultPassengersNumber>
															<FirstClassAdultPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_adultf" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</FirstClassAdultPassengersNumber>
															<BusinessClassAdultPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_adultc" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</BusinessClassAdultPassengersNumber>
															<EconomicClassAdultPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_adulty" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</EconomicClassAdultPassengersNumber>
														</AdultPassengers>
														<ChildPassengers>
															<TotalChildPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_child" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</TotalChildPassengersNumber>
															<FirstClassChildPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_childf" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</FirstClassChildPassengersNumber>
															<BusinessClassChildPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_childc" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</BusinessClassChildPassengersNumber>
															<EconomicClassChildPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_childy" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</EconomicClassChildPassengersNumber>
														</ChildPassengers>
														<InfantPassengers>
															<TotalInfantPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_infant" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</TotalInfantPassengersNumber>
															<FirstClassInfantPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_infantf" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</FirstClassInfantPassengersNumber>
															<BusinessClassInfantPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_infantc" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>

															</BusinessClassInfantPassengersNumber>
															<EconomicClassInfantPassengersNumber>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pals_infanty" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</EconomicClassInfantPassengersNumber>
														</InfantPassengers>
													</Passenger>
													<Weight>
														<TotalWeight>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pals_totalweight" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</TotalWeight>
														<BaggageWeight>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pals_baggageweight" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</BaggageWeight>
														<CargoWeight>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pals_cargoweight" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</CargoWeight>
														<MailWeight>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pals_mailweight" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</MailWeight>
													</Weight>
												</Payload>
											</xsl:for-each>
										</xsl:if>
									</xsl:for-each>
								<Airport>
									<Terminal>
											<FlightTerminalID>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pa_rtrm_terminal" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</FlightTerminalID>
											<AircraftTerminalID />
									</Terminal>
									<Runway>
											<RunwayID>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pa_rrwy_runway" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</RunwayID>
									</Runway>
									<Airbridge>
									<Airbridges>
									<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pa_airbridges" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
									
									</Airbridges>
									
									</Airbridge>
									<Stand>
										<StandID>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_rsta_stand" />
												<xsl:with-param name="needAddNil" select="false()" />
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
																<xsl:with-param name="ref_standid"
																	select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_rsta_refstand/ref_stand/rsta_code" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</StandID>
														<ScheduledStandStartDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pst_beginplan" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</ScheduledStandStartDateTime>
														<ScheduledStandEndDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pst_endplan" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</ScheduledStandEndDateTime>
														<ActualStandStartDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pst_beginactual" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</ActualStandStartDateTime>
														<ActualStandEndDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pst_endactual" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</ActualStandEndDateTime>
													</GroundMovement>
												</xsl:for-each>
											</xsl:when>
										</xsl:choose>
									</xsl:for-each>
									<xsl:for-each select="pl_arrivalgate_list">
										<xsl:choose>
											<xsl:when test="pl_arrivalgate">
												<xsl:for-each select="pl_arrivalgate">
													<Gate>
														<GateID>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pag_rgt_gate" />
																<xsl:with-param name="needAddNil" select="false()" />
															</xsl:call-template>
														</GateID>
														<GateStatus>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pag_status" />
																<xsl:with-param name="needAddNil" select="false()" />
															</xsl:call-template>
														</GateStatus>
														<ScheduledGateStartDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pag_beginplan" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</ScheduledGateStartDateTime>
														<ScheduledGateEndDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pag_endplan" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</ScheduledGateEndDateTime>
														<ActualGateStartDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pag_beginactual" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</ActualGateStartDateTime>
														<ActualGateEndDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pag_endactual" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</ActualGateEndDateTime>
													</Gate>
												</xsl:for-each>
											</xsl:when>
										</xsl:choose>
									</xsl:for-each>
									<xsl:for-each select="pl_baggagebelt_list">
										<xsl:choose>
											<xsl:when test="pl_baggagebelt">
												<xsl:for-each select="pl_baggagebelt">
													<BaggageReclaim>
														<BaggageReclaimID>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="pbb_rbb_baggagebelt" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</BaggageReclaimID>
														<BaggageReclaimStatus>
														<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="pbb_status" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														
														</BaggageReclaimStatus>
														<ScheduledReclaimStartDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pbb_beginplan" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</ScheduledReclaimStartDateTime>
														<ScheduledReclaimEndDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pbb_endplan" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</ScheduledReclaimEndDateTime>
														<ActualReclaimStartDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pbb_beginactual" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</ActualReclaimStartDateTime>
														<ActualReclaimEndDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pbb_endactual" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</ActualReclaimEndDateTime>
														<FirstBaggageDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pbb_firstbag" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</FirstBaggageDateTime>
														<LastBaggageDateTime>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pbb_lastbag" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</LastBaggageDateTime>
													</BaggageReclaim>
												</xsl:for-each>
											</xsl:when>
										</xsl:choose>
									</xsl:for-each>
								</Airport>
							</FlightData>
							</xsl:if>
						</Data>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:if>
		</IMFRoot>
	</xsl:template>

	<xsl:template name="xsltTemplate">
		<xsl:param name="inElement" />
		<xsl:param name="needAddNil" />
		<xsl:if test="$inElement/@old">
			<!-- <xsl:attribute name="OldValue"><xsl:value-of select="$inElement/@old" /> 
			<xsl:attribute name="OldValue"><xsl:value-of select="normalize-space(adjust-dateTime-to-timezone($inElement/@old,xs:dayTimeDuration('PT8H')))" />
			-->
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
		<xsl:variable name="action">
			<xsl:value-of select="pl_turn/pt_pa_arrival/pl_arrival/@action[1]" />
		</xsl:variable>
		<xsl:variable name="messageType">
			<xsl:value-of select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:message-type" />
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$messageType='ACK'">SYS</xsl:when>
			<xsl:when test="$action='insert'">NEW</xsl:when>
			<xsl:when test="$action='update'">MOD</xsl:when>
			<xsl:when test="$action='delete'">DEL</xsl:when>
			<xsl:when test="$messageType='DATASET'">NEW</xsl:when>
			<xsl:when test="$messageType!='DATASET'">MOD</xsl:when>
			<xsl:otherwise>SYS</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!--update to fix subsystem can not receive the stand update information 
		for some special operation -->
	<xsl:template name="updateStandID">
		<xsl:param name="inElement" />
		<xsl:param name="needAddNil" />
		<xsl:param name="ref_standid" />
		<xsl:choose>
			<xsl:when test="$inElement/@old">
				<xsl:attribute name="OldValue"><xsl:value-of select="$inElement/@old" />
        	  </xsl:attribute>
			</xsl:when>
			<!--check whether the current stand have old value ,if do, map it to the 
				corresponding stand -->
			<xsl:when
				test="/soap-env:Envelope/soap-env:Body/pl_turn/pt_rsta_currentstand/@old">
				<xsl:if
					test="/soap-env:Envelope/soap-env:Body/pl_turn/pt_rsta_currentstand=$inElement">
					<xsl:attribute name="OldValue"><xsl:value-of
						select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_rsta_currentstand/@old" />
        	     </xsl:attribute>
				</xsl:if>
			</xsl:when>
			<!--if refstand have old value then neeed to map oldvalue to the stand 
				which have the same id -->
			<xsl:when test="$ref_standid/@old">
				<xsl:if test="$ref_standid=$inElement">
					<xsl:attribute name="OldValue"><xsl:value-of
						select="$ref_standid/@old" />
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
	
</xsl:stylesheet>