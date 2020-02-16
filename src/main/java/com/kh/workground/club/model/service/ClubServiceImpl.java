package com.kh.workground.club.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.club.model.dao.ClubDAO;
import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.club.model.vo.ClubPlan;

@Service
public class ClubServiceImpl implements ClubService {
	
	@Autowired
	ClubDAO clubDAO;

	@Override
	public List<Club> selectAllClubList(Map param) {
		return clubDAO.selectAllClubList(param);
	}

	@Override
	public int insertNewClub(Club club) {
		return clubDAO.insertNewClub(club);
	}

	@Override
	public int deleteClub(int clubNo) {
		return clubDAO.deleteClub(clubNo);
	}

	@Override
	public int updateClub(Club club) {
		return clubDAO.updateClub(club);
	}

	@Override
	public int selectCountClub() {
		return clubDAO.selectCountClub();
	}

	@Override
	public int insertClubMember(Map map) {

		return clubDAO.insertClubMember(map);
	}

	@Override
	public List<Club> selectAllMyClubList(Map param) {
		return clubDAO.selectAllMyClubList(param);
	}

	@Override
	public List<Club> selectAllStandByClubList(Map param) {
		return clubDAO.selectAllStandByClubList(param);
	}

	@Override
	public List<ClubMember> selectClubMemberList(int clubNo) {
		return clubDAO.selectClubMemberList(clubNo);
	}

	@Override
	public int deleteClubMember(int clubMemberNo) {
		return clubDAO.deleteClubMember(clubMemberNo);
	}

	@Override
	public int updateClubManager(Map param) {

		return clubDAO.updateClubManager(param);
	}

	@Override
	public int approveClubMember(Map param) {

		return clubDAO.approveClubMember(param);
	}

	@Override
	public List<ClubMember> searchClubMember(Map param) {

		return clubDAO.searchClubMember(param);
	}

	@Override
	public List<ClubPlan> selectClubPlanList(int clubNo) {
		return clubDAO.selectClubPlanList(clubNo);
	}

	@Override
	public ClubPlan selectOneClubPlan(int clubPlanNo) {
		return clubDAO.selectOneClubPlan(clubPlanNo);
	}

	@Override
	public List<Club> selectAllClubListByCategory(Map param) {

		return clubDAO.selectAllClubListByCategory(param);
	}

	@Override
	public List<Club> selectAllMyClubListByCategory(Map param) {
		return clubDAO.selectAllMyClubListByCategory(param);
	}

	@Override
	public List<Club> selectAllStandByClubListByCategory(Map param) {
		return clubDAO.selectAllStandByClubListByCategory(param);
	}





}
