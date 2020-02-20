package com.kh.workground.search.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.member.model.vo.Member;
import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.Notice;
import com.kh.workground.project.model.vo.Project;

@Repository
public class SearchDAOImpl implements SearchDAO {
	
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public List<Notice> selectTotalNoticeListByKeyword(String keyword) {
		return sqlSession.selectList("search.selectTotalNoticeListByKeyword", keyword);
	}

	@Override
	public List<Notice> selectDeptNoticeListByKeyword(Map<String, String> param) {
		return sqlSession.selectList("search.selectDeptNoticeListByKeyword", param);
	}

	@Override
	public List<Community> selectCommuListByKeyword(String keyword) {
		return sqlSession.selectList("search.selectCommuListByKeyword", keyword);
	}

	@Override
	public List<Project> selectProjectListByKeyword(Map<String, String> param) {
		return sqlSession.selectList("search.selectProjectListByKeyword", param);
	}

/*	@Override
	public List<Map<String, Object>> selectClubListByKeyword(String keyword) {
		return sqlSession.selectList("search.selectClubListByKeyword", keyword);
	} */
	@Override
	public List<Club> selectClubListByKeyword(Map<String, String> param) {
		return sqlSession.selectList("search.selectClubListByKeyword", param);
	}

	@Override
	public List<Member> selectMemberListByKeyword(String keyword) {
		return sqlSession.selectList("search.selectMemberListByKeyword", keyword);
	}

	@Override
	public List<Member> selectMemberListByPageBar(int cPage, int numPerPage, String keyword) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("search.selectMemberListByKeyword", keyword, rowBounds);
	}

	@Override
	public int selectMemberTotalContents() {
		return sqlSession.selectOne("search.selectMemberTotalContents");
	}

	@Override
	public List<Notice> selectTotalNoticeListByKeyword(int cPage, int numPerPage, String keyword) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("search.selectTotalNoticeListByKeyword", keyword, rowBounds);
	}

	@Override
	public int selectTotalNoticeTotalContents() {
		return sqlSession.selectOne("search.selectTotalNoticeTotalContents");
	}

	@Override
	public List<Notice> selectDeptNoticeListByPageBar(int cPage, int numPerPage, Map<String, String> param) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("search.selectDeptNoticeListByKeyword", param, rowBounds);
	}

	@Override
	public int selectDeptNoticeTotalContents(Map<String, String> param) {
		return sqlSession.selectOne("search.selectDeptNoticeTotalContents", param);
	}

	@Override
	public List<Community> selectCommuListByPageBar(int cPage, int numPerPage, String keyword) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("search.selectCommuListByKeyword", keyword, rowBounds);
	}

	@Override
	public int selectCommuListTotalContents() {
		return sqlSession.selectOne("search.selectCommuListTotalContents");
	}

	@Override
	public List<Project> selectProjectListByPageBar(int cPage, int numPerPage, Map<String, String> param) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("search.selectProjectListByKeyword", param, rowBounds);
	}

	@Override
	public int selectProjectTotalContents() {
		return sqlSession.selectOne("search.selectProjectTotalContents");
	}

/*	@Override
	public List<Map<String, Object>> selectClubListByPageBar(int cPage, int numPerPage, String keyword) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("search.selectClubListByKeyword", keyword, rowBounds);
	} */
	@Override
	public List<Club> selectClubListByPageBar(int cPage, int numPerPage, Map<String, String> param) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("search.selectClubListByKeyword", param, rowBounds);
	}

	@Override
	public int selectClubTotalContents() {
		return sqlSession.selectOne("search.selectClubTotalContents");
	}

}
