package com.kh.workground.project.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.dao.ProjectDAO;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.vo.Project;

@Service
public class ProjectServiceImpl implements ProjectService {
	
	private static final Logger logger = LoggerFactory.getLogger(ProjectServiceImpl.class);
	
	@Autowired
	ProjectDAO projectDAO;

	@Override
	public Member selectMemberOne(String string) {
		return projectDAO.selectMemberOne(string);
	}

	@Override
	public Map<String, List<Project>> selectProjectListAll(Member memberLoggedIn) {
		Map<String, List<Project>> map = new HashMap<>(); //조회한 프로젝트 담는 맵
		String deptCode = memberLoggedIn.getDeptCode();
		String memberId = memberLoggedIn.getMemberId();
		
		//1. 부서 전체 프로젝트(최근 프로젝트) 조회
		List<Project> listByDept = projectDAO.selectListByDept(deptCode);
		
		if(listByDept==null)
			throw new ProjectException("최근 프로젝트 조회 오류!");
		else
			map.put("listByDept", listByDept);
		
		//2. 중요 표시된 프로젝트 조회
		List<Project> listByImportant = projectDAO.selectListByImportant(memberId);
		
		if(listByImportant==null)
			throw new ProjectException("중요 표시된 프로젝트 조회 오류!");
		else 
			map.put("listByImportant", listByImportant);
		
		//3. 내가 속한 프로젝트(내 워크패드 포함) 조회	
		List<Project> listByInclude = new ArrayList<>();
		
		//3-1. 내 워크패드 조회해서 listByInclude에 추가
		Project myP = projectDAO.selectMyProject(memberId);
		
		if(myP==null)
			throw new ProjectException("내 워크패드 조회 오류!");
		else 
			listByInclude.add(myP);
		
		//3-2. 1번에서 구한 프로젝트 리스트에서 내가 포함된 리스트만 listByInclude에 추가
		boolean bool = false; //내가 포함됐는지 여부
		if(!listByDept.isEmpty()) {
			for(Project p: listByDept) {
				List<Member> memList = p.getProjectMemberList();
				
				for(Member m: memList) {
					String pMemId = m.getMemberId();
					if(memberId.equals(pMemId)) 
						bool = true;
				}
				
				//포함됐으면 list에 추가
				if(bool) 
					listByInclude.add(p);
			}
		}
		
		map.put("listByInclude", listByInclude);
		
		return map;
	}

	@Override
	public List<Member> selectMemberListByDept(String deptCode) {
		List<Member> list = projectDAO.selectMemberListByDept(deptCode);
		logger.debug("list={}", list);
		
		if(list==null) 
			throw new ProjectException("부서 멤버 조회 오류!");
		
		return list;
	}

}
