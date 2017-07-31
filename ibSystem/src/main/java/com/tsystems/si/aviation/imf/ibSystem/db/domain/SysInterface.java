package com.tsystems.si.aviation.imf.ibSystem.db.domain;

import java.io.Serializable;
import javax.persistence.*;
import java.util.Date;
import java.util.List;


/**
 * The persistent class for the sys_interface database table.
 * 
 */
@Entity
@Table(name="sys_interface")
@NamedQuery(name="SysInterface.findAll", query="SELECT s FROM SysInterface s")
public class SysInterface implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="int_id")
	private int intId;

	@Column(name="int_bssParameter")
	private String intBssParameter;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="int_CreateTime")
	private Date intCreateTime;

	@Column(name="int_createUser")
	private String intCreateUser;

	@Lob
	@Column(name="int_fssFilterXsl")
	private String intFssFilterXsl;

	@Column(name="int_fssParameter")
	private String intFssParameter;

	@Lob
	@Column(name="int_fusFilterXsl")
	private String intFusFilterXsl;

	@Column(name="int_InitializationReason")
	private String intInitializationReason;

	@Column(name="int_InitializationStatus")
	private String intInitializationStatus;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="int_InitializationTime")
	private Date intInitializationTime;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="int_modTime")
	private Date intModTime;

	@Column(name="int_modUser")
	private String intModUser;

	@Column(name="int_name")
	private String intName;

	@Column(name="int_rssParameter")
	private String intRssParameter;

	@Column(name="int_status")
	private String intStatus;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="int_statusChangeTime")
	private Date intStatusChangeTime;

	@Column(name="int_type")
	private String intType;

	//bi-directional many-to-one association to SysRequest
	@OneToMany(mappedBy="sysInterface")
	private List<SysRequest> sysRequests;

	public SysInterface() {
	}

	public int getIntId() {
		return this.intId;
	}

	public void setIntId(int intId) {
		this.intId = intId;
	}

	public String getIntBssParameter() {
		return this.intBssParameter;
	}

	public void setIntBssParameter(String intBssParameter) {
		this.intBssParameter = intBssParameter;
	}

	public Date getIntCreateTime() {
		return this.intCreateTime;
	}

	public void setIntCreateTime(Date intCreateTime) {
		this.intCreateTime = intCreateTime;
	}

	public String getIntCreateUser() {
		return this.intCreateUser;
	}

	public void setIntCreateUser(String intCreateUser) {
		this.intCreateUser = intCreateUser;
	}

	public String getIntFssFilterXsl() {
		return this.intFssFilterXsl;
	}

	public void setIntFssFilterXsl(String intFssFilterXsl) {
		this.intFssFilterXsl = intFssFilterXsl;
	}

	public String getIntFssParameter() {
		return this.intFssParameter;
	}

	public void setIntFssParameter(String intFssParameter) {
		this.intFssParameter = intFssParameter;
	}

	public String getIntFusFilterXsl() {
		return this.intFusFilterXsl;
	}

	public void setIntFusFilterXsl(String intFusFilterXsl) {
		this.intFusFilterXsl = intFusFilterXsl;
	}

	public String getIntInitializationReason() {
		return this.intInitializationReason;
	}

	public void setIntInitializationReason(String intInitializationReason) {
		this.intInitializationReason = intInitializationReason;
	}

	public String getIntInitializationStatus() {
		return this.intInitializationStatus;
	}

	public void setIntInitializationStatus(String intInitializationStatus) {
		this.intInitializationStatus = intInitializationStatus;
	}

	public Date getIntInitializationTime() {
		return this.intInitializationTime;
	}

	public void setIntInitializationTime(Date intInitializationTime) {
		this.intInitializationTime = intInitializationTime;
	}

	public Date getIntModTime() {
		return this.intModTime;
	}

	public void setIntModTime(Date intModTime) {
		this.intModTime = intModTime;
	}

	public String getIntModUser() {
		return this.intModUser;
	}

	public void setIntModUser(String intModUser) {
		this.intModUser = intModUser;
	}

	public String getIntName() {
		return this.intName;
	}

	public void setIntName(String intName) {
		this.intName = intName;
	}

	public String getIntRssParameter() {
		return this.intRssParameter;
	}

	public void setIntRssParameter(String intRssParameter) {
		this.intRssParameter = intRssParameter;
	}

	public String getIntStatus() {
		return this.intStatus;
	}

	public void setIntStatus(String intStatus) {
		this.intStatus = intStatus;
	}

	public Date getIntStatusChangeTime() {
		return this.intStatusChangeTime;
	}

	public void setIntStatusChangeTime(Date intStatusChangeTime) {
		this.intStatusChangeTime = intStatusChangeTime;
	}

	public String getIntType() {
		return this.intType;
	}

	public void setIntType(String intType) {
		this.intType = intType;
	}

	public List<SysRequest> getSysRequests() {
		return this.sysRequests;
	}

	public void setSysRequests(List<SysRequest> sysRequests) {
		this.sysRequests = sysRequests;
	}

	public SysRequest addSysRequest(SysRequest sysRequest) {
		getSysRequests().add(sysRequest);
		sysRequest.setSysInterface(this);

		return sysRequest;
	}

	public SysRequest removeSysRequest(SysRequest sysRequest) {
		getSysRequests().remove(sysRequest);
		sysRequest.setSysInterface(null);

		return sysRequest;
	}

}