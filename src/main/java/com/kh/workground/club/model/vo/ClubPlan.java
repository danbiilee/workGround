package com.kh.workground.club.model.vo;

import java.io.Serializable;
import java.sql.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

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
public class ClubPlan implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int clubPlanNo;
	private String clubPlanTitle;
	private String clubPlanContent;
	
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd")
	private Date clubPlanStart;
	
	private String clubPlanState;
	private String clubPlanPlace;
	private String clubPlanManager;
	private int clubNo;
	private String clubPlanColor;
	private String memberId;
	
	//가상컬럼
	private String clubManagerYN; //관리자인가 아닌가.?
	private String memberName; //사용자 이름.


	//참가자 가상컬럼 추가
	private List<ClubPlanAttendee> planAttendeeList;

}
