package com.kh.workground.club.controller;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.club.model.exception.ClubException;
import com.kh.workground.club.model.service.ClubService;
import com.kh.workground.club.model.service.ClubService2;
import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.club.model.vo.ClubPlan;
import com.kh.workground.member.model.vo.Member;

@RestController
public class ClubController {

	private static final Logger logger = LoggerFactory.getLogger(ClubController.class);

	@Autowired
	ClubService clubService;
	@Autowired
	ClubService2 clubService2;

	@RequestMapping("/club/clubList.do")
	public ModelAndView clubList(ModelAndView mav, HttpSession session) {

		try {
			Member memberLoggedIn = (Member) session.getAttribute("memberLoggedIn");
			String memberId = memberLoggedIn.getMemberId();
			Map map = new HashMap<>();
			map.put("memberId", memberId);
			map.put("sort", "club_enroll_date");
			map.put("category", "%_%");

			// 모달창을 띄우기 위해 정보를 보낸다.
			List<Club> clubList = clubService.selectAllClubList(map); // 전체 동호회

			mav.addObject("clubList", clubList);
			mav.setViewName("/club/clubList");

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("동호회 목록 불러오기 오류!");
		}

		return mav;
	}

	@GetMapping("/club/clubListBySort.do")
	public Map<String, List> clubListBySortAndCategroy(@RequestParam("sort") String sort,
													   @RequestParam("category") String category,
													  HttpSession session) {

		Map<String, List> map = new HashMap<>();

		try {
			Member memberLoggedIn = (Member) session.getAttribute("memberLoggedIn");
			String memberId = memberLoggedIn.getMemberId();

			Map param = new HashMap<>();
			param.put("memberId", memberId);
			
			List<Club> clubList = null;
			List<Club> myClubList = null;
			List<Club> standByClubList = null;
			
			if (sort.equals("이름순")) {
				param.put("sort", "club_name");
			} else {
				param.put("sort", "club_enroll_date");
			}
			
			if(category.equals("전체")) {
				clubList = clubService.selectAllClubList(param); // 전체 동호회
				myClubList = clubService.selectAllMyClubList(param); // 가입한 동호회
				standByClubList = clubService.selectAllStandByClubList(param); // 승인 대기중인 동호회
			}
			else {
				param.put("category",category);
				clubList = clubService.selectAllClubListByCategory(param); // 전체 동호회
				myClubList = clubService.selectAllMyClubListByCategory(param); // 가입한 동호회
				standByClubList = clubService.selectAllStandByClubListByCategory(param); // 승인 대기중인 동호회
				
			}

		

			map.put("clubList", clubList);
			map.put("myClubList", myClubList);
			map.put("standByClubList", standByClubList);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("동호회 목록 정렬오류!");
		}

		return map;

	}

	@PostMapping("/club/insertNewClub.do")
	public ModelAndView insertNewClub(ModelAndView mav, Club club) {

		try {
			logger.info("club={}", club);

			int result = clubService.insertNewClub(club);
			mav.addObject("msg", result > 0 ? "동호회 개설 성공!" : "동호회 개설 실패");
			mav.addObject("loc", "/club/clubList.do");
			mav.setViewName("common/msg");

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("동호회 개설 오류!");
		}

		return mav;

	}

	@RequestMapping("/club/deleteClub.do")
	public ModelAndView deleteClub(ModelAndView mav, @RequestParam(value = "clubNo") int clubNo) {

		try {
			// logger.info("clubNo={}", clubNo);
			int result = clubService.deleteClub(clubNo);
			// logger.info("result={}", result);
			mav.addObject("msg", result > 0 ? "동호회 삭제 성공!" : "동호회 삭제 실패");
			mav.addObject("loc", "/club/clubList.do");
			mav.setViewName("common/msg");

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("동호회 삭제 오류!");
		}

		return mav;

	}

