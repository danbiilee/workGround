package com.kh.workground.notice.model.vo;

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
public class NoticeComment implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int noticeCommentNo;
	private int noticeRef;
	private int noticeCommentLevel;
	private String noticeCommentWriter;
	private String noticeCommentContent;
	private Date noticeCommentDate;
	private int noticeCommentRef;
	
	//view_noticeMemberNoticeComment (notice + member + notice_comment 테이블)
	private String commentWriterName;
	private String commentWriterProfile;

}
