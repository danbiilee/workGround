package com.kh.workground.notice.model.vo;

import java.io.Serializable;
import java.sql.Date;
import java.util.List;

import com.kh.workground.member.model.vo.Member;

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
public class Notice implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int noticeNo;
	private String noticeWriter;
	private String noticeTitle;
	private Date noticeDate;
	private String noticeContent;
	private String noticeOriginalFileName;
	private String noticeRenamedFileName;
	private String deptCode;
	
	//view_noticeMemberNoticeComment (notice + member + notice_comment 테이블)
	private String memberName;
	private String renamedFileName;
	private List<NoticeComment> noticeCommentList;

	
	
	

}
