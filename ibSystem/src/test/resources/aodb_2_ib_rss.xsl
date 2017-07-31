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
			<xsl:if test="(/soap-env:Envelope/soap-env:Body/*[1] != '' and //*[@action] )or $aodbMessageType = 'ACK' ">
			<xsl:for-each select="/soap-env:Envelope/soap-env:Body">
				<SysInfo>
					<MessageSequenceID>
						<xsl:value-of select="/soap-env:Envelope/soap-env:Header/aodb:control/aodb:message-id" />
					</MessageSequenceID>
					<MessageType>
						<xsl:choose>
							<xsl:when test="$aodbMessageType='ACK'">Operation</xsl:when>
							<xsl:otherwise>ResourceData</xsl:otherwise>
						</xsl:choose>
					</MessageType>
					<ServiceType>
						<xsl:choose>
							<xsl:when test="$aodbMessageType='DATASET' or $aodbMessageType='ACK'">RSS2</xsl:when>
							<xsl:otherwise>RSS1</xsl:otherwise>
						</xsl:choose>
					</ServiceType>
					<OperationMode>
						<xsl:call-template name="operation"/>
					</OperationMode>
					<SendDateTime/>
					<CreateDateTime/>
					<OriginalDateTime>
						<xsl:choose>
							<xsl:when test="$dataType='rm_closing'">
								<xsl:value-of select="rm_closing/rcl_modtime" />
							</xsl:when>
							<xsl:when test="$dataType='pl_desk'">
								<xsl:value-of select="pl_desk/pdk_modtime"></xsl:value-of>
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
					<Priority>4</Priority>
				</SysInfo>
				<xsl:if test="$aodbMessageType!='ACK'">
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
	
	<xsl:template name="resourceTypeConvert">
		<xsl:param name="resourceType" />
		<xsl:if test="$resourceType='RSTA'">Stand</xsl:if>
		<xsl:if test="$resourceType='RBB'">BaggageReclaim</xsl:if>
		<xsl:if test="$resourceType='RGT'">Gate</xsl:if>
		<xsl:if test="$resourceType='RCNT'">CheckInDesk</xsl:if>
		<xsl:if test="$resourceType='RDB'">BaggageMakeup</xsl:if>
		<xsl:if test="$resourceType='RAB'">BoardingBridge</xsl:if>
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