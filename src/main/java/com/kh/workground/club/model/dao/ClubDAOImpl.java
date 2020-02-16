package com.kh.workground.club.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.club.model.vo.ClubPlan;

@Repository
public class ClubDAOImpl implements ClubDAO {
	
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public List<Club> selectAllClubList(Map param) {
		return sqlSession.selectList("club.selectAllClubList",param);
	}

	@Override
	public int insertNewClub(Club club) {
		return sqlSession.insert("club.insertNewClub",club);
	}

	@Override
	public int deleteClub(int clubNo) {
		return sqlSession.insert("club.deleteClub",clubNo);
	}

	@Override
	public int updateClub(Club club) {
		return sqlSession.update("club.updateClub",club);
	}

	@Override
	public int selectCountClub() {
		return sqlSession.selectOne("club.selectCountClub");
	}

	@Override
	public int insertClubMember(Map map) {

		return sqlSession.insert("club.insertClubMember",map);
	}

	@Override
	public List<Club> selectAllMyClubList(Map param) {
		return sqlSession.selectList("club.selectAllMyClubList",param);
	}

	@Override
	public List<Club> selectAllStandByClubList(Map param) {

		return sqlSession.selectList("club.selectAllStandByClubList",param);
	}

	@Override
	public List<ClubMember> selectClubMemberList(int clubNo) {

		return sqlSession.selectList("club.selectClubMemberList",clubNo);
	}

	@Override
	public int deleteClubMember(int clubMemberNo) {
		return sqlSession.delete("club.deleteClubMember",clubMemberNo);
	}

	@Override
	public int updateClubManager(Map param) {
		return sqlSession.update("club.updateClubManager",param);
	}

	@Override
	public int approveClubMember(Map param) {

		return sqlSession.update("club.approveClubMember",param);
	}

	@Override
	public List<ClubMember> searchClubMember(Map param) {
		return sqlSession.selectList("club.searchClubMember",param);
	}

	@Override
	public List<ClubPlan> selectClubPlanList(int clubNo) {
		return sqlSession.selectList("club.selectClubPlanList",clubNo);
	}

	@Override
	public ClubPlan selectOneClubPlan(int clubPlanNo) {

		return sqlSession.selectOne("club.selectOneClubPlan",clubPlanNo);
	}

	@Override
	public List<Club> selectAllClubListByCategory(Map param) {
		return sqlSession.selectList("club.selectAllClubListByCategory",param);
	}

	@Override
	public List<Club> selectAllMyClubListByCategory(Map param) {
		return sqlSession.selectList("club.selectAllMyClubListByCategory",param);
	}

	@Override
	public List<Club> selectAllStandByClubListByCategory(Map param) {
		return sqlSession.selectList("club.selectAllStandByClubListByCategory",param);
	}




}
