package com.kh.workground.member.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.member.model.exception.MemberException;
import com.kh.workground.member.model.service.MemberService;
import com.kh.workground.member.model.vo.Member;

@SessionAttributes(value={"memberLoggedIn"})
@Controller
public class MemberController {

	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

	@Autowired
	MemberService memberSerivce;

	@Autowired
	BCryptPasswordEncoder bcryptPasswordEncoder;
	
	@Autowired
	private JavaMailSender mailSender;
	
	@RequestMapping("/member/memberRegister.do")
	public void memberRegister() {
	}

	@RequestMapping("/member/memberList.do")
	public ModelAndView memberList(ModelAndView mav) {
		try {
			//1. 업무로직
			List<Member> list = memberSerivce.selectMemberListAll();
			logger.debug("list={}", list);
			
			//2. 뷰모델 처리
			mav.addObject("list", list);
			mav.setViewName("/member/memberList");
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new MemberException("멤버리스트 조회 오류!", e);
		}

		return mav;
	}
	
	@RequestMapping("/member/memberView.do")
	public ModelAndView memberView(ModelAndView mav, 
								   @RequestParam String memberId, 
								   @RequestParam(value="active", defaultValue="profile", required=false) String active) {
		logger.debug("active={}", active);
		
		try {
			//1.업무로직
			//logger.debug("memberId={}", memberId);
			Member m = memberSerivce.selectOneMember(memberId);
			
			//2.뷰모델 처리
			//나중에 업무로직 하고 나서 memberId는 지우기!! 
			//memberView.jsp에서도 c:if태그에서 memberId로 되어있는 부분 수정하기!!!! 
			mav.addObject("m", m);
			mav.addObject("active", active);
			mav.setViewName("/member/memberView");
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new MemberException("멤버 조회 오류!", e);
		}
		
		return mav;
	}

	/*@PostMapping("/member/memberLogin.do")
	public ModelAndView memberLogin(@RequestParam String memberId, @RequestParam String password, ModelAndView mav,
			HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		try {
			// 1. 업무로직
			Member m = memberSerivce.selectOneMember(memberId);
			logger.debug("m@controller={}", m);

			String msg = "";
			String loc = "/";
			String viewName = "common/msg";
			
			String encryptedPassword = bcryptPasswordEncoder.encode(password);
			
			logger.debug("rawPassword={}",password);
			logger.debug("encryptedPassword={}",encryptedPassword);

			// 로그인
			if (m == null) {
				msg = "존재하지 않는 아이디 입니다.";
			} else {
				//로그인 한 경우
				if (bcryptPasswordEncoder.matches(password, m.getPassword())) {
					mav.addObject("memberLoggedIn", m);
					viewName="notice/noticeList";
					String saveId = request.getParameter("saveId");
					//체크한경우
					if(saveId != null) {
						Cookie c = new Cookie("saveId", memberId);
						c.setMaxAge(7*24*60*60);//7일후 소멸
						c.setPath("/");//쿠키사용디렉토리. 도메인 전역에서 사용함.
						response.addCookie(c);
					}
					//체크하지 않은 경우
					else {
						Cookie c = new Cookie("saveId", memberId);
						c.setMaxAge(0);//삭제를 위해 유효기간을 0으로 설정
						c.setPath("/");
						response.addCookie(c);
					}
				} else {
					msg = "비밀번호가 틀렸습니다.";
				}
			}

			// 2. view모델 처리
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);

			// viewName 지정
			mav.setViewName(viewName);

		} catch (Exception e) {
			logger.error("로그인 오류", e);
			throw new MemberException("회원 관리 오류!", e);
		}

		return mav;
	}*/
	@RequestMapping("/member/memberLogin.do")
	public ModelAndView memberLogin(@RequestParam String memberId, ModelAndView mav,
			HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		try {
			// 1. 업무로직
			Member m = memberSerivce.selectOneMember(memberId);

			String msg = "";
			String loc = "/";
			String viewName = "common/msg";

			// 로그인
			if (m == null) {
				msg = "존재하지 않는 아이디 입니다.";
				mav.addObject("msg", msg);
				mav.addObject("loc", loc);
			} else {
				//로그인 한 경우
				mav.addObject("memberLoggedIn", m);
				viewName="redirect:/notice/noticeList.do";
			}

			// 2. view모델 처리
			

			// viewName 지정
			mav.setViewName(viewName);

		} catch (Exception e) {
			logger.error("로그인 오류", e);
			throw new MemberException("회원 관리 오류!", e);
		}

		return mav;
	}
	
