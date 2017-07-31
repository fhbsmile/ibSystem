<!-- 3.0 1. change pa_srta to pa_sibt and pd_srtd to pd_sobt -->
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:aodb="urn:com.tsystems.ac.aodb" xmlns:javacode="com.tsystems.aviation.adapter.us.utils.Util"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	exclude-result-prefixes="javacode">
	<xsl:output method="xml" indent="yes" />
	<xsl:template match="/">
		<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/"
			xmlns:aodb="urn:com.tsystems.ac.aodb" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:if test="/IMFRoot/SysInfo/ServiceType = 'FUS'">
				<xsl:variable name="originalDate" select="IMFRoot/SysInfo/OriginalDateTime"></xsl:variable>
				<xsl:variable name="synstarttime"
					select="IMFRoot/Operation/Subscription/SyncPeriodRequest/SyncUpdateFromDateTime" />
				<xsl:variable name="schstarttime"
					select="IMFRoot/Operation/Subscription/FlightPeriodRequest/FlightScheduleFromDateTime" />
				<xsl:variable name="schendtime"
					select="IMFRoot/Operation/Subscription/FlightPeriodRequest/FlightScheduleEndDateTime" />
				<xsl:variable name="sender" select="IMFRoot/SysInfo/Sender" />
				<xsl:variable name="owner" select="IMFRoot/SysInfo/Owner" />
				<xsl:variable name="msgID" select="IMFRoot/SysInfo/MessageSequenceID" />
				<soap-env:Header>
					<aodb:control>
						<xsl:for-each select="IMFRoot/SysInfo">
							<aodb:message-id>
								<xsl:value-of select="concat($sender, '|', $msgID)" />
							</aodb:message-id>
							<aodb:message-version>1.4</aodb:message-version>
							<aodb:message-type>UPDATE</aodb:message-type>
							<aodb:request>
								<aodb:datatype>pl_turn</aodb:datatype>
							</aodb:request>
							<aodb:timestamp>
								<xsl:value-of select="$originalDate" />
							</aodb:timestamp>
							<aodb:sender>
								<xsl:value-of select="$sender" />
							</aodb:sender>
						</xsl:for-each>
					</aodb:control>
				</soap-env:Header>
				<soap-env:Body>
					<xsl:variable name="direction"
						select="IMFRoot/Data/PrimaryKey/FlightKey/FlightDirection"></xsl:variable>
					<xsl:variable name="operationMode" select="IMFRoot/SysInfo/OperationMode"></xsl:variable>
					<xsl:for-each select="IMFRoot/Data">
						<xsl:if test="PrimaryKey/FlightKey">
							<pl_turn>
								<xsl:if test="$operationMode='DEL'">
									<xsl:attribute name="action">delete</xsl:attribute>
								</xsl:if>
								<xsl:if test="$direction='A' ">
									<pt_pa_arrival>
										<!--update by zzhao 2013-08-27 -->
										<pl_arrival>
											<!--<pa_modtime> <xsl:value-of select="../SysInfo/OriginalDateTime" 
												/> </pa_modtime> edited by Steven -->
											<xsl:for-each select="PrimaryKey/FlightKey">
												<!-- mod by zzhao 2013-10-11 -->
												<xsl:if test="FlightScheduledDate">
													<pa_sibt>
														<xsl:variable name="seceduledate" select="FlightScheduledDate" />
														<xsl:if test="FlightScheduledDate/@old">
															<xsl:attribute name="OldValue">
                               		<xsl:value-of select="FlightScheduledDate/@old" />
                              </xsl:attribute>
														</xsl:if>
														<xsl:call-template name="flightScheduleDateTimeTemplate">
															<xsl:with-param name="scheduleDatetime"
																select="../../FlightData/General/FlightScheduledDateTime" />
															<xsl:with-param name="seceduledate"
																select="$seceduledate" />
														</xsl:call-template>
													</pa_sibt>
												</xsl:if>
												<xsl:if test="FlightIdentity">
													<pa_flightnumber>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="FlightIdentity" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_flightnumber>
												</xsl:if>
											</xsl:for-each>
											<xsl:for-each select="FlightData/General">
												<!-- mod by zzhao 2013-09-24 -->
												<xsl:if test="Registration">
													<pa_registration>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">
																pl_turn.pt_pa_arrival.pl_arrival.pa_registration
															</xsl:with-param>
															<xsl:with-param name="sender" select="$owner" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="Registration" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_registration>
												</xsl:if>
												<xsl:if test="CallSign">
													<pa_callsign>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="CallSign" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_callsign>
												</xsl:if>

												<xsl:for-each select="AircraftType">
													<pa_ract_aircrafttype>
														<xsl:value-of select="AircraftIATACode" />
													</pa_ract_aircrafttype>
												</xsl:for-each>

												<xsl:if test="FlightServiceType/FlightIATAServiceType">
													<pa_rstc_servicetypecode>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="FlightServiceType/FlightIATAServiceType" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_rstc_servicetypecode>
												</xsl:if>



												<xsl:for-each select="FlightRoute">
													<xsl:if
														test="IATARoute/IATAOriginAirport or ICAORoute/ICAOOriginAirport">
														<pa_rap_originairport>
															<xsl:value-of select="IATARoute/IATAOriginAirport" />
															<!--<ref_airport> <xsl:if test="IATARoute/IATAOriginAirport"> 
																<rap_iata3lc> <xsl:call-template name="xsltTemplate"> <xsl:with-param name="inElement" 
																select="IATARoute/IATAOriginAirport" /> <xsl:with-param name="needAddNil" 
																select="true()" /> </xsl:call-template> </rap_iata3lc> </xsl:if> <xsl:if 
																test="ICAORoute/ICAOOriginAirport"> <rap_icao4lc> <xsl:call-template name="xsltTemplate"> 
																<xsl:with-param name="inElement" select="ICAORoute/ICAOOriginAirport" /> 
																<xsl:with-param name="needAddNil" select="true()" /> </xsl:call-template> 
																</rap_icao4lc> </xsl:if> </ref_airport> edited by Steven -->
														</pa_rap_originairport>
													</xsl:if>
													<xsl:if
														test="IATARoute/IATAPreviousAirport or ICAORoute/ICAOPreviousAirport">
														<pa_rap_previousairport>
															<xsl:value-of select="IATARoute/IATAPreviousAirport" />
															<!-- <ref_airport> <xsl:if test="IATARoute/IATAPreviousAirport"> 
																<rap_iata3lc> <xsl:call-template name="xsltTemplate"> <xsl:with-param name="inElement" 
																select="IATARoute/IATAPreviousAirport" /> <xsl:with-param name="needAddNil" 
																select="true()" /> </xsl:call-template> </rap_iata3lc> </xsl:if> <xsl:if 
																test="ICAORoute/ICAOPreviousAirport"> <rap_icao4lc> <xsl:call-template name="xsltTemplate"> 
																<xsl:with-param name="inElement" select="ICAORoute/ICAOPreviousAirport" /> 
																<xsl:with-param name="needAddNil" select="true()" /> </xsl:call-template> 
																</rap_icao4lc> </xsl:if> <xsl:if test="../FlightCountryType"> <rap_rctt_countrytype> 
																<xsl:value-of select="../FlightCountryType" /> <xsl:call-template name="xsltTemplate"> 
																<xsl:with-param name="inElement" select="../FlightCountryType" /> <xsl:with-param 
																name="needAddNil" select="true()" /> </xsl:call-template> </rap_rctt_countrytype> 
																</xsl:if> </ref_airport> edited by Steven -->
														</pa_rap_previousairport>
													</xsl:if>

													<xsl:variable name="countRoute"
														select="count(IATARoute/IATAFullRoute/AirportIATACode)" />
													<xsl:if test="IATARoute/IATAFullRoute/AirportIATACode">

														<pl_routing_list>
															<xsl:for-each select="IATARoute/IATAFullRoute/AirportIATACode">
																<pl_routing>
																	<prt_numberinleg>
																		<xsl:value-of select="@LegNo" />
																	</prt_numberinleg>
																	<prt_rap_airport>
																		<xsl:value-of select="." />
																		<ref_airport>
																			<rap_iata3lc>
																				<xsl:value-of select="." />
																			</rap_iata3lc>
																		</ref_airport>
																	</prt_rap_airport>

																	<!--Steven Edit -->
																	<xsl:if test="position()=$countRoute">
																		<prt_stdstation>
																			<xsl:value-of select="$stotstation" />
																		</prt_stdstation>
																	</xsl:if>
																	<!-- Steven Edit -->

																</pl_routing>
															</xsl:for-each>
														</pl_routing_list>

													</xsl:if>
												</xsl:for-each>

												<xsl:if test="SlaveFlight">
													<pl_arrival_list>

														<xsl:for-each select="SlaveFlight">
															<pl_arrival>
																<pa_flightnumber>
																	<xsl:value-of select="FlightIdentity" />
																</pa_flightnumber>
															</pl_arrival>
														</xsl:for-each>

													</pl_arrival_list>
												</xsl:if>



												<xsl:if test="FreeTextComment/PublicTextComment">
													<pa_opscomment>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="FreeTextComment/PublicTextComment" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_opscomment>
												</xsl:if>
												<xsl:if test="FreeTextComment/CreateReason">
													<pa_createreason>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="FreeTextComment/CreateReason" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_createreason>
												</xsl:if>
											</xsl:for-each>
											<xsl:for-each select="FlightData/OperationalDateTime">
												<!--add by zzhao 2014-05-08 -->
												<xsl:if
													test="PreviousAirportDepartureDateTime/ScheduledPreviousAirportDepartureDateTime">
													<pa_stotoutstation>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">
																pl_turn.pt_pa_arrival.pl_arrival.pa_stotoutstation
															</xsl:with-param>
															<xsl:with-param name="sender" select="$owner" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="PreviousAirportDepartureDateTime/ScheduledPreviousAirportDepartureDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_stotoutstation>
												</xsl:if>
												<xsl:if
													test="PreviousAirportDepartureDateTime/EstimatedPreviousAirportDepartureDateTime">
													<pa_etotoutstation>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">
																pl_turn.pt_pa_arrival.pl_arrival.pa_etotoutstation
															</xsl:with-param>
															<xsl:with-param name="sender" select="$owner" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="PreviousAirportDepartureDateTime/EstimatedPreviousAirportDepartureDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_etotoutstation>
												</xsl:if>
												<xsl:if
													test="PreviousAirportDepartureDateTime/ActualPreviousAirportDepartureDateTime">
													<pa_atotoutstation>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">
																pl_turn.pt_pa_arrival.pl_arrival.pa_atotoutstation
															</xsl:with-param>
															<xsl:with-param name="sender" select="$owner" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="PreviousAirportDepartureDateTime/ActualPreviousAirportDepartureDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_atotoutstation>
												</xsl:if>
												<xsl:if test="TenMilesDateTime">
													<pa_fnlt>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="TenMilesDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_fnlt>
												</xsl:if>
												<!--Add by zzhao 2013-06-20 -->
												<xsl:if test="LandingDateTime/EstimatedLandingDateTime">
													<pa_eldt>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">
																pl_turn.pt_pa_arrival.pl_arrival.pa_eldt
															</xsl:with-param>
															<xsl:with-param name="sender" select="$owner" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="LandingDateTime/EstimatedLandingDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_eldt>
												</xsl:if>
												<xsl:if test="LandingDateTime/ActualLandingDateTime">
													<pa_aldt>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">
																pl_turn.pt_pa_arrival.pl_arrival.pa_aldt
															</xsl:with-param>
															<xsl:with-param name="sender" select="$owner" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="LandingDateTime/ActualLandingDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_aldt>
												</xsl:if>
												<!--Add by zzhao 2013-09-23 -->
												<xsl:if test="OnBlockDateTime/ScheduledOnBlockDateTime">
													<pa_sibt>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">
																pl_turn.pt_pa_arrival.pl_arrival.pa_sibt
															</xsl:with-param>
															<xsl:with-param name="sender" select="$owner" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="OnBlockDateTime/ScheduledOnBlockDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_sibt>
												</xsl:if>
												<xsl:if test="OnBlockDateTime/EstimatedOnBlockDateTime">
													<pa_eibt>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">
																pl_turn.pt_pa_arrival.pl_arrival.pa_eibt
															</xsl:with-param>
															<xsl:with-param name="sender" select="$owner" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="OnBlockDateTime/EstimatedOnBlockDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_eibt>
												</xsl:if>
												<xsl:if test="OnBlockDateTime/ActualOnBlockDateTime">
													<pa_aibt>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">
																pl_turn.pt_pa_arrival.pl_arrival.pa_aibt
															</xsl:with-param>
															<xsl:with-param name="sender" select="$owner" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="OnBlockDateTime/ActualOnBlockDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_aibt>
												</xsl:if>
												<!--Add by zzhao 2014-05-22 -->
												<xsl:if test="FlyTime/EstimatedFlyTime">
													<pa_eflt>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">
																pl_turn.pt_pa_arrival.pl_arrival.pa_eflt
															</xsl:with-param>
															<xsl:with-param name="sender" select="$owner" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="FlyTime/EstimatedFlyTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_eflt>
												</xsl:if>
												<!--Add by zzhao 2013-06-20 -->
												<xsl:if test="DoorOpenDateTime/ActualDoorOpenDateTime">
													<pa_dooropentime>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="DoorOpenDateTime/ActualDoorOpenDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_dooropentime>
												</xsl:if>
												<xsl:if test="OnBridgeDateTime/ActualOnBridgeDateTime">
													<pa_onbridge>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="OnBridgeDateTime/ActualOnBridgeDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_onbridge>
												</xsl:if>

											</xsl:for-each>

											<xsl:for-each select="FlightData/Status">
												<!-- mod by zzhao 2014-02-26 -->
												<!-- <xsl:if test="IsCashFlight='Y'"> <pa_paymentmode>C</pa_paymentmode> 
													</xsl:if> -->
												<!--mod by zzhao 2013-10-14 -->
												<xsl:if test="DelayReason">
													<pl_delayreason_list>
														<xsl:for-each select="DelayReason">
															<pl_delayreason>
																<pdlr_rdlr_delayreason>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="DelayCode" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</pdlr_rdlr_delayreason>
															</pl_delayreason>
														</xsl:for-each>
													</pl_delayreason_list>
												</xsl:if>
												<xsl:if test="OperationStatus">
													<pa_rrmk_remark>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">
																pl_turn.pt_pa_arrival.pl_arrival.pa_rrmk_remark
															</xsl:with-param>
															<xsl:with-param name="sender" select="$owner" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="OperationStatus" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_rrmk_remark>
												</xsl:if>
												<xsl:if test="FlightStatus">
													<pa_rfst_flightstatus>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="FlightStatus" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_rfst_flightstatus>
												</xsl:if>
												<xsl:if test="DisplayCode">
													<pa_displaycode>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="DisplayCode" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_displaycode>
												</xsl:if>
												<!--add by zzhao 2014-02-26 -->
												<xsl:if test="IsVIPFlight">
													<pa_vipind>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="IsVIPFlight" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_vipind>
												</xsl:if>
												<xsl:if test="VIPComment">
													<pa_vipcomment>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="VIPComment" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_vipcomment>
												</xsl:if>
											</xsl:for-each>

											<xsl:if test="FlightData/Payload">
												<pl_arrivalloadstatistics_list>
													<xsl:for-each select="FlightData/Payload">
														<pl_arrivalloadstatistics>
															<!-- Add by zzhao 2013-06-20 -->
															<xsl:if test="DepartureAirport">
																<pals_rap_airportfrom>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="DepartureAirport" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</pals_rap_airportfrom>
															</xsl:if>
															<xsl:if test="DestinationAirport">
																<pals_rap_airportto>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="DestinationAirport" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</pals_rap_airportto>
															</xsl:if>

															<xsl:for-each select="Passenger">
																<xsl:for-each select="PassengersNumber">
																	<xsl:if test="TotalPassengersNumber">
																		<pals_pax>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="TotalPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_pax>
																	</xsl:if>
																	<xsl:if test="FirstClassPassengersNumber">
																		<pals_paxf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="FirstClassPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_paxf>
																	</xsl:if>
																	<xsl:if test="BusinessClassPassengersNumber">
																		<pals_paxc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="BusinessClassPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_paxc>
																	</xsl:if>
																	<xsl:if test="EconomicClassPassengersNumber">
																		<pals_paxy>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="EconomicClassPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_paxy>
																	</xsl:if>
																</xsl:for-each>
																<xsl:for-each select="AdultPassengers">
																	<xsl:if test="TotalAdultPassengersNumber">
																		<pals_adult>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="TotalAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_adult>
																	</xsl:if>
																	<xsl:if test="FirstClassAdultPassengersNumber">
																		<pals_adultf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="FirstClassAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_adultf>
																	</xsl:if>
																	<xsl:if test="BusinessClassAdultPassengersNumber">
																		<pals_adultc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="BusinessClassAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_adultc>
																	</xsl:if>
																	<xsl:if test="EconomicClassAdultPassengersNumber">
																		<pals_adulty>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="EconomicClassAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_adulty>
																	</xsl:if>
																</xsl:for-each>
																<xsl:for-each select="ChildPassengers">
																	<xsl:if test="TotalChildPassengersNumber">
																		<pals_child>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="TotalChildPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_child>
																	</xsl:if>
																	<xsl:if test="FirstClassChildPassengersNumber">
																		<pals_childf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="FirstClassChildPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_childf>
																	</xsl:if>
																	<xsl:if test="BusinessClassChildPassengersNumber">
																		<pals_childc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="BusinessClassChildPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_childc>
																	</xsl:if>
																	<xsl:if test="EconomicClassChildPassengersNumber">
																		<pals_childy>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="EconomicClassChildPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_childy>
																	</xsl:if>
																</xsl:for-each>
																<xsl:for-each select="InfantPassengers">
																	<xsl:if test="TotalInfantPassengersNumber">
																		<pals_infant>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="TotalInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_infant>
																	</xsl:if>
																	<xsl:if test="FirstClassInfantPassengersNumber">
																		<pals_infantf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="FirstClassInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_infantf>
																	</xsl:if>
																	<xsl:if test="BusinessClassInfantPassengersNumber">
																		<pals_infantc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="BusinessClassInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_infantc>
																	</xsl:if>
																	<xsl:if test="EconomicClassInfantPassengersNumber">
																		<pals_infanty>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="EconomicClassInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pals_infanty>
																	</xsl:if>
																</xsl:for-each>
															</xsl:for-each>
															<xsl:for-each select="Weight">
																<xsl:if test="TotalWeight">
																	<pals_totalweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="TotalWeight" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pals_totalweight>
																</xsl:if>
																<xsl:if test="BaggageWeight">
																	<pals_baggageweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="BaggageWeight" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pals_baggageweight>
																</xsl:if>
																<xsl:if test="CargoWeight">
																	<pals_cargoweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="CargoWeight" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pals_cargoweight>
																</xsl:if>
																<xsl:if test="MailWeight">
																	<pals_mailweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="MailWeight" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pals_mailweight>
																</xsl:if>
															</xsl:for-each>
															<!-- redundant node mapping, please refer to mapping of pals_rap_airportfrom 
																above -->
															<!-- <pals_rap_airportfrom xsi:nil="true" /> <pals_rap_airportto 
																xsi:nil="true" /> -->
														</pl_arrivalloadstatistics>
													</xsl:for-each>
												</pl_arrivalloadstatistics_list>
											</xsl:if>

											<xsl:for-each select="FlightData/Airport">
												<xsl:if test="Terminal/FlightTerminalID">
													<pa_rtrm_terminal>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="Terminal/FlightTerminalID" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_rtrm_terminal>
												</xsl:if>
												<xsl:if test="Runway/RunwayID">
													<pa_rrwy_runway>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="Runway/RunwayID" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_rrwy_runway>
												</xsl:if>

												<xsl:if test="Gate">
													<pl_arrivalgate_list>
														<xsl:for-each select="Gate">
															<pl_arrivalgate>
																<xsl:if test="GateID">
																	<pag_rgt_gate>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="GateID" />
																			<xsl:with-param name="needAddNil"
																				select="false()" />
																		</xsl:call-template>
																	</pag_rgt_gate>
																</xsl:if>
																<!--<xsl:if test="GateStatus"> <pag_status> <xsl:call-template 
																	name="xsltTemplate"> <xsl:with-param name="inElement" select="GateStatus" 
																	/> <xsl:with-param name="needAddNil" select="false()" /> </xsl:call-template> 
																	</pag_status> </xsl:if> Steven commented 2013/12/10 -->
																<xsl:if test="ScheduledGateStartDateTime">
																	<pag_beginplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ScheduledGateStartDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pag_beginplan>
																</xsl:if>
																<xsl:if test="ScheduledGateEndDateTime">
																	<pag_endplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ScheduledGateEndDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pag_endplan>
																</xsl:if>
																<xsl:if test="ActualGateStartDateTime">
																	<pag_beginactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ActualGateStartDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pag_beginactual>
																</xsl:if>
																<xsl:if test="ActualGateEndDateTime">
																	<pag_endactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ActualGateEndDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pag_endactual>
																</xsl:if>
															</pl_arrivalgate>
														</xsl:for-each>
													</pl_arrivalgate_list>
												</xsl:if>

												<xsl:if test="BaggageReclaim">
													<pl_baggagebelt_list>
														<xsl:for-each select="BaggageReclaim">
															<pl_baggagebelt>
																<xsl:if test="BaggageReclaimID">
																	<pbb_rbb_baggagebelt>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="BaggageReclaimID" />
																			<xsl:with-param name="needAddNil"
																				select="false()" />
																		</xsl:call-template>
																	</pbb_rbb_baggagebelt>
																</xsl:if>
																<xsl:if test="ScheduledReclaimStartDateTime">
																	<pbb_beginplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ScheduledReclaimStartDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pbb_beginplan>
																</xsl:if>
																<xsl:if test="ScheduledReclaimEndDateTime">
																	<pbb_endplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ScheduledReclaimEndDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pbb_endplan>
																</xsl:if>
																<xsl:if test="ActualReclaimStartDateTime">
																	<pbb_beginactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ActualReclaimStartDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pbb_beginactual>
																</xsl:if>
																<xsl:if test="ActualReclaimEndDateTime">
																	<pbb_endactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ActualReclaimEndDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pbb_endactual>
																</xsl:if>
																<xsl:if test="FirstBaggageDateTime">
																	<pbb_firstbag>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="FirstBaggageDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pbb_firstbag>
																</xsl:if>
																<xsl:if test="LastBaggageDateTime">
																	<pbb_lastbag>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="LastBaggageDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pbb_lastbag>
																</xsl:if>
															</pl_baggagebelt>
														</xsl:for-each>
													</pl_baggagebelt_list>
												</xsl:if>
											</xsl:for-each>

										</pl_arrival>
									</pt_pa_arrival>

									<xsl:for-each select="FlightData/Airport">
										<xsl:if test="Stand">
											<pl_stand_list>
												<xsl:for-each select="Stand">
													<pl_stand>
														<xsl:if test="StandID">
															<pst_rsta_stand>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="StandID" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</pst_rsta_stand>
														</xsl:if>
														<xsl:if test="ScheduledStandStartDateTime">
															<pst_beginplan>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="ScheduledStandStartDateTime" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</pst_beginplan>
														</xsl:if>
														<xsl:if test="ScheduledStandEndDateTime">
															<pst_endplan>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="ScheduledStandEndDateTime" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</pst_endplan>
														</xsl:if>
														<xsl:if test="ActualStandStartDateTime">
															<pst_beginactual>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="ActualStandStartDateTime" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</pst_beginactual>
														</xsl:if>
														<xsl:if test="ActualStandEndDateTime">
															<pst_endactual>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="ActualStandEndDateTime" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</pst_endactual>
														</xsl:if>
													</pl_stand>
												</xsl:for-each>
											</pl_stand_list>
										</xsl:if>
									</xsl:for-each>

								</xsl:if>

								<xsl:if test="$direction ='D' ">
									<pt_pd_departure>
										<!--update by zzhao 2013-08-27 -->
										<pl_departure>
											<!--<pd_modtime> <xsl:value-of select="../SysInfo/OriginalDateTime" 
												/> </pd_modtime> edited by Steven -->
											<xsl:for-each select="PrimaryKey/FlightKey">
												<!-- mod by zzhao 2013-10-11 -->
												<xsl:if test="FlightScheduledDate">
													<pd_sobt>
														<xsl:variable name="seceduledate" select="FlightScheduledDate" />
														<xsl:if test="FlightScheduledDate/@old">
															<xsl:attribute name="OldValue">
                                <xsl:value-of
																select="FlightScheduledDate/@old" />
                              </xsl:attribute>
														</xsl:if>
														<xsl:call-template name="flightScheduleDateTimeTemplate">
															<xsl:with-param name="scheduleDatetime"
																select="../../FlightData/General/FlightScheduledDateTime" />
															<xsl:with-param name="seceduledate"
																select="$seceduledate" />
														</xsl:call-template>
													</pd_sobt>
												</xsl:if>
												<xsl:if test="FlightIdentity">
													<pd_flightnumber>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="FlightIdentity" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_flightnumber>
												</xsl:if>
											</xsl:for-each>

											<xsl:for-each select="FlightData/General">
												<xsl:if test="Registration">
													<pd_registration>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">
																pl_turn.pt_pd_departure.pl_departure.pd_registration
															</xsl:with-param>
															<xsl:with-param name="sender" select="$owner" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="Registration" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_registration>
												</xsl:if>
												<xsl:if test="CallSign">
													<pd_callsign>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="CallSign" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_callsign>
												</xsl:if>
												<xsl:for-each select="AircraftType">
													<pd_ract_aircrafttype>
														<xsl:value-of select="AircraftIATACode" />
													</pd_ract_aircrafttype>
												</xsl:for-each>

												<xsl:if test="FlightServiceType">
													<pd_rstc_servicetypecode>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="FlightServiceType" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_rstc_servicetypecode>
												</xsl:if>

										
												<xsl:for-each select="FlightRoute">

													<xsl:if test="IATARoute/IATAFullRoute/AirportIATACode">

														<pl_routing_list>
															<xsl:for-each select="IATARoute/IATAFullRoute/AirportIATACode">
																<pl_routing>
																	<xsl:if test="position()=last()">
																		<prt_numberinleg>99</prt_numberinleg>
																	</xsl:if>
																	<xsl:if test="not(position()=last())">
																		<prt_numberinleg>
																			<xsl:value-of select="@LegNo" />
																		</prt_numberinleg>
																	</xsl:if>
																	<prt_rap_airport>
																		<xsl:value-of select="." />
																		<ref_airport>
																			<rap_iata3lc>
																				<xsl:value-of select="." />
																			</rap_iata3lc>
																		</ref_airport>
																	</prt_rap_airport>
																</pl_routing>
															</xsl:for-each>
														</pl_routing_list>

													</xsl:if>

													<xsl:for-each
														select="/IMFRoot/Data/FlightData/General/FlightRoute/IATARoute/IATANextAirport">
														<pd_rap_nextairport>
															<xsl:value-of select="." />
														</pd_rap_nextairport>
													</xsl:for-each>

													<xsl:for-each
														select="/IMFRoot/Data/FlightData/General/FlightRoute/IATARoute/IATADestinationAirport">
														<pd_rap_destinationairport>
															<xsl:value-of select="." />
														</pd_rap_destinationairport>
													</xsl:for-each>

												</xsl:for-each>

												<xsl:if test="SlaveFlight">
													<pl_departure_list>

														<xsl:for-each select="SlaveFlight">
															<pl_departure>
																<pd_flightnumber>
																	<xsl:value-of select="FlightIdentity" />
																</pd_flightnumber>
															</pl_departure>
														</xsl:for-each>

													</pl_departure_list>
												</xsl:if>

												<!--Add by zzhao 2013-06-20 2013-10-11 -->
												<xsl:if test="FreeTextComment/PublicTextComment">
													<pd_opscomment>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="FreeTextComment/PublicTextComment" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_opscomment>
												</xsl:if>
												<xsl:if test="FreeTextComment/CreateReason">
													<pd_createreason>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="FreeTextComment/CreateReason" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_createreason>
												</xsl:if>
											</xsl:for-each>

											<xsl:for-each select="FlightData/OperationalDateTime">
												<xsl:for-each select="OffBlockDateTime">
													<!--Add by zzhao 2013-09-23 -->
													<xsl:if test="ScheduledOffBlockDateTime">
														<pd_sobt>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">
																	pl_turn.pt_pd_departure.pl_departure.pd_sobt
																</xsl:with-param>
																<xsl:with-param name="sender" select="$owner" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="ScheduledOffBlockDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_sobt>
													</xsl:if>
													<xsl:if test="EstimatedOffBlockDateTime">
														<pd_eobtlocal>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">
																	pl_turn.pt_pd_departure.pl_departure.pd_eobtlocal
																</xsl:with-param>
																<xsl:with-param name="sender" select="$owner" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="EstimatedOffBlockDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_eobtlocal>
													</xsl:if>
													<xsl:if test="ActualOffBlockDateTime">
														<pd_aobt>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">
																	pl_turn.pt_pd_departure.pl_departure.pd_aobt
																</xsl:with-param>
																<xsl:with-param name="sender" select="$owner" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="ActualOffBlockDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_aobt>
													</xsl:if>
												</xsl:for-each>
												<xsl:for-each select="TakeOffDateTime">

													<!-- <xsl:if test="ScheduledTakeOffDateTime"> <pd_srtd> <xsl:call-template 
														name="xsltTemplate"> <xsl:with-param name="inElement" select="ScheduledTakeOffDateTime" 
														/> <xsl:with-param name="needAddNil" select="true()" /> </xsl:call-template> 
														</pd_srtd> </xsl:if> -->
													<xsl:if test="EstimatedTakeOffDateTime">
														<pd_etot>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">
																	pl_turn.pt_pd_departure.pl_departure.pd_etot
																</xsl:with-param>
																<xsl:with-param name="sender" select="$owner" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="EstimatedTakeOffDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_etot>
													</xsl:if>
													<xsl:if test="ActualTakeOffDateTime">
														<pd_atot>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">
																	pl_turn.pt_pd_departure.pl_departure.pd_atot
																</xsl:with-param>
																<xsl:with-param name="sender" select="$owner" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="ActualTakeOffDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_atot>
													</xsl:if>
												</xsl:for-each>
												<!--add by zzhao 2014-05-15 -->
												<xsl:for-each select="NextAirportArrivalDateTime">
													<xsl:if test="ActualNextAirportArrivalDateTime">
														<pd_aldtnext>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">
																	pl_turn.pt_pd_departure.pl_departure.pd_aldtnext
																</xsl:with-param>
																<xsl:with-param name="sender" select="$owner" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="ActualNextAirportArrivalDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_aldtnext>
													</xsl:if>
												</xsl:for-each>

												<xsl:for-each select="GroundHandleDateTime">
													<xsl:if test="ActualGroundHandleStartDateTime">
														<pd_acgt>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="ActualGroundHandleStartDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_acgt>
													</xsl:if>
													<xsl:if test="ActualGroundHandleEndDateTime">
														<pd_aegt>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="ActualGroundHandleEndDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_aegt>
													</xsl:if>
												</xsl:for-each>

												<!--Add by zzhao 2013-06-20 -->
												<xsl:if test="DoorCloseDateTime/ActualDoorCloseDateTime">
													<pd_doorclosetime>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="DoorCloseDateTime/ActualDoorCloseDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_doorclosetime>
												</xsl:if>
												<xsl:if test="OffBridgeDateTime/ActualOffBridgeDateTime">
													<pd_offbridge>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="OffBridgeDateTime/ActualOffBridgeDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_offbridge>
												</xsl:if>
											</xsl:for-each>

											<xsl:for-each select="FlightData/Status">

												<xsl:if test="OperationStatus">
													<pd_rrmk_remark>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">
																pl_turn.pt_pd_departure.pl_departure.pd_rrmk_remark
															</xsl:with-param>
															<xsl:with-param name="sender" select="$owner" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="OperationStatus" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_rrmk_remark>
												</xsl:if>
												<xsl:if test="FlightStatus">
													<pd_rfst_flightstatus>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="FlightStatus" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_rfst_flightstatus>
												</xsl:if>
												<!-- mod by zzhao 2014-02-26 -->
												<!-- <xsl:if test="IsCashFlight='Y'"> <pd_paymentmode>C</pd_paymentmode> 
													</xsl:if> -->
												<!--mod by zzhao 2013-10-14 -->
												<xsl:if test="DelayReason">
													<pl_delayreason_list>
														<xsl:for-each select="DelayReason">
															<pl_delayreason>
																<pdlr_rdlr_delayreason>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="DelayCode" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</pdlr_rdlr_delayreason>
															</pl_delayreason>
														</xsl:for-each>
													</pl_delayreason_list>
												</xsl:if>
												<xsl:if test="DisplayCode">
													<pd_displaycode>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="DisplayCode" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_displaycode>
												</xsl:if>
												<!-- add by zzhao 2014-02-26 -->
												<xsl:if test="IsVIPFlight">
													<pd_vipind>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="IsVIPFlight" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_vipind>
												</xsl:if>
												<xsl:if test="VIPComment">
													<pd_vipcomment>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="VIPComment" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_vipcomment>
												</xsl:if>
											</xsl:for-each>

											<xsl:if test="FlightData/Payload">
												<pl_departureloadstatistics_list>
													<xsl:for-each select="FlightData/Payload">
														<pl_departureloadstatistics>
															<!-- Add by zzhao 2013-06-20 -->
															<xsl:if test="DepartureAirport">
																<pdls_rap_airportfrom>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="DepartureAirport" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</pdls_rap_airportfrom>
															</xsl:if>
															<xsl:if test="DestinationAirport">
																<pdls_rap_airportto>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="DestinationAirport" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</pdls_rap_airportto>
															</xsl:if>
															<xsl:for-each select="Passenger">
																<xsl:for-each select="PassengersNumber">
																	<xsl:if test="TotalPassengersNumber">
																		<pdls_pax>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="TotalPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_pax>
																	</xsl:if>
																	<xsl:if test="FirstClassPassengersNumber">
																		<pdls_paxf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="FirstClassPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_paxf>
																	</xsl:if>
																	<xsl:if test="BusinessClassPassengersNumber">
																		<pdls_paxc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="BusinessClassPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_paxc>
																	</xsl:if>
																	<xsl:if test="EconomicClassPassengersNumber">
																		<pdls_paxy>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="EconomicClassPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_paxy>
																	</xsl:if>
																</xsl:for-each>
																<xsl:for-each select="AdultPassengers">
																	<xsl:if test="TotalAdultPassengersNumber">
																		<pdls_adult>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="TotalAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_adult>
																	</xsl:if>
																	<xsl:if test="FirstClassAdultPassengersNumber">
																		<pdls_adultf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="FirstClassAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_adultf>
																	</xsl:if>
																	<xsl:if test="BusinessClassAdultPassengersNumber">
																		<pdls_adultc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="BusinessClassAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_adultc>
																	</xsl:if>
																	<xsl:if test="EconomicClassAdultPassengersNumber">
																		<pdls_adulty>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="EconomicClassAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_adulty>
																	</xsl:if>
																</xsl:for-each>
																<xsl:for-each select="ChildPassengers">
																	<xsl:if test="TotalChildPassengersNumber">
																		<pdls_child>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="TotalChildPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_child>
																	</xsl:if>
																	<xsl:if test="FirstClassChildPassengersNumber">
																		<pdls_childf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="FirstClassChildPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_childf>
																	</xsl:if>
																	<xsl:if test="BusinessClassChildPassengersNumber">
																		<pdls_childc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="BusinessClassChildPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_childc>
																	</xsl:if>
																	<xsl:if test="EconomicClassChildPassengersNumber">
																		<pdls_childy>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="EconomicClassChildPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_childy>
																	</xsl:if>
																</xsl:for-each>
																<xsl:for-each select="InfantPassengers">
																	<xsl:if test="TotalInfantPassengersNumber">
																		<pdls_infant>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="TotalInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_infant>
																	</xsl:if>
																	<xsl:if test="FirstClassInfantPassengersNumber">
																		<pdls_infantf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="FirstClassInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_infantf>
																	</xsl:if>
																	<xsl:if test="BusinessClassInfantPassengersNumber">
																		<pdls_infantc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="BusinessClassInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_infantc>
																	</xsl:if>
																	<xsl:if test="EconomicClassInfantPassengersNumber">
																		<pdls_infanty>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement"
																					select="EconomicClassInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil"
																					select="true()" />
																			</xsl:call-template>
																		</pdls_infanty>
																	</xsl:if>
																</xsl:for-each>
															</xsl:for-each>
															<xsl:for-each select="Weight">
																<xsl:if test="TotalWeight">
																	<pdls_totalweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="TotalWeight" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdls_totalweight>
																</xsl:if>
																<xsl:if test="BaggageWeight">
																	<pdls_baggageweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="BaggageWeight" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdls_baggageweight>
																</xsl:if>
																<xsl:if test="CargoWeight">
																	<pdls_cargoweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="CargoWeight" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdls_cargoweight>
																</xsl:if>
																<xsl:if test="MailWeight">
																	<pdls_mailweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="MailWeight" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdls_mailweight>
																</xsl:if>
															</xsl:for-each>
														</pl_departureloadstatistics>
													</xsl:for-each>
												</pl_departureloadstatistics_list>
											</xsl:if>

											<xsl:for-each select="FlightData/Airport">
												<xsl:if test="Terminal/FlightTerminalID">
													<pd_rtrm_terminal>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="Terminal/FlightTerminalID" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_rtrm_terminal>
												</xsl:if>
												<xsl:if test="Runway/RunwayID">
													<pd_rrwy_runway>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="Runway/RunwayID" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_rrwy_runway>
												</xsl:if>

												<xsl:if test="BaggageMakeup">
													<pl_departurebelt_list>
														<xsl:for-each select="BaggageMakeup">
															<pl_departurebelt>
																<xsl:if test="BaggageBeltID">
																	<pdb_rdb_departurebelt>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="BaggageBeltID" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdb_rdb_departurebelt>
																</xsl:if>
																<xsl:if test="BaggageBeltStatus">
																	<pdb_status>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="BaggageBeltStatus" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdb_status>
																</xsl:if>
																<xsl:if test="ScheduledMakeupStartDateTime">
																	<pdb_beginplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ScheduledMakeupStartDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdb_beginplan>
																</xsl:if>
																<xsl:if test="ScheduledMakeupEndDateTime">
																	<pdb_endplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ScheduledMakeupEndDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdb_endplan>
																</xsl:if>
																<xsl:if test="ActualMakeupStartDateTime">
																	<pdb_beginactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ActualMakeupStartDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdb_beginactual>
																</xsl:if>
																<xsl:if test="ActualMakeupEndDateTime">
																	<pdb_endactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ActualMakeupEndDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdb_endactual>
																</xsl:if>
															</pl_departurebelt>
														</xsl:for-each>
													</pl_departurebelt_list>
												</xsl:if>

												<xsl:if test="Gate">
													<xsl:if test="Gate/BoardingStartDateTime[1]">
														<pd_gotogate>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="Gate/BoardingStartDateTime[1]" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_gotogate>
													</xsl:if>
													<xsl:if test="Gate/LastCallDateTime[1]">
														<pd_secondcall>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="Gate/LastCallDateTime[1]" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_secondcall>
													</xsl:if>
													<xsl:if test="Gate/BoardingEndDateTime[1]">
														<pd_aebt>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement"
																	select="Gate/BoardingEndDateTime[1]" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_aebt>
													</xsl:if>

													<pl_departuregate_list>
														<xsl:for-each select="Gate">
															<pl_departuregate>
																<xsl:if test="GateID">
																	<pdg_rgt_gate>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="GateID" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdg_rgt_gate>
																</xsl:if>
																<!--<xsl:if test="GateStatus"> <pdg_status> <xsl:call-template 
																	name="xsltTemplate"> <xsl:with-param name="inElement" select="GateStatus" 
																	/> <xsl:with-param name="needAddNil" select="true()" /> </xsl:call-template> 
																	</pdg_status> </xsl:if> Steven Commented 2013/12/10 -->
																<!--mod by zzhao 2014-03-24 -->
																<xsl:if test="ScheduledGateStartDateTime">
																	<pdg_begingateplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ScheduledGateStartDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdg_begingateplan>
																</xsl:if>
																<xsl:if test="ScheduledGateEndDateTime">
																	<pdg_endplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ScheduledGateEndDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdg_endplan>
																</xsl:if>
																<xsl:if test="ActualGateStartDateTime">
																	<pdg_begingateactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ActualGateStartDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdg_begingateactual>
																</xsl:if>
																<xsl:if test="ActualGateEndDateTime">
																	<pdg_endactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ActualGateEndDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdg_endactual>
																</xsl:if>
															</pl_departuregate>
														</xsl:for-each>
													</pl_departuregate_list>
												</xsl:if>

												<xsl:if test="CheckInDesk">
													<pl_desk_list>
														<xsl:for-each select="CheckInDesk">
															<pl_desk>
																<xsl:if test="CheckInDeskID">
																	<pdk_rcnt_counter>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="CheckInDeskID" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdk_rcnt_counter>
																</xsl:if>
																<!--mod by zzhao 2014-03-04 <xsl:if test="CheckInType"> <pdk_cciind> 
																	<xsl:call-template name="xsltTemplate"> <xsl:with-param name="inElement" 
																	select="CheckInType" /> <xsl:with-param name="needAddNil" select="true()" 
																	/> </xsl:call-template> </pdk_cciind> </xsl:if> -->
																<xsl:if test="CheckInStatus">
																	<pdk_status>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="CheckInStatus" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdk_status>
																</xsl:if>
																<xsl:if test="CheckInClassService">
																	<pdk_checkinclassid>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="CheckInClassService" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdk_checkinclassid>
																</xsl:if>
																<xsl:if test="ScheduledCheckInBeginDateTime">
																	<pdk_beginplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ScheduledCheckInBeginDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdk_beginplan>
																</xsl:if>
																<xsl:if test="ScheduledCheckInEndDateTime">
																	<pdk_endplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ScheduledCheckInEndDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdk_endplan>
																</xsl:if>
																<xsl:if test="ActualCheckInBeginDateTime">
																	<pdk_beginactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ActualCheckInBeginDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdk_beginactual>
																</xsl:if>
																<xsl:if test="ActualCheckInEndDateTime">
																	<pdk_endactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement"
																				select="ActualCheckInEndDateTime" />
																			<xsl:with-param name="needAddNil"
																				select="true()" />
																		</xsl:call-template>
																	</pdk_endactual>
																</xsl:if>
															</pl_desk>
														</xsl:for-each>
													</pl_desk_list>
												</xsl:if>

												<!--add mapping for PassengerStatus 2013-11-26 -->
												<xsl:for-each select="PassengerStatus">
													<pl_departureaddinfo_list>
														<pl_departureaddinfo>
															<xsl:if test="CheckInPassengerCount">
																<pdai_actualcheckedin>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="CheckInPassengerCount" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</pdai_actualcheckedin>
															</xsl:if>
															<xsl:if test="SecurityCheckPassengerCount">
																<pdai_actualsecurity>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="SecurityCheckPassengerCount" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</pdai_actualsecurity>
															</xsl:if>
															<xsl:if test="OnboardPassengerCount">
																<pdai_actualboarding>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="OnboardPassengerCount" />
																		<xsl:with-param name="needAddNil"
																			select="true()" />
																	</xsl:call-template>
																</pdai_actualboarding>
															</xsl:if>
														</pl_departureaddinfo>
													</pl_departureaddinfo_list>
												</xsl:for-each>
												<xsl:if test="Gate/ActualGateStartDateTime">
													<pd_asbt>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="Gate/ActualGateStartDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_asbt>
												</xsl:if>
											</xsl:for-each>
										</pl_departure>
									</pt_pd_departure>

									<xsl:for-each select="FlightData/Airport">
										<xsl:if test="Stand">
											<pl_stand_list>
												<xsl:for-each select="Stand">
													<pl_stand>
														<xsl:if test="StandID">
															<pst_rsta_stand>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="StandID" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</pst_rsta_stand>
														</xsl:if>
														<xsl:if test="ScheduledStandStartDateTime">
															<pst_beginplan>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="ScheduledStandStartDateTime" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</pst_beginplan>
														</xsl:if>
														<xsl:if test="ScheduledStandEndDateTime">
															<pst_endplan>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="ScheduledStandEndDateTime" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</pst_endplan>
														</xsl:if>
														<xsl:if test="ActualStandStartDateTime">
															<pst_beginactual>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="ActualStandStartDateTime" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</pst_beginactual>
														</xsl:if>
														<xsl:if test="ActualStandEndDateTime">
															<pst_endactual>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="ActualStandEndDateTime" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</pst_endactual>
														</xsl:if>
													</pl_stand>
												</xsl:for-each>
											</pl_stand_list>
										</xsl:if>
									</xsl:for-each>
								</xsl:if>
							</pl_turn>
						</xsl:if>
					</xsl:for-each>
				</soap-env:Body>
			</xsl:if>
		</soap-env:Envelope>
	</xsl:template>
	<xsl:template name="xsltTemplate">
		<xsl:param name="inElement" />
		<xsl:param name="needAddNil" />
		<xsl:if test="$inElement/@OldValue">
			<xsl:attribute name="old">
        <xsl:value-of select="$inElement/@OldValue" />
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

	<xsl:template name="flightScheduleDateTimeTemplate">
		<xsl:param name="scheduleDatetime" />
		<xsl:param name="seceduledate" />
		<xsl:choose>
			<xsl:when test="$scheduleDatetime">
				<xsl:value-of select="$scheduleDatetime" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($seceduledate,'T00:00:00')" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="addPriority">
		<xsl:param name="key" />
		<xsl:param name="sender" />
		<xsl:attribute name="priority">
      <xsl:value-of select="javacode:getPriority($key, $sender)" />
    </xsl:attribute>
	</xsl:template>
</xsl:stylesheet>