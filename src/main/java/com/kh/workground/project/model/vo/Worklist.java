package com.kh.workground.project.model.vo;

import java.io.Serializable;
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
public class Worklist extends Project implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int worklistNo;
	//프로젝트 번호는 !? 
	private String worklistTitle;
	
	private List<Work> workList; //업무리스트 안의 업무들
	private int totalWorkCompletYn; //진행중인 업무 수
}
