package com.kh.workground.club.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.club.model.vo.ClubPlan;

public interface ClubDAO {

	List<Club> selectAllClubList(Map param);

	int insertNewClub(Club club);

	int deleteClub(int clubNo);

	int updateClub(Club club);

	int selectCountClub();

	int insertClubMember(Map map);

	List<Club> selectAllMyClubList(Map param);

	List<Club> selectAllStandByClubList(Map param);

	List<ClubMember> selectClubMemberList(int clubNo);

	int deleteClubMember(int clubMemberNo);

	int updateClubManager(Map param);

	int approveClubMember(Map param);

	List<ClubMember> searchClubMember(Map param);

	List<ClubPlan> selectClubPlanList(int clubNo);

	ClubPlan selectOneClubPlan(int clubPlanNo);

	List<Club> selectAllClubListByCategory(Map param);

	List<Club> selectAllMyClubListByCategory(Map param);

	List<Club> selectAllStandByClubListByCategory(Map param);

	

	


}
