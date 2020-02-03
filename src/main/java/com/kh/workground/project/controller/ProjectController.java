package com.kh.workground.project.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ProjectController {
	
	private static final Logger logger = LoggerFactory.getLogger(ProjectController.class);
	
//	@Autowired
//	ProjectService projectService;
	
	@RequestMapping("/project/projectList.do")
	public ModelAndView projectList(ModelAndView mav) {
		
		mav.setViewName("/project/projectList");
		
		return mav;
	}
	
	@RequestMapping("/project/projectView.do")
	public ModelAndView projectView(ModelAndView mav) {
		
		mav.setViewName("/project/projectView");
		
		return mav;
	}
	
	@RequestMapping("/project/projectAttachment.do")
	public ModelAndView projectAttachment(ModelAndView mav) {
		
		mav.setViewName("/project/projectAttachment");
		
		return mav;
	}
	
	@RequestMapping("/project/projectAnalysis.do")
	public ModelAndView projectAnalysis(ModelAndView mav) {
		
		mav.setViewName("/project/projectAnalysis");
		
		return mav;
	}
	
}
