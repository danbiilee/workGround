package com.kh.workground.club.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonIOException;
import com.kh.workground.club.model.exception.ClubException;
import com.kh.workground.club.model.service.ClubService;
import com.kh.workground.club.model.service.ClubService2;
import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.club.model.vo.ClubNotice;
import com.kh.workground.club.model.vo.ClubNoticeComment;
import com.kh.workground.club.model.vo.ClubPhoto;
import com.kh.workground.club.model.vo.ClubPlan;
import com.kh.workground.club.model.vo.ClubPlanAttendee;
import com.kh.workground.member.model.vo.Member;

@Controller
public class ClubController2 {
	
private static final Logger logger = LoggerFactory.getLogger(ClubController.class);
	
	@Autowired
	ClubService2 clubService2;
	@Autowired
	ClubService clubService1;
	
	@RequestMapping("/club/clubView.do")
	public ModelAndView clubView(ModelAndView mav,
								 @RequestParam("clubNo") int clubNo, 
								 HttpServletRequest request) {
		try {
//			logger.info("clubNo={}",clubNo);
			
			Club club = clubService2.selectClub(clubNo);
//			logger.info("club={}", club);
			
			List<ClubPlan> clubPlanList = clubService2.selectClubPlanList(clubNo);
			logger.debug("clubPlanList={}", clubPlanList);
			List<ClubNotice> clubNoticeList = clubService2.selectClubNoticeList(clubNo);
//			logger.debug("clubNoticeList={}", clubNoticeList);
			List<ClubPhoto> clubPhotoList = clubService2.selectClubPhotoList(clubNo);
//			logger.debug("clubPhotoList={}", clubPhotoList);
			List<ClubNoticeComment> clubNoticeCommentList = clubService2.selectClubNoticeCommentList(clubNo);
//			logger.debug("clubNoticeCommentList={}", clubNoticeCommentList);
			List<ClubPlanAttendee> clubPlanAttendeeList = clubService2.selectAllClubPlanAttendeeList(clubNo);
//			logger.debug("clubPlanAttendeeList={}", clubPlanAttendeeList);
			List<ClubMember> clubMemberList = clubService1.selectClubMemberList(clubNo);
//			logger.debug("clubMemberList={}", clubMemberList);
			
			Member memberLoggedIn = (Member) request.getSession().getAttribute("memberLoggedIn");
//			logger.debug("memberLoggedIn={}", memberLoggedIn);
			
			Map<String, String> param = new HashMap<>();
			param.put("clubNo", clubNo+"");
			param.put("memberId", memberLoggedIn.getMemberId());
			ClubMember clubMember = clubService2.selectOneClubMember(param);
//			logger.debug("clubMember={}", clubMember);
			
			boolean isManager = false;
//			logger.debug("clubManagerYN={}", clubMember.getClubManagerYN());
			if("admin".equals(memberLoggedIn.getMemberId()) || 'Y'==clubMember.getClubManagerYN().charAt(0)) {
				isManager = true;
			}
//			logger.debug("isManager={}", isManager);
			
			mav.addObject("club", club);
			mav.addObject("clubPlanList", clubPlanList);
			mav.addObject("clubNoticeList", clubNoticeList);
			mav.addObject("clubPhotoList", clubPhotoList);
			mav.addObject("clubNoticeCommentList", clubNoticeCommentList);
			mav.addObject("clubPlanAttendeeList", clubPlanAttendeeList);
			mav.addObject("clubMemberList", clubMemberList);
			mav.addObject("clubPhotoCount", clubPhotoList.size());
			mav.addObject("clubPlanCount", clubPlanList.size());
			mav.addObject("clubNoticeCount", clubNoticeList.size());
			mav.addObject("isManager", isManager);
			mav.setViewName("club/clubView");
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw new ClubException("로그인 오류!");
		}
		
		return mav;
	}
	
	@RequestMapping("/club/clubIntroduceUpdate.do")
	public ModelAndView clubIntroduceUpdate(ModelAndView mav, 
											Club club) {
		try {
//			logger.debug("club={}", club);
			
			int result = clubService2.clubIntroduceUpdate(club);
			
			mav.addObject("msg", result>0?"동호회 소개를 성공적으로 수정하였습니다.":"동호회 소개를 수정하지 못했습니다.");
			mav.addObject("loc", "/club/clubView.do?clubNo="+club.getClubNo());
			mav.setViewName("common/msg");
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
			
		}
		
		return mav;
	}
	
