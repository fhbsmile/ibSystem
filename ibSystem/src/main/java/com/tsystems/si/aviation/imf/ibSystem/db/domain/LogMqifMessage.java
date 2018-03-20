package com.tsystems.si.aviation.imf.ibSystem.db.domain;

import java.io.Serializable;
import javax.persistence.*;
import java.util.Date;


/**
 * The persistent class for the log_mqifMessage database table.
 * 
 */
@Entity
@Table(name="log_mqifMessage")
@NamedQuery(name="LogMqifMessage.findAll", query="SELECT l FROM LogMqifMessage l")
public class LogMqifMessage implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="mqif_id")
	private Long mqifId;

	@Column(name="mqif_arrivalId")
	private String mqifArrivalId;

	@Lob
	@Column(name="mqif_content")
	private String mqifContent;

	@Column(name="mqif_correlationId")
	private String mqifCorrelationId;

	@Temporal(TemporalType.TIMESTAMP)
	private Date mqif_createTime;

	@Column(name="mqif_dataType")
	private String mqifDataType;

	@Column(name="mqif_departureId")
	private String mqifDepartureId;

	@Column(name="mqif_internalId")
	private String mqifInternalId;

	@Column(name="mqif_messageId")
	private String mqifMessageId;

	@Column(name="mqif_messageType")
	private String mqifMessageType;

	@Column(name="mqif_orgMessageType")
	private String mqifOrgMessageType;

	@Column(name="mqif_orignator")
	private String mqifOrignator;

	@Column(name="mqif_receiver")
	private String mqifReceiver;

	@Column(name="mqif_sender")
	private String mqifSender;

	@Column(name="mqif_station")
	private String mqifStation;

	@Column(name="mqif_turnId")
	private String mqifTurnId;

	public LogMqifMessage() {
	}

	public Long getMqifId() {
		return this.mqifId;
	}

	public void setMqifId(Long mqifId) {
		this.mqifId = mqifId;
	}

	public String getMqifArrivalId() {
		return this.mqifArrivalId;
	}

	public void setMqifArrivalId(String mqifArrivalId) {
		this.mqifArrivalId = mqifArrivalId;
	}

	public String getMqifContent() {
		return this.mqifContent;
	}

	public void setMqifContent(String mqifContent) {
		this.mqifContent = mqifContent;
	}

	public String getMqifCorrelationId() {
		return this.mqifCorrelationId;
	}

	public void setMqifCorrelationId(String mqifCorrelationId) {
		this.mqifCorrelationId = mqifCorrelationId;
	}

	public Date getMqif_createTime() {
		return this.mqif_createTime;
	}

	public void setMqif_createTime(Date mqif_createTime) {
		this.mqif_createTime = mqif_createTime;
	}

	public String getMqifDataType() {
		return this.mqifDataType;
	}

	public void setMqifDataType(String mqifDataType) {
		this.mqifDataType = mqifDataType;
	}

	public String getMqifDepartureId() {
		return this.mqifDepartureId;
	}

	public void setMqifDepartureId(String mqifDepartureId) {
		this.mqifDepartureId = mqifDepartureId;
	}

	public String getMqifInternalId() {
		return this.mqifInternalId;
	}

	public void setMqifInternalId(String mqifInternalId) {
		this.mqifInternalId = mqifInternalId;
	}

	public String getMqifMessageId() {
		return this.mqifMessageId;
	}

	public void setMqifMessageId(String mqifMessageId) {
		this.mqifMessageId = mqifMessageId;
	}

	public String getMqifMessageType() {
		return this.mqifMessageType;
	}

	public void setMqifMessageType(String mqifMessageType) {
		this.mqifMessageType = mqifMessageType;
	}

	public String getMqifOrgMessageType() {
		return this.mqifOrgMessageType;
	}

	public void setMqifOrgMessageType(String mqifOrgMessageType) {
		this.mqifOrgMessageType = mqifOrgMessageType;
	}

	public String getMqifOrignator() {
		return this.mqifOrignator;
	}

	public void setMqifOrignator(String mqifOrignator) {
		this.mqifOrignator = mqifOrignator;
	}

	public String getMqifReceiver() {
		return this.mqifReceiver;
	}

	public void setMqifReceiver(String mqifReceiver) {
		this.mqifReceiver = mqifReceiver;
	}

	public String getMqifSender() {
		return this.mqifSender;
	}

	public void setMqifSender(String mqifSender) {
		this.mqifSender = mqifSender;
	}

	public String getMqifStation() {
		return this.mqifStation;
	}

	public void setMqifStation(String mqifStation) {
		this.mqifStation = mqifStation;
	}

	public String getMqifTurnId() {
		return this.mqifTurnId;
	}

	public void setMqifTurnId(String mqifTurnId) {
		this.mqifTurnId = mqifTurnId;
	}

}