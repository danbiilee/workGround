package com.kh.workground.club.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.club.model.vo.ClubNotice;
import com.kh.workground.club.model.vo.ClubNoticeComment;
import com.kh.workground.club.model.vo.ClubPhoto;
import com.kh.workground.club.model.vo.ClubPlan;
import com.kh.workground.club.model.vo.ClubPlanAttendee;

@Repository
public class ClubDAOImpl2 implements ClubDAO2 {
	
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public int insertClubPhoto(ClubPhoto clubPhoto) {
		return sqlSession.insert("club.insertClubPhoto", clubPhoto);
	}

	@Override
	public Club selectClub(int clubNo) {
		return sqlSession.selectOne("club.selectClub", clubNo);
	}

	@Override
	public List<ClubPlan> selectClubPlanList(int clubNo) {
		return sqlSession.selectList("club.selectClubPlanList", clubNo);
	}

	@Override
	public int updateClubPlan(ClubPlan clubPlan) {
		return sqlSession.update("club.updateClubPlan", clubPlan);
	}

	@Override
	public int clubIntroduceUpdate(Club club) {
		return sqlSession.update("club.clubIntroduceUpdate", club);
	}

	@Override
	public int clubPlanInsert(ClubPlan clubPlan) {
		return sqlSession.insert("club.clubPlanInsert", clubPlan);
	}

	@Override
	public List<ClubNotice> selectClubNoticeList(int clubNo) {
		return sqlSession.selectList("club.selectClubNoticeList", clubNo);
	}

	@Override
	public int clubNoticeUpdate(ClubNotice clubNotice) {
		return sqlSession.update("club.clubNoticeUpdate", clubNotice);
	}

	@Override
	public int clubNoticeInsert(ClubNotice clubNotice) {
		return sqlSession.insert("club.clubNoticeInsert", clubNotice);
	}

	@Override
	public ClubMember selectOneClubMember(Map<String, String> param) {
		return sqlSession.selectOne("club.selectOneClubMember", param);
	}

	@Override
	public int deleteClubNotice(int clubNoticeNo) {
		return sqlSession.delete("club.deleteClubNotice", clubNoticeNo);
	}

	@Override
	public List<ClubPhoto> selectClubPhotoList(int clubNo) {
		return sqlSession.selectList("club.selectClubPhotoList", clubNo);
	}

	@Override
	public int deleteClubPhoto(ClubPhoto clubPhoto) {
		return sqlSession.delete("club.deleteClubPhoto", clubPhoto);
	}

	@Override
	public List<ClubPlanAttendee> selectClubPlanAttendeeList(int clubPlanNo) {
		return sqlSession.selectList("club.selectClubPlanAttendeeList", clubPlanNo);
	}

	@Override
	public int insertClubPlanAttendee(ClubPlanAttendee clubPlanAttendee) {
		return sqlSession.insert("club.insertClubPlanAttendee", clubPlanAttendee);
	}

	@Override
	public int deleteClubPlanAttendee(ClubPlanAttendee clubPlanAttendee) {
		return sqlSession.delete("club.deleteClubPlanAttendee", clubPlanAttendee);
	}

	@Override
	public List<ClubNoticeComment> selectClubNoticeCommentList(int clubNo) {
		return sqlSession.selectList("club.selectClubNoticeCommentList", clubNo);
	}

	@Override
	public int insertClubNoticeComment(ClubNoticeComment clubNoticeComment) {
		return sqlSession.insert("club.insertClubNoticeComment", clubNoticeComment);
	}

	@Override
	public List<ClubPlanAttendee> selectAllClubPlanAttendeeList(int clubNo) {
		return sqlSession.selectList("club.selectAllClubPlanAttendeeList", clubNo);
	}

	@Override
	public int deleteClubPlanAttendee(int clubPlanNo) {
		return sqlSession.delete("club.deleteClubPlan", clubPlanNo);
	}

	@Override
	public int deleteClubNoticeComment(int clubNoticeCommentNo) {
		return sqlSession.delete("club.deleteClubNoticeComment", clubNoticeCommentNo);
	}

	@Override
	public List<ClubPhoto> searchClubPhotoList(Map<String, String> param) {
		return sqlSession.selectList("club.searchClubPhotoList", param);
	}

	@Override
	public List<ClubNotice> searchClubNoticeList(Map<String, String> param) {
		return sqlSession.selectList("club.searchClubNoticeList", param);
	}

	@Override
	public List<ClubPlan> searchClubPlanList(Map<String, String> param) {
		return sqlSession.selectList("club.searchClubPlanList", param);
	}



}
