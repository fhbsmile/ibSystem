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
							<xsl:when test="$aodbBodyDataType='ref_aircraft'">
								<xsl:value-of select="ref_aircraft/rac_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_terminal'">
								<xsl:value-of select="ref_terminal/rtrm_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_runway'">
								<xsl:value-of select="ref_runway/rrwy_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_stand'">
								<xsl:value-of select="ref_stand/rsta_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_counter'">
								<xsl:value-of select="ref_counter/rcnt_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_departurebelt'">
								<xsl:value-of select="ref_departurebelt/rdb_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_gate'">
								<xsl:value-of select="ref_gate/rgt_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_baggagebelt'">
								<xsl:value-of select="ref_baggagebelt/rbb_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_airline'">
								<xsl:value-of select="ref_airline/ral_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_handlingagent'">
								<xsl:value-of select="ref_handlingagent/rha_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_airport'">
								<xsl:value-of select="ref_airport/rap_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_passengerclass'">
								<xsl:value-of select="ref_passengerclass/rpc_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_remark'">
								<xsl:value-of select="ref_remark/rrmk_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_aircrafttype'">
								<xsl:value-of select="ref_aircrafttype/ract_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_country'">
								<xsl:value-of select="ref_country/rctr_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_servicetypecode'">
								<xsl:value-of select="ref_servicetypecode/rstc_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='ref_delayreason'">
								<xsl:value-of select="ref_delayreason/rdlr_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='rm_closing'">
								<xsl:value-of select="rm_closing/rcl_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='pl_desk'">
								<xsl:value-of select="pl_desk/pdk_modtime"></xsl:value-of>
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='et_gs_staff'">
								<xsl:value-of select="et_gs_staff/egst_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='et_gs_service'">
								<xsl:value-of select="et_gs_service/egs_modtime" />
							</xsl:when>
							<xsl:when test="$aodbBodyDataType='et_gs_task'">
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
				<xsl:if test="$aodbMessageType!='ACK' and $aodbMessageType!='NACK'">
					<xsl:if test="starts-with($aodbBodyDataType,'ref')">
						<Data>
							<PrimaryKey>
								<BasicDataKey>
									<xsl:if test="$aodbBodyDataType='ref_aircraft'">
										<BasicDataCategory>Aircraft</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_terminal'">
										<BasicDataCategory>Terminal</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_runway'">
										<BasicDataCategory>Runway</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_stand'">
										<BasicDataCategory>Stand</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_counter'">
										<BasicDataCategory>CheckInDesk</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_departurebelt'">
										<BasicDataCategory>BaggageMakeup</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_gate'">
										<BasicDataCategory>Gate</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_baggagebelt'">
										<BasicDataCategory>BaggageReclaim</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_airline'">
										<BasicDataCategory>Airline</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_handlingagent'">
										<BasicDataCategory>Handler</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_airport'">
										<BasicDataCategory>Airport</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_passengerclass'">
										<BasicDataCategory>PassengerClass</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_remark'">
										<BasicDataCategory>FlightOperationCode</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_aircrafttype'">
										<BasicDataCategory>AircraftType</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_country'">
										<BasicDataCategory>Country</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_servicetypecode'">
										<BasicDataCategory>FlightServiceType</BasicDataCategory>
									</xsl:if>
									<xsl:if test="$aodbBodyDataType='ref_delayreason'">
										<BasicDataCategory>DelayCode</BasicDataCategory>
									</xsl:if>
									<BasicDataID>
										<xsl:if test="$aodbBodyDataType='ref_aircraft'">
											<xsl:value-of select="ref_aircraft/rac_registration" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_terminal'">
											<xsl:value-of select="ref_terminal/rtrm_code" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_runway'">
											<xsl:value-of select="ref_runway/rrwy_code" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_stand'">
											<xsl:value-of select="ref_stand/rsta_code" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_counter'">
											<xsl:value-of select="ref_counter/rcnt_code" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_departurebelt'">
											<xsl:value-of select="ref_departurebelt/rdb_code" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_gate'">
											<xsl:value-of select="ref_gate/rgt_code" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_baggagebelt'">
											<xsl:value-of select="ref_baggagebelt/rbb_code" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_airline'">
											<xsl:value-of select="ref_airline/ral_2lc"></xsl:value-of>
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_handlingagent'">
											<xsl:value-of select="ref_handlingagent/rha_code" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_airport'">
											<xsl:value-of select="ref_airport/rap_iata3lc" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_passengerclass'">
											<xsl:value-of select="ref_passengerclass/rpc_code" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_remark'">
											<xsl:value-of select="ref_remark/rrmk_code" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_aircrafttype'">
											<xsl:value-of select="ref_aircrafttype/ract_iatatype" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_country'">
											<xsl:value-of select="ref_country/rctr_code" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_servicetypecode'">
											<xsl:value-of select="ref_servicetypecode/rstc_code" />
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='ref_delayreason'">
											<xsl:value-of select="ref_delayreason/rdlr_codenumeric" />
										</xsl:if>
									</BasicDataID>
								</BasicDataKey>
							</PrimaryKey>
							<!-- The next will judge the ref_aircraft -->
							<xsl:if test="$aodbBodyDataType='ref_aircraft'">
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
													<xsl:with-param name="inElement" select="rac_ract_aircrafttype/ref_aircrafttype/ract_iatatype" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</AircraftTypeIATACode>
											<AircraftTypeICAOCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rac_ract_aircrafttype/ref_aircrafttype/ract_icaotype" />
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
							<xsl:if test="$aodbBodyDataType='ref_aircrafttype'">
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
													<xsl:with-param name="inElement" select="ract_averageseatcapacity" />
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
													<xsl:with-param name="inElement" select="ract_rnca_noisecategory" />
													<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
												</xsl:call-template>
											</AircraftNoiseCategory>
											<BoardingBridgeRequired>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ract_bridgerequiredind" />
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
							<xsl:if test="$aodbBodyDataType='ref_terminal'">
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
							<xsl:if test="$aodbBodyDataType='ref_runway'">
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
							<xsl:if test="$aodbBodyDataType='ref_stand'">
								<BasicData>
									<Stand>
										<xsl:for-each select="ref_stand">
											<StandCode>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="rsta_code" />
													<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
												</xsl:call-template>
											</StandCode>
											<!--mod by zzhao 2013-11-07 -->
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
							<xsl:if test="$aodbBodyDataType='ref_counter'">
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
							<xsl:if test="$aodbBodyDataType='ref_departurebelt'">
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
							<xsl:if test="$aodbBodyDataType='ref_gate'">
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
											<!--add by zzhao at 2013-08-27 -->
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
							<xsl:if test="$aodbBodyDataType='ref_baggagebelt'">
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
							<xsl:if test="$aodbBodyDataType='ref_airline'">
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
							<xsl:if test="$aodbBodyDataType='ref_handlingagent'">
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
							<xsl:if test="$aodbBodyDataType='ref_airport'">
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
							<xsl:if test="$aodbBodyDataType='ref_passengerclass'">
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
							<xsl:if test="$aodbBodyDataType='ref_remark'">
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
							<xsl:if test="$aodbBodyDataType='ref_servicetypecode'">
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
							<xsl:if test="$aodbBodyDataType='ref_country'">
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
							<xsl:if test="$aodbBodyDataType='ref_delayreason'">
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
						<!-- <xsl:variable name="pa_ral_airline" select="normalize-space(pl_turn/pt_pa_arrival/pl_arrival/pa_ral_airline/text())" /> <xsl:variable name="pd_ral_airline" 
							select="normalize-space(pl_turn/pt_pd_departure/pl_departure/pd_ral_airline/text())" /> -->
						<xsl:variable name="pd_ral_airline">
							<xsl:if test="pl_turn/pt_pd_departure/pl_departure/@action='delete'">
								<xsl:value-of select="normalize-space(pl_turn/pt_pd_departure/pl_departure/pd_ral_airline/@old)" />
							</xsl:if>
							<xsl:if test="not(pl_turn/pt_pd_departure/pl_departure/@action) or pl_turn/pt_pd_departure/pl_departure/@action!='delete'">
								<xsl:value-of select="normalize-space(pl_turn/pt_pd_departure/pl_departure/pd_ral_airline/text())" />
							</xsl:if>
						</xsl:variable>
						<xsl:variable name="pa_ral_airline">
							<xsl:if test="pl_turn/pt_pa_arrival/pl_arrival/@action='delete'">
								<xsl:value-of select="normalize-space(pl_turn/pt_pa_arrival/pl_arrival/pa_ral_airline/@old)" />
							</xsl:if>
							<xsl:if test="not(pl_turn/pt_pa_arrival/pl_arrival/@action) or pl_turn/pt_pa_arrival/pl_arrival/@action!='delete'">
								<xsl:value-of select="normalize-space(pl_turn/pt_pa_arrival/pl_arrival/pa_ral_airline/text())" />
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
							<xsl:if test="/soap-env:Envelope/soap-env:Body/pl_turn/pt_pa_arrival/pl_arrival">
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
														select="pa_rap_originairport" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</IATAOriginAirport>
											<IATAPreviousAirport>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pa_rap_previousairport" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</IATAPreviousAirport>
											<IATAFullRoute>
												<xsl:for-each select="pl_routing_list/pl_routing">
													<xsl:sort select="prt_numberinleg" />
													<xsl:variable name="legNo" select="prt_numberinleg" />
													<xsl:variable name="viaAirport" select="prt_rap_airport" />
													<AirportIATACode>
														<xsl:attribute name="LegNo">
													<xsl:value-of select="$legNo" />
														</xsl:attribute>
														<xsl:if test="prt_rap_airport/@old">

															<xsl:attribute name="OldValue">
															<xsl:value-of
																select="prt_rap_airport/@old" />
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
														select="pa_rap_reforiginairport/ref_airport/rap_icao4lc" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</ICAOOriginAirport>
											<ICAOPreviousAirport>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement"
														select="pa_rap_refpreviousairport/ref_airport/rap_icao4lc" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</ICAOPreviousAirport>
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
										        <xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="pa_rap_diversionairport" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</AirportIATACode>
										<AirportICAOCode>
												 <xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement"
													select="pa_rap_diversionairport/pa_rap_refdiversionairport/ref_airport.rap_icao4lc" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</AirportICAOCode>
									</DiversionAirport>
									<ChangeLandingAirport>
										<AirportIATACode />
										<AirportICAOCode />
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
									<PassengerAmount>
											<TotalPassengers>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pa_totalpax" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</TotalPassengers>
											<TransferPassengers>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pa_transferpax" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</TransferPassengers>
											<TransitPassengers>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pa_transitpax" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</TransitPassengers>
											<TotalCrews>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pa_totalcrew" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</TotalCrews>
											<TotalExtraCrews>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pa_totalextracrew" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</TotalExtraCrews>
									</PassengerAmount>
								</Airport>
								<SpecialServices>
								<xsl:for-each select="pl_specialservice_list">
										<xsl:choose>
											<xsl:when test="pl_specialservice">
												<xsl:for-each select="pl_specialservice">
												<SpecialService>
											<SpecialServiceID>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pss_idseq" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</SpecialServiceID>
											<SpecialServiceType>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pss_type" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</SpecialServiceType>
											<SpecialServiceAmountPlanned>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pss_amountplanned" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</SpecialServiceAmountPlanned>	
											<SpecialServiceAmountUsed>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pss_amount" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</SpecialServiceAmountUsed>	
											<SpecialServiceAmountPayable>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pss_amountpayable" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</SpecialServiceAmountPayable>	
											<SpecialServiceBeginDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pss_begin" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</SpecialServiceBeginDateTime>	
											<SpecialServiceEndDateTime>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pss_end" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</SpecialServiceEndDateTime>	
											<SpecialServicePayable>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pss_payable" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</SpecialServicePayable>	
											<SpecialServiceDeliveryNote>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pss_deliverynote" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</SpecialServiceDeliveryNote>	
											<SpecialServiceReceipt>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pss_receipt" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</SpecialServiceReceipt>	
											<SpecialServiceComment>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="pss_comment" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</SpecialServiceComment>	
											<SpecialServiceResourceType>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ref_servicecatalog/rsc_resourcetype" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</SpecialServiceResourceType>	
											<SpecialServiceResourceID>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ref_servicecatalog/rsc_resourceid" />
													<xsl:with-param name="needAddNil" select="false()" />
												</xsl:call-template>
											</SpecialServiceResourceID>	
											<SpecialServiceResourceDescription>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ref_servicecatalog/rsc_description" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</SpecialServiceResourceDescription>	
											<SpecialServiceResourceUnit>
												<xsl:call-template name="xsltTemplate">
													<xsl:with-param name="inElement" select="ref_servicecatalog/rsc_unit" />
													<xsl:with-param name="needAddNil" select="true()" />
												</xsl:call-template>
											</SpecialServiceResourceUnit>		
											</SpecialService>	
											
												
												</xsl:for-each>
												</xsl:when>
												</xsl:choose>
												</xsl:for-each>
								</SpecialServices>
							</FlightData>
							</xsl:if>
						</Data>
					</xsl:for-each>				
					</xsl:if>
					<!--RUS rm_closing request mapping work -->
					<xsl:if test="$aodbBodyDataType='rm_closing'">
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
					<xsl:if test="$aodbBodyDataType='pl_desk'">
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
												<xsl:with-param name="inElement" select="pdk_rcnt_refcounter/ref_counter/rcnt_code" />
												<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
											</xsl:call-template>
										</CheckInDeskID>
										<CheckInClassService>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="pdk_checkinclassid" />
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
					<xsl:if test="starts-with($aodbBodyDataType,'et_gs')">
						<Data>
							<PrimaryKey>
								<GroundServiceDataKey>
									<GroundServiceDataCategory>
										<xsl:if test="$aodbBodyDataType='et_gs_staff'">
											Staff
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='et_gs_service'">
											Service
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='et_gs_task'">
											Task
										</xsl:if>
									</GroundServiceDataCategory>
									<GroundServiceDataID>
										<xsl:if test="$aodbBodyDataType='et_gs_staff'">
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="et_gs_staff/assignmentid" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='et_gs_service'">
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="et_gs_service/serviceid" />
												<xsl:with-param name="needAddNil" select="false()" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$aodbBodyDataType='et_gs_task'">
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
												<xsl:attribute name="OldValue"><xsl:value-of select="stt/@old" />
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
												<xsl:attribute name="OldValue"><xsl:value-of select="stt/@old" />
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
												<xsl:with-param name="inElement" select="taskskdmobilefacilityname" />
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
												<xsl:with-param name="inElement" select="taskskdmobilefacilityusage" />
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
												<xsl:with-param name="inElement" select="taskskdexecutionsequence" />
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
												<xsl:with-param name="inElement" select="taskactmobilefacilityname" />
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
												<xsl:with-param name="inElement" select="taskactmobilefacilityusage" />
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
												<xsl:with-param name="inElement" select="taskactexecutionsequence" />
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
				<xsl:if test="$aodbMessageType='ACK'  and $aodbOrgMessageType = 'DATASET'">
					<Operation>
						<Subscription>
							<SubscribeResponse>
								<SubscriptionStatus>End</SubscriptionStatus>
								<SubscriptionRequestID>
									<xsl:value-of select="$aodbCorrelationId" />
								</SubscriptionRequestID>
								<SyncMessageCount>0</SyncMessageCount>
							</SubscribeResponse>
						</Subscription>
					</Operation>
				</xsl:if>
				<xsl:if test="$aodbMessageType='NACK' and $aodbOrgMessageType = 'DATASET'">
					<Operation>
						<Subscription>
							<SubscribeResponse>
								<SubscriptionStatus>Error</SubscriptionStatus>
								<SubscriptionRequestID>
									<xsl:value-of select="$aodbCorrelationId" />
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
		<xsl:param name="aodbmessageType" />
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