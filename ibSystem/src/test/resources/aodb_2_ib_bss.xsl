<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:aodb="urn:com.tsystems.ac.aodb"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	exclude-result-prefixes="aodb soap-env">
	<xsl:output method="xml" indent="yes" />
	<xsl:template match="/">
	<xsl:variable name="dataType" select="name(/soap-env:Envelope/soap-env:Body/*[1])"></xsl:variable>
	<xsl:variable name="aodbMessageType"
			select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:message-type"></xsl:variable>
	<xsl:variable name="correlationID"
			select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:correlation-id"></xsl:variable>
	<xsl:variable name="receiver"
		select="substring-before(substring-after($correlationID,'|' ), '|')"></xsl:variable>
	<xsl:variable name="reqID"
		select="substring-before(substring-after(substring-after($correlationID,'|' ), '|'), '|')"></xsl:variable>
		<IMFRoot>
		<xsl:if test="(/soap-env:Envelope/soap-env:Body/*[1] != '' and //*[@action]) or $aodbMessageType = 'ACK' or $aodbMessageType = 'DATASET'">
			<xsl:for-each select="/soap-env:Envelope/soap-env:Body">
				<SysInfo>
					<MessageSequenceID>
						<xsl:value-of select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:message-id" />
					</MessageSequenceID>
					<MessageType>
						<xsl:choose>
							<xsl:when test="$aodbMessageType='ACK'">Operation</xsl:when>
							<xsl:otherwise>BasicData</xsl:otherwise>
						</xsl:choose>
					</MessageType>
					<ServiceType>
						<xsl:choose>
							<xsl:when test="$aodbMessageType='DATASET' or $aodbMessageType='ACK'">BSS2</xsl:when>
							<xsl:otherwise>BSS1</xsl:otherwise>
						</xsl:choose>
					</ServiceType>
					<OperationMode>
						<xsl:call-template name="operation"/>
					</OperationMode>
					<SendDateTime/>
					<CreateDateTime/>
					<OriginalDateTime>
						<xsl:choose>
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
						</xsl:choose>
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
					<Priority>0</Priority>
				</SysInfo>
				<xsl:if test="$aodbMessageType!='ACK'">
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
										<AircraftSeats>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rac_seatcapacity" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</AircraftSeats>
										<AircraftMaxTakeOffWaight>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rac_mtow" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</AircraftMaxTakeOffWaight>
										<AircraftComment>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rac_comment" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</AircraftComment>
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
										<AircraftWideBody>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="ract_widebodyind" />
												<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
											</xsl:call-template>
										</AircraftWideBody>
										<MinTrunAroundTime>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="ract_mttt" />
												<xsl:with-param name="needAddNil" select="false()"></xsl:with-param>
											</xsl:call-template>
										</MinTrunAroundTime>
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
										<TermialComment>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rtrm_comment" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</TermialComment>
										<TermialClosed>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rtrm_closedind" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</TermialClosed>
										<TermialClosureReason>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rtrm_closurereason" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</TermialClosureReason>
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
										<RunwayComment>
											<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rrwy_comment" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</RunwayComment>
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
										<CheckInDeskAirline>
										    <xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rcnt_ral_airline" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>										
										</CheckInDeskAirline>
										<CheckInDeskCountryType>
										<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rcnt_rctt_countrytype" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</CheckInDeskCountryType>
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
										<GateAirline>										
										<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rgt_ral_airline" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</GateAirline>
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
										<BaggageReclaimAirline>
										<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rbb_ral_airline" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>										
										</BaggageReclaimAirline>
										<BaggageReclaimCountryType>
										<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rbb_rctt_countrytype" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</BaggageReclaimCountryType>
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
												<xsl:with-param name="inElement" select="rap_name1" />
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
												<xsl:with-param name="inElement" select="rap_name2" />
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
										<DelayCodeAlphabetic>
										<xsl:call-template name="xsltTemplate">
												<xsl:with-param name="inElement" select="rdlr_codealphabetic" />
												<xsl:with-param name="needAddNil" select="true()"></xsl:with-param>
											</xsl:call-template>
										</DelayCodeAlphabetic>
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
				<xsl:if test="$aodbMessageType ='ACK'">
					<Operation>
						<Subscription>
							<SubscribeResponse>
								<SubscriptionStatus>End</SubscriptionStatus>
								<SubscriptionRequestID>
									<xsl:value-of select="$reqID" />
								</SubscriptionRequestID>
								<SyncMessageCount>0</SyncMessageCount>
							</SubscribeResponse>
						</Subscription>
					</Operation>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		</IMFRoot>
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

	<xsl:template name="operation">
		<xsl:variable name="action"
			select="*[1]//@action[1]"></xsl:variable>
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
</xsl:stylesheet>