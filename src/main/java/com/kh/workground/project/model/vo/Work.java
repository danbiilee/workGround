package com.kh.workground.project.model.vo;

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
public class Work extends Worklist implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int workNo;
	private String workTitle;
	private String workDesc;
	private int workPoint;
	private Date workStartDate;
	private Date workEndDate;
	private Date workRealEndDate;
	private String workCompleteYn;
	private String workTagCode; 
	private String workTagTitle; //work_tag테이블값 
	private String workTagColor; //work_tag테이블값 
	private int workNoRef; //참조할 업무번호  
	
	private List<Member> workChargedMemberList; //업무에 배정된 멤버 리스트
	private List<Checklist> checklistList; //업무안의 체크리스트 리스트
	private List<Attachment> attachmentList; //업무에 첨부된 파일 리스트
	private List<WorkComment> workCommentList; //업무에 달린 코멘트 리스트
	
}
