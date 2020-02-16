package com.kh.workground.member.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.member.model.vo.Member;

@Repository
public class MemberDAOImpl implements MemberDAO {
	//
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public Member selectOneMember(String memberId) {
		return sqlSession.selectOne("member.selectOneMember",memberId);
	}

	@Override
	public int updateRegister(Member member) {
		return sqlSession.update("member.updateRegister", member);
	}
	
	@Override
	public List<Member> selectMemberListAll() {
		return sqlSession.selectList("member.selectMemberListAll");
	}

	@Override
	public int updateProfileImg(Member m) {
		return sqlSession.update("member.updateProfileImg", m);
	}

	@Override
	public int updateEmail(Map<String, String> map) {
		return sqlSession.update("member.updateEmail", map);
	}

	@Override
	public int updatePhone(Map<String, String> map) {
		return sqlSession.update("member.updatePhone", map);
	}

	@Override
	public int deleteMember(String memberId) {
		return sqlSession.delete("member.deleteMember", memberId);
	}

	@Override
	public int updatePassword(Map<String, String> map) {
		return sqlSession.update("member.updatePassword", map);
	}
}