	@RequestMapping("/club/clubPlanUpdate.do")
	public ModelAndView clubPlanUpdate(ModelAndView mav, 
									   ClubPlan clubPlan, 
									   @RequestParam("clubPlanDate") String clubPlanDate, 
									   int where) {
		try {
//			logger.debug("clubPlan={}", clubPlan);
//			logger.debug("clubPlanDate={}", clubPlanDate);
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date utilDate = new Date();
			try {
				utilDate = sdf.parse(clubPlanDate);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			
			java.sql.Date clubPlanStart = new java.sql.Date(utilDate.getTime());
//			logger.debug("clubPlanStart={}", clubPlanStart);
			
			clubPlan.setClubPlanStart(clubPlanStart);
//			logger.debug("clubPlan={}", clubPlan);
			
			if("예정".equals(clubPlan.getClubPlanState())) clubPlan.setClubPlanColor("success");
			else if("완료".equals(clubPlan.getClubPlanState())) clubPlan.setClubPlanColor("warning");
			else if("취소".equals(clubPlan.getClubPlanState())) clubPlan.setClubPlanColor("danger");
			
			int result = clubService2.updateClubPlan(clubPlan);
			
			mav.addObject("msg", result>0?"일정 수정을 성공적으로 완료하였습니다.":"일정 수정을 하지 못했습니다.");
			mav.addObject("loc", "/club/clubCalendar.do?clubNo="+clubPlan.getClubNo());
			if(where==1)
				mav.addObject("loc", "/club/clubView.do?clubNo="+clubPlan.getClubNo());
			mav.setViewName("common/msg");
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
			
		}
		
		return mav;
	}
	
	@RequestMapping("/club/clubPlanInsert.do")
	public ModelAndView clubPlanInsert(ModelAndView mav, 
									   ClubPlan clubPlan, 
									   @RequestParam("clubPlanDate") String clubPlanDate) {
		try {
//			logger.debug("clubPlan={}", clubPlan);
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date utilDate = new Date();
			try {
				utilDate = sdf.parse(clubPlanDate);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			
			java.sql.Date clubPlanStart = new java.sql.Date(utilDate.getTime());
//			logger.debug("clubPlanStart={}", clubPlanStart);
			
			clubPlan.setClubPlanStart(clubPlanStart);
//			logger.debug("clubPlan={}", clubPlan);
			
			if("예정".equals(clubPlan.getClubPlanState())) clubPlan.setClubPlanColor("success");
			else if("완료".equals(clubPlan.getClubPlanState())) clubPlan.setClubPlanColor("warning");
			else if("취소".equals(clubPlan.getClubPlanState())) clubPlan.setClubPlanColor("danger");
			
			int result = clubService2.clubPlanInsert(clubPlan);
			
			mav.addObject("msg", result>0?"일정을 성공적으로 추가하였습니다.":"일정을 추가하지 못했습니다.");
			mav.addObject("loc", "/club/clubView.do?clubNo="+clubPlan.getClubNo());
			mav.setViewName("common/msg");
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
			
		}
		
		return mav;
	}
	
	@RequestMapping("/club/clubNoticeUpdate.do")
	public ModelAndView clubNoticeUpdate(ModelAndView mav, 
										 ClubNotice clubNotice, 
										 @RequestParam(value="upFile", required=false) MultipartFile upFile, 
										 String delFileChk, 
										 HttpServletRequest request) {
		try {
//			logger.debug("clubNotice={}", clubNotice);
//			logger.debug("delFileChk={}", delFileChk);
//			logger.debug("delFileChk={}", delFileChk);
			
			String saveDirectory = request.getServletContext().getRealPath("/resources/upload/club/"+clubNotice.getClubNo());
			
			//동적으로 directory 생성하기
			File dir = new File(saveDirectory);
			if(dir.exists() == false)
				dir.mkdir();
			if(!"".equals(clubNotice.getClubNoticeOriginal())) {
				//신규첨부파일이 있는 경우, 기존첨부파일 삭제
				if(!"".equals(upFile.getOriginalFilename())) {
					File delFile = new File(saveDirectory, clubNotice.getClubNoticeRenamed());
					boolean result = delFile.delete();
					logger.debug("기존첨부파일삭제: {}", result?"성공!":"실패!");
					
					clubNotice.setClubNoticeOriginal(upFile.getOriginalFilename());
					String ext = clubNotice.getClubNoticeOriginal().substring(clubNotice.getClubNoticeOriginal().lastIndexOf("."));
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
					int rndNum = (int)(Math.random()*1000);
					clubNotice.setClubNoticeRenamed(sdf.format(new Date())+"_"+rndNum+ext);
				}
				//신규첨부파일이 없는 경우: 기존파일 삭제
				else if(delFileChk!=null) {
					File delFile = new File(saveDirectory, clubNotice.getClubNoticeRenamed());
					boolean result = delFile.delete();
					logger.debug("기존첨부파일삭제: {}", result?"성공!":"실패!");
					
				}
				//신규첨부파일이 없는 경우: 기존파일 유지
				else {
					logger.debug("신규첨부파일이 없는 경우 : 기존파일 유지");
					
				}
				
				try {
					upFile.transferTo(new File(saveDirectory+"/"+clubNotice.getClubNoticeRenamed()));
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				
			}
			
			int result = clubService2.clubNoticeUpdate(clubNotice);
			
			mav.addObject("msg", result>0?"공지사항을 성공적으로 수정하였습니다.":"공지사항을 수정하지 못했습니다.");
			mav.addObject("loc", "/club/clubView.do?clubNo="+clubNotice.getClubNo());
			mav.setViewName("common/msg");
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
		}
		
		return mav;
	}
	
	@RequestMapping("/club/insertClubNotice.do")
	public ModelAndView clubNoticeInsert(ModelAndView mav, 
										 ClubNotice clubNotice, 
										 @RequestParam(value="upFile", required=false) MultipartFile upFile, 
										 HttpServletRequest request) {
		try {
//			logger.debug("clubNotice={}", clubNotice);
			logger.debug("upFile={}", upFile.getOriginalFilename());
			
			Map<String, String> param = new HashMap<>();
			param.put("clubNo", clubNotice.getClubNo()+"");
			param.put("memberId", clubNotice.getMemberId());
			
			//memberLoggedIn.memberId와 clubNotice.clubNo으로 글 작성자(clubMemberNo) 넣어주기
			ClubMember clubMember = clubService2.selectOneClubMember(param);
			
			clubNotice.setClubMemberNo(clubMember.getClubMemberNo());
//			logger.debug("clubNotice={}", clubNotice);
			
			String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/club/"+clubNotice.getClubNo());
			
			//동적으로 directory 생성하기
			File dir = new File(saveDirectory);
			if(dir.exists() == false)
				dir.mkdir();
			if(!"".equals(upFile.getOriginalFilename())) {
				String clubNoticeOriginal = upFile.getOriginalFilename();
				String ext = clubNoticeOriginal.substring(clubNoticeOriginal.lastIndexOf("."));
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int)(Math.random()*1000);
				String clubNoticeRenamed = sdf.format(new Date())+"_"+rndNum+ext;
				
				try {
					upFile.transferTo(new File(saveDirectory+"/"+clubNoticeRenamed));
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				
				clubNotice.setClubNoticeOriginal(clubNoticeOriginal);
				clubNotice.setClubNoticeRenamed(clubNoticeRenamed);
			}
			
//			logger.debug("clubPhoto={}", clubPhoto);
			
			int result = clubService2.clubNoticeInsert(clubNotice);
			
			mav.addObject("msg", result>0?"공지사항을 성공적으로 추가하였습니다.":"공지사항을 추가하지 못했습니다.");
			mav.addObject("loc", "/club/clubView.do?clubNo="+clubNotice.getClubNo());
			mav.setViewName("common/msg");
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
		}
		
		return mav;
	}
	
	@PostMapping("/club/deleteClubNotice.do")
	public ModelAndView deleteClubNotice(ModelAndView mav, 
										 ClubNotice clubNotice, 
										 HttpServletRequest request) {
		try {
//			logger.debug("clubNotice={}", clubNotice);
			
			int result = clubService2.deleteClubNotice(clubNotice.getClubNoticeNo());
			
			if(result>0 && !"".equals(clubNotice.getClubNoticeRenamed())) {
				String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/club/"+clubNotice.getClubNo());
				
				//1. 파일 삭제처리
				File delFile = new File(saveDirectory, clubNotice.getClubNoticeRenamed());
				boolean bool = delFile.delete();
//			logger.debug("bool={}", bool?"파일삭제처리성공":"파일삭제처리실패");
				
				//2.파일 이동처리
//			String delDirectory = request.getSession().getServletContext().getRealPath("/resources/delete/club/"+clubPhoto.getClubNo());
//			File delFileTo = new File(delDirectory,  clubPhoto.getClubPhotoRenamed());
//			boolean bool = delFile.renameTo(delFileTo);
//			logger.debug("bool={}", bool?"파일삭제이동처리성공":"파일삭제이동처리실패");
			}
			
			mav.addObject("msg", result>0?"공지사항을 성공적으로 삭제하였습니다.":"공지사항을 삭제하지 못했습니다.");
			mav.addObject("loc", "/club/clubView.do?clubNo="+clubNotice.getClubNo());
			mav.setViewName("common/msg");
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
		}
		
		return mav;
	}
	
	@RequestMapping("/club/clubPhotoForm.do")
	public ModelAndView clubPhotoForm(ModelAndView mav, 
									  ClubPhoto clubPhoto, 
									  @RequestParam(value="upFile", required=false) MultipartFile upFile, 
									  HttpServletRequest request) {
		try {
//			logger.debug("게시물 등록 요청!");
//			logger.debug("clubPhoto={}", clubPhoto);
//			logger.debug("사용자입력 name={}", upFile.getName());
//			logger.debug("fileName={}", upFile.getOriginalFilename());
//			logger.debug("size={}", upFile.getSize());
			
			Map<String, String> param = new HashMap<>();
			param.put("clubNo", clubPhoto.getClubNo()+"");
			param.put("memberId", clubPhoto.getMemberId());
			
			//memberLoggedIn.memberId와 clubNotice.clubNo으로 글 작성자(clubMemberNo) 넣어주기
			ClubMember clubMember = clubService2.selectOneClubMember(param);
			
			clubPhoto.setClubMemberNo(clubMember.getClubMemberNo());
			
			String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/club/"+clubPhoto.getClubNo());
			
			//동적으로 directory 생성하기
			File dir = new File(saveDirectory);
			if(dir.exists() == false)
				dir.mkdir();
			
			String clubPhotoOriginal = upFile.getOriginalFilename();
			String ext = clubPhotoOriginal.substring(clubPhotoOriginal.lastIndexOf("."));
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
			int rndNum = (int)(Math.random()*1000);
			String clubPhotoRenamed = sdf.format(new Date())+"_"+rndNum+ext;
			
			try {
				upFile.transferTo(new File(saveDirectory+"/"+clubPhotoRenamed));
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			clubPhoto.setClubPhotoOriginal(clubPhotoOriginal);
			clubPhoto.setClubPhotoRenamed(clubPhotoRenamed);
			
//			logger.debug("clubPhoto={}", clubPhoto);
			
			int result = clubService2.insertClubPhoto(clubPhoto);
			
			mav.addObject("msg", result>0?"사진등록 성공!":"사진등록 실패!");
			mav.addObject("loc", "/club/clubView.do?clubNo="+clubPhoto.getClubNo());
			mav.setViewName("common/msg");
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
		}
		
		return mav;
	}
	
	@PostMapping("/club/deleteClubPhoto.do")
	public ModelAndView deleteClubPhoto(ModelAndView mav, 
										ClubPhoto clubPhoto, 
										HttpServletRequest request) {
		try {
//			logger.debug("clubPhoto={}", clubPhoto);
			
			int result = clubService2.deleteClubPhoto(clubPhoto);
			
			if(result>0 && !"".equals(clubPhoto.getClubPhotoRenamed())) {
				String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/club/"+clubPhoto.getClubNo());
				
				//1. 파일 삭제처리
				File delFile = new File(saveDirectory, clubPhoto.getClubPhotoRenamed());
				boolean bool = delFile.delete();
//			logger.debug("bool={}", bool?"파일삭제처리성공":"파일삭제처리실패");
				
				//2.파일 이동처리
//			String delDirectory = request.getSession().getServletContext().getRealPath("/resources/delete/club/"+clubPhoto.getClubNo());
//			File delFileTo = new File(delDirectory,  clubPhoto.getClubPhotoRenamed());
//			boolean bool = delFile.renameTo(delFileTo);
//			logger.debug("bool={}", bool?"파일삭제이동처리성공":"파일삭제이동처리실패");
			}
			
			mav.addObject("msg", result>0?"사진을 성공적으로 삭제하였습니다.":"사진을 삭제하지 못했습니다.");
			mav.addObject("loc", "/club/clubView.do?clubNo="+clubPhoto.getClubNo());
			mav.setViewName("common/msg");
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
		}
		
		return mav;
	}
	
	@RequestMapping("/club/insertClubPlanAttendee.do")
	public ModelAndView insertClubPlanAttendee(ModelAndView mav, 
											   ClubPlanAttendee clubPlanAttendee, 
											   @RequestParam("clubNo") int clubNo, 
											   int where) {
		try {
//			logger.debug("clubPlanAttendee={}", clubPlanAttendee);
			
			Map<String, String> param = new HashMap<>();
			param.put("clubNo", clubNo+"");
			param.put("memberId", clubPlanAttendee.getMemberId());
			
			ClubMember clubMember = clubService2.selectOneClubMember(param);
			
			clubPlanAttendee.setClubMemberNo(clubMember.getClubMemberNo());
//			logger.debug("clubPlanAttendee={}", clubPlanAttendee);
			
			List<ClubPlanAttendee> clubPlanAttendeeList = clubService2.selectClubPlanAttendeeList(clubPlanAttendee.getClubPlanNo());
//			logger.debug("clubPlanAttendeeList={}", clubPlanAttendeeList);
			
			List<Integer> clubMemberNoList = new ArrayList<>();
			for(ClubPlanAttendee a : clubPlanAttendeeList) {
				clubMemberNoList.add(a.getClubMemberNo());			
			}
//			logger.debug("clubPlanNoList={}", clubMemberNoList);
			
			mav.addObject("loc", "/club/clubCalendar.do?clubNo="+clubNo);
			if(where==1)
				mav.addObject("loc", "/club/clubView.do?clubNo="+clubNo);
			mav.setViewName("common/msg");
			
			if(clubMemberNoList.contains(clubPlanAttendee.getClubMemberNo())) {
				mav.addObject("msg", "이미 참석 예약 되어있습니다.");
				return mav;
			}
			else {
				int result = clubService2.insertClubPlanAttendee(clubPlanAttendee);
				mav.addObject("msg", result>0?"참석 예약 되었습니다.":"참석예약이 되지 않았습니다.");
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
		}
		
		return mav;
	}
	
	@PostMapping("/club/deleteClubPlanAttendee.do")
	public ModelAndView deleteClubPlanAttendee(ModelAndView mav, 
											   ClubPlanAttendee clubPlanAttendee, 
											   @RequestParam("clubNo") int clubNo, 
											   int where, 
											   HttpServletRequest request) {
		try {
//			logger.debug("clubPlanAttendee={}", clubPlanAttendee);
//			logger.debug("clubNo={}", clubNo);
			Member memberLoggedIn = (Member) request.getSession().getAttribute("memberLoggedIn");
//			logger.debug("memberLoggedIn={}", memberLoggedIn);
			
			mav.addObject("loc", "/club/clubCalendar.do?clubNo="+clubNo);
			if(where==1)
				mav.addObject("loc", "/club/clubView.do?clubNo="+clubNo);
			
			if(memberLoggedIn==null || !clubPlanAttendee.getMemberId().equals(memberLoggedIn.getMemberId())) {
				mav.addObject("msg", "본인의 일정만 취소할 수 있습니다.");
			}
			else {
				int result = clubService2.deleteClubPlanAttendee(clubPlanAttendee);
				
				mav.addObject("msg", result>0?"일정을 취소하였습니다.":"일정을 취소하지 못했습니다.");
			}
			
			mav.setViewName("common/msg");
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
		}
		
		return mav;
	}
	
	@PostMapping("/club/insertClubNoticeComment.do")
	public ModelAndView insertClubNoticeComment(ModelAndView mav, 
												ClubNoticeComment clubNoticeComment) {
		try {
//			logger.debug("clubNoticeComment={}", clubNoticeComment);
			
			int result = clubService2.insertClubNoticeComment(clubNoticeComment);
			
			mav.setViewName("redirect:/club/clubView.do?clubNo="+clubNoticeComment.getClubNo());
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
		}
		
		return mav;
	}
	
	@PostMapping("/club/deleteClubPlan.do")
	public ModelAndView deleteClubPlan(ModelAndView mav, 
									   @RequestParam("clubPlanNo") int clubPlanNo, 
									   @RequestParam("clubNo") int clubNo, 
									   int where) {
		try {
//			logger.debug("clubPlanNo={}", clubPlanNo);
//			logger.debug("clubNo={}", clubNo);
			
			int result = clubService2.deleteClubPlanAttendee(clubPlanNo);
			
			mav.addObject("msg", result>0?"일정을 성공적으로 삭제했습니다.":"일정을 삭제하지 못했습니다.");
			mav.addObject("loc", "/club/clubCalendar.do?clubNo="+clubNo);
			if(where==1)
				mav.addObject("loc", "/club/clubView.do?clubNo="+clubNo);
			mav.setViewName("common/msg");
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
		}
		
		return mav;
	}
	
	@PostMapping("/club/deleteClubNoticeComment.do")
	public ModelAndView deleteClubNoticeComment(ModelAndView mav, 
												@RequestParam("clubNoticeCommentNo") int clubNoticeCommentNo, 
												@RequestParam("clubNo") int clubNo) {
		try {
			int result = clubService2.deleteClubNoticeComment(clubNoticeCommentNo);
			
			mav.addObject("msg", result>0?"댓글을 삭제하였습니다.":"댓글을 삭제하지 못했습니다.");
			mav.addObject("loc", "/club/clubView.do?clubNo="+clubNo);
			mav.setViewName("common/msg");
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
		}
		
		return mav;
	}
	
	@RequestMapping("/club/clubFileList.do")
	public ModelAndView clubFileList(ModelAndView mav, 
									 @RequestParam("clubNo") int clubNo) {
		try {
			Club club = clubService2.selectClub(clubNo);
//			logger.info("club={}", club);
			
			List<ClubPhoto> clubPhotoList = clubService2.selectClubPhotoList(clubNo);
//			logger.debug("clubPhotoList={}", clubPhotoList);
			List<ClubNotice> clubNoticeList = clubService2.selectClubNoticeList(clubNo);
//			logger.debug("clubNoticeList={}", clubNoticeList);
			List<ClubMember> clubMemberList = clubService1.selectClubMemberList(clubNo);
//			logger.debug("clubMemberList={}", clubMemberList);
			
			mav.addObject("club", club);
			mav.addObject("clubPhotoList", clubPhotoList);
			mav.addObject("clubNoticeList", clubNoticeList);
			mav.addObject("clubMemberList", clubMemberList);
			mav.setViewName("club/clubFileList");
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
		}
		
		return mav;
	}
	
	@RequestMapping("/club/clubFileDownload.do")
	public ModelAndView clubFileDownload(ModelAndView mav, 
										 @RequestParam("oName") String oName, 
										 @RequestParam("rName") String rName, 
										 @RequestParam("clubNo") int clubNo, 
										 HttpServletRequest request, 
										 HttpServletResponse response) throws ServletException, IOException {
		try {
			String saveDirectory = request.getServletContext().getRealPath("/resources/upload/club/"+clubNo);
//			logger.debug("saveDirectory={}", saveDirectory);
			
			BufferedInputStream bis = new BufferedInputStream(new FileInputStream(saveDirectory+File.separator+rName));
			
			ServletOutputStream sos = response.getOutputStream();
			BufferedOutputStream  bos = new BufferedOutputStream(sos);
			
			String resFileName = "";
			
			boolean isMSIE = request.getHeader("user-agent").indexOf("MSIE") != -1 
					|| request.getHeader("user-agent").indexOf("Trident") != -1;
			
			if(isMSIE) {
				resFileName = URLEncoder.encode(oName, "utf-8");
				resFileName = resFileName.replaceAll("\\", "%20");
			}
			else {
				resFileName = new String(oName.getBytes("utf-8"), "iso-8859-1");
			}
			
			response.setContentType("application/oxtet-stream");
			response.setHeader("Content-Disposition", "attachment;filename="+resFileName);
			
			int read = -1;
			while((read = bis.read()) != -1) {
				bos.write(read);
			}
			bos.close();
			bis.close();
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
		}
		
		return mav;
	}
	
	@RequestMapping("/club/searchClubFile.do")
	public ModelAndView searchClubFile(ModelAndView mav, 
									   @RequestParam("keyword") String keyword, 
									   @RequestParam("clubNo") int clubNo) {
		try {
			Club club = clubService2.selectClub(clubNo);
			
			Map<String, String> param = new HashMap<>();
			param.put("keyword", keyword);
			param.put("clubNo", clubNo+"");
			logger.debug("param={}", param);
			
			List<ClubPhoto> clubPhotoList = clubService2.searchClubPhotoList(param);
			logger.debug("clubPhotoList={}", clubPhotoList);
			List<ClubNotice> clubNoticeList = clubService2.searchClubNoticeList(param);
			logger.debug("clubNoticeList={}", clubNoticeList);
			List<ClubMember> clubMemberList = clubService1.selectClubMemberList(clubNo);
			
			mav.addObject("club", club);
			mav.addObject("clubPhotoList", clubPhotoList);
			mav.addObject("clubNoticeList", clubNoticeList);
			mav.addObject("clubMemberList", clubMemberList);
			mav.setViewName("club/clubFileList");
			
		} catch (Exception e) {
			logger.debug(e.getMessage(), e);
			throw e;
		}
		
		return mav;
	}
	
	@RequestMapping("/club/searchClubContent.do")
	public ModelAndView searchClubContent(ModelAndView mav, 
										  @RequestParam("clubNo") int clubNo, 
										  @RequestParam("keyword") String keyword, 
										  HttpServletRequest request) {
		try {
//			logger.info("clubNo={}",clubNo);
			
			Club club = clubService2.selectClub(clubNo);
//			logger.info("club={}", club);
			
			Map<String, String> param = new HashMap<>();
			param.put("clubNo", clubNo+"");
			param.put("keyword", keyword);
			logger.debug("param={}", param);
			
			List<ClubPlan> clubPlanList = clubService2.searchClubPlanList(param);
			logger.debug("clubPlanList={}", clubPlanList);
			List<ClubNotice> clubNoticeList = clubService2.searchClubNoticeList(param);
			logger.debug("clubNoticeList={}", clubNoticeList);
			List<ClubPhoto> clubPhotoList = clubService2.searchClubPhotoList(param);
			logger.debug("clubPhotoList={}", clubPhotoList);
			List<ClubNoticeComment> clubNoticeCommentList = clubService2.selectClubNoticeCommentList(clubNo);
			logger.debug("clubNoticeCommentList={}", clubNoticeCommentList);
			List<ClubPlanAttendee> clubPlanAttendeeList = clubService2.selectAllClubPlanAttendeeList(clubNo);
			logger.debug("clubPlanAttendeeList={}", clubPlanAttendeeList);
			List<ClubMember> clubMemberList = clubService1.selectClubMemberList(clubNo);
			logger.debug("clubMemberList={}", clubMemberList);
			
			Member memberLoggedIn = (Member) request.getSession().getAttribute("memberLoggedIn");
			logger.debug("memberLoggedIn={}", memberLoggedIn);
			
			Map<String, String> param2 = new HashMap<>();
			param2.put("clubNo", clubNo+"");
			param2.put("memberId", memberLoggedIn.getMemberId());
			ClubMember clubMember = clubService2.selectOneClubMember(param2);
			logger.debug("clubMember={}", clubMember);
			
			boolean isManager = false;
//			logger.debug("clubManagerYN={}", clubMember.getClubManagerYN());
			if("admin".equals(memberLoggedIn.getMemberId()) || 'Y'==clubMember.getClubManagerYN().charAt(0)) {
				isManager = true;
			}
//			logger.debug("isManager={}", isManager);
			
			mav.addObject("club", club);
			mav.addObject("clubPlanList", clubPlanList);
			mav.addObject("clubNoticeList", clubNoticeList);
			mav.addObject("clubPhotoList", clubPhotoList);
			mav.addObject("clubNoticeCommentList", clubNoticeCommentList);
			mav.addObject("clubPlanAttendeeList", clubPlanAttendeeList);
			mav.addObject("clubMemberList", clubMemberList);
			mav.addObject("clubPhotoCount", clubPhotoList.size());
			mav.addObject("clubPlanCount", clubPlanList.size());
			mav.addObject("clubNoticeCount", clubNoticeList.size());
			mav.addObject("isManager", isManager);
			mav.setViewName("club/clubView");
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			throw e;
		}
		
		return mav;
	}
}
