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

	@Column(name="req_createuser")
	private String reqCreateuser;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="req_endtime")
	private Date reqEndtime;

	@Lob
	@Column(name="req_imfmessage")
	private String reqImfmessage;

	@Column(name="req_interfacename")
	private String reqInterfacename;

	@Column(name="req_interfacetype")
	private String reqInterfacetype;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="req_modificationstarttime")
	private Date reqModificationstarttime;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="req_modtime")
	private Date reqModtime;

	@Column(name="req_moduser")
	private String reqModuser;

	@Lob
	@Column(name="req_mqifmessage")
	private String reqMqifmessage;

	@Column(name="req_requestID")
	private String reqRequestId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="req_starttime")
	private Date reqStarttime;

	@Column(name="req_status")
	private String reqStatus;

	//bi-directional many-to-one association to SysInterface
	@ManyToOne
	@JoinColumn(name="req_interfaceID")
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

	public String getReqCreateuser() {
		return this.reqCreateuser;
	}

	public void setReqCreateuser(String reqCreateuser) {
		this.reqCreateuser = reqCreateuser;
	}

	public Date getReqEndtime() {
		return this.reqEndtime;
	}

	public void setReqEndtime(Date reqEndtime) {
		this.reqEndtime = reqEndtime;
	}

	public String getReqImfmessage() {
		return this.reqImfmessage;
	}

	public void setReqImfmessage(String reqImfmessage) {
		this.reqImfmessage = reqImfmessage;
	}

	public String getReqInterfacename() {
		return this.reqInterfacename;
	}

	public void setReqInterfacename(String reqInterfacename) {
		this.reqInterfacename = reqInterfacename;
	}

	public String getReqInterfacetype() {
		return this.reqInterfacetype;
	}

	public void setReqInterfacetype(String reqInterfacetype) {
		this.reqInterfacetype = reqInterfacetype;
	}

	public Date getReqModificationstarttime() {
		return this.reqModificationstarttime;
	}

	public void setReqModificationstarttime(Date reqModificationstarttime) {
		this.reqModificationstarttime = reqModificationstarttime;
	}

	public Date getReqModtime() {
		return this.reqModtime;
	}

	public void setReqModtime(Date reqModtime) {
		this.reqModtime = reqModtime;
	}

	public String getReqModuser() {
		return this.reqModuser;
	}

	public void setReqModuser(String reqModuser) {
		this.reqModuser = reqModuser;
	}

	public String getReqMqifmessage() {
		return this.reqMqifmessage;
	}

	public void setReqMqifmessage(String reqMqifmessage) {
		this.reqMqifmessage = reqMqifmessage;
	}

	public String getReqRequestId() {
		return this.reqRequestId;
	}

	public void setReqRequestId(String reqRequestId) {
		this.reqRequestId = reqRequestId;
	}

	public Date getReqStarttime() {
		return this.reqStarttime;
	}

	public void setReqStarttime(Date reqStarttime) {
		this.reqStarttime = reqStarttime;
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