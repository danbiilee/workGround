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
public class ClubNoticeComment implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int clubNoticeCommentNo;
	private int clubNoticeNo;
	private int clubNoticeCommentLevel;
	private int clubMemberNo;
	private String clubNoticeCommentContent;
	private Date clubNoticeCommentDate;
	private String clubNoticeCommentRef;
	private int clubNo;
	
	//가상컬럼
	private String memberName;
	private String renamedFileName;
	private String memberId;
}
