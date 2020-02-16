package com.kh.workground.club.model.vo;

import java.io.Serializable;
import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ClubNotice implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int clubNoticeNo;
	private String clubNoticeTitle;
	private String clubNoticeContent;
	private int clubNo;
	private int clubMemberNo;
	private Date clubNoticeDate;
	private String clubNoticeOriginal;
	private String clubNoticeRenamed;
	
	//가상컬럼
	private String memberName;
	private String memberId;
	private String renamedFileName;
}
