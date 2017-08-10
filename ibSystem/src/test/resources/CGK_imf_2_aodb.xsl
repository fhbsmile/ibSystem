<!--
	Version 2.0n 2014-06-30 mod by zzhao update node mapping of "DepartureAirport" and "DestinationAirport";
	Version 2.0m 2014-05-27 mod by zzhao add node mapping of "CreateReason";
	Version 2.0l 2014-05-22 mod by zzhao add node mapping of "FlyTime/EstimatedFlyTime" and add mapping of node "pd_asbt";
	Version 2.0k 2014-05-19 mod by zzhao change mapping rule of "EstimatedOffBlockDateTime" from "pd_eobt" to "pd_eobtlocal" and "ActualOffBlockDateTime" from 
	"pd_eobtlocal" to "pd_aobt";
	Version 2.0j 2014-05-16 mod by zzhao change mapping rule of node "ScheduledPreviousAirportDepartureDateTime" and node "EstimatedPreviousAirportDepartureDateTime"
	Version 2.0i 2014-05-15 mod by zzhao add node of "ActualNextAirportArrivalDateTime";
	Version 2.0h 2014-05-08 mod by zzhao add node mapping of "ScheduledPreviousAirportDepartureDateTime" and "EstimatedPreviousAirportDepartureDateTime".
	Version 2.0g 2014-04-30 mod by zzhao "EstimatedOffBlockDateTime" mapping node change from "pd_eobtlocal" to "pd_eobt";
	"ActualOffBlockDateTime" mapping node change from "pd_aobt" to "pd_eobtlocal"; "FlightData.OperationalDateTime.GoundHandlelDateTime.ActualGoundHandleStartDateTime" 
	change to "pl_turn.pt_pd_departure.pl_departure.pd_acgt";
	"FlightData.OperationalDateTime.GoundHandlelDateTime.ActualGoundHandleEndDateTime" change to "pl_turn.pt_pd_departure.pl_departure.pd_aegt";
	Version 2.0f 2014-03-24 mod by zzhao fix bug on "FlightDirection" when do datasetquery mapping
	Version 2.0e 2014-02-26 mod by zzhao
	add node "ActualGroundHandleStartDateTime", "ActualGroundHandleEndDateTime", "IsVIPFlight", "VIPComment" and remove node "IsCashFlight";
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:javacode="com.tsystems.si.aviation.imf.ibSystem.message.XsltUtil" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:aodb="urn:com.tsystems.ac.aodb"
	exclude-result-prefixes="javacode" version="1.0">
	<xsl:output method="xml" indent="yes" />
	<xsl:template match="/">
		<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:aodb="urn:com.tsystems.ac.aodb"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:variable name="originalDate" select="IMFRoot/SysInfo/OriginalDateTime"></xsl:variable>
			<xsl:variable name="synstarttime" select="IMFRoot/Operation/Subscription/SyncPeriodRequest/SyncUpdateFromDateTime" />
			<!--
				<xsl:variable name="synendtime"
				select="IMFRoot/Operation/Subscription/SyncPeriodRequest/SyncUpdateEndDateTime" />
			-->
      <xsl:variable name="messageid" select="IMFRoot/SysInfo/MessageSequenceID" />
			<xsl:variable name="schstarttime" select="IMFRoot/Operation/Subscription/FlightPeriodRequest/FlightScheduleFromDateTime" />
			<xsl:variable name="schendtime" select="IMFRoot/Operation/Subscription/FlightPeriodRequest/FlightScheduleEndDateTime" />
			<xsl:variable name="sender" select="IMFRoot/SysInfo/Sender" />
			<xsl:variable name="st" select="IMFRoot/SysInfo/ServiceType" />
			<xsl:variable name="operaMode" select="IMFRoot/SysInfo/OperationMode" />
      <xsl:variable name="stotstation" select="IMFRoot/Data/FlightData/OperationalDateTime/PreviousAirportDepartureDateTime/ScheduledPreviousAirportDepartureDateTime" />
			<soap-env:Header>
				<aodb:control>
					<xsl:for-each select="IMFRoot/SysInfo">
						<aodb:message-id>
							<xsl:value-of select="$messageid" />
						</aodb:message-id>
						<aodb:message-version>1.4</aodb:message-version>
						<xsl:if test="(ServiceType='FSS1' or ServiceType='BSS1' or ServiceType='RSS1' or ServiceType='GSS1') and ../Operation/Subscription ">
							<aodb:message-type>SUBSCRIBE</aodb:message-type>
						</xsl:if>
						<xsl:if test="(ServiceType='FSS1'  or ServiceType='BSS1' or ServiceType='RSS1' or ServiceType='GSS1') and ../Operation/Unsubscription">
							<aodb:message-type>UNSUBSCRIBE</aodb:message-type>
						</xsl:if>
						<xsl:if test="ServiceType='FSS2' or ServiceType='BSS2' or ServiceType='RSS2' or ServiceType='GSS2'">
							<aodb:message-type>DATASET</aodb:message-type>
						</xsl:if>
						<xsl:if test="ServiceType='FUS' or ServiceType='RUS' or ServiceType='GUS' or ServiceType='FRS'">
							<aodb:message-type>UPDATE</aodb:message-type>
						</xsl:if>
						<xsl:if test="ServiceType!='FRS'">
							<aodb:request>
								<xsl:if test="ServiceType='FSS1' or ServiceType='FSS2' or ServiceType='FUS'">
									<aodb:datatype>pl_turn</aodb:datatype>
								</xsl:if>
								<xsl:if test="ServiceType='BSS1' or ServiceType='BSS2'">
									<aodb:datatype>BSSDATATYPE</aodb:datatype>
								</xsl:if>
								<xsl:if test="ServiceType='RSS1' or ServiceType='RSS2'">
									<aodb:datatype>RSSDATATYPE</aodb:datatype>
								</xsl:if>
								<xsl:if test="ServiceType='RUS'">
									<aodb:datatype>rm_closing</aodb:datatype>
								</xsl:if>
								<xsl:if test="ServiceType='GSS1' or ServiceType='GSS2' or ServiceType='GUS'">
									<aodb:datatype>GSSDATATYPE</aodb:datatype>
									<!--<aodb:modification-start-time> <xsl:apply-templates select="IMFRoot/SysInfo/SendDateTime"
										/> </aodb:modification-start-time> -->
								</xsl:if>
								<xsl:if test="../Operation/Subscription/SyncPeriodRequest/SyncUpdateFromDateTime">
									<aodb:modification-start-time>
										<xsl:value-of select="$synstarttime" />
									</aodb:modification-start-time>
								</xsl:if>
								<xsl:if test="../Operation/Subscription/FlightPeriodRequest/FlightScheduleFromDateTime">
									<aodb:start-time>
										<xsl:value-of select="$schstarttime" />
									</aodb:start-time>
								</xsl:if>
								<xsl:if test="../Operation/Subscription/FlightPeriodRequest/FlightScheduleEndDateTime">
									<aodb:end-time>
										<xsl:value-of select="$schendtime" />
									</aodb:end-time>
								</xsl:if>
								<!-- mod by zzhao 2013-03-24 -->
								<xsl:if test="ServiceType='FSS2'">
									<aodb:datasetquery>
										<xsl:if test="../Data/FlightData/Airport/Terminal/FlightTerminalID">
											<xsl:variable name="terminalId" select="../Data/FlightData/Airport/Terminal/FlightTerminalID"></xsl:variable>
											<xsl:variable name="terminalPrefix">
												pl_arrival.pa_rtrm_terminal,pl_departure.pd_rtrm_terminal
											</xsl:variable>
											<xsl:variable name="tidCondition" select="javacode:buildRequestFilter($terminalId, $terminalPrefix)" />
											<xsl:value-of select="$tidCondition" />
											and
										</xsl:if>
										<xsl:if test="../Data/PrimaryKey/FlightKey/DetailedIdentity/AirlineIATACode">
											<xsl:variable name="iataCode" select="../Data/PrimaryKey/FlightKey/DetailedIdentity/AirlineIATACode"></xsl:variable>
											<xsl:variable name="iataPrefix">
												pl_arrival.pa_ral_airline,pl_departure.pd_ral_airline
											</xsl:variable>
											<xsl:variable name="iataCondition" select="javacode:buildRequestFilter($iataCode, $iataPrefix)" />
											<xsl:value-of select="$iataCondition" />
											and
										</xsl:if>
										<xsl:if test="../Data/PrimaryKey/FlightKey/FlightDirection">
											<xsl:variable name="direction" select="../Data/PrimaryKey/FlightKey/FlightDirection"></xsl:variable>
											<xsl:if test="$direction='A'">
												pl_arrival.pa_ral_airline is not null
											</xsl:if>
											<xsl:if test="$direction='D'">
												pl_departure.pd_ral_airline is not null
											</xsl:if>
											and
										</xsl:if>
										<xsl:if test="../Data/FlightData/General/FlightServiceType">
											<xsl:variable name="fst" select="../Data/FlightData/General/FlightServiceType/FlightIATAServiceType"></xsl:variable>
											<xsl:variable name="stPrefix">
												pl_arrival.pa_rstc_servicetypecode,pl_departure.pd_rstc_servicetypecode
											</xsl:variable>
											<xsl:variable name="stCondition" select="javacode:buildRequestFilter($fst, $stPrefix)" />
											<xsl:value-of select="$stCondition" />
											and
										</xsl:if>
										(1 = 1)
									</aodb:datasetquery>
								</xsl:if>
							</aodb:request>
						</xsl:if>
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
				<xsl:if test="IMFRoot/Data and $st!='FSS1' and $st!='FSS2' and $st!='RSS1' and $st!='RSS2'">
					<xsl:variable name="arrivalOrDepature" select="IMFRoot/Data/PrimaryKey/FlightKey/FlightDirection"></xsl:variable>
					<xsl:for-each select="IMFRoot/Data">
						<xsl:if test="PrimaryKey/FlightKey">
							<pl_turn>
								<xsl:call-template name="actionMode">
									<xsl:with-param name="operationMode" select="$operaMode" />
								</xsl:call-template>
								<xsl:if test="$arrivalOrDepature='Arrival' or $arrivalOrDepature='A' ">
									<pt_pa_arrival>
										<!--update by zzhao 2013-08-27 -->
										<pl_arrival>
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
															<xsl:with-param name="scheduleDatetime" select="../../FlightData/General/FlightScheduledDateTime" />
															<xsl:with-param name="seceduledate" select="$seceduledate" />
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
												<xsl:if test="Registration">
													<pa_registration>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">pl_turn.pt_pa_arrival.pl_arrival.pa_registration</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
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
												<xsl:if test="FlightServiceType">
													<pa_rstc_servicetypecode>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="FlightServiceType/FlightIATAServiceType" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_rstc_servicetypecode>
												</xsl:if>
												<xsl:for-each select="FlightRoute">
													<xsl:if test="IATARoute/IATAOriginAirport">
														<pa_rap_originairport>
															<xsl:value-of select="IATARoute/IATAOriginAirport" />
														</pa_rap_originairport>
													</xsl:if>
													<xsl:if test="IATARoute/IATAPreviousAirport" >
														<pa_rap_previousairport>
															<xsl:value-of select="IATARoute/IATAPreviousAirport" />
														</pa_rap_previousairport>
													</xsl:if>
	                           <xsl:variable name="countRoute" select="count(IATARoute/IATAFullRoute/AirportIATACode)" />
													<xsl:if test="IATARoute/IATAFullRoute/AirportIATACode">														
														<pl_routing_list>
														 <xsl:for-each select="IATARoute/IATAFullRoute/AirportIATACode">
														   <pl_routing>
														      <prt_numberinleg><xsl:value-of select="@LegNo"/></prt_numberinleg>
														       <prt_rap_airport><xsl:value-of select="." /></prt_rap_airport>															   
															   <!--Steven Edit-->
															   <xsl:if test="position()=$countRoute">
																   <prt_stdstation><xsl:value-of select="$stotstation" /></prt_stdstation>
															  </xsl:if>
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
												<!--add by zzhao 2013-10-11 -->
												<xsl:if test="FreeTextComment/PublicTextComment">
													<pa_opscomment>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="FreeTextComment/PublicTextComment" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_opscomment>
												</xsl:if>
												<xsl:if test="FreeTextComment/CreateReason">
													<pa_createreason>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="FreeTextComment/CreateReason" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_createreason>
												</xsl:if>
											</xsl:for-each>
											<xsl:for-each select="FlightData/OperationalDateTime">
												<!--add by zzhao 2014-05-08 -->
												<xsl:if test="PreviousAirportDepartureDateTime/ScheduledPreviousAirportDepartureDateTime">
													<pa_stotoutstation>
                            <!--
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">pl_turn.pt_pa_arrival.pl_arrival.pa_stotoutstation
															</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
														</xsl:call-template>
                            -->
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="PreviousAirportDepartureDateTime/ScheduledPreviousAirportDepartureDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_stotoutstation>
												</xsl:if>
												<xsl:if test="PreviousAirportDepartureDateTime/EstimatedPreviousAirportDepartureDateTime">
													<pa_etotoutstation>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">pl_turn.pt_pa_arrival.pl_arrival.pa_etotoutstation</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="PreviousAirportDepartureDateTime/EstimatedPreviousAirportDepartureDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_etotoutstation>
												</xsl:if>
												<xsl:if test="PreviousAirportDepartureDateTime/ActualPreviousAirportDepartureDateTime">
													<pa_atotoutstation>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">pl_turn.pt_pa_arrival.pl_arrival.pa_atotoutstation</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="PreviousAirportDepartureDateTime/ActualPreviousAirportDepartureDateTime" />
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
                        <xsl:if test="FinalApproachTime">
													<pa_firt>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="FinalApproachTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_firt>
												</xsl:if>
												<!--Add by zzhao 2013-06-20 -->
												<xsl:if test="LandingDateTime/EstimatedLandingDateTime">
													<pa_eldt>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">pl_turn.pt_pa_arrival.pl_arrival.pa_eldt</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="LandingDateTime/EstimatedLandingDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_eldt>
												</xsl:if>
                        <xsl:if test="LandingDateTime/TargetLandingDateTime">
													<pa_tldt>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">pl_turn.pt_pa_arrival.pl_arrival.pa_tldt</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="LandingDateTime/TargetLandingDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_tldt>
												</xsl:if>
												<xsl:if test="LandingDateTime/ActualLandingDateTime">
													<pa_aldt>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">pl_turn.pt_pa_arrival.pl_arrival.pa_aldt</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="LandingDateTime/ActualLandingDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_aldt>
												</xsl:if>
												<!--Add by zzhao 2013-09-23 -->
												<xsl:if test="OnBlockDateTime/ScheduledOnBlockDateTime">
													<pa_sibt>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">pl_turn.pt_pa_arrival.pl_arrival.pa_sibt</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="OnBlockDateTime/ScheduledOnBlockDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_sibt>
												</xsl:if>
												<xsl:if test="OnBlockDateTime/EstimatedOnBlockDateTime">
													<pa_eibt>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">pl_turn.pt_pa_arrival.pl_arrival.pa_eibt</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="OnBlockDateTime/EstimatedOnBlockDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_eibt>
												</xsl:if>
												<xsl:if test="OnBlockDateTime/ActualOnBlockDateTime">
													<pa_aibt>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">pl_turn.pt_pa_arrival.pl_arrival.pa_aibt</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="OnBlockDateTime/ActualOnBlockDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_aibt>
												</xsl:if>
												<!--Add by zzhao 2014-05-22 -->
												<xsl:if test="FlyTime/EstimatedFlyTime">
													<pa_eflt>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">pl_turn.pt_pa_arrival.pl_arrival.pa_eflt</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
														</xsl:call-template>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="FlyTime/EstimatedFlyTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_eflt>
												</xsl:if>
												<!--Add by zzhao 2013-06-20 -->
												<xsl:if test="DoorOpenDateTime/ActualDoorOpenDateTime">
													<pa_dooropentime>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="DoorOpenDateTime/ActualDoorOpenDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_dooropentime>
												</xsl:if>
												<xsl:if test="OnBridgeDateTime/ActualOnBridgeDateTime">
													<pa_onbridge>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="OnBridgeDateTime/ActualOnBridgeDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pa_onbridge>
												</xsl:if>
											</xsl:for-each>
											<xsl:for-each select="FlightData/Status">
												<!--mod by zzhao 2013-10-14 -->
												<xsl:if test="DelayReason">
													<pl_delayreason_list>
														<xsl:for-each select="DelayReason">
															<pl_delayreason>
																<pdlr_rdlr_delayreason>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="DelayCode" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pdlr_rdlr_delayreason>
															</pl_delayreason>
														</xsl:for-each>
													</pl_delayreason_list>
												</xsl:if>
												<xsl:if test="OperationStatus">
													<pa_rrmk_remark>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">pl_turn.pt_pa_arrival.pl_arrival.pa_rrmk_remark</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
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
																		<xsl:with-param name="inElement" select="DepartureAirport" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pals_rap_airportfrom>
															</xsl:if>
															<xsl:if test="DestinationAirport">
																<pals_rap_airportto>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="DestinationAirport" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pals_rap_airportto>
															</xsl:if>
															<xsl:for-each select="Passenger">
																<xsl:for-each select="PassengersNumber">
																	<xsl:if test="TotalPassengersNumber">
																		<pals_pax>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="TotalPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_pax>
																	</xsl:if>
																	<xsl:if test="FirstClassPassengersNumber">
																		<pals_paxf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="FirstClassPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_paxf>
																	</xsl:if>
																	<xsl:if test="BusinessClassPassengersNumber">
																		<pals_paxc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="BusinessClassPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_paxc>
																	</xsl:if>
																	<xsl:if test="EconomicClassPassengersNumber">
																		<pals_paxy>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="EconomicClassPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_paxy>
																	</xsl:if>
																</xsl:for-each>
																<xsl:for-each select="AdultPassengers">
																	<xsl:if test="TotalAdultPassengersNumber">
																		<pals_adult>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="TotalAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_adult>
																	</xsl:if>
																	<xsl:if test="FirstClassAdultPassengersNumber">
																		<pals_adultf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="FirstClassAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_adultf>
																	</xsl:if>
																	<xsl:if test="BusinessClassAdultPassengersNumber">
																		<pals_adultc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="BusinessClassAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_adultc>
																	</xsl:if>
																	<xsl:if test="EconomicClassAdultPassengersNumber">
																		<pals_adulty>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="EconomicClassAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_adulty>
																	</xsl:if>
																</xsl:for-each>
																<xsl:for-each select="ChildPassengers">
																	<xsl:if test="TotalChildPassengersNumber">
																		<pals_child>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="TotalChildPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_child>
																	</xsl:if>
																	<xsl:if test="FirstClassChildPassengersNumber">
																		<pals_childf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="FirstClassChildPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_childf>
																	</xsl:if>
																	<xsl:if test="BusinessClassChildPassengersNumber">
																		<pals_childc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="BusinessClassChildPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_childc>
																	</xsl:if>
																	<xsl:if test="EconomicClassChildPassengersNumber">
																		<pals_childy>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="EconomicClassChildPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_childy>
																	</xsl:if>
																</xsl:for-each>
																<xsl:for-each select="InfantPassengers">
																	<xsl:if test="TotalInfantPassengersNumber">
																		<pals_infant>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="TotalInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_infant>
																	</xsl:if>
																	<xsl:if test="FirstClassInfantPassengersNumber">
																		<pals_infantf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="FirstClassInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_infantf>
																	</xsl:if>
																	<xsl:if test="BusinessClassInfantPassengersNumber">
																		<pals_infantc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="BusinessClassInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_infantc>
																	</xsl:if>
																	<xsl:if test="EconomicClassInfantPassengersNumber">
																		<pals_infanty>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="EconomicClassInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pals_infanty>
																	</xsl:if>
																</xsl:for-each>
															</xsl:for-each>
															<xsl:for-each select="Weight">
																<xsl:if test="TotalWeight">
																	<pals_totalweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="TotalWeight" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pals_totalweight>
																</xsl:if>
																<xsl:if test="BaggageWeight">
																	<pals_baggageweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="BaggageWeight" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pals_baggageweight>
																</xsl:if>
																<xsl:if test="CargoWeight">
																	<pals_cargoweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="CargoWeight" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pals_cargoweight>
																</xsl:if>
																<xsl:if test="MailWeight">
																	<pals_mailweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="MailWeight" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pals_mailweight>
																</xsl:if>
															</xsl:for-each>
															<!-- redundant node mapping, please refer to mapping of pals_rap_airportfrom above -->
															<!--
																<pals_rap_airportfrom xsi:nil="true" />
																<pals_rap_airportto xsi:nil="true" />
															-->
														</pl_arrivalloadstatistics>
													</xsl:for-each>
												</pl_arrivalloadstatistics_list>
											</xsl:if>
											<xsl:for-each select="FlightData/Airport">
												<xsl:if test="Terminal/FlightTerminalID">
													<pa_rtrm_terminal>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="Terminal/FlightTerminalID" />
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
																			<xsl:with-param name="inElement" select="GateID" />
																			<xsl:with-param name="needAddNil" select="false()" />
																		</xsl:call-template>
																	</pag_rgt_gate>
																</xsl:if>
																<xsl:if test="ScheduledGateStartDateTime">
																	<pag_beginplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ScheduledGateStartDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pag_beginplan>
																</xsl:if>
																<xsl:if test="ScheduledGateEndDateTime">
																	<pag_endplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ScheduledGateEndDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pag_endplan>
																</xsl:if>
																<xsl:if test="ActualGateStartDateTime">
																	<pag_beginactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ActualGateStartDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pag_beginactual>
																</xsl:if>
																<xsl:if test="ActualGateEndDateTime">
																	<pag_endactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ActualGateEndDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
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
																			<xsl:with-param name="inElement" select="BaggageReclaimID" />
																			<xsl:with-param name="needAddNil" select="false()" />
																		</xsl:call-template>
																	</pbb_rbb_baggagebelt>
																</xsl:if>
																<xsl:if test="ScheduledReclaimStartDateTime">
																	<pbb_beginplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ScheduledReclaimStartDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pbb_beginplan>
																</xsl:if>
																<xsl:if test="ScheduledReclaimEndDateTime">
																	<pbb_endplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ScheduledReclaimEndDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pbb_endplan>
																</xsl:if>
																<xsl:if test="ActualReclaimStartDateTime">
																	<pbb_beginactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ActualReclaimStartDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pbb_beginactual>
																</xsl:if>
																<xsl:if test="ActualReclaimEndDateTime">
																	<pbb_endactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ActualReclaimEndDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pbb_endactual>
																</xsl:if>
																<xsl:if test="FirstBaggageDateTime">
																	<pbb_firstbag>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="FirstBaggageDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pbb_firstbag>
																</xsl:if>
																<xsl:if test="LastBaggageDateTime">
																	<pbb_lastbag>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="LastBaggageDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pbb_lastbag>
																</xsl:if>
															</pl_baggagebelt>
														</xsl:for-each>
													</pl_baggagebelt_list>
												</xsl:if>
                        <!--add mapping for PassengerAmount 2017-7-31 -->
												<xsl:for-each select="PassengerAmount">
															<xsl:if test="TotalPassengers">
																<pa_toatlpax>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="TotalPassengers" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pa_toatlpax>
															</xsl:if>
															<xsl:if test="TransferPassengers">
																<pa_transferpax>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="TransferPassengers" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pa_transferpax>
															</xsl:if>
															<xsl:if test="TransitPassengers">
																<pa_transitpax>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="TransitPassengers" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pa_transitpax>
															</xsl:if>
															<xsl:if test="TotalCrews">
																<pa_totalcrew>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="TotalCrews" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pa_totalcrew>
															</xsl:if>
                        			<xsl:if test="TotalExtraCrews">
																<pa_totalextracrew>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="TotalExtraCrews" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pa_totalextracrew>
															</xsl:if>
												</xsl:for-each>
                       <xsl:if test="Stand/StandID">
									       <pa_rsta_stand>
										       <xsl:value-of select="."/>
										     </pa_rsta_stand>
									    </xsl:if>
											</xsl:for-each>
                    
                    	
										</pl_arrival>
									</pt_pa_arrival>
									<xsl:for-each select="FlightData/Airport">
					
									 <xsl:if test="GroundMovement">
										<pl_stand_list>
										  <xsl:for-each select="GroundMovement">
											<pl_stand>
												<xsl:if test="StandID">
													<pst_rsta_stand>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="StandID" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pst_rsta_stand>
												</xsl:if>
												<xsl:if test="ScheduledStandStartDateTime">
													<pst_beginplan>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="ScheduledStandStartDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pst_beginplan>
												</xsl:if>
												<xsl:if test="ScheduledStandEndDateTime">
													<pst_endplan>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="ScheduledStandEndDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pst_endplan>
												</xsl:if>
												<xsl:if test="ActualStandStartDateTime">
													<pst_beginactual>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="ActualStandStartDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pst_beginactual>
												</xsl:if>
												<xsl:if test="ActualStandEndDateTime">
													<pst_endactual>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="ActualStandEndDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pst_endactual>
												</xsl:if>
											</pl_stand>
											</xsl:for-each>
										</pl_stand_list>
										</xsl:if>
									</xsl:for-each>
								</xsl:if>
								<xsl:if test="$arrivalOrDepature='Departure' or $arrivalOrDepature='D' ">
									<pt_pd_departure>
										<!--update by zzhao 2013-08-27 -->
										<pl_departure>
											<xsl:for-each select="PrimaryKey/FlightKey">
												<!-- mod by zzhao 2013-10-11 -->
												<xsl:if test="FlightScheduledDate">
													<pd_srtd>
														<xsl:variable name="seceduledate" select="FlightScheduledDate" />
														<xsl:if test="FlightScheduledDate/@old">
															<xsl:attribute name="OldValue">
                                <xsl:value-of select="FlightScheduledDate/@old" />
                              </xsl:attribute>
														</xsl:if>
														<xsl:call-template name="flightScheduleDateTimeTemplate">
															<xsl:with-param name="scheduleDatetime" select="../../FlightData/General/FlightScheduledDateTime" />
															<xsl:with-param name="seceduledate" select="$seceduledate" />
														</xsl:call-template>
													</pd_srtd>
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
															<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_registration
															</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
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
															<xsl:with-param name="inElement" select="FlightServiceType/FlightIATAServiceType" />
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
															     <prt_numberinleg><xsl:value-of select="@LegNo"/></prt_numberinleg>
															    </xsl:if>
														       <prt_rap_airport><xsl:value-of select="." /></prt_rap_airport>
														   </pl_routing>
														   </xsl:for-each>
														</pl_routing_list>
													    														
													</xsl:if>
													
													<xsl:for-each select="/IMFRoot/Data/FlightData/General/FlightRoute/IATARoute/IATANextAirport">
														<pd_rap_nextairport>
															<xsl:value-of select="." />														
														</pd_rap_nextairport>
													 </xsl:for-each>
												
													<xsl:for-each select="/IMFRoot/Data/FlightData/General/FlightRoute/IATARoute/IATADestinationAirport">
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
															<xsl:with-param name="inElement" select="FreeTextComment/PublicTextComment" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_opscomment>
												</xsl:if>
												<xsl:if test="FreeTextComment/CreateReason">
													<pd_createreason>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="FreeTextComment/CreateReason" />
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
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_sobt
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="ScheduledOffBlockDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_sobt>
													</xsl:if>
													<xsl:if test="EstimatedOffBlockDateTime">
														<pd_eobt>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_eobt
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="EstimatedOffBlockDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_eobt>
													</xsl:if>
                          	<xsl:if test="EstimatedOffBlockDateTimeLocal">
														<pd_eobtlocal>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_eobtlocal
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="EstimatedOffBlockDateTimeLocal" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_eobtlocal>
													</xsl:if>
                          <xsl:if test="EstimatedOffBlockDateTimeATC">
														<pd_eobtatc>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_eobtatc
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="EstimatedOffBlockDateTimeATC" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_eobtatc>
													</xsl:if>
                         <xsl:if test="TargetOffBlockDateTime">
														<pd_tobt>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_tobt
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="TargetOffBlockDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_tobt>
													</xsl:if>
													<xsl:if test="ActualOffBlockDateTime">
														<pd_aobt>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_aobt
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="ActualOffBlockDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_aobt>
													</xsl:if>
												</xsl:for-each>
                        <xsl:for-each select="StartupDateTime">
													<xsl:if test="TargetStartupApprovedDateTime">
														<pd_tsat>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_tsat
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="TargetStartupApprovedDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_tsat>
													</xsl:if>
                          <xsl:if test="ActualStartupRequestDateTime">
														<pd_asrt>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_asrt
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="ActualStartupRequestDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_asrt>
													</xsl:if>
                          <xsl:if test="ActualStartupApprovedDateTime">
														<pd_asat>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_asat
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="ActualStartupApprovedDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_asat>
													</xsl:if>
												</xsl:for-each>
												<xsl:for-each select="TakeOffDateTime">
													<xsl:if test="EstimatedTakeOffDateTime">
														<pd_etot>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_etot
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="EstimatedTakeOffDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_etot>
													</xsl:if>
                          <xsl:if test="TargetTakeOffDateTime">
														<pd_ttot>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_ttot
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="TargetTakeOffDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_ttot>
													</xsl:if>
                          <xsl:if test="ConfirmedTakeOffDateTime">
														<pd_ctot>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_ctot
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="ConfirmedTakeOffDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_ctot>
													</xsl:if>
													<xsl:if test="ActualTakeOffDateTime">
														<pd_atot>
															<xsl:call-template name="addPriority">
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_atot
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="ActualTakeOffDateTime" />
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
																<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_aldtnext
																</xsl:with-param>
																<xsl:with-param name="sender" select="$sender" />
															</xsl:call-template>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="ActualNextAirportArrivalDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_aldtnext>
													</xsl:if>
												</xsl:for-each>
												<xsl:for-each select="GroundHandleDateTime">
													<xsl:if test="ActualGroundHandleStartDateTime">
														<pd_acgt>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="ActualGroundHandleStartDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_acgt>
													</xsl:if>
													<xsl:if test="ActualGroundHandleEndDateTime">
														<pd_aegt>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="ActualGroundHandleEndDateTime" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_aegt>
													</xsl:if>
												</xsl:for-each>
												<!--Add by zzhao 2013-06-20 -->
                        <xsl:if test="DoorCloseDateTime/EstimatedDoorCloseDateTime">
													<pd_estimateddoorclosetime>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="DoorCloseDateTime/EstimatedDoorCloseDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_estimateddoorclosetime>
												</xsl:if>
												<xsl:if test="DoorCloseDateTime/ActualDoorCloseDateTime">
													<pd_doorclosetime>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="DoorCloseDateTime/ActualDoorCloseDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_doorclosetime>
												</xsl:if>
												<xsl:if test="OffBridgeDateTime/ActualOffBridgeDateTime">
													<pd_offbridge>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="OffBridgeDateTime/ActualOffBridgeDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_offbridge>
												</xsl:if>
											</xsl:for-each>
											<xsl:for-each select="FlightData/Status">
												<xsl:if test="OperationStatus">
													<pd_rrmk_remark>
														<xsl:call-template name="addPriority">
															<xsl:with-param name="key">pl_turn.pt_pd_departure.pl_departure.pd_rrmk_remark
															</xsl:with-param>
															<xsl:with-param name="sender" select="$sender" />
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
												<!--
													<xsl:if test="IsCashFlight='Y'">
													<pd_paymentmode>C</pd_paymentmode>
													</xsl:if>
												-->
												<!--mod by zzhao 2013-10-14 -->
												<xsl:if test="DelayReason">
													<pl_delayreason_list>
														<xsl:for-each select="DelayReason">
															<pl_delayreason>
																<pdlr_rdlr_delayreason>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="DelayCode" />
																		<xsl:with-param name="needAddNil" select="true()" />
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
																		<xsl:with-param name="inElement" select="DepartureAirport" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pdls_rap_airportfrom>
															</xsl:if>
															<xsl:if test="DestinationAirport">
																<pdls_rap_airportto>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="DestinationAirport" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pdls_rap_airportto>
															</xsl:if>
															<xsl:for-each select="Passenger">
																<xsl:for-each select="PassengersNumber">
																	<xsl:if test="TotalPassengersNumber">
																		<pdls_pax>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="TotalPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_pax>
																	</xsl:if>
																	<xsl:if test="FirstClassPassengersNumber">
																		<pdls_paxf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="FirstClassPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_paxf>
																	</xsl:if>
																	<xsl:if test="BusinessClassPassengersNumber">
																		<pdls_paxc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="BusinessClassPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_paxc>
																	</xsl:if>
																	<xsl:if test="EconomicClassPassengersNumber">
																		<pdls_paxy>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="EconomicClassPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_paxy>
																	</xsl:if>
																</xsl:for-each>
																<xsl:for-each select="AdultPassengers">
																	<xsl:if test="TotalAdultPassengersNumber">
																		<pdls_adult>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="TotalAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_adult>
																	</xsl:if>
																	<xsl:if test="FirstClassAdultPassengersNumber">
																		<pdls_adultf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="FirstClassAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_adultf>
																	</xsl:if>
																	<xsl:if test="BusinessClassAdultPassengersNumber">
																		<pdls_adultc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="BusinessClassAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_adultc>
																	</xsl:if>
																	<xsl:if test="EconomicClassAdultPassengersNumber">
																		<pdls_adulty>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="EconomicClassAdultPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_adulty>
																	</xsl:if>
																</xsl:for-each>
																<xsl:for-each select="ChildPassengers">
																	<xsl:if test="TotalChildPassengersNumber">
																		<pdls_child>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="TotalChildPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_child>
																	</xsl:if>
																	<xsl:if test="FirstClassChildPassengersNumber">
																		<pdls_childf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="FirstClassChildPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_childf>
																	</xsl:if>
																	<xsl:if test="BusinessClassChildPassengersNumber">
																		<pdls_childc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="BusinessClassChildPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_childc>
																	</xsl:if>
																	<xsl:if test="EconomicClassChildPassengersNumber">
																		<pdls_childy>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="EconomicClassChildPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_childy>
																	</xsl:if>
																</xsl:for-each>
																<xsl:for-each select="InfantPassengers">
																	<xsl:if test="TotalInfantPassengersNumber">
																		<pdls_infant>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="TotalInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_infant>
																	</xsl:if>
																	<xsl:if test="FirstClassInfantPassengersNumber">
																		<pdls_infantf>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="FirstClassInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_infantf>
																	</xsl:if>
																	<xsl:if test="BusinessClassInfantPassengersNumber">
																		<pdls_infantc>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="BusinessClassInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_infantc>
																	</xsl:if>
																	<xsl:if test="EconomicClassInfantPassengersNumber">
																		<pdls_infanty>
																			<xsl:call-template name="xsltTemplate">
																				<xsl:with-param name="inElement" select="EconomicClassInfantPassengersNumber" />
																				<xsl:with-param name="needAddNil" select="true()" />
																			</xsl:call-template>
																		</pdls_infanty>
																	</xsl:if>
																</xsl:for-each>
															</xsl:for-each>
															<xsl:for-each select="Weight">
																<xsl:if test="TotalWeight">
																	<pdls_totalweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="TotalWeight" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdls_totalweight>
																</xsl:if>
																<xsl:if test="BaggageWeight">
																	<pdls_baggageweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="BaggageWeight" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdls_baggageweight>
																</xsl:if>
																<xsl:if test="CargoWeight">
																	<pdls_cargoweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="CargoWeight" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdls_cargoweight>
																</xsl:if>
																<xsl:if test="MailWeight">
																	<pdls_mailweight>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="MailWeight" />
																			<xsl:with-param name="needAddNil" select="true()" />
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
															<xsl:with-param name="inElement" select="Terminal/FlightTerminalID" />
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
																			<xsl:with-param name="inElement" select="BaggageBeltID" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdb_rdb_departurebelt>
																</xsl:if>
																<xsl:if test="BaggageBeltStatus">
																	<pdb_status>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="BaggageBeltStatus" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdb_status>
																</xsl:if>
																<xsl:if test="ScheduledMakeupStartDateTime">
																	<pdb_beginplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ScheduledMakeupStartDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdb_beginplan>
																</xsl:if>
																<xsl:if test="ScheduledMakeupEndDateTime">
																	<pdb_endplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ScheduledMakeupEndDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdb_endplan>
																</xsl:if>
																<xsl:if test="ActualMakeupStartDateTime">
																	<pdb_beginactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ActualMakeupStartDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdb_beginactual>
																</xsl:if>
																<xsl:if test="ActualMakeupEndDateTime">
																	<pdb_endactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ActualMakeupEndDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
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
																<xsl:with-param name="inElement" select="Gate/BoardingStartDateTime[1]" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_gotogate>
													</xsl:if>
													<xsl:if test="Gate/LastCallDateTime[1]">
														<pd_secondcall>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="Gate/LastCallDateTime[1]" />
																<xsl:with-param name="needAddNil" select="true()" />
															</xsl:call-template>
														</pd_secondcall>
													</xsl:if>
													<xsl:if test="Gate/BoardingEndDateTime[1]">
														<pd_aebt>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="Gate/BoardingEndDateTime[1]" />
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
																			<xsl:with-param name="inElement" select="GateID" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdg_rgt_gate>
																</xsl:if>
																<!--<xsl:if test="GateStatus">
																	<pdg_status>
																	<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																	select="GateStatus" />
																	<xsl:with-param name="needAddNil"
																	select="true()" />
																	</xsl:call-template>
																	</pdg_status>
																	</xsl:if> Steven Commented 2013/12/10 -->
																<!--mod by zzhao 2014-03-24 -->
																<xsl:if test="ScheduledGateStartDateTime">
																	<pdg_begingateplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ScheduledGateStartDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdg_begingateplan>
																</xsl:if>
																<xsl:if test="ScheduledGateEndDateTime">
																	<pdg_endplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ScheduledGateEndDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdg_endplan>
																</xsl:if>
																<xsl:if test="ActualGateStartDateTime">
																	<pdg_begingateactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ActualGateStartDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdg_begingateactual>
																</xsl:if>
																<xsl:if test="ActualGateEndDateTime">
																	<pdg_endactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ActualGateEndDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
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
																			<xsl:with-param name="inElement" select="CheckInDeskID" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdk_rcnt_counter>
																</xsl:if>
																<!--mod by zzhao 2014-03-04
																	<xsl:if test="CheckInType">
																	<pdk_cciind>
																	<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																	select="CheckInType" />
																	<xsl:with-param name="needAddNil"
																	select="true()" />
																	</xsl:call-template>
																	</pdk_cciind>
																	</xsl:if>
																-->
																<xsl:if test="CheckInStatus">
																	<pdk_status>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="CheckInStatus" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdk_status>
																</xsl:if>
																<xsl:if test="CheckInClassService">
																	<pdk_checkinclassid>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="CheckInClassService" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdk_checkinclassid>
																</xsl:if>
																<xsl:if test="ScheduledCheckInBeginDateTime">
																	<pdk_beginplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ScheduledCheckInBeginDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdk_beginplan>
																</xsl:if>
																<xsl:if test="ScheduledCheckInEndDateTime">
																	<pdk_endplan>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ScheduledCheckInEndDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdk_endplan>
																</xsl:if>
																<xsl:if test="ActualCheckInBeginDateTime">
																	<pdk_beginactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ActualCheckInBeginDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
																		</xsl:call-template>
																	</pdk_beginactual>
																</xsl:if>
																<xsl:if test="ActualCheckInEndDateTime">
																	<pdk_endactual>
																		<xsl:call-template name="xsltTemplate">
																			<xsl:with-param name="inElement" select="ActualCheckInEndDateTime" />
																			<xsl:with-param name="needAddNil" select="true()" />
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
																		<xsl:with-param name="inElement" select="CheckInPassengerCount" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pdai_actualcheckedin>
															</xsl:if>
															<xsl:if test="SecurityCheckPassengerCount">
																<pdai_actualsecurity>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="SecurityCheckPassengerCount" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pdai_actualsecurity>
															</xsl:if>
															<xsl:if test="OnboardPassengerCount">
																<pdai_actualboarding>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="OnboardPassengerCount" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pdai_actualboarding>
															</xsl:if>
														</pl_departureaddinfo>
													</pl_departureaddinfo_list>
												</xsl:for-each>
                       <!--add mapping for PassengerAmount 2017-7-31 -->
												<xsl:for-each select="PassengerAmount">
															<xsl:if test="TotalPassengers">
																<pd_toatlpax>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="TotalPassengers" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pd_toatlpax>
															</xsl:if>
															<xsl:if test="TransferPassengers">
																<pd_transferpax>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="TransferPassengers" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pd_transferpax>
															</xsl:if>
															<xsl:if test="TransitPassengers">
																<pd_transitpax>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="TransitPassengers" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pd_transitpax>
															</xsl:if>
															<xsl:if test="TotalCrews">
																<pd_totalcrew>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="TotalCrews" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pd_totalcrew>
															</xsl:if>
                        			<xsl:if test="TotalExtraCrews">
																<pd_totalextracrew>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement" select="TotalExtraCrews" />
																		<xsl:with-param name="needAddNil" select="true()" />
																	</xsl:call-template>
																</pd_totalextracrew>
															</xsl:if>
												</xsl:for-each>
												<xsl:if test="Gate/ActualGateStartDateTime">
													<pd_asbt>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="Gate/ActualGateStartDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_asbt>
												</xsl:if>
                      <xsl:if test="Stand/StandID">
													<pd_rsta_stand>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="Stand/StandID" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pd_rsta_stand>
												</xsl:if>
											</xsl:for-each>
										</pl_departure>
									</pt_pd_departure>
									<xsl:for-each select="FlightData/Airport">			
									 <xsl:if test="GroundMovement">
										<pl_stand_list>
										  <xsl:for-each select="GroundMovement">
											<pl_stand>
												<xsl:if test="StandID">
													<pst_rsta_stand>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement" select="StandID" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pst_rsta_stand>
												</xsl:if>
												<xsl:if test="ScheduledStandStartDateTime">
													<pst_beginplan>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="ScheduledStandStartDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pst_beginplan>
												</xsl:if>
												<xsl:if test="ScheduledStandEndDateTime">
													<pst_endplan>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="ScheduledStandEndDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pst_endplan>
												</xsl:if>
												<xsl:if test="ActualStandStartDateTime">
													<pst_beginactual>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="ActualStandStartDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
														</xsl:call-template>
													</pst_beginactual>
												</xsl:if>
												<xsl:if test="ActualStandEndDateTime">
													<pst_endactual>
														<xsl:call-template name="xsltTemplate">
															<xsl:with-param name="inElement"
																select="ActualStandEndDateTime" />
															<xsl:with-param name="needAddNil" select="true()" />
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
						<!-- RUS rm_closing mapping work -->
						<xsl:if test="../SysInfo/ServiceType='RUS'">
							<rm_closing>
								<xsl:call-template name="actionMode">
									<xsl:with-param name="operationMode" select="../SysInfo/OperationMode" />
								</xsl:call-template>
								<xsl:if test="PrimaryKey/ResourceKey">
									<xsl:for-each select="PrimaryKey/ResourceKey">
										<rcl_resourcetype>
											<xsl:call-template name="resourceTypeConvert">
												<xsl:with-param name="resourceType" select="ResourceCategory" />
											</xsl:call-template>
										</rcl_resourcetype>
										<rcl_resourcename>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="ResourceID" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</rcl_resourcename>
									</xsl:for-each>
								</xsl:if>
								<xsl:if test="ResourceData/Closing">
									<xsl:for-each select="ResourceData/Closing">
										<rcl_beginplantime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="ClosingScheduledFromDateTime" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</rcl_beginplantime>
										<rcl_endplantime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="ClosingScheduledEndDateTime" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</rcl_endplantime>
										<rcl_beginactual>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="ClosingActualFromDateTime" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</rcl_beginactual>
										<rcl_endactual>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="ClosingActualEndDateTime" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</rcl_endactual>
										<rcl_reason>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="CommentFreeText" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</rcl_reason>
									</xsl:for-each>
								</xsl:if>
							</rm_closing>
						</xsl:if>
						<xsl:if test="PrimaryKey/GroundServiceDataKey">
							<xsl:for-each select="GroundServiceData">
								<xsl:for-each select="Service">
									<et_gs_service>
										<xsl:call-template name="actionMode">
											<xsl:with-param name="operationMode" select="../../../SysInfo/OperationMode" />
										</xsl:call-template>
										<xsl:if test="ServiceID">
											<serviceid>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ServiceID" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</serviceid>
										</xsl:if>
										<xsl:if test="FlightIdentity">
											<flightnumber>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="FlightIdentity" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</flightnumber>
										</xsl:if>
										<xsl:if test="FlightScheduledDate">
											<stt>
												<xsl:variable name="seceduledate" select="FlightScheduledDate" />
												<xsl:if test="FlightScheduledDate/@old">
													<xsl:attribute name="OldValue">
                            <xsl:value-of select="FlightScheduledDate/@old" />
                          </xsl:attribute>
												</xsl:if>
												<xsl:call-template name="flightScheduleDateTimeTemplate">
													<xsl:with-param name="scheduleDatetime" select="null" />
													<xsl:with-param name="seceduledate" select="$seceduledate" />
												</xsl:call-template>
											</stt>
										</xsl:if>
										<xsl:if test="FlightDirection">
											<flightdirection>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="FlightDirection" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</flightdirection>
										</xsl:if>
										<xsl:if test="ServiceName">
											<servicename>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ServiceName" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</servicename>
										</xsl:if>
										<xsl:if test="ServiceScheduleStartDateTime">
											<serviceschedulestart>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ServiceScheduleStartDateTime" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</serviceschedulestart>
										</xsl:if>
										<xsl:if test="ServiceScheduleEndDateTime">
											<servicescheduleend>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ServiceScheduleEndDateTime" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</servicescheduleend>
										</xsl:if>
										<xsl:if test="ServiceActualStartDateTime">
											<serviceactualstart>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ServiceActualStartDateTime" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</serviceactualstart>
										</xsl:if>
										<xsl:if test="ServiceActualEndDateTime">
											<serviceactualend>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ServiceActualEndDateTime" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</serviceactualend>
										</xsl:if>
										<xsl:if test="ServiceExceptionType">
											<serviceexceptiontype>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ServiceExceptionType" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</serviceexceptiontype>
										</xsl:if>
										<xsl:if test="ServiceExceptionReason">
											<serviceexceptionreason>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ServiceExceptionReason" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</serviceexceptionreason>
										</xsl:if>
									</et_gs_service>
								</xsl:for-each>
								<xsl:for-each select="Staff">
									<et_gs_staff>
										<xsl:call-template name="actionMode">
											<xsl:with-param name="operationMode" select="../../../SysInfo/OperationMode" />
										</xsl:call-template>
										<xsl:if test="AssignmentID">
											<assignmentid>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="AssignmentID" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</assignmentid>
										</xsl:if>
										<xsl:if test="StaffName">
											<staffname>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="StaffName" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</staffname>
										</xsl:if>
										<xsl:if test="StaffCode">
											<staffcode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="StaffCode" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</staffcode>
										</xsl:if>
										<xsl:if test="StaffSkill">
											<staffskill>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="StaffSkill" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</staffskill>
										</xsl:if>
										<xsl:if test="StaffScheduledOndutyDateTime">
											<staffscheduledonduty>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="StaffScheduledOndutyDateTime" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</staffscheduledonduty>
										</xsl:if>
										<xsl:if test="StaffScheduledOffdutyDateTime">
											<staffscheduledoffduty>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="StaffScheduledOffdutyDateTime" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</staffscheduledoffduty>
										</xsl:if>
										<xsl:if test="StaffActualOndutyDateTime">
											<staffactualonduty>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="StaffActualOndutyDateTime" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</staffactualonduty>
										</xsl:if>
										<xsl:if test="StaffActualOffdutyDateTime">
											<staffactualoffduty>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="StaffActualOffdutyDateTime" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</staffactualoffduty>
										</xsl:if>
										<xsl:if test="StaffExceptionType">
											<stafflexceptiontype>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="StaffExceptionType" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</stafflexceptiontype>
										</xsl:if>
										<xsl:if test="StaffExceptionReason">
											<staffexceptionreason>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="StaffExceptionReason" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</staffexceptionreason>
										</xsl:if>
									</et_gs_staff>
								</xsl:for-each>
								<xsl:for-each select="Task">
									<et_gs_task>
										<xsl:call-template name="actionMode">
											<xsl:with-param name="operationMode" select="../../../SysInfo/OperationMode" />
										</xsl:call-template>
										<xsl:if test="TaskID">
											<taskid>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskID" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskid>
										</xsl:if>
										<xsl:if test="FlightIdentity">
											<flightnumber>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="FlightIdentity" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</flightnumber>
										</xsl:if>
										<xsl:if test="FlightScheduledDate">
											<stt>
												<xsl:variable name="seceduledate" select="FlightScheduledDate" />
												<xsl:if test="FlightScheduledDate/@old">
													<xsl:attribute name="OldValue">
                            <xsl:value-of select="FlightScheduledDate/@old" />
                          </xsl:attribute>
												</xsl:if>
												<xsl:call-template name="flightScheduleDateTimeTemplate">
													<xsl:with-param name="scheduleDatetime" select="null" />
													<xsl:with-param name="seceduledate" select="$seceduledate" />
												</xsl:call-template>
											</stt>
										</xsl:if>
										<xsl:if test="FlightDirection">
											<flightdirection>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="FlightDirection" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</flightdirection>
										</xsl:if>
										<xsl:if test="ServiceID">
											<serviceid>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ServiceID" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</serviceid>
										</xsl:if>
										<xsl:if test="TaskName">
											<taskname>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskName" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskname>
										</xsl:if>
										<xsl:if test="TaskScheduledStartDateTime">
											<taskskdstart>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskScheduledStartDateTime" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskskdstart>
										</xsl:if>
										<xsl:if test="TaskScheduledEndDateTime">
											<taskskdend>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskScheduledEndDateTime" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskskdend>
										</xsl:if>
										<xsl:if test="TaskScheduledMobileFacilityName">
											<taskskdmobilefacilityname>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskScheduledMobileFacilityName" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskskdmobilefacilityname>
										</xsl:if>
										<xsl:if test="TaskScheduledLicense">
											<taskskdlicense>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskScheduledLicense" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskskdlicense>
										</xsl:if>
										<xsl:if test="TaskScheduledMobileFacilityUsage">
											<taskskdmobilefacilityusage>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskScheduledMobileFacilityUsage" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskskdmobilefacilityusage>
										</xsl:if>
										<xsl:if test="TaskScheduledInput">
											<taskskdinput>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskScheduledInput" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskskdinput>
										</xsl:if>
										<xsl:if test="TaskScheduledOutput">
											<taskskdoutput>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskScheduledOutput" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskskdoutput>
										</xsl:if>
										<xsl:if test="TaskScheduledExecutionSequence">
											<taskskdexecutionsequence>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskScheduledExecutionSequence" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskskdexecutionsequence>
										</xsl:if>
										<xsl:if test="TaskScheduledStaffName">
											<taskskdstaffname>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskScheduledStaffName" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskskdstaffname>
										</xsl:if>
										<xsl:if test="TaskScheduledStaffCode">
											<taskskdstaffcode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskScheduledStaffCode" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskskdstaffcode>
										</xsl:if>
										<xsl:if test="TaskScheduledStaffSkill">
											<taskskdstaffskill>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskScheduledStaffSkill" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskskdstaffskill>
										</xsl:if>
										<xsl:if test="TaskActualStartDateTime">
											<taskactstart>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskActualStartDateTime" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskactstart>
										</xsl:if>
										<xsl:if test="TaskActualEndDateTime">
											<taskactend>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskActualEndDateTime" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskactend>
										</xsl:if>
										<xsl:if test="TaskActualMobileFacilityName">
											<taskactmobilefacilityname>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskActualMobileFacilityName" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskactmobilefacilityname>
										</xsl:if>
										<xsl:if test="TaskActualLicense">
											<taskactlicense>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskActualLicense" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskactlicense>
										</xsl:if>
										<xsl:if test="TaskActualMobileFacilityUsage">
											<taskactmobilefacilityusage>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskActualMobileFacilityUsage" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskactmobilefacilityusage>
										</xsl:if>
										<xsl:if test="TaskActualInput">
											<taskactinput>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskActualInput" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskactinput>
										</xsl:if>
										<xsl:if test="TaskActualOutput">
											<taskactoutput>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskActualOutput" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskactoutput>
										</xsl:if>
										<xsl:if test="TaskActualExecutionSequence">
											<taskactexecutionsequence>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskActualExecutionSequence" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskactexecutionsequence>
										</xsl:if>
										<xsl:if test="TaskActualStaffName">
											<taskactstaffname>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskActualStaffName" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskactstaffname>
										</xsl:if>
										<xsl:if test="TaskActualStaffCode">
											<taskactstaffcode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskActualStaffCode" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskactstaffcode>
										</xsl:if>
										<xsl:if test="TaskActualStaffSkill">
											<taskactstaffskill>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="TaskActualStaffSkill" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</taskactstaffskill>
										</xsl:if>
									</et_gs_task>
								</xsl:for-each>
							</xsl:for-each>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</soap-env:Body>
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
	<xsl:template name="actionMode">
		<xsl:param name="operationMode" />
		<xsl:if test="$operationMode='DEL'">
			<xsl:attribute name="action">delete</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="resourceTypeConvert">
		<xsl:param name="resourceType" />
		<xsl:if test="$resourceType='Stand'">
			RSTA
		</xsl:if>
		<xsl:if test="$resourceType='BaggageMakeup'">
			RDB
		</xsl:if>
		<xsl:if test="$resourceType='Gate'">
			RGT
		</xsl:if>
		<xsl:if test="$resourceType='CheckInDesk'">
			RCNT
		</xsl:if>
		<xsl:if test="$resourceType='BaggageReclaim'">
			RBB
		</xsl:if>
		<xsl:if test="$resourceType='BoardingBridge'">
			RAB
		</xsl:if>
	</xsl:template>
	<xsl:template name="flightScheduleDateTimeTemplate">
		<xsl:param name="scheduleDatetime" />
		<xsl:param name="seceduledate" />
		<xsl:choose>
			<xsl:when test="$scheduleDatetime">
				<xsl:value-of select="$scheduleDatetime" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="javacode:dateToDatetime($seceduledate)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="addPriority">
		<xsl:param name="key" />
		<xsl:param name="sender" />
		<xsl:variable name="sender_length" select="string-length($sender)" />
		<xsl:attribute name="priority">
      <xsl:value-of select="javacode:getPriority($key, substring($sender,5,$sender_length))" />
    </xsl:attribute>
	</xsl:template>
</xsl:stylesheet>