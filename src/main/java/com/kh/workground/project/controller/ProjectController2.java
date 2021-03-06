package com.kh.workground.project.controller;


import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.service.ProjectService2;
import com.kh.workground.project.model.vo.Attachment;
import com.kh.workground.project.model.vo.Checklist;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;
import com.kh.workground.project.model.vo.WorkComment;
import com.kh.workground.project.model.vo.Worklist;

@Controller
public class ProjectController2 {
	// 혜민 컨트롤러
	private static final Logger logger = LoggerFactory.getLogger(ProjectController2.class);
	
	@Autowired
	ProjectService2 projectService;
	
	@RequestMapping("/project/addProject.do")
	public ModelAndView addProject(@RequestParam String projectTitle, @RequestParam(value="projectDesc", required=false) String projectDesc, @RequestParam(value="projectMember", required=false) String projectMember, HttpSession session
			,ModelAndView mav) {
		try {
			Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
			
			Project p = new Project();
			p.setProjectTitle(projectTitle);
			p.setProjectWriter(memberLoggedIn.getMemberId());
			p.setProjectDesc(projectDesc);
			
			List<String> projectMemberList = null;
			if(projectMember != null && projectMember != "") {
				String[] memberArr = projectMember.split(",");
				projectMemberList = new ArrayList<>(Arrays.asList(memberArr));
			}
			//project 생성
			int result = projectService.insertProject(p, projectMemberList);
			
			mav.addObject("msg", result>0?"프로젝트 등록 성공!":"프로젝트 등록 실패!");
			mav.addObject("loc","/project/projectList.do");
			mav.setViewName("common/msg");
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 생성 오류!");
		}
		
		return mav;
	}
	
	@RequestMapping("/project/projectDeptMember.do")
	@ResponseBody
	public List<Member> projectDeptMember(HttpSession session){
		List<Member> list = null;
		try {
				//나를 제외한 부서 사람 리스트
				Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
				Map<String, String> param = new HashMap<>();
				param.put("memberId", "'"+memberLoggedIn.getMemberId()+"'");
				param.put("deptCode", memberLoggedIn.getDeptCode());
				list = projectService.selectMemberListByDeptCode(param);
				
			}catch(Exception e) {
				logger.error(e.getMessage(), e);
				throw new ProjectException("부서별 프로젝트 멤버 조회 오류!");
			}
		return list;
	}
	
	@RequestMapping("/project/projectSetting.do")
	public ModelAndView projectSetting(ModelAndView mav, HttpServletRequest request) {
		int projectNo = Integer.parseInt(request.getParameter("projectNo"));
		
		try {
			//프로젝트 팀원 리스트에 팀장 포함이면 true, 제외하면 false
			Project p = projectService.selectProjectOneForSetting(projectNo);
			
			//프로젝트 작성자 멤버 객체
			Member pwriter = projectService.selectMemberOneByMemberId(p.getProjectWriter());
			
			//프로젝트 활동로그
			List<Map<String, Object>> logList = projectService.selectProjectLogList(projectNo);
			
			mav.addObject("project", p);
			mav.addObject("projectWriter", pwriter);
			mav.addObject("logList", logList);
			mav.setViewName("/project/projectSettingSideBar");
			
		}catch(Exception e){
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 속성 조회 오류!");
		}
		return mav;
	}
	
	@RequestMapping("/project/projectSettingMember.do")
	@ResponseBody
	public Map<String,List<Member>> projectManagerSetting(HttpServletRequest request){
		Map<String, List<Member>> map = null;
		try {
			int projectNo = Integer.parseInt(request.getParameter("projectNo"));
			
			map = projectService.selectProjectSettingMemberList(projectNo);
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 세팅 멤버 조회 오류!");
		}
		return map;
	}
	
	@RequestMapping("/project/workSetting.do")
	@ResponseBody
	public ModelAndView workSetting(ModelAndView mav, HttpServletRequest request) {
		int workNo = Integer.parseInt(request.getParameter("workNo"));
		String worklistTitle = request.getParameter("worklistTitle");
		int projectNo = Integer.parseInt(request.getParameter("projectNo"));
		
		try {
			Project p = projectService.selectProjectOneForSetting(projectNo);
			
			Work work = projectService.selectOneWorkForSetting(workNo);
			
			mav.addObject("project", p);
			mav.addObject("work", work);
			mav.addObject("worklistTitle",worklistTitle);
			mav.setViewName("/project/workSettingSideBar");
			
		}catch(Exception e){
			
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 속성 조회 오류!");
			
		}
		
		return mav;
	}
	