	@RequestMapping("/club/updateClub.do")
	public ModelAndView updateClub(ModelAndView mav, Club club) {
		try {
			// logger.info("club={}",club);
			int result = clubService.updateClub(club);
			// logger.info("result={}",result);

			mav.addObject("msg", result > 0 ? "동호회 수정 성공" : "동호회 수정 실패");
			mav.addObject("loc", "/club/clubList.do");
			mav.setViewName("common/msg");

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("동호회 수정 오류!");
		}
		return mav;
	}

	@PostMapping("/club/insertClubMember.do")
	public ModelAndView insertClubMember(ModelAndView mav, @RequestParam(value = "clubNo") int clubNo,
			@RequestParam(value = "memberId") String memberId) {

		// logger.info("clubNo={}",clubNo);
		// logger.info("memberId={}",memberId);
		try {
			Map map = new HashMap<>();
			map.put("clubNo", clubNo);
			map.put("memberId", memberId);

			int result = clubService.insertClubMember(map);

			mav.addObject("msg", result > 0 ? "동호회 가입 요청" : "동호회 가입요청 실패");
			mav.addObject("loc", "/club/clubList.do");
			mav.setViewName("common/msg");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("동호회 삭제 오류!");
		}
		return mav;
	}

	@RequestMapping("/club/clubMemberList.do")
	public ModelAndView selectClubMember(ModelAndView mav, @RequestParam(value = "clubNo") int clubNo) {

		try {
			List<ClubMember> memberList = clubService.selectClubMemberList(clubNo);
			logger.info("memberList{}", memberList);
			Club club = clubService2.selectClub(clubNo);

			mav.addObject("memberList", memberList);
			mav.addObject("club", club);
			mav.addObject("clubNo", clubNo);
			mav.addObject("searchKeyword", "no");

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("동호회 멤버 호출 오류!");
		}

		return mav;
	}

	@RequestMapping("/club/deleteClubMember.do")
	public ModelAndView deleteClubMEmber(ModelAndView mav, @RequestParam(value = "clubNo") int clubNo,
			@RequestParam(value = "clubMemberNo") int clubMemberNo) {
		try {

			logger.info("clubMemberNo{}", clubMemberNo);
			int result = clubService.deleteClubMember(clubMemberNo);

			mav.addObject("msg", result > 0 ? "회원 탈퇴 성공" : "회원 탈퇴 실패");
			mav.addObject("loc", "/club/clubMemberList.do?clubNo=" + clubNo);
			mav.setViewName("common/msg");

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("동호회 멤버 탈퇴 오류!");
		}

		return mav;
	}

	@RequestMapping("/club/updateClubManager.do")
	public ModelAndView updateClubManager(ModelAndView mav, @RequestParam(value = "clubNo") int clubNo,
			@RequestParam(value = "memberId") String memberId) {

		try {
			Map param = new HashMap<>();
			param.put("clubNo", clubNo);
			param.put("memberId", memberId);

			int result = clubService.updateClubManager(param);
			logger.info("result{}", result);
			mav.addObject("msg", result > 0 ? "관리자 변경 성공" : "관리자 변경 실패");
			mav.addObject("loc", "/club/clubMemberList.do?clubNo=" + clubNo);
			mav.setViewName("common/msg");

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("동호회 관리자 추가 오류!");
		}
		return mav;
	}

	@RequestMapping("/club/approveClubMember.do")
	public ModelAndView approveClubMember(ModelAndView mav, @RequestParam(value = "clubNo") int clubNo,
			@RequestParam(value = "memberId") String memberId) {

		try {
			Map param = new HashMap<>();
			param.put("clubNo", clubNo);
			param.put("memberId", memberId);

			int result = clubService.approveClubMember(param);
			// logger.info("result{}", result);
			mav.addObject("msg", result > 0 ? "회원 승인" : "회원 승인 실패");
			mav.addObject("loc", "/club/clubMemberList.do?clubNo=" + clubNo);
			mav.setViewName("common/msg");

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("회원 승인 오류!");
		}

		return mav;
	}

