package com.tsystems.si.aviation.imf.ibSystem.db.domain;

import java.io.Serializable;
import javax.persistence.*;
import java.util.Date;


/**
 * The persistent class for the log_imfMessage database table.
 * 
 */
@Entity
@Table(name="log_imfMessage")
@NamedQuery(name="LogImfMessage.findAll", query="SELECT l FROM LogImfMessage l")
public class LogImfMessage implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="imf_id")
	private int imfId;

	@Column(name="imf_basicDataCategory")
	private String imfBasicDataCategory;

	@Column(name="imf_basicDataId")
	private String imfBasicDataId;

	@Lob
	@Column(name="imf_content")
	private String imfContent;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="imf_createtime")
	private Date imfCreatetime;

	@Column(name="imf_flightDirection")
	private String imfFlightDirection;

	@Column(name="imf_flightInternalId")
	private String imfFlightInternalId;

	@Column(name="imf_flightNumber")
	private String imfFlightNumber;

	@Column(name="imf_flightScheduledDate")
	private String imfFlightScheduledDate;

	@Column(name="imf_flightScheduledDatetime")
	private String imfFlightScheduledDatetime;

	@Column(name="imf_messageId")
	private String imfMessageId;

	@Column(name="imf_messageType")
	private String imfMessageType;

	@Column(name="IMF_mqifId")
	private String IMFMqifId;

	@Column(name="imf_operationMode")
	private String imfOperationMode;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="imf_orgCreatetime")
	private Date imfOrgCreatetime;

	@Column(name="imf_owner")
	private String imfOwner;

	@Column(name="imf_receiver")
	private String imfReceiver;

	@Column(name="imf_resourceCategory")
	private String imfResourceCategory;

	@Column(name="imf_resourceId")
	private String imfResourceId;

	@Column(name="imf_sender")
	private String imfSender;

	@Column(name="imf_serviceType")
	private String imfServiceType;

	public LogImfMessage() {
	}

	public int getImfId() {
		return this.imfId;
	}

	public void setImfId(int imfId) {
		this.imfId = imfId;
	}

	public String getImfBasicDataCategory() {
		return this.imfBasicDataCategory;
	}

	public void setImfBasicDataCategory(String imfBasicDataCategory) {
		this.imfBasicDataCategory = imfBasicDataCategory;
	}

	public String getImfBasicDataId() {
		return this.imfBasicDataId;
	}

	public void setImfBasicDataId(String imfBasicDataId) {
		this.imfBasicDataId = imfBasicDataId;
	}

	public String getImfContent() {
		return this.imfContent;
	}

	public void setImfContent(String imfContent) {
		this.imfContent = imfContent;
	}

	public Date getImfCreatetime() {
		return this.imfCreatetime;
	}

	public void setImfCreatetime(Date imfCreatetime) {
		this.imfCreatetime = imfCreatetime;
	}

	public String getImfFlightDirection() {
		return this.imfFlightDirection;
	}

	public void setImfFlightDirection(String imfFlightDirection) {
		this.imfFlightDirection = imfFlightDirection;
	}

	public String getImfFlightInternalId() {
		return this.imfFlightInternalId;
	}

	public void setImfFlightInternalId(String imfFlightInternalId) {
		this.imfFlightInternalId = imfFlightInternalId;
	}

	public String getImfFlightNumber() {
		return this.imfFlightNumber;
	}

	public void setImfFlightNumber(String imfFlightNumber) {
		this.imfFlightNumber = imfFlightNumber;
	}

	public String getImfFlightScheduledDate() {
		return this.imfFlightScheduledDate;
	}

	public void setImfFlightScheduledDate(String imfFlightScheduledDate) {
		this.imfFlightScheduledDate = imfFlightScheduledDate;
	}

	public String getImfFlightScheduledDatetime() {
		return this.imfFlightScheduledDatetime;
	}

	public void setImfFlightScheduledDatetime(String imfFlightScheduledDatetime) {
		this.imfFlightScheduledDatetime = imfFlightScheduledDatetime;
	}

	public String getImfMessageId() {
		return this.imfMessageId;
	}

	public void setImfMessageId(String imfMessageId) {
		this.imfMessageId = imfMessageId;
	}

	public String getImfMessageType() {
		return this.imfMessageType;
	}

	public void setImfMessageType(String imfMessageType) {
		this.imfMessageType = imfMessageType;
	}

	public String getIMFMqifId() {
		return this.IMFMqifId;
	}

	public void setIMFMqifId(String IMFMqifId) {
		this.IMFMqifId = IMFMqifId;
	}

	public String getImfOperationMode() {
		return this.imfOperationMode;
	}

	public void setImfOperationMode(String imfOperationMode) {
		this.imfOperationMode = imfOperationMode;
	}

	public Date getImfOrgCreatetime() {
		return this.imfOrgCreatetime;
	}

	public void setImfOrgCreatetime(Date imfOrgCreatetime) {
		this.imfOrgCreatetime = imfOrgCreatetime;
	}

	public String getImfOwner() {
		return this.imfOwner;
	}

	public void setImfOwner(String imfOwner) {
		this.imfOwner = imfOwner;
	}

	public String getImfReceiver() {
		return this.imfReceiver;
	}

	public void setImfReceiver(String imfReceiver) {
		this.imfReceiver = imfReceiver;
	}

	public String getImfResourceCategory() {
		return this.imfResourceCategory;
	}

	public void setImfResourceCategory(String imfResourceCategory) {
		this.imfResourceCategory = imfResourceCategory;
	}

	public String getImfResourceId() {
		return this.imfResourceId;
	}

	public void setImfResourceId(String imfResourceId) {
		this.imfResourceId = imfResourceId;
	}

	public String getImfSender() {
		return this.imfSender;
	}

	public void setImfSender(String imfSender) {
		this.imfSender = imfSender;
	}

	public String getImfServiceType() {
		return this.imfServiceType;
	}

	public void setImfServiceType(String imfServiceType) {
		this.imfServiceType = imfServiceType;
	}

}