	@RequestMapping("/member/memberLogOut.do")
	public String memberLogout(SessionStatus sessionStatus) {
		
		//setComplete 메소드 호출로 해당 세션 폐기
		if(!sessionStatus.isComplete()) {
			sessionStatus.setComplete();
		}
		
		return "redirect:/"; // /spring 으로 리다이렉트
	}
	
	@PostMapping("/member/memberRegisterEnd.do")
	public String memberRegisterEnd(Member member, Model model) {
		String rawPassword = member.getPassword();
		String encryptedPassword = bcryptPasswordEncoder.encode(rawPassword);
		
		//logger.debug("rawPassword={}", rawPassword);
		//logger.debug("encryptPassword={}", encryptedPassword);
		
		//비밀번호 암호화 처리
		member.setPassword(encryptedPassword);
		logger.debug("member={}", member);
		
		int result = memberSerivce.updateRegister(member);
		
		String loc = "/";
		String msg ="";
		if(result>0) msg="환영합니다 :) "+member.getMemberName()+"님, WORKGROUND의 회원이 되셨습니다.";
		else msg="회원가입에 실패하셨습니다. 깔깔깔";
		
		model.addAttribute("loc", loc);
		model.addAttribute("msg", msg);
		
		return  "common/msg";
	}
	@RequestMapping("/member/checkIdExistence.do")
	public ModelAndView checkIdExistence(@RequestParam("memberId") String memberId,
										 ModelAndView mav) {
		
		//logger.debug("memberId={}", memberId);
		Member member = memberSerivce.selectOneMember(memberId);
		int idValid = 1;
		if(member == null) {
			String msg = "존재하지 않는 회원입니다.";
			String loc = "/member/memberRegister.do";
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
		}
		else {
			if(member.getPassword() != null) {
				String msg = "이미 존재하는 회원입니다.";
				String loc = "/member/memberRegister.do";
				mav.addObject("msg", msg);
				mav.addObject("loc", loc);
				mav.setViewName("common/msg");
			}
			else {
				mav.addObject("idValid", idValid);
				mav.addObject("member", member);
				mav.setViewName("member/memberRegister");						
			}
		}
		
		return mav;
	}
	