	@RequestMapping("/club/searchClubMember.do")
	public ModelAndView searchClubMember(ModelAndView mav, @RequestParam(value = "keyword") String keyword,
			@RequestParam(value = "clubNo") int clubNo) {

		try {
			Map param = new HashMap<>();
			param.put("keyword", keyword);
			param.put("clubNo", clubNo);
			// logger.info("clubNo={}",clubNo);
			List<ClubMember> memberList = clubService.searchClubMember(param);
			// logger.info("memberList{}", memberList);

			mav.addObject("memberList", memberList);
			mav.addObject("clubNo", clubNo);
			mav.addObject("searchKeyword", "no");
			mav.setViewName("/club/clubMemberList");

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("동호회 멤버 검색 오류!");
		}

		return mav;
	}

	@RequestMapping("/club/clubCalendar.do")
	public ModelAndView selectClubSchedule(ModelAndView mav,HttpSession session, @RequestParam(value = "clubNo") int clubNo) {
		List<ClubPlan> clubPlanList = null;

		try {

			// 일정가져오기
			clubPlanList = clubService.selectClubPlanList(clubNo);
			String calString = "";
			calString += "events: [";
			/*
			 * title : 'All Day Event', start : new Date(y, m, 2), end : new Date(y, m, 2),
			 * backgroundColor: '#f56954', //red borderColor : '#f56954', //red
			 * 
			 */
			for (int i = 0; i < clubPlanList.size(); i++) {

				calString += "{";
				String calNoAndTitle = clubPlanList.get(i).getClubPlanNo() + ","
						+ clubPlanList.get(i).getClubPlanTitle();

				// title
				calString += "title :" + "'" + calNoAndTitle + "'" + ",";
				// 시작날짜 구하기
				SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
				String sDate = fmt.format(clubPlanList.get(i).getClubPlanStart());

				String dateArr[] = sDate.split("-");
				String date = dateArr[0] + " , " + (Integer.parseInt(dateArr[1]) - 1) + " , " + (Integer.parseInt(dateArr[2])-1);

				calString += "start :new Date(" + date + "),";

				String color = "";
				if ("예정".equals(clubPlanList.get(i).getClubPlanState()))
					color = "#239d3f";
				else if ("완료".equals(clubPlanList.get(i).getClubPlanState()))
					color = "#eef946";
				else if ("취소".equals(clubPlanList.get(i).getClubPlanState()))
					color = "#ed5a5a";

				calString += "backgroundColor: '" + color + "',";
				calString += "borderColor: '" + color +"'";

				if (clubPlanList.size() - 1 == i) {

					calString += "}";
				} else {

					calString += "},";
				}

			}
			calString += "]";
			
			//clubNo를 가지고 club_member의 manager_YN이 Y인지 관리자 여부 판단하기
			Map param = new HashMap<>();
			Member memberLoggedIn = (Member) session.getAttribute("memberLoggedIn");
			param.put("memberId", memberLoggedIn.getMemberId());
			param.put("clubNo", clubNo);
			
			ClubMember clubMember = clubService2.selectOneClubMember(param);
			
			mav.addObject("calString", calString);
			mav.addObject("managerYN", clubMember.getClubManagerYN());
			mav.addObject("clubNo", clubNo);
			

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("동호회 일정 페이지 오류!");
		}

		return mav;
	}

	@GetMapping("/club/selectOneClubPlan.do")
	@ResponseBody
	public Map<String,List> selectOneClubPlan(ModelAndView mav, @RequestParam(value = "clubPlanNo") int clubPlanNo) {
		
		Map map = new HashMap<>();
		try {
			ClubPlan clubPlan = clubService.selectOneClubPlan(clubPlanNo);
		
			//날짜를 util.date로 바꿔서 돌려주기.
			logger.info("clubPlanDate={}",clubPlan.getClubPlanStart());
			logger.info("clubPlan={}",clubPlan);
			map.put("clubPlan", clubPlan);
							
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("동호회 일정 가져오기 오류!");
		}
		
		return map;
	}

}
