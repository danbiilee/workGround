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
public class CommunityComment implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int commuCommentNo;
	private int commuRef;
	private int commuCommentLevel;
	private String commuCommentWriter;
	private String commuCommentContent;
	private Date commuCommentDate;
	private int commuCommentRef;
	
	//view_commuMemberCommuCommen (community + member + community_comment 테이블)
	private String commentWriterName;
	private String commentWriterProfile;
	

}
