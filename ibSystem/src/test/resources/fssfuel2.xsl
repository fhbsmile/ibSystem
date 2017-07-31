<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
	<xsl:output method="xml" indent="yes" />
	<xsl:include href="common.xsl" />

	<xsl:template match="/">
		<xsl:apply-templates select="*" />
	</xsl:template>
	<xsl:template match="FlightData">
		<xsl:copy>
			<xsl:apply-templates select="CallSign" />
			<xsl:apply-templates select="IsMasterFlight" />
			<xsl:apply-templates select="MasterOrSlaveFlight" />
			<xsl:apply-templates select="FreeTextComment" />
			<xsl:apply-templates select="PreviousAirportDepartureDateTime" />
			<xsl:apply-templates select="TenMilesDateTime" />
			<xsl:apply-templates select="FlyTime" />
			<xsl:apply-templates select="DoorOpenDateTime" />
			<xsl:apply-templates select="DoorCloseDateTime" />
			<xsl:apply-templates select="OnBridgeDateTime" />
			<xsl:apply-templates select="OffBridgeDateTime" />
			<xsl:apply-templates select="NextAirportArrivalDateTime" />
			<xsl:apply-templates select="GroundHandleDateTime" />
			<xsl:apply-templates select="BestKnownDateTime" />
			<xsl:apply-templates select="DelayReason" />
			<xsl:apply-templates select="DiversionAirport" />
			<xsl:apply-templates select="ChangeLandingAirport" />
			<xsl:apply-templates select="DisplayCode" />
			<xsl:apply-templates select="IsTransitFlight" />
			<xsl:apply-templates select="IsOverNightFlight" />
			<xsl:apply-templates select="IsVIPFlight" />
			<xsl:apply-templates select="VIPComment" />
			<xsl:apply-templates select="Payload" />
			<xsl:apply-templates select="Terminal" />
			<xsl:apply-templates select="Runway" />
			<xsl:apply-templates select="BaggageMakeup" />
			<xsl:apply-templates select="Gate" />
			<xsl:apply-templates select="BaggageReclaim" />
			<xsl:apply-templates select="CheckInDesk" />
			<xsl:apply-templates select="PassengerStatus" />
			<xsl:apply-templates select="CDMOperationDateTime/LandingDateTime" />
			<xsl:apply-templates select="CDMOperationDateTime/TakeOffDateTime" />
			<xsl:apply-templates select="TargetOffBlockDateTime" />
			<xsl:apply-templates select="CoordinateOffBlockDateTime" />
			<xsl:apply-templates select="DoorOpenDateTime" />
			<xsl:apply-templates select="DoorCloseDateTime" />
			<xsl:apply-templates select="TaxiInDuration" />
			<xsl:apply-templates select="TaxiOutDuration" />
			<xsl:apply-templates select="GroundHandleDateTime" />
			<xsl:apply-templates select="DeicingDateTime" />
			<xsl:apply-templates select="AircraftPrepareDateTime" />
			<xsl:apply-templates select="FlowRestrict" />
			<xsl:apply-templates select="./*" />
		</xsl:copy>
	</xsl:template>
	<xsl:template
		match="CallSign|IsMasterFlight|MasterOrSlaveFlight|FreeTextComment|PreviousAirportDepartureDateTime|TenMilesDateTime|FlyTime|DoorOpenDateTime|DoorCloseDateTime|OnBridgeDateTime|OffBridgeDateTime|NextAirportArrivalDateTime|GroundHandleDateTime|BestKnownDateTime|DelayReason|DiversionAirport|ChangeLandingAirport|DisplayCode|IsTransitFlight|IsOverNightFlight|IsVIPFlight|VIPComment|Payload|Terminal|Runway|BaggageMakeup|Gate|BaggageReclaim|CheckInDesk|PassengerStatus|CDMOperationDateTime/LandingDateTime|CDMOperationDateTime/TakeOffDateTime|TargetOffBlockDateTime|CoordinateOffBlockDateTime|DoorOpenDateTime|DoorCloseDateTime|TaxiInDuration|TaxiOutDuration|GroundHandleDateTime|DeicingDateTime|AircraftPrepareDateTime|FlowRestrict" />
</xsl:stylesheet>
