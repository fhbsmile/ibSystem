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

	@Lob
	@Column(name="int_bssFilterXsl")
	private String intBssFilterXsl;

	@Temporal(TemporalType.DATE)
	@Column(name="int_bssLastHeartBeat")
	private Date intBssLastHeartBeat;

	@Column(name="int_bssParameter")
	private String intBssParameter;

	@Column(name="int_bssStatus")
	private String intBssStatus;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="int_createTime")
	private Date intCreateTime;

	@Column(name="int_createUser")
	private String intCreateUser;

	@Column(name="int_description")
	private String intDescription;

	@Lob
	@Column(name="int_fssFilterXsl")
	private String intFssFilterXsl;

	@Temporal(TemporalType.DATE)
	@Column(name="int_fssLastHeartBeat")
	private Date intFssLastHeartBeat;

	@Column(name="int_fssParameter")
	private String intFssParameter;

	@Column(name="int_fssStatus")
	private String intFssStatus;

	@Lob
	@Column(name="int_fusFilterXsl")
	private String intFusFilterXsl;

	@Temporal(TemporalType.DATE)
	@Column(name="int_fusLastHeatBeat")
	private Date intFusLastHeatBeat;

	@Column(name="int_fusStatus")
	private String intFusStatus;

	@Column(name="int_initializationReason")
	private String intInitializationReason;

	@Column(name="int_initializationStatus")
	private String intInitializationStatus;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="int_initializationTime")
	private Date intInitializationTime;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="int_modTime")
	private Date intModTime;

	@Column(name="int_modUser")
	private String intModUser;

	@Column(name="int_name")
	private String intName;

	@Lob
	@Column(name="int_rssFilterXsl")
	private String intRssFilterXsl;

	@Temporal(TemporalType.DATE)
	@Column(name="int_rssLastHeartBeat")
	private Date intRssLastHeartBeat;

	@Column(name="int_rssParameter")
	private String intRssParameter;

	@Column(name="int_rssStatus")
	private String intRssStatus;

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

	public String getIntBssFilterXsl() {
		return this.intBssFilterXsl;
	}

	public void setIntBssFilterXsl(String intBssFilterXsl) {
		this.intBssFilterXsl = intBssFilterXsl;
	}

	public Date getIntBssLastHeartBeat() {
		return this.intBssLastHeartBeat;
	}

	public void setIntBssLastHeartBeat(Date intBssLastHeartBeat) {
		this.intBssLastHeartBeat = intBssLastHeartBeat;
	}

	public String getIntBssParameter() {
		return this.intBssParameter;
	}

	public void setIntBssParameter(String intBssParameter) {
		this.intBssParameter = intBssParameter;
	}

	public String getIntBssStatus() {
		return this.intBssStatus;
	}

	public void setIntBssStatus(String intBssStatus) {
		this.intBssStatus = intBssStatus;
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

	public String getIntDescription() {
		return this.intDescription;
	}

	public void setIntDescription(String intDescription) {
		this.intDescription = intDescription;
	}

	public String getIntFssFilterXsl() {
		return this.intFssFilterXsl;
	}

	public void setIntFssFilterXsl(String intFssFilterXsl) {
		this.intFssFilterXsl = intFssFilterXsl;
	}

	public Date getIntFssLastHeartBeat() {
		return this.intFssLastHeartBeat;
	}

	public void setIntFssLastHeartBeat(Date intFssLastHeartBeat) {
		this.intFssLastHeartBeat = intFssLastHeartBeat;
	}

	public String getIntFssParameter() {
		return this.intFssParameter;
	}

	public void setIntFssParameter(String intFssParameter) {
		this.intFssParameter = intFssParameter;
	}

	public String getIntFssStatus() {
		return this.intFssStatus;
	}

	public void setIntFssStatus(String intFssStatus) {
		this.intFssStatus = intFssStatus;
	}

	public String getIntFusFilterXsl() {
		return this.intFusFilterXsl;
	}

	public void setIntFusFilterXsl(String intFusFilterXsl) {
		this.intFusFilterXsl = intFusFilterXsl;
	}

	public Date getIntFusLastHeatBeat() {
		return this.intFusLastHeatBeat;
	}

	public void setIntFusLastHeatBeat(Date intFusLastHeatBeat) {
		this.intFusLastHeatBeat = intFusLastHeatBeat;
	}

	public String getIntFusStatus() {
		return this.intFusStatus;
	}

	public void setIntFusStatus(String intFusStatus) {
		this.intFusStatus = intFusStatus;
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

	public String getIntRssFilterXsl() {
		return this.intRssFilterXsl;
	}

	public void setIntRssFilterXsl(String intRssFilterXsl) {
		this.intRssFilterXsl = intRssFilterXsl;
	}

	public Date getIntRssLastHeartBeat() {
		return this.intRssLastHeartBeat;
	}

	public void setIntRssLastHeartBeat(Date intRssLastHeartBeat) {
		this.intRssLastHeartBeat = intRssLastHeartBeat;
	}

	public String getIntRssParameter() {
		return this.intRssParameter;
	}

	public void setIntRssParameter(String intRssParameter) {
		this.intRssParameter = intRssParameter;
	}

	public String getIntRssStatus() {
		return this.intRssStatus;
	}

	public void setIntRssStatus(String intRssStatus) {
		this.intRssStatus = intRssStatus;
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