	@RequestMapping("/project/workChargedMemberSetting.do")
	@ResponseBody
	public Map<String,List<Member>> workChargedMemberSetting(HttpServletRequest request){
		Map<String, List<Member>> map = null;
			try {
				int projectNo = Integer.parseInt(request.getParameter("projectNo"));
				int workNo = Integer.parseInt(request.getParameter("workNo"));
				
				map = new HashMap<>();
				
				Project p = projectService.selectProjectOneForSetting(projectNo);
				Work work = projectService.selectOneWorkForSetting(workNo);
				
				//프로젝트 팀원 리스트
				List<Member> projectMemberList = p.getProjectMemberList();
				
				//업무에 배정된 멤버 리스트
				List<Member> workChargedMemberList = work.getWorkChargedMemberList();
				
				map.put("projectMemberList", projectMemberList);
				map.put("workChargedMemberList", workChargedMemberList);
				
			}catch(Exception e) {
				logger.error(e.getMessage(), e);
				throw new ProjectException("프로젝트 팀원 조회 오류!");
			}
		return map;
	}
	
	@RequestMapping("/project/updateStatusCode.do")
	@ResponseBody
	public Map<String, Object> updateStatusCode(@RequestParam String statusCode, @RequestParam int projectNo){
		Map<String, Object> map = new HashMap<>();
		
		try {
			
			Map<String, Object> param = new HashMap<>();
			param.put("projectNo", projectNo);
			param.put("statusCode", statusCode);
			
			int result = projectService.updateStatusCode(param);
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated );
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 상태코드 수정 오류!");
		}
		
