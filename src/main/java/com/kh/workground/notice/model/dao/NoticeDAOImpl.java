package com.kh.workground.notice.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.Notice;

@Repository
public class NoticeDAOImpl implements NoticeDAO {
	
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public List<Notice> selectNoticeList() {
		return sqlSession.selectList("notice.selectNoticeList");
	}

	@Override
	public List<Notice> selectPlanningDeptNoticeList() {
		return sqlSession.selectList("notice.selectPlanningDeptNoticeList");
	}

	@Override
	public List<Notice> selectDesignDeptNoticeList() {
		return sqlSession.selectList("notice.selectDesignDeptNoticeList");
	}

	@Override
	public List<Notice> selectDevelopmentDeptNoticeList() {
		return sqlSession.selectList("notice.selectDevelopmentDeptNoticeList");
	}

	@Override
	public List<Community> selectCommunityList() {
		return sqlSession.selectList("notice.selectCommunityList");
	}

	@Override
	public int insertNotice(Notice notice) {
		return sqlSession.insert("notice.insertNotice", notice);
	}

	@Override
	public int deleteNotice(int noticeNo) {
		return sqlSession.delete("notice.deleteNotice", noticeNo);
	}

	@Override
	public int insertCommunity(Community commu) {
		return sqlSession.insert("notice.insertCommunity", commu);
	}

	@Override
	public int deleteCommunity(int commuNo) {
		return sqlSession.delete("notice.deleteCommunity", commuNo);
	}

	@Override
	public int updateNotice(Notice notice) {
		return sqlSession.update("notice.updateNotice", notice);
	}

	@Override
	public int updateCommunity(Community commu) {
		return sqlSession.update("notice.updateCommunity", commu);
	}
	
	@Override
	public int insertNoticeComment(Map<String, Object> noticeCommentMap) {
		return sqlSession.insert("notice.insertNoticeComment", noticeCommentMap);
	}

	@Override
	public int deleteNoticeComment(int noticeCommentNo) {
		return sqlSession.delete("notice.deleteNoticeComment", noticeCommentNo);
	}

	@Override
	public int insertCommunityComment(Map<String, Object> communityCommentMap) {
		return sqlSession.insert("notice.insertCommunityComment", communityCommentMap);
	}

	@Override
	public int deleteCommunityComment(int communityCommentNo) {
		return sqlSession.delete("notice.deleteCommunityComment", communityCommentNo);
	}


}

