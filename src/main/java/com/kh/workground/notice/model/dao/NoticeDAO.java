package com.kh.workground.notice.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.Notice;

public interface NoticeDAO {

	List<Notice> selectNoticeList();

	List<Notice> selectPlanningDeptNoticeList();

	List<Notice> selectDesignDeptNoticeList();
	
	List<Notice> selectDevelopmentDeptNoticeList();

	List<Community> selectCommunityList();
	
	int insertNotice(Notice notice);

	int deleteNotice(int noticeNo);

	int insertCommunity(Community commu);

	int deleteCommunity(int commuNo);

	int updateNotice(Notice notice);

	int updateCommunity(Community commu);
	
	int insertNoticeComment(Map<String, Object> noticeCommentMap);

	int deleteNoticeComment(int noticeCommentNo);

	int insertCommunityComment(Map<String, Object> communityCommentMap);

	int deleteCommunityComment(int communityCommentNo);
	
	
}