		return map;
	}
	
	@RequestMapping("/project/updateProjectDate.do")
	@ResponseBody
	public Map<String, Object> updateProjectDate(@RequestParam String date, @RequestParam String dateType,@RequestParam String projectNo){
			Map<String, Object> map = new HashMap<>();
		
		try {
			Map<String, String> param = new HashMap<>();
			param.put("date", date);
			param.put("dateType", dateType);
			param.put("projectNo", projectNo);
			
			int result = projectService.updateProjectDate(param);
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated );
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 날짜 수정 오류!");
		}
		
		return map;
	}
	
	@RequestMapping("/project/updateProjectMember.do")
	@ResponseBody
	public Map<String, Object> updateProjectMember(@RequestParam String updateMemberStr, @RequestParam int projectNo) {
			Map<String, Object> map = new HashMap<>();
		
		try {
			int result=0;
			
			//모두 삭제할 경우
			if(("").equals(updateMemberStr) || updateMemberStr ==null) {
				Map<String, String> param = new HashMap<>();
				param.put("projectNo", Integer.toString(projectNo));
				param.put("quitYN", "Y");
				result = projectService.updateProjectQuit(param);
			}else {
				result = projectService.updateProjectMember(updateMemberStr, projectNo);
			}
			
			Project p = projectService.selectProjectOneForSetting(projectNo);
			List<Member> memberList = p.getProjectMemberList();
			
			int memberCnt = memberList.size();
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated);
			map.put("memberList",memberList);
			map.put("memberCnt",memberCnt);
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 팀원 수정 오류!");
		}
		return map;
	}
	
	@RequestMapping("/project/updateProjectManager.do")
	@ResponseBody
	public Map<String, Object> updateProjectManager(@RequestParam String updateManager, @RequestParam int projectNo){
		Map<String, Object> map = new HashMap<>();
		
		try {

			int result = projectService.updateProjectManager(updateManager, projectNo);
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated );
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 관리자 수정 오류!");
		}
		return map;
	}
	
	@RequestMapping("/project/quitProject.do")
	public ModelAndView quitProject(@RequestParam int projectNo, ModelAndView mav, HttpSession session) {
		
		try{
			Member m = (Member)session.getAttribute("memberLoggedIn");
			String memberId = m.getMemberId();
			
			Map<String, String> param = new HashMap<>();
			param.put("projectNo", Integer.toString(projectNo));
			param.put("projectMember", memberId);
			param.put("quitYN", "Y");
			
			int result = projectService.updateProjectQuit(param);
			
			mav.addObject("msg", result>0?"성공적으로 처리되었습니다.":"처리를 실패하었습니다.");
			mav.addObject("loc","/project/projectList.do");
			mav.setViewName("common/msg");
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 나가기 오류!");
		}
		return mav;
	}
	
	@RequestMapping("/project/updateWorkMember.do")
	@ResponseBody
	public Map<String, Object> updateWorkMember(@RequestParam String updateWorkMemberStr, @RequestParam int workNo) {
			Map<String, Object> map = new HashMap<>();
		try {
			int result = 0;
			//모두 삭제할 경우
			if(("").equals(updateWorkMemberStr) || updateWorkMemberStr ==null) {
				Map<String,String> param = new HashMap<>();
				param.put("workNo",Integer.toString(workNo));
				result = projectService.deleteWorkMember(param);
			}else {
				result = projectService.updateWorkMember(updateWorkMemberStr, workNo);
			}
			
			boolean isUpdated = result==0?false:true;
			map.put("isUpdated",isUpdated);
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 배정 멤버 수정 오류!");
		}
		return map;
	}
	
	@RequestMapping("/project/updateWorkTag.do")
	@ResponseBody
	public Map<String, Object> updateWorkTag(@RequestParam String workTag, @RequestParam int workNo){
		Map<String, Object> map = new HashMap<>();
			try {
				
				Map<String, Object> param = new HashMap<>();
				param.put("workNo", workNo);
				param.put("workTag", workTag);
				
				int result = projectService.updateWorkTag(param);
				
				boolean isUpdated = result>0?true:false;
				map.put("isUpdated",isUpdated );
				
			}catch(Exception e) {
				logger.error(e.getMessage(), e);
				throw new ProjectException("업무 태그 수정 오류!");
			}
		return map;
	}
	
	@RequestMapping("/project/updateWorkPoint.do")
	@ResponseBody
	public Map<String, Object> updateWorkPoint(@RequestParam int workPoint ,@RequestParam int workNo){
		Map<String, Object> map = new HashMap<>();
		try {
			
			Map<String, Integer> param = new HashMap<>();
			param.put("workNo", workNo);
			param.put("workPoint", workPoint);
			
			int result = projectService.updateWorkPoint(param);
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated );
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 포인트 수정 오류!");
		}
		return map;
	}
	
	@RequestMapping("/project/updateWorkDate.do")
	@ResponseBody
	public Map<String, Object> updateWorkDate(@RequestParam String date, @RequestParam String dateType,@RequestParam String workNo){
			Map<String, Object> map = new HashMap<>();
		
		try {
			Map<String, String> param = new HashMap<>();
			param.put("date", date);
			param.put("dateType", dateType);
			param.put("workNo", workNo);
			
			int result = projectService.updateWorkDate(param);
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated );
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 날짜 수정 오류!");
		}
		
		return map;
	}
	
	@RequestMapping("/project/insertCheckList.do")
	@ResponseBody
	public Map<String, Object> insertCheckList(@RequestParam int workNo, @RequestParam String chkWriter, @RequestParam String chkContent){
		Map<String, Object> map = new HashMap<>();
		
		try {
			Checklist chk = new Checklist();
			chk.setWorkNo(workNo);
			chk.setChecklistContent(chkContent);
			chk.setChecklistWriter(chkWriter);
			
			//insert한 checklist 객체 가져오기
			Checklist checklist = projectService.insertCheckList(chk);
			
			map.put("checklist",checklist);
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 날짜 수정 오류!");
		}
		
		return map;
	}
	
	@RequestMapping("/project/updateWorkLocation.do")
	@ResponseBody
	public Map<String, Object> updateWorkLocation(@RequestParam int workNo, @RequestParam int worklistNo){
		Map<String, Object> map = new HashMap<>();
		try {
			
			Map<String, Integer> param = new HashMap<>();
			param.put("worklistNo", worklistNo);
			param.put("workNo", workNo);
			
			int result = projectService.updateWorkLocation(param);
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated);
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 이동 오류!");
		}
		return map;
	}
	
	@RequestMapping("/project/updateChkChargedMember.do")
	@ResponseBody
	public Map<String, Object> updateChkChargedMember(@RequestParam String checklistNo, @RequestParam String memberId, @RequestParam String workNo){
		Map<String, Object> map = new HashMap<>();
		try {
			
			Map<String, String> param = new HashMap<>();
			param.put("checklistNo", checklistNo);
			param.put("memberId", memberId);
			param.put("workNo", workNo);
			
			int result = projectService.updateChkChargedMember(param);
			
			boolean isUpdated = false;
			if(result>0) {
				isUpdated = true;
				map.put("isUpdated",isUpdated);
				Member member = null;
				if(!("").equals(memberId)) {
					member = projectService.selectMemberOneByMemberId(memberId);
				}
				map.put("member", member);
			}
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("체크리스트 멤버 배정 오류!");
		}
		return map;
	}
	
	@RequestMapping("/project/deleteChecklist.do")
	@ResponseBody
	public Map<String, Object> deleteChecklist(@RequestParam int checklistNo){
		Map<String, Object> map = new HashMap<>();
		try {
			
			int result = projectService.deleteChecklist(checklistNo);
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated);
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("체크리스트 삭제 오류!");
		}
		return map;
	}
	
	@RequestMapping("/project/updateDesc.do")
	@ResponseBody
	public Map<String, Object> updateDesc(@RequestParam String no, @RequestParam String desc, @RequestParam String type){
		Map<String, Object> map = new HashMap<>();
		try {
			
			Map<String, String> param = new HashMap<>();
			param.put("no", no);
			param.put("type", type);
			param.put("desc", desc);
			
			int result = projectService.updateDesc(param);
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated);
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 설명 수정 오류!");
		}
		return map;
	}
	
	@RequestMapping("/project/updateTitle.do")
	@ResponseBody
	public Map<String, Object> updateTitle(@RequestParam String no, @RequestParam String title, @RequestParam String type){
		Map<String, Object> map = new HashMap<>();
		try {
			
			Map<String, String> param = new HashMap<>();
			param.put("no", no);
			param.put("type", type);
			param.put("title", title);
			
			int result = projectService.updateTitle(param);
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated);
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 제목 수정 오류!");
		}
		return map;
	}
	
	@RequestMapping("/project/insertWorkComment.do")
	@ResponseBody
	public Map<String, Object> insertWorkComment(@RequestParam int workNo, @RequestParam String commentContent,
			@RequestParam String commentWriter, @RequestParam int commentLevel, @RequestParam String commentRef){
		Map<String, Object> result = new HashMap<>();
		try {
			//XSS공격대비 &문자변환
			commentContent = commentContent.replaceAll("<", "&lt;")
									   .replaceAll(">", "&gt;")
									   .replaceAll("\\n", "<br/>");//개행문자처리
			
			WorkComment wc = new WorkComment();
			wc.setWorkNo(workNo);
			wc.setWorkCommentContent(commentContent);
			wc.setWorkCommentWriterId(commentWriter);
			wc.setWorkCommentLevel(commentLevel);
			if(commentLevel == 2) wc.setWorkCommentRef(Integer.parseInt(commentRef));
			
			result = projectService.insertWorkComment(wc);
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 제목 수정 오류!");
		}
		return result;
	}
	
	@RequestMapping("/project/deleteWorkComment.do")
	@ResponseBody
	public Map<String, Object> deleteWorkComment(@RequestParam int commentNo){
		Map<String, Object> map = new HashMap<>();
		try {
			
			int result = projectService.deleteWorkComment(commentNo);
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated);
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 코멘트 삭제 오류!");
		}
		return map;
	}
	
	@RequestMapping("/project/uploadWorkFile.do")
	@ResponseBody
	public Map<String, Object> uploadWorkFile(MultipartHttpServletRequest request){
		Map<String, Object> result;
		try {
			String projectNo = request.getParameter("projectNo");
			String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/project/"+projectNo);
			MultipartFile f = request.getFile("workFile");
			Attachment attach = new Attachment();
			
			//동적으로 directory 생성하기
			File dir = new File(saveDirectory);
			if(dir.exists() == false)
				dir.mkdir();
			
			//MultipartFile 객체 파일 업로드 처리 시작 /////////////
				if(!f.isEmpty()) {
					//파일명 재생성
					String originalFileName = f.getOriginalFilename();
					String ext = originalFileName.substring(originalFileName.lastIndexOf("."));
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
					int rndNum = (int)(Math.random()*1000);
					String renamedFileName = sdf.format(new Date())+"_"+rndNum+ext;
					
					//	서버 컴퓨터에 파일 저장
					try {
						f.transferTo(new File(saveDirectory+"/"+renamedFileName));
					
					} catch (IllegalStateException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}
					
					attach.setOriginalFilename(originalFileName);
					attach.setRenamedFilename(renamedFileName);
					attach.setAttachmentWriterId(request.getParameter("memberId"));
					attach.setWorkNo(Integer.parseInt(request.getParameter("workNo")));
				}
			//MultipartFile 객체 파일 업로드 처리 끝 /////////////
			
			//2. 업무로직
			result = projectService.insertWorkFile(attach);
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 파일 업로드 오류!");
		}
		return result;
	}
	
	@RequestMapping("/project/resetWorkOne.do")
	@ResponseBody
	public ModelAndView resetWorkOne(ModelAndView mav,@RequestParam int workNo,@RequestParam String projectNo, @RequestParam String worklistTitle) {
		try {
			
			//work객체 가져오기
			Work work = projectService.selectOneWorkForSetting(workNo);
			
			mav.addObject("w", work);
			mav.addObject("worklistTitle",worklistTitle);
			mav.addObject("projectNo",projectNo);
			mav.setViewName("/project/ajaxWorkOne");
			
		}catch(Exception e){
			
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 속성 조회 오류!");
			
		}
		return mav;
	}
	
	@RequestMapping("/project/projectAnalysis.do")
	public ModelAndView projectAnalysis(ModelAndView mav, HttpServletRequest request, HttpSession session) {
		try {
			Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
			
			int projectNo = Integer.parseInt(request.getParameter("projectNo"));
			
			//프로젝트 개요를 위한 프로젝트 객체
			Project p = projectService.selectProjectOneForSetting(projectNo);
			
			//내가 배정받은 업무 리스트
			List<Work> myWorkList = projectService.selectMyWorkList(projectNo, memberLoggedIn.getMemberId());
			
			//내 활동 이력
			Map<String, Integer> cntMap = projectService.selectMyActivity(projectNo, memberLoggedIn.getMemberId());
			
			mav.addObject("project",p);
			mav.addObject("myWorkList",myWorkList);
			mav.addObject("myActivityCnt",cntMap);
			
			mav.setViewName("/project/projectAnalysis");
			
		}catch(Exception e){
			
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 속성 조회 오류!");
			
		}
		
		return mav;
	}
	
	@RequestMapping("/project/updateChklist.do")
	@ResponseBody
	public Map<String,Object> updateChklist(@RequestParam String chkContent,@RequestParam String chkNo){
		Map<String, Object> map = new HashMap<>();
		try{
			
			Map<String, String> param = new HashMap<>();
			param.put("chkContent", chkContent);
			param.put("chkNo", chkNo);
			int result = projectService.updateChklist(param);
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated);
			
		}catch(Exception e){
			
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 속성 조회 오류!");
			
		}
		return map;
	}
	
	@RequestMapping("/project/getMyManagingProjectList.do")
	@ResponseBody
	public List<Project> getMyManagingProjectList(HttpSession session){
		List<Project> list = null;
		try {
			
			Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
			String memberId = memberLoggedIn.getMemberId();
			
			list = projectService.selectMyManagingProjectList(memberId);
			
		}catch(Exception e){
			logger.error(e.getMessage(), e);
			throw new ProjectException("내 프로젝트 리스트(매니저) 조회 오류!");
		}
		return list;
	}
	
	@RequestMapping("/project/getWorklistByProjectNo.do")
	@ResponseBody
	public List<Worklist> getWorklistByProjectNo(@RequestParam int projectNo){
		List<Worklist> list = null;
		try {
			
			list = projectService.selectWorklistByProjectNo(projectNo);
			
		}catch(Exception e){
			logger.error(e.getMessage(), e);
			throw new ProjectException("내 프로젝트 리스트(매니저) 조회 오류!");
		}
		return list;
	}
	
	@RequestMapping("/project/copyWork.do")
	@ResponseBody
	public Map<String,Object> copyWork(@RequestParam int workNo,@RequestParam int worklistNo,HttpSession session){
		Map<String,Object> map = null;
		try {
			map = new HashMap<>();
			Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
			logger.debug("worklistNo={}",worklistNo);
			int result = projectService.insertCopyWork(workNo,worklistNo,memberLoggedIn);

			map.put("isComplete", result>0?true:false);
		}catch(Exception e){
			logger.error(e.getMessage(), e);
			throw new ProjectException("내 프로젝트 리스트(매니저) 조회 오류!");
		}
		return map;
	}
}
