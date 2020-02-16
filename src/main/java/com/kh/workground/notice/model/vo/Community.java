package com.kh.workground.notice.model.vo;

import java.io.Serializable;
import java.sql.Date;
import java.util.List;

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
public class Community implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int commuNo;
	private String commuWriter;
	private String commuTitle;
	private String commuContent;
	private Date commuDate;
	private String commuOriginalFileName;
	private String commuRenamedFileName;
	
	//view_commuMemberCommuComment (community + member + community_comment 테이블)
	private String memberName; 
	private String renamedFileName; 
	private List<CommunityComment> communityCommentList;

}