	@RequestMapping("/member/updateProfileImg.do")
	public ModelAndView updateProfileImg(@RequestParam("memberId") String memberId,
										 @RequestParam("upFile") MultipartFile upFile,
										 @RequestParam("oldRenamedFileName") String oldRenamedFileName,
										 ModelAndView mav,
										 HttpServletRequest request,
										 HttpSession session) {
//		logger.debug("memberId={}", memberId);
//		logger.debug("사용자입력 name={}", upFile.getName());
//		logger.debug("fileName={}", upFile.getOriginalFilename());
//		logger.debug("size={}", upFile.getSize());
		//테스트테스트
		
		String saveDirectory = request.getSession()
				  			  		  .getServletContext()
				                      .getRealPath("/resources/img/profile");
		
		String originalFileName = null;
		String renamedFileName = null;
		File dir = new File(saveDirectory);
		if(dir.exists() == false)
			dir.mkdir();
		MultipartFile f = upFile;
		if(!f.isEmpty()) {
			originalFileName = f.getOriginalFilename();
			String ext = originalFileName.substring(originalFileName.lastIndexOf("."));
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
			int rndNum = (int)(Math.random()*1000);
			renamedFileName = sdf.format(new Date())+"_"+rndNum+ext;
			try {
				f.transferTo(new File(saveDirectory+"/"+renamedFileName));
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
		}

		//신규첨부파일이 있는 경우, 기존첨부파일 삭제(기본이미지 제외)
		if(!upFile.getOriginalFilename().equals("default.jpg")){
			File delFile = new File(saveDirectory, oldRenamedFileName);
			boolean result = delFile.delete();
			logger.debug("기존첨부파일삭제={}",result?"성공!":"실패!");
		}
		
		Member m = new Member();
		m.setMemberId(memberId);
		m.setOriginalFileName(originalFileName);
		m.setRenamedFileName(renamedFileName);
		int result = memberSerivce.updateProfileImg(m);
		
		Member memberLoggedIn = (Member) session.getAttribute("memberLoggedIn");
		memberLoggedIn.setRenamedFileName(renamedFileName);
		mav.addObject("msg", result>0?"프로필 사진이 변경되었습니다.":"프로필사진 변경 실패! 깔깔깔");
		mav.addObject("loc", "/member/memberView.do?memberId="+memberId);
		mav.setViewName("common/msg");
		return mav;
	}
	
	@RequestMapping("/member/updateEmail.do")
	public ModelAndView updateEmail(@RequestParam("memberId") String memberId,
									@RequestParam("email") String email,
								    ModelAndView mav) {
		Map<String, String> map = new HashMap<>();
		map.put("memberId", memberId);
		map.put("email", email);
		int result = memberSerivce.updateEmail(map);
		mav.addObject("msg", result>0?"이메일이 변경되었습니다.":"이메일 변경 실패! 깔깔깔");
		mav.addObject("loc", "/member/memberView.do?memberId="+memberId);
		mav.setViewName("common/msg");
		return mav;
	}
	
	@RequestMapping("/member/updatePhone.do")
	public ModelAndView updatePhone(@RequestParam("memberId") String memberId,
									@RequestParam("phone") String phone,
								    ModelAndView mav) {
		Map<String, String> map = new HashMap<>();
		map.put("memberId", memberId);
		map.put("phone", phone);
		int result = memberSerivce.updatePhone(map);
		mav.addObject("msg", result>0?"전화번호가 변경되었습니다.":"전화번호 변경 실패! 깔깔깔");
		mav.addObject("loc", "/member/memberView.do?memberId="+memberId);
		mav.setViewName("common/msg");
		return mav;
	}
	
	@RequestMapping("/member/deleteMember.do")
	public ModelAndView deleteMember(@RequestParam("memberId") String memberId,
									 ModelAndView mav) {
		int result = memberSerivce.deleteMember(memberId);
		mav.addObject("msg", result>0?"계정이 삭제되었습니다.":"계정 삭제 실패! 깔깔깔");
		mav.addObject("loc", "/");
		mav.setViewName("common/msg");
		return mav;
	}
	
	@RequestMapping("/member/updatePassword.do")
	public ModelAndView updatePassword(@RequestParam("memberId") String memberId,
									   @RequestParam("password_now") String nowPassword,
									   @RequestParam("password_new") String rawPassword,
									   ModelAndView mav, HttpSession session) {
		
		Member memberLoggedIn = (Member) session.getAttribute("memberLoggedIn");
		//logger.debug(memberLoggedIn.getPassword());
	
		if(bcryptPasswordEncoder.matches(nowPassword, memberLoggedIn.getPassword())){
			//비밀번호 암호화 처리
			String encryptedPassword = bcryptPasswordEncoder.encode(rawPassword);
			logger.debug("password={}", encryptedPassword);
			
			Map<String, String> map = new HashMap<>();
			map.put("memberId", memberId);
			map.put("password", encryptedPassword);
			
			int result = memberSerivce.updatePassword(map);
			if(result>0) {memberLoggedIn.setPassword(encryptedPassword);}
			mav.addObject("msg", result>0?"비밀번호가 변경되었습니다.":"비밀번호 변경 실패! 깔깔깔");
			mav.addObject("loc", "/member/memberView.do?memberId="+memberId);
			mav.setViewName("common/msg");
		} 
		else {
			mav.addObject("msg", "비밀번호를 정확하게 입력해 주세요.");
			mav.addObject("loc", "/member/memberView.do?memberId="+memberId);
			mav.setViewName("common/msg");
			
		}
		return mav;
		
	}
	
	/*@ResponseBody
	@RequestMapping("/member/forgotPassword.do")
	public Member forgotPassword(@RequestParam("memberId") String memberId) {
		
		Member m = memberSerivce.selectOneMember(memberId);
		logger.debug("member={}", m);
		
		if(m == null) {
			mav.addObject("msg", "입력하신 아이디를 찾을 수 없습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
		}
		else {
			MimeMessage mail = mailSender.createMimeMessage();
			String htmlStr = "안녕하세요!";
			try {
				mail.setSubject("메일테스트");
				mail.setText(htmlStr, "utf-8", "html");
				mail.addRecipient(RecipientType.TO, new InternetAddress(m.getEmail()));
				mailSender.send(mail);
			} catch (MessagingException e) {
				e.getStackTrace();
			}
		}
		return m;
	}*/
	
	@RequestMapping("/member/forgotPassword.do")
	public ModelAndView forgotPassword(@RequestParam("memberId") String memberId,
									   ModelAndView mav) {
		Member m = memberSerivce.selectOneMember(memberId);
		logger.debug("member={}", m);
		if(m == null) {
			mav.addObject("msg", "입력하신 아이디를 찾을 수 없습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
		}
		else {
			mav.addObject("msg", "임시비밀번호가 이메일로 전송되었습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			
			String subject ="[WORKGROUND] "+m.getMemberName()+"님! WORKGROUND 회원 임시 비밀번호 입니다."; 
			Random rnd = new Random();
			String temppwd = "wg"+rnd.nextInt(99)+rnd.nextInt(99)+rnd.nextInt(10);
			String encryptedPassword = bcryptPasswordEncoder.encode(temppwd);
			
			Map<String, String> map = new HashMap<>();
			map.put("memberId", memberId);
			map.put("password", encryptedPassword);
			int result = memberSerivce.updatePassword(map);
			if(result>0) {logger.debug("임시비밀번호로 변경 성공!");}
			
			MimeMessage mail = mailSender.createMimeMessage();
			String htmlStr = "<div style='padding:30px 20px; font-size:2rem; font-weight:bold'>WORKGROUND</div>"
						   + "<div style='height: 1px; background: none; padding: 0px; border-top-width:1px;border-top-style:solid;border-top-color:#999;margin:0 10px'></div>"
						   + "<div style='padding:20px 20px;'><p>안녕하세요! "+m.getMemberName()+"님! WORKGROUND를 이용해주셔서 감사합니다 :)</p></br>"
						   + "<p>요청하신 회원님의 임시비밀번호 입니다.</p></br>"
						   + "<p>WORKGROUND 홈페이지에  오셔서 로그인 하신 후</p></br>"
						   + "<p style='font-weight:bold;'>계정설정>비밀번호 변경에서 반드시 비밀번호를 변경해 주세요.</p></div>"
						   + "<div style='margin:0 auto; text-align: center; padding: 2rem; border: 1px dashed #999'><p style='font-weight:bold;'>임시 비밀번호:<mark>"+temppwd+"</mark></p></div>";
			
			try {
				mail.setSubject(subject);
				mail.setText(htmlStr, "utf-8", "html");
				mail.addRecipient(RecipientType.TO, new InternetAddress(m.getEmail()));
				mailSender.send(mail);
			} catch (MessagingException e) {
				e.getStackTrace();
			}
		}
		return mav;
	}
}
