package com.tsystems.si.aviation.imf.ibSystem.db.domain;

import java.io.Serializable;
import javax.persistence.*;
import java.util.Date;


/**
 * The persistent class for the sys_request database table.
 * 
 */
@Entity
@Table(name="sys_request")
@NamedQuery(name="SysRequest.findAll", query="SELECT s FROM SysRequest s")
public class SysRequest implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="req_id")
	private int reqId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="req_createTime")
	private Date reqCreateTime;

	private String req_createUser;

	@Temporal(TemporalType.TIMESTAMP)
	private Date req_endTime;

	@Lob
	private String req_imfMessage;

	private String req_interfaceName;

	private String req_interfaceType;

	@Temporal(TemporalType.TIMESTAMP)
	private Date req_modificationStartTime;

	@Temporal(TemporalType.TIMESTAMP)
	private Date req_modTime;

	private String req_modUser;

	@Lob
	private String req_mqifMessage;

	@Column(name="req_requestID")
	private String reqRequestId;

	@Temporal(TemporalType.TIMESTAMP)
	private Date req_startTime;

	@Column(name="req_status")
	private String reqStatus;

	//bi-directional many-to-one association to SysInterface
	@ManyToOne
	@JoinColumn(name="req_interfaceId")
	private SysInterface sysInterface;

	public SysRequest() {
	}

	public int getReqId() {
		return this.reqId;
	}

	public void setReqId(int reqId) {
		this.reqId = reqId;
	}

	public Date getReqCreateTime() {
		return this.reqCreateTime;
	}

	public void setReqCreateTime(Date reqCreateTime) {
		this.reqCreateTime = reqCreateTime;
	}

	public String getReq_createUser() {
		return this.req_createUser;
	}

	public void setReq_createUser(String req_createUser) {
		this.req_createUser = req_createUser;
	}

	public Date getReq_endTime() {
		return this.req_endTime;
	}

	public void setReq_endTime(Date req_endTime) {
		this.req_endTime = req_endTime;
	}

	public String getReq_imfMessage() {
		return this.req_imfMessage;
	}

	public void setReq_imfMessage(String req_imfMessage) {
		this.req_imfMessage = req_imfMessage;
	}

	public String getReq_interfaceName() {
		return this.req_interfaceName;
	}

	public void setReq_interfaceName(String req_interfaceName) {
		this.req_interfaceName = req_interfaceName;
	}

	public String getReq_interfaceType() {
		return this.req_interfaceType;
	}

	public void setReq_interfaceType(String req_interfaceType) {
		this.req_interfaceType = req_interfaceType;
	}

	public Date getReq_modificationStartTime() {
		return this.req_modificationStartTime;
	}

	public void setReq_modificationStartTime(Date req_modificationStartTime) {
		this.req_modificationStartTime = req_modificationStartTime;
	}

	public Date getReq_modTime() {
		return this.req_modTime;
	}

	public void setReq_modTime(Date req_modTime) {
		this.req_modTime = req_modTime;
	}

	public String getReq_modUser() {
		return this.req_modUser;
	}

	public void setReq_modUser(String req_modUser) {
		this.req_modUser = req_modUser;
	}

	public String getReq_mqifMessage() {
		return this.req_mqifMessage;
	}

	public void setReq_mqifMessage(String req_mqifMessage) {
		this.req_mqifMessage = req_mqifMessage;
	}

	public String getReqRequestId() {
		return this.reqRequestId;
	}

	public void setReqRequestId(String reqRequestId) {
		this.reqRequestId = reqRequestId;
	}

	public Date getReq_startTime() {
		return this.req_startTime;
	}

	public void setReq_startTime(Date req_startTime) {
		this.req_startTime = req_startTime;
	}

	public String getReqStatus() {
		return this.reqStatus;
	}

	public void setReqStatus(String reqStatus) {
		this.reqStatus = reqStatus;
	}

	public SysInterface getSysInterface() {
		return this.sysInterface;
	}

	public void setSysInterface(SysInterface sysInterface) {
		this.sysInterface = sysInterface;
	}

}