<!--
Version 2.0j 2014-06-23 mod by zzhao mod mapping rule of "flightnumber";
Version 2.0i 2014-05-27 mod by zzhao add node mapping of "CreateReason";
Version 2.0h 2014-05-22 mod by zzhao add node mapping of "FlyTime/EstimatedFlyTime";
Version 2.0g 2014-05-19 mod by zzhao change mapping rule of node "ScheduledPreviousAirportDepartureDateTime" and node "EstimatedPreviousAirportDepartureDateTime"
Version 2.0f 2014-05-16 mod by zzhao add mapping rule for node "DiversionAirport/AirportIATACode",node "DiversionAirport/AirportICAOCode", node "ChangeLandingAirport/AirportIATACode" and node "ChangeLandingAirport/AirportICAOCode";
Version 2.0e 2014-05-16 mod by zzhao change mapping rule of node "ScheduledPreviousAirportDepartureDateTime" and node "EstimatedPreviousAirportDepartureDateTime"
version 2.0d 2014-05-08 mod by zzhao add node mapping of "ScheduledPreviousAirportDepartureDateTime" and "EstimatedPreviousAirportDepartureDateTime".
Version 2.0c 2014-02-26 mod by zzhao
add node "IsVIPFlight", "VIPComment" and remove node "IsCashFlight"; 
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
	<!-- <xsl:choose>
		if on fss1 and there is no action arrtibute in the aodb message, then ignore it.
		<xsl:when test="$dataType ='pl_turn' and not(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/@action[1]) and $aodb_servicetype='SUBSCRIBE' and (not(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_srtd or /soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_flightnumber) or (/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_srtd and not(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_srtd/@old[1])) or (/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_flightnumber and not(/soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_flightnumber/@old[1])))"></xsl:when>
		<xsl:otherwise> -->
		<IMFRoot>
			<xsl:variable name="messageType"
				select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:message-type"></xsl:variable>
			<xsl:variable name="orgmessageType"
				select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:org-message-type"></xsl:variable>
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
							<xsl:with-param name="messageType" select="$messageType" />
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
								<xsl:value-of select="pl_turn/pt_pa_arrival/pl_arrival/pa_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_aircraft'">
								<xsl:value-of select="ref_aircraft/rac_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_terminal'">
								<xsl:value-of select="ref_terminal/rtrm_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_runway'">
								<xsl:value-of select="ref_runway/rrwy_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_stand'">
								<xsl:value-of select="ref_stand/rsta_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_counter'">
								<xsl:value-of select="ref_counter/rcnt_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_departurebelt'">
								<xsl:value-of select="ref_departurebelt/rdb_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_gate'">
								<xsl:value-of select="ref_gate/rgt_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_baggagebelt'">
								<xsl:value-of select="ref_baggagebelt/rbb_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_airline'">
								<xsl:value-of select="ref_airline/ral_modtime"/>
							</xsl:when>
							<xsl:when test="$dataType='ref_handlingagent'">
								<xsl:value-of select="ref_handlingagent/rha_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_airport'">
								<xsl:value-of select="ref_airport/rap_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_passengerclass'">
								<xsl:value-of select="ref_passengerclass/rpc_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_remark'">
								<xsl:value-of select="ref_remark/rrmk_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_aircrafttype'">
								<xsl:value-of select="ref_aircrafttype/ract_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_country'">
								<xsl:value-of select="ref_country/rctr_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_servicetypecode'">
								<xsl:value-of select="ref_servicetypecode/rstc_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='ref_delayreason'">
								<xsl:value-of select="ref_delayreason/rdlr_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='rm_closing'">
								<xsl:value-of select="rm_closing/rcl_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='pl_desk'">
								<xsl:value-of select="pl_desk/pdk_modtime"></xsl:value-of>
							</xsl:when>
							<xsl:when test="$dataType='et_gs_staff'">
								<xsl:value-of select="et_gs_staff/egst_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='et_gs_service'">
								<xsl:value-of select="et_gs_service/egs_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='et_gs_task'">
								<xsl:value-of select="et_gs_task/egt_modtime" />
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
					<xsl:if test="starts-with($dataType,'ref')">
						<Data>
							<PrimaryKey>
								<BasicDataKey>
									<xsl:if test="$dataType='ref_aircraft'">
										<BasicDataCategory>Aircraft</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_terminal'">
										<BasicDataCategory>Terminal</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_runway'">
										<BasicDataCategory>Runway</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_stand'">
										<BasicDataCategory>Stand</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_counter'">
										<BasicDataCategory>CheckInDesk</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_departurebelt'">
										<BasicDataCategory>BaggageMakeup</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_gate'">
										<BasicDataCategory>Gate</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_baggagebelt'">
										<BasicDataCategory>BaggageReclaim</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_airline'">
										<BasicDataCategory>Airline</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_handlingagent'">
										<BasicDataCategory>Handler</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_airport'">
										<BasicDataCategory>Airport</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_passengerclass'">
										<BasicDataCategory>PassengerClass</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_remark'">
										<BasicDataCategory>FlightOperationCode</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_aircrafttype'">
										<BasicDataCategory>AircraftType</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_country'">
										<BasicDataCategory>Country</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_servicetypecode'">
										<BasicDataCategory>FlightServiceType</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$dataType='ref_delayreason'">
										<BasicDataCategory>DelayCode</BasicDataCategory>
									</xsl:if>
									<BasicDataID>
										<xsl:if test="$dataType='ref_aircraft'">
											<xsl:value-of select="ref_aircraft/rac_registration" />
										</xsl:if>
										<xsl:if test="$dataType='ref_terminal'">
											<xsl:value-of select="ref_terminal/rtrm_code" />
										</xsl:if>
										<xsl:if test="$dataType='ref_runway'">
											<xsl:value-of select="ref_runway/rrwy_code" />
										</xsl:if>
										<xsl:if test="$dataType='ref_stand'">
											<xsl:value-of select="ref_stand/rsta_code" />
										</xsl:if>
										<xsl:if test="$dataType='ref_counter'">
											<xsl:value-of select="ref_counter/rcnt_code" />
										</xsl:if>
										<xsl:if test="$dataType='ref_departurebelt'">
											<xsl:value-of select="ref_departurebelt/rdb_code" />
										</xsl:if>
										<xsl:if test="$dataType='ref_gate'">
											<xsl:value-of select="ref_gate/rgt_code" />
										</xsl:if>
										<xsl:if test="$dataType='ref_baggagebelt'">
											<xsl:value-of select="ref_baggagebelt/rbb_code" />
										</xsl:if>
										<xsl:if test="$dataType='ref_airline'">
											<xsl:value-of select="ref_airline/ral_2lc"></xsl:value-of>
										</xsl:if>
										<xsl:if test="$dataType='ref_handlingagent'">
											<xsl:value-of select="ref_handlingagent/rha_code" />
										</xsl:if>
										<xsl:if test="$dataType='ref_airport'">
											<xsl:value-of select="ref_airport/rap_iata3lc" />
										</xsl:if>
										<xsl:if test="$dataType='ref_passengerclass'">
											<xsl:value-of select="ref_passengerclass/rpc_code" />
										</xsl:if>
										<xsl:if test="$dataType='ref_remark'">
											<xsl:value-of select="ref_remark/rrmk_code" />
										</xsl:if>
										<xsl:if test="$dataType='ref_aircrafttype'">
											<xsl:value-of select="ref_aircrafttype/ract_iatatype" />
										</xsl:if>
										<xsl:if test="$dataType='ref_country'">
											<xsl:value-of select="ref_country/rctr_code" />
										</xsl:if>
										<xsl:if test="$dataType='ref_servicetypecode'">
											<xsl:value-of select="ref_servicetypecode/rstc_code" />
										</xsl:if>
										<xsl:if test="$dataType='ref_delayreason'">
											<xsl:value-of select="ref_delayreason/rdlr_codenumeric" />
										</xsl:if>
									</BasicDataID>
								</BasicDataKey>
							</PrimaryKey>
							<!-- The next will judge the ref_aircraft -->
							<xsl:if test="$dataType='ref_aircraft'">
								<BasicData>
									<Aircraft>
										<xsl:for-each select="ref_aircraft">
											<AircraftRegistration>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rac_registration" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AircraftRegistration>
											<AircraftTypeIATACode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="rac_ract_aircrafttype/ref_aircrafttype/ract_iatatype" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AircraftTypeIATACode>
											<AircraftTypeICAOCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="rac_ract_aircrafttype/ref_aircrafttype/ract_icaotype" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AircraftTypeICAOCode>
											<AircraftOwnerAirline>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rac_owner" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AircraftOwnerAirline>
											<AircraftLeasingAirline>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rac_ral_lessee" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AircraftLeasingAirline>
										</xsl:for-each>
									</Aircraft>
								</BasicData>
							</xsl:if>

							<xsl:if test="$dataType='ref_aircrafttype'">
								<BasicData>
									<AircraftType>
										<xsl:for-each select="ref_aircrafttype">
											<AircraftTypeIATACode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_iatatype" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AircraftTypeIATACode>
											<AircraftTypeICAOCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_icaotype" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AircraftTypeICAOCode>
											<AircraftSubTypeIATACode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_iatasubtype" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AircraftSubTypeIATACode>
											<AircraftManufactory>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_manufacturer" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AircraftManufactory>
											<AircraftEngineNumber>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_enginecount" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AircraftEngineNumber>
											<AircraftHeight>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_height" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AircraftHeight>
											<AircraftLength>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_length" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AircraftLength>
											<AircraftWidth>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_width" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AircraftWidth>
											<AircarftTakeoffWeight>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_mtow" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AircarftTakeoffWeight>
											<AircraftSeatCapacity>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="ract_averageseatcapacity" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AircraftSeatCapacity>
											<AircarftPayload>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_payload" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AircarftPayload>
											<AircarftLandingWeight>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_landingweight" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AircarftLandingWeight>
											<AircraftTypeDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_description" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AircraftTypeDescription>
											<AircraftNoiseCategory>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="ract_rnca_noisecategory" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AircraftNoiseCategory>
											<BoardingBridgeRequired>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="ract_bridgerequiredind" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</BoardingBridgeRequired>
											<AircraftMode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_model" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AircraftMode>
											<AircraftSizaCategory>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_sizecategory" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AircraftSizaCategory>
										</xsl:for-each>
									</AircraftType>
								</BasicData>
							</xsl:if>
							<!-- The next will judge the ref_terminal -->
							<xsl:if test="$dataType='ref_terminal'">
								<BasicData>
									<Terminal>
										<xsl:for-each select="ref_terminal">
											<TerminalCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rtrm_code" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</TerminalCode>
											<TerminalDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rtrm_description" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</TerminalDescription>
										</xsl:for-each>
									</Terminal>
								</BasicData>
							</xsl:if>

							<!-- The next will judge the ref_runway -->
							<xsl:if test="$dataType='ref_runway'">
								<BasicData>
									<Runway>
										<xsl:for-each select="ref_runway">
											<RunwayCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rrwy_code" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</RunwayCode>
											<RunwayDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rrwy_description" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</RunwayDescription>
											<RunwayLength>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rrwy_length" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</RunwayLength>
											<RunwayWidth>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rrwy_width" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</RunwayWidth>
										</xsl:for-each>
									</Runway>
								</BasicData>
							</xsl:if>

							<!-- The next will judge the ref_stand -->
							<xsl:if test="$dataType='ref_stand'">
								<BasicData>
									<Stand>
										<xsl:for-each select="ref_stand">
											<StandCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rsta_code" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</StandCode>
											<!--mod by zzhao 2013-11-07  -->
											<StandTerminal>
											<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rsta_rco_concourse" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</StandTerminal>
											<StandCapacity>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rsta_capacity" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</StandCapacity>
											<StandDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rsta_description" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</StandDescription>
											<StandRefGate>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rsta_rgt_gate" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</StandRefGate>
											<StandLength>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rsta_length" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</StandLength>
											<StandWidth>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rsta_width" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</StandWidth>
										</xsl:for-each>
									</Stand>
								</BasicData>
							</xsl:if>

							<!-- The next will judge the ref_counter -->
							<xsl:if test="$dataType='ref_counter'">
								<BasicData>
									<CheckInDesk>
										<xsl:for-each select="ref_counter">
											<CheckInDeskCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rcnt_code" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</CheckInDeskCode>
											<!-- mod by zzhao 2013-11-07 -->
											<CheckInDeskTerminal>
											<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rcnt_rco_concourse" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</CheckInDeskTerminal>
											<CheckInDeskType>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rcnt_type" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</CheckInDeskType>
											<CheckInDeskCapacity>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rcnt_capacity" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</CheckInDeskCapacity>
											<CheckInDeskDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rcnt_description" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</CheckInDeskDescription>
										</xsl:for-each>
									</CheckInDesk>
								</BasicData>
							</xsl:if>

							<!-- mod by zzhao 2013-11-07 -->
							<xsl:if test="$dataType='ref_departurebelt'">
								<BasicData>
									<BaggageMakeup>
										<xsl:for-each select="ref_departurebelt">
											<BaggageMakeupCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rdb_code" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</BaggageMakeupCode>
											<BaggageTerminal>
											<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rdb_rco_concourse" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</BaggageTerminal>
											<BaggageDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rdb_description" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</BaggageDescription>
											<BaggageMakeupCapacity>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rdb_capacity" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</BaggageMakeupCapacity>
										</xsl:for-each>
									</BaggageMakeup>
								</BasicData>
							</xsl:if>

							<!-- The next will judge the ref_gate -->
							<xsl:if test="$dataType='ref_gate'">
								<BasicData>
									<Gate>
										<xsl:for-each select="ref_gate">
											<GateCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rgt_code" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</GateCode>
											<GateTerminal>
											<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rgt_rco_concourse" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</GateTerminal>
											<GateType>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rgt_gatetype" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</GateType>
											<!--add by zzhao at 2013-08-27  -->
											<GateCountryType>
											<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rgt_rctt_countrytype" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</GateCountryType>
											<GateDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rgt_description" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</GateDescription>
										</xsl:for-each>
									</Gate>
								</BasicData>
							</xsl:if>

							<!-- mod by zzhao 2013-11-07 ref_baggagebelt -->
							<xsl:if test="$dataType='ref_baggagebelt'">
								<BasicData>
									<BaggageReclaim>
										<xsl:for-each select="ref_baggagebelt">
											<BaggageReclaimCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rbb_code" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</BaggageReclaimCode>
											<BaggageReclaimTerminal>
											<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rbb_rco_concourse" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</BaggageReclaimTerminal>
											<BaggageReclaimDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rbb_description" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</BaggageReclaimDescription>
										</xsl:for-each>
									</BaggageReclaim>
								</BasicData>
							</xsl:if>
							
							<xsl:if test="$dataType='ref_airline'">
								<BasicData>
									<Airline>
										<xsl:for-each select="ref_airline">
											<AirlineIATACode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ral_2lc" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AirlineIATACode>
											<AirlineICAOCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ral_3lc" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AirlineICAOCode>
											<AirlineName>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ral_name" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AirlineName>
											<AirlineHomeCountry>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ral_rctr_country" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AirlineHomeCountry>
											<AirlineAllianceGroup>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ral_alliance" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AirlineAllianceGroup>
											<AirlineDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ral_description" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AirlineDescription>
											<AirlineHandler>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ral_rha_agentci" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AirlineHandler>
										</xsl:for-each>
									</Airline>
								</BasicData>
							</xsl:if>

							<!-- The next will judge the ref_handlingagent -->
							<xsl:if test="$dataType='ref_handlingagent'">
								<BasicData>
									<Handler>
										<xsl:for-each select="ref_handlingagent">
											<HandlerCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rha_code" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</HandlerCode>
											<HandlerName>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rha_name" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</HandlerName>
											<HandlerDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rha_description" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</HandlerDescription>
										</xsl:for-each>
									</Handler>
								</BasicData>
							</xsl:if>

							<!-- The next will judge the ref_airport -->
							<xsl:if test="$dataType='ref_airport'">
								<BasicData>
									<Airport>
										<xsl:for-each select="ref_airport">
											<AirportIATACode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rap_iata3lc" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AirportIATACode>
											<AirportICAOCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rap_icao4lc" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AirportICAOCode>
											<AirportRoutingName>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rap_name5" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AirportRoutingName>
											<AirportCountry>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rap_rctr_country" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AirportCountry>
											<AirportCountryType>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rap_rctt_countrytype" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AirportCountryType>
											<AirportCity>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rap_city" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AirportCity>
											<AirportRegion>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rap_iataregion" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AirportRegion>
											<AirportTimezone>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rap_timezone" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AirportTimezone>
											<AirportDistance>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rap_distance" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AirportDistance>
											<AirportDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rap_name1" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AirportDescription>
										</xsl:for-each>
									</Airport>
								</BasicData>
							</xsl:if>

							<!-- The next will judge the ref_passengerclass -->
							<xsl:if test="$dataType='ref_passengerclass'">
								<BasicData>
									<PassengerClass>
										<xsl:for-each select="ref_passengerclass">
											<PassengerClassCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rpc_code" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</PassengerClassCode>
											<PassengerClassName xsi:nil="true" />
											<PassengerClassDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rpc_description" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</PassengerClassDescription>
											<PassengerClassAirline xsi:nil="true" />
										</xsl:for-each>
									</PassengerClass>
								</BasicData>
							</xsl:if>

							<xsl:if test="$dataType='ref_remark'">
								<BasicData>
									<FlightOperationCode>
										<xsl:for-each select="ref_remark">
											<FlightOperationCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rrmk_code" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</FlightOperationCode>
											<FlightOperationCodeDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rrmk_description" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</FlightOperationCodeDescription>
										</xsl:for-each>
									</FlightOperationCode>
								</BasicData>
							</xsl:if>

							<xsl:if test="$dataType='ref_servicetypecode'">
								<BasicData>
									<FlightServiceType>
										<xsl:for-each select="ref_servicetypecode">
											<ServiceTypeCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rstc_code" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</ServiceTypeCode>
											<ServiceTypeDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rstc_description" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</ServiceTypeDescription>
										</xsl:for-each>
									</FlightServiceType>
								</BasicData>
							</xsl:if>

							<xsl:if test="$dataType='ref_country'">
								<BasicData>
									<Country>
										<xsl:for-each select="ref_country">
											<CountryIATACode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rctr_code" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</CountryIATACode>
											<CountryICAOCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rctr_icao4lc" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</CountryICAOCode>
											<CountryName>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rctr_name" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</CountryName>
											<CountryType>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rctr_rctt_countrytype" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</CountryType>
											<CountryArea>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rctr_subregion" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</CountryArea>
										</xsl:for-each>
									</Country>
								</BasicData>
							</xsl:if>

							<xsl:if test="$dataType='ref_delayreason'">
								<BasicData>
									<DelayCode>
										<xsl:for-each select="ref_delayreason">
											<DelayCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rdlr_codenumeric" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</DelayCode>
											<DelayReason>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rdlr_description" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</DelayReason>
											<DelaySubCode xsi:nil="true" />
											<DelaySubReason xsi:nil="true" />
										</xsl:for-each>
									</DelayCode>
								</BasicData>
							</xsl:if>
							
						</Data>
					</xsl:if>

					<xsl:if test="$dataType='pl_turn'">
					  <xsl:variable name="iataOrigAirport" select="pl_turn/pt_pa_arrival/pl_arrival/pa_rap_originairport/ref_airport/rap_iata3lc" />
					  <xsl:variable name="icaoOrigAirport" select="pl_turn/pt_pa_arrival/pl_arrival/pa_rap_originairport/ref_airport/rap_icao4lc" />
				      <!-- change flightnumber mapping rule as flightnumber= flightidentity-ral_2lc  -->
				      <xsl:variable name="ral_2lc">
						<xsl:if test="pl_turn/pt_pa_arrival/pl_arrival/@action='delete'">
							<xsl:value-of select="normalize-space(pl_turn/pt_pa_arrival/pl_arrival/pa_ral_airline/ref_airline/ral_2lc/@old)"/>
						</xsl:if>
						<xsl:if test="not(pl_turn/pt_pa_arrival/pl_arrival/@action) or pl_turn/pt_pa_arrival/pl_arrival/@action!='delete'">
							<xsl:value-of select="normalize-space(pl_turn/pt_pa_arrival/pl_arrival/pa_ral_airline/ref_airline/ral_2lc/text())"/>
						</xsl:if>
					  </xsl:variable>
					  <!-- <xsl:variable name="pa_ral_airline" select="normalize-space(pl_turn/pt_pa_arrival/pl_arrival/pa_ral_airline/text())" />
					  <xsl:variable name="pd_ral_airline" select="normalize-space(pl_turn/pt_pd_departure/pl_departure/pd_ral_airline/text())" /> -->				 				  		
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
								<!-- do the operation for the arrival data -->
								<xsl:for-each select="pt_pa_arrival/pl_arrival">
									<PrimaryKey>
										<FlightKey>
											<FlightScheduledDate>
												<xsl:if test="pa_srta/@xsi:nil='true' or not(pa_srta)">
													<xsl:attribute name="xsi:nil">true</xsl:attribute>
												</xsl:if>
												<!-- <xsl:if test="pa_srta/@old">
													<xsl:attribute name="OldValue"><xsl:value-of
														select="pa_srta/@old" />
															</xsl:attribute>
												</xsl:if> 新的CR，flightscheduledate是可以修改的-->
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

											<!-- need to confer -->
											<xsl:for-each select="pa_ral_airline/ref_airline">
												<DetailedIdentity>												  
													<AirlineIATACode>
													   <xsl:value-of select="$ral_2lc" />
													</AirlineIATACode>
													<AirlineICAOCode>
													<xsl:if test="../../@action='delete'">
														<xsl:value-of select="normalize-space(ral_3lc/@old)"/>
													</xsl:if>
													<xsl:if test="not(../../@action) or ../../@action!='delete'">
														<xsl:value-of select="normalize-space(ral_3lc/text())"/>
													</xsl:if>
													</AirlineICAOCode>
													<!-- change flightnumber mapping rule as flightnumber= flightidentity-pa_ral_airline  -->
													<FlightNumber>
														<xsl:variable name="flightNumber" select="../../pa_flightnumber" />
														<xsl:if test="../../pa_flightnumber/@old">
															<xsl:attribute name="OldValue">
																<xsl:value-of select="javacode:getFlightNumber($flightNumber/@old, $pa_ral_airline)" />
																</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="javacode:getFlightNumber($flightNumber, $pa_ral_airline)" />
													</FlightNumber>
													<FlightSuffix>
														<xsl:variable name="flightNumber" select="../../pa_flightnumber" />
														<xsl:if test="../../pa_flightnumber/@old">
															<xsl:attribute name="OldValue">
																<xsl:value-of
																select="javacode:getFlightSuffix($flightNumber/@old)" />
																</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="javacode:getFlightSuffix($flightNumber)" />
													</FlightSuffix>
												</DetailedIdentity>
											</xsl:for-each>
										</FlightKey>
									</PrimaryKey>
								</xsl:for-each>

								<FlightData>
									<General>
										<xsl:for-each select="pt_pa_arrival/pl_arrival">
											<FlightScheduledDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pa_srta" />
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
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pa_rstc_servicetypecode" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
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
												    <xsl:for-each
														select="pl_routing_list/pl_routing/prt_rap_airport/ref_airport">
														<!-- add by zzhao 2014-01-21 -->
														<xsl:sort select="../../prt_numberinleg"/>
														<!-- udpate by zzhao 2013-09-06 -->
														<xsl:variable name="viaAirport" select="rap_iata3lc" />
														<xsl:if test="$iataOrigAirport!=$viaAirport">
														<IATAViaAirport>
														    <!--oldvalue1  -->
														    <xsl:if test="rap_iata3lc/@old">
															   <xsl:attribute name="OldValue">
																<xsl:value-of select="rap_iata3lc/@old" />
															   </xsl:attribute>
														    </xsl:if>
															<xsl:value-of select="$viaAirport" />
														</IATAViaAirport>
														</xsl:if>
													</xsl:for-each>
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
													<xsl:for-each
														select="pl_routing_list/pl_routing/prt_rap_airport/ref_airport">
														<!-- add by zzhao 2014-01-21 -->
														<xsl:sort select="../../prt_numberinleg"/>
														<!-- udpate by zzhao 2013-09-06 -->	
														<xsl:variable name="viaAirport" select="rap_icao4lc" />
														<xsl:if test="$icaoOrigAirport!=$viaAirport">
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
												</ICAORoute>
											</FlightRoute>

											<FlightCountryType>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pa_rctt_countrytype/ref_countrytype/rctt_code" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</FlightCountryType>

											
											<!-- mod by zzhao 2014-03-31 -->
											<xsl:choose>
											<xsl:when test="../../pt_pd_departure/pl_departure/pd_idseq">
											<LinkFlight>
											<xsl:for-each select="../../pt_pd_departure/pl_departure">
															<FlightScheduledDate>
																<xsl:call-template name="xsltTemplate4Date">
																	<xsl:with-param name="inElement" select="pd_srtd" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />																
																</xsl:call-template>																													
															</FlightScheduledDate>
															<FlightIdentity>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pd_flightnumber" />
																	<xsl:with-param name="needAddNil"
																		select="false()" />
																</xsl:call-template>
															</FlightIdentity>
															<FlightDirection>D</FlightDirection>
															<BaseAirport>
																<AirportIATACode>NKG</AirportIATACode>
																<AirportICAOCode>ZSNJ</AirportICAOCode>
															</BaseAirport>
															<DetailedIdentity>
																<AirlineIATACode>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pd_ral_airline/ref_airline/ral_2lc" />
																		<xsl:with-param name="needAddNil"
																			select="false()" />
																	</xsl:call-template>
																</AirlineIATACode>
																<AirlineICAOCode>
																	<xsl:call-template name="xsltTemplate">
																		<xsl:with-param name="inElement"
																			select="pd_ral_airline/ref_airline/ral_3lc" />
																		<xsl:with-param name="needAddNil"
																			select="false()" />
																	</xsl:call-template>
																</AirlineICAOCode>
																<xsl:variable name="flightNumber" select="pd_flightnumber" />
																<!-- change flightnumber mapping rule as flightnumber= flightidentity-pa_ral_airline  -->
																<FlightNumber>
																   <xsl:if test="pd_flightnumber/@old">
																      <xsl:attribute name="OldValue">
																      <xsl:value-of
																			select="javacode:getFlightNumber($flightNumber/@old, $pd_ral_airline)" />
																      </xsl:attribute>
																   </xsl:if>
																	 <xsl:value-of select="javacode:getFlightNumber($flightNumber, $pd_ral_airline)" />
																</FlightNumber>
																<FlightSuffix>
																	<xsl:if test="pd_flightnumber/@old">
																		<xsl:attribute name="OldValue">
																<xsl:value-of
																			select="javacode:getFlightSuffix($flightNumber/@old)" />
																</xsl:attribute>
																	</xsl:if>
																	<xsl:value-of select="javacode:getFlightSuffix($flightNumber)" />
																</FlightSuffix>
															</DetailedIdentity>
												</xsl:for-each>
											</LinkFlight>
											</xsl:when>
                                            <xsl:otherwise>
                                                 <LinkFlight>
                                                 	<FlightScheduledDate xsi:nil="true" />
                                                 	<FlightIdentity />
                                                 	<FlightDirection>D</FlightDirection>
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
												<xsl:if test="pa_pa_mainflight/@old">
													<xsl:attribute name="OldValue">
													<xsl:choose>
														<xsl:when test="pa_pa_mainflight/@old=''">Y</xsl:when>
														<xsl:otherwise>N</xsl:otherwise>
													</xsl:choose>
        											</xsl:attribute>
												</xsl:if>
												<xsl:choose>
													<xsl:when test="pa_pa_mainflight/text()">N</xsl:when>
													<xsl:otherwise>Y</xsl:otherwise>
												</xsl:choose>
											</IsMasterFlight>

											<xsl:choose>
												<xsl:when test="pa_pa_mainflight/text()">
													<MasterOrSlaveFlight>
														<FlightIdentity>
															<xsl:call-template name="xsltTemplate">
																<xsl:with-param name="inElement" select="pa_pa_mainflight" />
																<xsl:with-param name="needAddNil" select="false()" />
															</xsl:call-template>
														</FlightIdentity>
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
														<FlightDirection>A</FlightDirection>
													</MasterOrSlaveFlight>
												</xsl:when>
												<xsl:when test="pl_arrival_list/pl_arrival">
													<xsl:for-each select="pl_arrival_list/pl_arrival">
														<MasterOrSlaveFlight>
															<FlightIdentity>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="pa_flightnumber" />
																	<xsl:with-param name="needAddNil" select="false()" />
																</xsl:call-template>
															</FlightIdentity>
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
															<FlightDirection>A</FlightDirection>
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
											
											<!-- Add by zzhao 2013-06-20;2013-10-11 -->
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
										</xsl:for-each>
									</General>


									<OperationalDateTime>
										<xsl:for-each select="pt_pa_arrival/pl_arrival">
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

											<LandingDateTime>
											    <!--mod by zzhao 2013-10-11  -->
												<ScheduledLandingDateTime>
												    <xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pa_srta" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</ScheduledLandingDateTime>
												<!--Mod by zzhao 2013-06-20 -->
												<EstimatedLandingDateTime>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pa_eldt" />
														<xsl:with-param name="needAddNil" select="true()" />
													</xsl:call-template>
												</EstimatedLandingDateTime>
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
											<!-- Add by zzhao 2014-05-22 -->
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
											
											<!-- Add by zzhao 2013-06-20 -->
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

											<BestKnownDateTime xsi:nil="true" />
										</xsl:for-each>
									</OperationalDateTime>

									<Status>
										<xsl:for-each select="pt_pa_arrival/pl_arrival">
											<OperationStatus>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pa_rrmk_remark" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</OperationStatus>
											<FlightStatus>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pa_rfst_flightstatus" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</FlightStatus>											
											<!--mod by zzhao 2013-10-09 2013-10-14  -->
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
											<!--add by zzhao 2014-05-16  -->
											<xsl:variable name="remark" select="pa_rrmk_remark" />
											<DiversionAirport>
												<AirportIATACode>
												<xsl:if test="$remark='DIVAL'">
												<xsl:if test="pa_rap_previousairport/ref_airport/rap_iata3lc/@old">
													<xsl:attribute name="OldValue">
														<xsl:value-of select="pa_rap_previousairport/ref_airport/rap_iata3lc/@old" />
													</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="pa_rap_previousairport/ref_airport/rap_iata3lc" />
												</xsl:if>
												</AirportIATACode>
												<AirportICAOCode>
												<xsl:if test="$remark='DIVAL'">
												<xsl:if test="pa_rap_previousairport/ref_airport/rap_icao4lc/@old">
													<xsl:attribute name="OldValue">
														<xsl:value-of select="pa_rap_previousairport/ref_airport/rap_icao4lc/@old" />
													</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="pa_rap_previousairport/ref_airport/rap_icao4lc" />
												</xsl:if>
												</AirportICAOCode>
											</DiversionAirport>
											<ChangeLandingAirport>
												<AirportIATACode>
												<xsl:if test="$remark='DIVCH'">
												<xsl:if test="pa_rap_previousairport/ref_airport/rap_iata3lc/@old">
													<xsl:attribute name="OldValue">
														<xsl:value-of select="pa_rap_previousairport/ref_airport/rap_iata3lc/@old" />
													</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="pa_rap_previousairport/ref_airport/rap_iata3lc" />
												</xsl:if>
												</AirportIATACode>
												<AirportICAOCode>
												<xsl:if test="$remark='DIVCH'">
											 	<xsl:if test="pa_rap_previousairport/ref_airport/rap_icao4lc/@old">
													<xsl:attribute name="OldValue">
														<xsl:value-of select="pa_rap_previousairport/ref_airport/rap_icao4lc/@old" />
													</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="pa_rap_previousairport/ref_airport/rap_icao4lc" />
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

											<xsl:variable name="srtaDate" select="substring(pa_srta,1,10)" />
											<xsl:variable name="srtdDate"
												select="substring(../../pt_pd_departure/pl_departure/pd_srtd,1,10)" />
											<IsOverNightFlight>
											    <xsl:call-template name="updateISOVERNIGHT">
													<xsl:with-param name="serviceType" select="$serviceTypeReturn" />
													<xsl:with-param name="messageType" select="$messageType" />
												</xsl:call-template>
												<xsl:choose>
													<xsl:when
														test="javacode:compareString($srtaDate,$srtdDate)
													or $srtaDate='' or $srtdDate=''">N</xsl:when>
													<xsl:otherwise>Y</xsl:otherwise>
												</xsl:choose>
											</IsOverNightFlight>
											<!--add by zzhao 2014-02-26  -->
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
											<!--
 											<IsCashFlight>
												<xsl:if test="pa_paymentmode/@old">
													<xsl:attribute name="OldValue">
													<xsl:choose>
														<xsl:when test="pa_paymentmode/@old='C'">Y</xsl:when>
														<xsl:otherwise>N</xsl:otherwise>
													</xsl:choose>
        											</xsl:attribute>
												</xsl:if>
												<xsl:choose>
													<xsl:when test="pa_paymentmode='C'">Y</xsl:when>
													<xsl:otherwise>N</xsl:otherwise>
												</xsl:choose>
											</IsCashFlight> mod by zzhao 2014-02-26-->
										</xsl:for-each>
									</Status>
                                 <xsl:if test="pt_pa_arrival/pl_arrival/pl_arrivalloadstatistics_list">
									<xsl:for-each select="pt_pa_arrival/pl_arrival/pl_arrivalloadstatistics_list">																						
													<xsl:if test="pl_arrivalloadstatistics">													   
														<xsl:for-each select="pl_arrivalloadstatistics">
														  <!--Add by zzhao 2013-06-20 -->
														  <Payload>
															<DepartureAirport>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="pals_rap_airportfrom" />
																	<xsl:with-param name="needAddNil"
																		select="false()" />
																</xsl:call-template>
															</DepartureAirport>
															<DestinationAirport>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="pals_rap_airportto" />
																	<xsl:with-param name="needAddNil"
																		select="false()" />
																</xsl:call-template>
															</DestinationAirport>
															<Passenger>
																<PassengersNumber>
																	<TotalPassengersNumber>
																	   <xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_pax" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																		<!-- <xsl:value-of select="sum(pals_pax)" /> -->
																	</TotalPassengersNumber>
																	<FirstClassPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_paxf" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																		<!-- <xsl:value-of
																			select="sum(pals_paxf)" /> -->
																	</FirstClassPassengersNumber>
																	<BusinessClassPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_paxc" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																		<!-- <xsl:value-of
																			select="sum(pals_paxc)" /> -->
																	</BusinessClassPassengersNumber>
																	<EconomicClassPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_paxy" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																		<!-- <xsl:value-of
																			select="sum(pals_paxy)" /> -->
																	</EconomicClassPassengersNumber>
																</PassengersNumber>

																<AdultPassengers>
																	<TotalAdultPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_adult" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																		<!-- <xsl:value-of
																			select="sum(pals_adult)" /> -->
																	</TotalAdultPassengersNumber>
																	<FirstClassAdultPassengersNumber>
																	  <xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_adultf" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																	<!-- 	<xsl:value-of
																			select="sum(pals_adultf)" /> -->
																	</FirstClassAdultPassengersNumber>
																	<BusinessClassAdultPassengersNumber>
																	   <xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_adultc" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																		<!-- <xsl:value-of
																			select="pals_adultc)" /> -->
																	</BusinessClassAdultPassengersNumber>
																	<EconomicClassAdultPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_adulty" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																		<!-- <xsl:value-of
																			select="pals_adulty" /> -->
																	</EconomicClassAdultPassengersNumber>
																</AdultPassengers>
																<ChildPassengers>
																	<TotalChildPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_child" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																	<!-- 	<xsl:value-of
																			select="pals_child" /> -->
																	</TotalChildPassengersNumber>
																	<FirstClassChildPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_childf" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																		<!-- <xsl:value-of
																			select="pals_childf" /> -->
																	</FirstClassChildPassengersNumber>
																	<BusinessClassChildPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_childc" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																		<!-- <xsl:value-of
																			select="pals_childc" /> -->
																	</BusinessClassChildPassengersNumber>
																	<EconomicClassChildPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_childy" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																	<!-- 	<xsl:value-of
																			select="pals_childy" /> -->
																	</EconomicClassChildPassengersNumber>
																</ChildPassengers>
																<InfantPassengers>
																	<TotalInfantPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_infant" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																		<!-- <xsl:value-of
																			select="pals_infant" /> -->
																	</TotalInfantPassengersNumber>
																	<FirstClassInfantPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_infantf" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																		<!-- <xsl:value-of
																			select="pals_infantf" /> -->
																	</FirstClassInfantPassengersNumber>
																	<BusinessClassInfantPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_infantc" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																<!-- 		<xsl:value-of
																			select="pals_infantc" /> -->
																	</BusinessClassInfantPassengersNumber>
																	<EconomicClassInfantPassengersNumber>
																	<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_infanty" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																	<!-- 	<xsl:value-of
																			select="pals_infanty" /> -->
																	</EconomicClassInfantPassengersNumber>
																</InfantPassengers>
															</Passenger>
															<Weight>
																<TotalWeight>
																<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_totalweight" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																	<!-- <xsl:value-of
																		select="pals_totalweight" /> -->
																</TotalWeight>
																<BaggageWeight>
																<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_baggageweight" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																	<!-- <xsl:value-of
																		select="pals_baggageweight" /> -->
																</BaggageWeight>
																<CargoWeight>
																<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_cargoweight" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																	<!-- <xsl:value-of
																		select="pals_cargoweight" /> -->
																</CargoWeight>
																<MailWeight>
																<xsl:call-template name="xsltTemplate">
																	      <xsl:with-param name="inElement"
																		     select="pals_mailweight" />
																	      <xsl:with-param name="needAddNil"
																		select="true()" />
																       </xsl:call-template>
																	<!-- <xsl:value-of
																		select="pals_mailweight" /> -->
																</MailWeight>
															</Weight>
														  </Payload>
														</xsl:for-each>														
													</xsl:if>										
										</xsl:for-each>
									</xsl:if>									

									<Airport>
										<!-- Mapping for the Terminalv of Airport -->
										<Terminal>
											<xsl:for-each select="pt_pa_arrival/pl_arrival">
												<FlightTerminalID>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pa_rtrm_terminal" />
														<xsl:with-param name="needAddNil" select="false()" />
													</xsl:call-template>
												</FlightTerminalID>
												<AircraftTerminalID />
											</xsl:for-each>
										</Terminal>

										<!-- Mapping for the Runway of Airport -->
										<Runway>
											<xsl:for-each select="pt_pa_arrival/pl_arrival">
												<RunwayID>
													<xsl:call-template name="xsltTemplate">
														<xsl:with-param name="inElement" select="pa_rrwy_runway" />
														<xsl:with-param name="needAddNil" select="false()" />
													</xsl:call-template>
												</RunwayID>
											</xsl:for-each>
										</Runway>

										<!-- Mapping for the Stand of Airport -->
										<xsl:for-each select="pl_stand_list">
											<xsl:choose>
												<xsl:when test="pl_stand">
													<xsl:for-each select="pl_stand">
														<Stand>
															<StandID>
																<xsl:call-template name="updateStandID">
																	<xsl:with-param name="inElement" select="pst_rsta_stand" />
																	<xsl:with-param name="ref_standid" select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/pa_rsta_refstand/ref_stand/rsta_code"/>																	
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

										<!-- Mapping fo the Gate of Airport -->
										<xsl:for-each select="pt_pa_arrival/pl_arrival/pl_arrivalgate_list">
											<xsl:choose>
												<xsl:when test="pl_arrivalgate">
													<xsl:for-each select="pl_arrivalgate">
														<Gate>
															<GateID>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pag_rgt_gate" />
																	<xsl:with-param name="needAddNil"
																		select="false()" />
																</xsl:call-template>
															</GateID>
															<GateStatus>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pag_status" />
																	<xsl:with-param name="needAddNil"
																		select="false()" />
																</xsl:call-template>
															</GateStatus>
															<ScheduledGateStartDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pag_beginplan" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ScheduledGateStartDateTime>
															<ScheduledGateEndDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pag_endplan" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ScheduledGateEndDateTime>
															<ActualGateStartDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pag_beginactual" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ActualGateStartDateTime>
															<ActualGateEndDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pag_endactual" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ActualGateEndDateTime>
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

										<!-- Mapping for the BaggageReclaim of Airport -->
										<xsl:for-each select="pt_pa_arrival/pl_arrival/pl_baggagebelt_list">
											<xsl:choose>
												<xsl:when test="pl_baggagebelt">
													<xsl:for-each select="pl_baggagebelt">
														<BaggageReclaim>
															<BaggageReclaimID>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement"
																		select="pbb_rbb_baggagebelt" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</BaggageReclaimID>
															<ScheduledReclaimStartDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pbb_beginplan" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ScheduledReclaimStartDateTime>
															<ScheduledReclaimEndDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pbb_endplan" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ScheduledReclaimEndDateTime>
															<ActualReclaimStartDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pbb_beginactual" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ActualReclaimStartDateTime>
															<ActualReclaimEndDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pbb_endactual" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</ActualReclaimEndDateTime>
															<FirstBaggageDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pbb_firstbag" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</FirstBaggageDateTime>
															<LastBaggageDateTime>
																<xsl:call-template name="xsltTemplate">
																	<xsl:with-param name="inElement" select="pbb_lastbag" />
																	<xsl:with-param name="needAddNil"
																		select="true()" />
																</xsl:call-template>
															</LastBaggageDateTime>
														</BaggageReclaim>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<BaggageReclaim>
														<BaggageReclaimID xsi:nil="true" />
														<ScheduledReclaimStartDateTime
															xsi:nil="true" />
														<ScheduledReclaimEndDateTime
															xsi:nil="true" />
														<ActualReclaimStartDateTime
															xsi:nil="true" />
														<ActualReclaimEndDateTime
															xsi:nil="true" />
														<FirstBaggageDateTime xsi:nil="true" />
														<LastBaggageDateTime xsi:nil="true" />
													</BaggageReclaim>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>

									</Airport>
								</FlightData>
							</Data>
						</xsl:for-each>
					</xsl:if>

					<!--RUS rm_closing request mapping work -->
					<xsl:if test="$dataType='rm_closing'">
						<xsl:for-each select="rm_closing">
							<Data>
								<PrimaryKey>
									<ResourceKey>
										<ResourceCategory>
											<xsl:call-template name="resourceTypeConvert">
												<xsl:with-param name="resourceType" select="rcl_resourcetype" />
											</xsl:call-template>
										</ResourceCategory>
										<ResourceID>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rcl_resourcename" />
												<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
											</xsl:call-template>
										</ResourceID>
									</ResourceKey>
								</PrimaryKey>
								<ResourceData>
									<Closing>
										<ClosingScheduledFromDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rcl_beginplantime" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</ClosingScheduledFromDateTime>
										<ClosingScheduledEndDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rcl_endplantime" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</ClosingScheduledEndDateTime>
										<ClosingActualFromDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rcl_beginactual" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</ClosingActualFromDateTime>
										<ClosingActualEndDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rcl_endactual" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</ClosingActualEndDateTime>
										<CommentFreeText>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rcl_reason" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</CommentFreeText>
									</Closing>
								</ResourceData>
							</Data>
						</xsl:for-each>
					</xsl:if>

					<xsl:if test="$dataType='pl_desk'">
						<xsl:for-each select="pl_desk">
							<Data>
								<PrimaryKey>
									<ResourceKey>
										<ResourceCategory>CommonCheckInDesk</ResourceCategory>
										<ResourceID>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pdk_rcnt_mastercci" />
												<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
											</xsl:call-template>
										</ResourceID>
									</ResourceKey>
								</PrimaryKey>
								<ResourceData>
									<CommonCheckInDesk>
										<CheckInGroupName>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pdk_rcnt_mastercci" />
												<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
											</xsl:call-template>
										</CheckInGroupName>
										<CheckInDeskID>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="pdk_rcnt_refcounter/ref_counter/rcnt_code" />
												<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
											</xsl:call-template>
										</CheckInDeskID>
										<CheckInClassService>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="pdk_checkinclassid" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</CheckInClassService>										
										<ScheduledStartAvailableDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pdk_beginplan" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</ScheduledStartAvailableDateTime>
										<ScheduledEndAvailableDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pdk_endplan" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</ScheduledEndAvailableDateTime>
									</CommonCheckInDesk>
								</ResourceData>
							</Data>
						</xsl:for-each>
					</xsl:if>

					<xsl:if test="starts-with($dataType,'et_gs')">
						<Data>
							<PrimaryKey>
								<GroundServiceDataKey>
									<GroundServiceDataCategory>
										<xsl:if test="$dataType='et_gs_staff'">
											Staff
										</xsl:if>
										<xsl:if test="$dataType='et_gs_service'">
											Service
										</xsl:if>
										<xsl:if test="$dataType='et_gs_task'">
											Task
										</xsl:if>
									</GroundServiceDataCategory>
									<GroundServiceDataID>
										<xsl:if test="$dataType='et_gs_staff'">
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="et_gs_staff/assignmentid" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$dataType='et_gs_service'">
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="et_gs_service/serviceid" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$dataType='et_gs_task'">
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="et_gs_task/taskid" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</xsl:if>
									</GroundServiceDataID>
								</GroundServiceDataKey>
							</PrimaryKey>
							<GroundServiceData>
								<xsl:for-each select="et_gs_service">
									<Service>
										<ServiceID>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="serviceid" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</ServiceID>
										<FlightIdentity>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="flightnumber" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</FlightIdentity>
										<FlightScheduledDate>
											<xsl:if test="stt/@old">
												<xsl:attribute name="OldValue"><xsl:value-of
													select="stt/@old" />
													</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="substring(stt,1,10)" />
										</FlightScheduledDate>
										<FlightDirection>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="flightdirection" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</FlightDirection>
										<ServiceName>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="servicename" />
												<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
											</xsl:call-template>
										</ServiceName>
										<ServiceScheduleStartDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="serviceschedulestart" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ServiceScheduleStartDateTime>
										<ServiceScheduleEndDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="servicescheduleend" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ServiceScheduleEndDateTime>
										<ServiceActualStartDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="serviceactualstart" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ServiceActualStartDateTime>
										<ServiceActualEndDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="serviceactualend" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ServiceActualEndDateTime>
										<ServiceExceptionType>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="serviceexceptiontype" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ServiceExceptionType>
										<ServiceExceptionReason>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="serviceexceptionreason" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</ServiceExceptionReason>
									</Service>
								</xsl:for-each>
								<xsl:for-each select="et_gs_staff">
									<Staff>
										<AssignmentID>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="assignmentid" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</AssignmentID>
										<StaffName>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="staffname" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</StaffName>
										<StaffCode>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="staffcode" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</StaffCode>
										<StaffSkill>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="staffskill" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</StaffSkill>
										<StaffScheduledOndutyDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="staffscheduledonduty" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</StaffScheduledOndutyDateTime>
										<StaffScheduledOffdutyDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="staffscheduledoffduty" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</StaffScheduledOffdutyDateTime>
										<StaffActualOndutyDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="staffactualonduty" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</StaffActualOndutyDateTime>
										<StaffActualOffdutyDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="staffactualoffduty" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</StaffActualOffdutyDateTime>
										<StaffExceptionType>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="stafflexceptiontype" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</StaffExceptionType>
										<StaffExceptionReason>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="staffexceptionreason" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</StaffExceptionReason>
									</Staff>
								</xsl:for-each>
								<xsl:for-each select="et_gs_task">
									<Task>
										<TaskID>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskid" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</TaskID>
										<FlightIdentity>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="flightnumber" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</FlightIdentity>
										<FlightScheduledDate>
											<xsl:if test="stt/@xsi:nil='true' or not(stt)">
												<xsl:attribute name="xsi:nil">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="stt/@old">
												<xsl:attribute name="OldValue"><xsl:value-of
													select="stt/@old" />
													</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="substring(stt,1,10)" />
										</FlightScheduledDate>
										<FlightDirection>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="flightdirection" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</FlightDirection>
										<ServiceID>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="serviceid" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</ServiceID>
										<TaskName>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskname" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</TaskName>
										<TaskScheduledStartDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskskdstart" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskScheduledStartDateTime>
										<TaskScheduledEndDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskskdend" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskScheduledEndDateTime>
										<TaskScheduledMobileFacilityName>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="taskskdmobilefacilityname" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskScheduledMobileFacilityName>
										<TaskScheduledLicense>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskskdlicense" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskScheduledLicense>
										<TaskScheduledMobileFacilityUsage>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="taskskdmobilefacilityusage" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskScheduledMobileFacilityUsage>
										<TaskScheduledInput>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskskdinput" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskScheduledInput>
										<TaskScheduledOutput>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskskdoutput" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskScheduledOutput>
										<TaskScheduledExecutionSequence>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="taskskdexecutionsequence" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskScheduledExecutionSequence>
										<TaskScheduledStaffName>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskskdstaffname" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskScheduledStaffName>
										<TaskScheduledStaffCode>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskskdstaffcode" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskScheduledStaffCode>
										<TaskScheduledStaffSkill>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskskdstaffskill" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskScheduledStaffSkill>
										<TaskActualStartDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskactstart" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskActualStartDateTime>
										<TaskActualEndDateTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskactend" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskActualEndDateTime>
										<TaskActualMobileFacilityName>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="taskactmobilefacilityname" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskActualMobileFacilityName>
										<TaskActualLicense>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskactlicense" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskActualLicense>
										<TaskActualMobileFacilityUsage>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="taskactmobilefacilityusage" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskActualMobileFacilityUsage>
										<TaskActualInput>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskactinput" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskActualInput>
										<TaskActualOutput>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskactoutput" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskActualOutput>
										<TaskActualExecutionSequence>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="taskactexecutionsequence" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskActualExecutionSequence>
										<TaskActualStaffName>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskactstaffname" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskActualStaffName>
										<TaskActualStaffCode>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskactstaffcode" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskActualStaffCode>
										<TaskActualStaffSkill>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="taskactstaffskill" />
												<xsl:with-param name="needAddNil" select="true()" />
											</xsl:call-template>
										</TaskActualStaffSkill>
									</Task>
								</xsl:for-each>
							</GroundServiceData>
						</Data>
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

				<xsl:if test="$messageType='ACK' and $aodb_servicetype = 'DATASET'">
					<Operation>
						<Subscription>
							<SubscribeResponse>
								<SubscriptionStatus>End</SubscriptionStatus>
								<SubscriptionRequestID>
									<xsl:value-of select="$correlationId" />
								</SubscriptionRequestID>
								<SyncMessageCount>0</SyncMessageCount>
							</SubscribeResponse>
						</Subscription>
					</Operation>
				</xsl:if>

				<xsl:if test="$messageType='NACK' and $aodb_servicetype = 'DATASET'">
					<Operation>
						<Subscription>
							<SubscribeResponse>
								<SubscriptionStatus>Error</SubscriptionStatus>
								<SubscriptionRequestID>
									<xsl:value-of select="$correlationId" />
								</SubscriptionRequestID>
							</SubscribeResponse>
						</Subscription>
						<SystemException>
							<ExceptionCode>001</ExceptionCode>
							<ExceptionMessage>
								<xsl:value-of select="soap-env:Fault/detail" />
							</ExceptionMessage>
						</SystemException>
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
		<xsl:value-of select="normalize-space($inElement/text())" />
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
		<xsl:param name="serviceType" />
		<xsl:param name="messageType" />
		<xsl:variable name="action">
			<xsl:choose>
			    <!-- update by zzhao 2013-08-27 -->
				<xsl:when test="contains($serviceType,'FSS')">
					<xsl:value-of select="pl_turn/pt_pa_arrival/pl_arrival/@action[1]" />
				</xsl:when>
				<xsl:when
					test="contains($serviceType,'BSS') or contains($serviceType, 'RSS')">
					<xsl:value-of select="*[1]//@action[1]" />
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
	<xsl:template name="resourceTypeConvert">
		<xsl:param name="resourceType" />
		<xsl:if test="$resourceType='RSTA'">Stand</xsl:if>
		<xsl:if test="$resourceType='RBB'">BaggageReclaim</xsl:if>
		<xsl:if test="$resourceType='RGT'">Gate</xsl:if>
		<xsl:if test="$resourceType='RCNT'">CheckInDesk</xsl:if>
		<xsl:if test="$resourceType='RDB'">BaggageMakeup</xsl:if>
		<xsl:if test="$resourceType='RAB'">BoardingBridge</xsl:if>
	</xsl:template>
	
	<!--update to fix subsystem can not receive the stand update information 
	    for some special operation-->
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
				<xsl:when test="contains($serviceType,'FSS1') and /soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/@action[1]">
					   <xsl:value-of select="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival/@action[1]" />
				</xsl:when>
				<xsl:otherwise>update</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$action='update' and contains($serviceType,'FSS1') and /soap-env:Envelope/soap-env:Body/pl_turn/pt_pd_departure/pl_departure/pd_flightnumber/@old"><xsl:attribute name="OldValue"></xsl:attribute></xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>