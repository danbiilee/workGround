package com.kh.workground.member.model.service;

import java.util.List;
import java.util.Map;

import com.kh.workground.member.model.vo.Member;

public interface MemberService {
	//

	Member selectOneMember(String memberId);

	int updateRegister(Member member);
	
	List<Member> selectMemberListAll();

	int updateProfileImg(Member m);

	int updateEmail(Map<String,String> map);

	int updatePhone(Map<String,String> map);

	int deleteMember(String memberId);

	int updatePassword(Map<String, String> map);
}

