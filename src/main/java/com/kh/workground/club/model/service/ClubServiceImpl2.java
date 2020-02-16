package com.kh.workground.club.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.club.model.dao.ClubDAO2;
import com.kh.workground.club.model.exception.ClubException;
import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.club.model.vo.ClubNotice;
import com.kh.workground.club.model.vo.ClubNoticeComment;
import com.kh.workground.club.model.vo.ClubPhoto;
import com.kh.workground.club.model.vo.ClubPlan;
import com.kh.workground.club.model.vo.ClubPlanAttendee;

@Service
public class ClubServiceImpl2 implements ClubService2 {
	
	@Autowired
	ClubDAO2 clubDAO2;

	@Override
	public int insertClubPhoto(ClubPhoto clubPhoto) {
		int result = 0;
		
		result = clubDAO2.insertClubPhoto(clubPhoto);
		if(result==0)
			throw new ClubException("사진 등록오류!");
		
		return result;
	}

	@Override
	public Club selectClub(int clubNo) {
		return clubDAO2.selectClub(clubNo);
	}

	@Override
	public List<ClubPlan> selectClubPlanList(int clubNo) {
		return clubDAO2.selectClubPlanList(clubNo);
	}

	@Override
	public int updateClubPlan(ClubPlan clubPlan) {
		return clubDAO2.updateClubPlan(clubPlan);
	}

	@Override
	public int clubIntroduceUpdate(Club club) {
		return clubDAO2.clubIntroduceUpdate(club);
	}

	@Override
	public int clubPlanInsert(ClubPlan clubPlan) {
		return clubDAO2.clubPlanInsert(clubPlan);
	}

	@Override
	public List<ClubNotice> selectClubNoticeList(int clubNo) {
		return clubDAO2.selectClubNoticeList(clubNo);
	}

	@Override
	public int clubNoticeUpdate(ClubNotice clubNotice) {
		return clubDAO2.clubNoticeUpdate(clubNotice);
	}

	@Override
	public int clubNoticeInsert(ClubNotice clubNotice) {
		return clubDAO2.clubNoticeInsert(clubNotice);
	}

	@Override
	public ClubMember selectOneClubMember(Map<String, String> param) {
		return clubDAO2.selectOneClubMember(param);
	}

	@Override
	public int deleteClubNotice(int clubNoticeNo) {
		return clubDAO2.deleteClubNotice(clubNoticeNo);
	}

	@Override
	public List<ClubPhoto> selectClubPhotoList(int clubNo) {
		return clubDAO2.selectClubPhotoList(clubNo);
	}

	@Override
	public int deleteClubPhoto(ClubPhoto clubPhoto) {
		return clubDAO2.deleteClubPhoto(clubPhoto);
	}

	@Override
	public List<ClubPlanAttendee> selectClubPlanAttendeeList(int clubPlanNo) {
		return clubDAO2.selectClubPlanAttendeeList(clubPlanNo);
	}

	@Override
	public int insertClubPlanAttendee(ClubPlanAttendee clubPlanAttendee) {
		return clubDAO2.insertClubPlanAttendee(clubPlanAttendee);
	}

	@Override
	public int deleteClubPlanAttendee(ClubPlanAttendee clubPlanAttendee) {
		return clubDAO2.deleteClubPlanAttendee(clubPlanAttendee);
	}

	@Override
	public List<ClubNoticeComment> selectClubNoticeCommentList(int clubNo) {
		return clubDAO2.selectClubNoticeCommentList(clubNo);
	}

	@Override
	public int insertClubNoticeComment(ClubNoticeComment clubNoticeComment) {
		return clubDAO2.insertClubNoticeComment(clubNoticeComment);
	}

	@Override
	public List<ClubPlanAttendee> selectAllClubPlanAttendeeList(int clubNo) {
		return clubDAO2.selectAllClubPlanAttendeeList(clubNo);
	}

	@Override
	public int deleteClubPlanAttendee(int clubPlanNo) {
		return clubDAO2.deleteClubPlanAttendee(clubPlanNo);
	}

	@Override
	public int deleteClubNoticeComment(int clubNoticeCommentNo) {
		return clubDAO2.deleteClubNoticeComment(clubNoticeCommentNo);
	}

	@Override
	public List<ClubPhoto> searchClubPhotoList(Map<String, String> param) {
		return clubDAO2.searchClubPhotoList(param);
	}

	@Override
	public List<ClubNotice> searchClubNoticeList(Map<String, String> param) {
		return clubDAO2.searchClubNoticeList(param);
	}

	@Override
	public List<ClubPlan> searchClubPlanList(Map<String, String> param) {
		return clubDAO2.searchClubPlanList(param);
	}



}
