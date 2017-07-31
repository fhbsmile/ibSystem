package com.tsystems.si.aviation.imf.ibSystem.db.domain;

import java.io.Serializable;
import javax.persistence.*;
import java.util.Date;


/**
 * The persistent class for the sys_parameter database table.
 * 
 */
@Entity
@Table(name="sys_parameter")
@NamedQuery(name="SysParameter.findAll", query="SELECT s FROM SysParameter s")
public class SysParameter implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="SpName")
	private String spName;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CreateDateTime")
	private Date createDateTime;

	@Column(name="CreateUser")
	private String createUser;

	@Column(name="SpDescription")
	private String spDescription;

	@Column(name="SpValue1")
	private String spValue1;

	@Column(name="SpValue2")
	private String spValue2;

	@Column(name="SpValue3")
	private String spValue3;

	@Column(name="SpValue4")
	private String spValue4;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="SpValue5")
	private Date spValue5;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="SpValue6")
	private Date spValue6;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UpdateDateTime")
	private Date updateDateTime;

	@Column(name="UpdateUser")
	private String updateUser;

	public SysParameter() {
	}

	public String getSpName() {
		return this.spName;
	}

	public void setSpName(String spName) {
		this.spName = spName;
	}

	public Date getCreateDateTime() {
		return this.createDateTime;
	}

	public void setCreateDateTime(Date createDateTime) {
		this.createDateTime = createDateTime;
	}

	public String getCreateUser() {
		return this.createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public String getSpDescription() {
		return this.spDescription;
	}

	public void setSpDescription(String spDescription) {
		this.spDescription = spDescription;
	}

	public String getSpValue1() {
		return this.spValue1;
	}

	public void setSpValue1(String spValue1) {
		this.spValue1 = spValue1;
	}

	public String getSpValue2() {
		return this.spValue2;
	}

	public void setSpValue2(String spValue2) {
		this.spValue2 = spValue2;
	}

	public String getSpValue3() {
		return this.spValue3;
	}

	public void setSpValue3(String spValue3) {
		this.spValue3 = spValue3;
	}

	public String getSpValue4() {
		return this.spValue4;
	}

	public void setSpValue4(String spValue4) {
		this.spValue4 = spValue4;
	}

	public Date getSpValue5() {
		return this.spValue5;
	}

	public void setSpValue5(Date spValue5) {
		this.spValue5 = spValue5;
	}

	public Date getSpValue6() {
		return this.spValue6;
	}

	public void setSpValue6(Date spValue6) {
		this.spValue6 = spValue6;
	}

	public Date getUpdateDateTime() {
		return this.updateDateTime;
	}

	public void setUpdateDateTime(Date updateDateTime) {
		this.updateDateTime = updateDateTime;
	}

	public String getUpdateUser() {
		return this.updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}

}