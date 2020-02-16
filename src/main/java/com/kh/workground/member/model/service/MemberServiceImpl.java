package com.kh.workground.member.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.member.model.dao.MemberDAO;
import com.kh.workground.member.model.exception.MemberException;
import com.kh.workground.member.model.vo.Member;


@Service
public class MemberServiceImpl implements MemberService {
	//

	@Autowired
	MemberDAO memberDAO;

	@Override
	public Member selectOneMember(String memberId) {
		return memberDAO.selectOneMember(memberId);
	}
	@Override
	public int updateRegister(Member member) {
		return memberDAO.updateRegister(member);
	}
	@Override
	public List<Member> selectMemberListAll() {
		List<Member> list = memberDAO.selectMemberListAll();
		
		if(list==null)
			throw new MemberException("멤버리스트 조회 오류!");
		
		return list;
	}
	@Override
	public int updateProfileImg(Member m) {
		return memberDAO.updateProfileImg(m);
	}
	@Override
	public int updateEmail(Map<String, String> map) {
		return memberDAO.updateEmail(map);
	}
	@Override
	public int updatePhone(Map<String, String> map) {
		return memberDAO.updatePhone(map);
	}
	@Override
	public int deleteMember(String memberId) {
		return memberDAO.deleteMember(memberId);
	}
	@Override
	public int updatePassword(Map<String, String> map) {
		return memberDAO.updatePassword(map);
	}
}
