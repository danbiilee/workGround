package com.kh.workground.club.controller;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.club.model.service.ClubService2;
import com.kh.workground.club.model.vo.Club;

@Controller
public class ClubController2 {
	
private static final Logger logger = LoggerFactory.getLogger(ClubController.class);
	
	@Autowired
	ClubService2 clubService2;
	
	
	@RequestMapping("/club/clubView.do")
	public ModelAndView clubView(ModelAndView mav,
								 @RequestParam("clubNo") int clubNo) {
		
		logger.info("clubNo{}",clubNo);
		
		mav.setViewName("/club/clubView");
		
		return mav;
	}
	
	@RequestMapping("/club/clubPhotoForm.do")
	public ModelAndView clubPhotoForm(ModelAndView mav, 
									  Club club, 
									  @RequestParam(value="upFile", required=false) MultipartFile upFile, 
									  HttpServletRequest request) {
		
		
		return mav;
	}
	

}
