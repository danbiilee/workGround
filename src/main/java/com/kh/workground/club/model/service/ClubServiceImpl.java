package com.kh.workground.club.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.club.model.dao.ClubDAO;
import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;

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


}