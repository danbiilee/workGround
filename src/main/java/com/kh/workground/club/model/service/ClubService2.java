package com.kh.workground.club.model.service;

import java.util.List;
import java.util.Map;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.club.model.vo.ClubNotice;
import com.kh.workground.club.model.vo.ClubNoticeComment;
import com.kh.workground.club.model.vo.ClubPhoto;
import com.kh.workground.club.model.vo.ClubPlan;
import com.kh.workground.club.model.vo.ClubPlanAttendee;

public interface ClubService2 {

	int insertClubPhoto(ClubPhoto clubPhoto);

	Club selectClub(int clubNo);

	List<ClubPlan> selectClubPlanList(int clubNo);

	int updateClubPlan(ClubPlan clubPlan);

	int clubIntroduceUpdate(Club club);

	int clubPlanInsert(ClubPlan clubPlan);

	List<ClubNotice> selectClubNoticeList(int clubNo);

	int clubNoticeUpdate(ClubNotice clubNotice);

	int clubNoticeInsert(ClubNotice clubNotice);

	ClubMember selectOneClubMember(Map<String, String> param);

	int deleteClubNotice(int clubNoticeNo);

	List<ClubPhoto> selectClubPhotoList(int clubNo);

	int deleteClubPhoto(ClubPhoto clubPhoto);

	List<ClubPlanAttendee> selectClubPlanAttendeeList(int clubPlanNo);

	int insertClubPlanAttendee(ClubPlanAttendee clubPlanAttendee);

	int deleteClubPlanAttendee(ClubPlanAttendee clubPlanAttendee);

	List<ClubNoticeComment> selectClubNoticeCommentList(int clubNo);

	int insertClubNoticeComment(ClubNoticeComment clubNoticeComment);

	List<ClubPlanAttendee> selectAllClubPlanAttendeeList(int clubNo);

	int deleteClubPlanAttendee(int clubPlanNo);

	int deleteClubNoticeComment(int clubNoticeCommentNo);

	List<ClubPhoto> searchClubPhotoList(Map<String, String> param);

	List<ClubNotice> searchClubNoticeList(Map<String, String> param);

	List<ClubPlan> searchClubPlanList(Map<String, String> param);



}
