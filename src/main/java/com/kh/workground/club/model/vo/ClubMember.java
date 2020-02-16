package com.kh.workground.club.model.vo;

import java.io.Serializable;
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
public class ClubMember implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int clubMemberNo;
	private String empId;
	private int clubCode;
	private String clubManagerYN;
	private String clubApproveYN;
	
	//부서 이름 가상컬럼
	private String deptTitle;
		
	//직급 이름 가상컬럼
	private String jobTitle;
	
	//멤버 정보 가상컬럼
	private List<Member> clubMemberList;
	
	
}

