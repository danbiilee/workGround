<%@page import="java.util.ArrayList"%>
<%@page import="com.kh.workground.member.model.vo.Member"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<link rel="stylesheet" property="stylesheet" href="${pageContext.request.contextPath}/resources/css/hyemin.css">

<script>
$(()=>{
	sidebarActive(); //사이드바 활성화
	
	projectStar(); //프로젝트 별 해제/등록
	
    addWorklist(); //새 업무리스트 만들기
    deleteWorklist(); //업무리스트 삭제하기
    
    addWork(); //새 업무 만들기
    checklist(); //체크리스트 체크
    
    tabActive(); //서브헤더 탭 활성화
    goTabMenu(); //서브헤더 탭 링크 이동
    
    setting(); //설정창- 나중에 수정
});

//multiselect.js파일에서 사용할 contextPath 전역변수
var contextPath = "${pageContext.request.contextPath}";

//사이드바 활성화
function sidebarActive(){
	let navLinkArr = document.querySelectorAll(".sidebar .nav-link");
	
	navLinkArr.forEach((obj, idx)=>{
		let $obj = $(obj);
		if($obj.hasClass('active'))
			$obj.removeClass('active');
	});
	
	$("#sidebar-project").addClass("active");
}

//프로젝트 별 해제/등록
function projectStar(){
    let btnStar = document.querySelector("#btn-star .fa-star");
    let projectNo = document.querySelector("#project-name #hiddenProjectNo").value;
    
    btnStar.addEventListener('click', (e)=>{
        let $this = $(e.target);

        $.ajax({
        	url: '${pageContext.request.contextPath}/project/projectStarCheck.do',
        	data: {memberId: '${memberLoggedIn.memberId}',
        		   projectNo: projectNo},
        	dataType: 'json',
        	type: 'POST',
        	success: data=>{
        		console.log(data);
        		
        		//중요표시 해제한 경우
        		if(data.result === 'delete')
        			$this.removeClass('fas').addClass('far');
        		//중요표시 한 경우
        		else
        			$this.removeClass('far').addClass('fas');
        	},
        	error: (x,s,e) => {
				console.log(x,s,e);
			}
        });
        
    });
}

//새 업무리스트 만들기
function addWorklist(){
    let addWklt = document.querySelector("#add-wklt-wrapper");
    let addWkltFrm = document.querySelector("#add-wkltfrm-wrapper");
    
    let inputTitle = document.querySelector("input[name=worklistTitle]");
    let frm = document.querySelector("#addWorklistFrm");
    
    let btnAdd = document.querySelector("#btn-addWorklist");
    let btnCancel = document.querySelector("#btn-cancel-addWorklist");

    //업무리스트 추가 클릭시 입력폼 보이기
    addWklt.addEventListener('click', ()=>{
        $(addWklt).hide();
        $(addWkltFrm).show();
        $(inputTitle).focus();
    });

    //x버튼 클릭시 다시 업무리스트 추가 보이기
    btnCancel.addEventListener('click', ()=>{
        $(addWkltFrm).hide();
        $(inputTitle).val("");
        $(addWklt).show();
    });

    //+버튼 클릭시 업무리스트 추가
    btnAdd.addEventListener('click', ()=>{
        let formData = $(frm).serialize();

        $.ajax({
        	url: '${pageContext.request.contextPath}/project/addWorklist.do',
        	data: formData,
        	dataType: 'json',
        	type: 'POST',
        	success: data=>{
        		console.log(data);
        		
        		if(data.result===1){
        			
        			//초기화
        			$(inputTitle).val("");
        			$(addWkltFrm).hide();
        			$(addWklt).show();
        		}
        	},
        	error: (x,s,e) => {
				console.log(x,s,e);
			}
      
        }); 
    });
}

//업무리스트 삭제하기
function deleteWorklist(){
	let btnDelModal = document.querySelectorAll(".btn-removeWorklist-modal");
	let modal = document.querySelector("#modal-worklist-remove");
	let modalTitle = document.querySelector("#modal-worklist-title");
	let btnDel = document.querySelector("#btn-removeWorklist");
	
	//업무리스트 x버튼 클릭시 모달창: 모달창에 업무리스트 정보 뿌리기
	btnDelModal.forEach((obj, idx)=>{
		let val = obj.value;
		let valArr = val.split(',');
		
		obj.addEventListener('click', ()=>{
			$(modalTitle).text(valArr[1]); //업무리스트 타이틀 
			$(btnDel).val(valArr[0]); //업무리스트 번호
		});
	});
	
	//삭제버튼 클릭시
	btnDel.addEventListener('click', e=>{
		let worklistNo = e.target.value;
		
		$.ajax({
        	url: '${pageContext.request.contextPath}/project/deleteWorklist.do',
        	data: {worklistNo: worklistNo},
        	dataType: 'json',
        	type: 'POST',
        	success: data=>{
        		console.log(data);
        		
        		if(data.result===1){
        			$(modal).modal('hide');
        		}
        	},
        	error: (x,s,e) => {
				console.log(x,s,e);
			}
        }); 
		
	}); //end of btnDel click 
}

//새 업무 만들기
function addWork(){
	//날짜 설정
    $('.btn-addWorkDate').daterangepicker();
	
	let $btnAddArr = $('.btn-addWork').not('#btn-addWorklist');
    let chkHtml = '<i class="fas fa-check"></i>'; //체크 아이콘 
	
	let addTag;
	let addDateArr = [];
	let addMemberArr = [];
	
	//+버튼 제어
    $btnAddArr.each((idx, obj)=>{
    	let worklistNo = obj.value;
    	let btnCancel = document.querySelector('#worklist-'+worklistNo+' .btn-addWork-cancel');
    	let btnSubmit = document.querySelector('#worklist-'+worklistNo+' .btn-addWork-submit');
   		let addWorkWrapper = document.querySelector('#worklist-'+worklistNo+' .addWork-wrapper');
   		let workTitle = document.querySelector('#worklist-'+worklistNo+' textarea[name=workTitle]');
   		
   		//설정 버튼: 멤버, 태그, 날짜 
   		let btnAddMem = document.querySelector('#worklist-'+worklistNo+' .btn-addWorkMember');
   		let btnAddTag = document.querySelector('#worklist-'+worklistNo+' .btn-addWorkTag');
   		let btnAddDate = document.querySelector('#worklist-'+worklistNo+' .btn-addWorkDate'); 
   		
   		let memTagArr = document.querySelectorAll('#worklist-'+worklistNo+' .drop-memTag');
		let workTagArr = document.querySelectorAll('#worklist-'+worklistNo+' .drop-workTag');
		let dPickerArr = document.querySelectorAll('.daterangepicker');
   		
   		//+버튼 클릭
    	obj.addEventListener('click', ()=>{
    		//입력창 열기
    		$('.addWork-wrapper').removeClass('show');
    		$(addWorkWrapper).addClass("show");
    		$(workTitle).focus();
    		
   			
    		//멤버버튼 클릭
   			memTagArr.forEach((obj, idx)=>{
   				obj.addEventListener('click', e=>{
   					let className = obj.className;
   					let classArr = className.split(" ");
   					let memberId = classArr[2];
   					
   					let idx = addMemberArr.indexOf(memberId);
   					let $hasCheck = $(obj).find('.media-body'); //체크아이콘 들어갈 태그
   					
   					//addMemberArr에 선택한 memberId 담기
   					//배열에 아이디가 존재하지 않는 경우
   					if(idx === -1) {
   						$(obj).addClass('checked');
   						$hasCheck.append(chkHtml);
   						addMemberArr.push(memberId);
   					}
   					//배열에 이미 존재하는 경우
   					else {
   						$(obj).removeClass('checked');
   						let $check = $hasCheck.find('.fa-check'); 
   						$check.remove();
   						addMemberArr.splice(idx, 1);
   					}
   				}); 
   			}); //end of memTagArr
   			
   			
   			//업무상태태그 클릭
   			workTagArr.forEach((obj, idx)=>{
    			obj.addEventListener('click', e=>{
    				let $this = $(e.target);
    				let $check = $('.drop-workTag .fa-check');
		    		
		    		//addTag변수에 선택한 태그코드 담기
    				if($this.hasClass('WT1')) {
    					//이미 선택된 태그가 아닌 경우에는 체크
    					if(!$this.hasClass('checked')){
	    					$this.addClass('checked');
	    					$check.remove(); //다른 태그에 체크 아이콘 더해져있으면 지우기
	    					$this.append(chkHtml); //체크 아이콘 추가 
	    					addTag = "WT1";
    					}
    					//이미 선택된 태그는 체크 해제
    					else{
    						$this.removeClass('checked');
    						$this.find('.fa-check').remove();
    						addTag = "";
    					}
    				}
    				else if($this.hasClass('WT2')) {
    					if(!$this.hasClass('checked')){
	    					$this.addClass('checked');
	    					$check.remove();
	    					$this.append(chkHtml);
	    					addTag = "WT2";
    					}
    					else{
    						$this.removeClass('checked');
    						$this.find('.fa-check').remove();
    						addTag = "";
    					}
    				}
    				else if($this.hasClass('WT3')) {
    					if(!$this.hasClass('checked')){
	    					$this.addClass('checked');
	    					$check.remove();
	    					$this.append(chkHtml);
	    					addTag = "WT3";
    					}
    					else{
    						$this.removeClass('checked');
    						$this.find('.fa-check').remove();
    						addTag = "";
    					}
    				} //end of else if
    				
    			}); //end of 업무태그 click
    		}); //업무태그 끝
   			
   			
    		//날짜버튼 클릭
   			btnAddDate.addEventListener('click', e=>{
   				let btnAddDate = e.target.parentNode;
   				let dp; //선택된 데이트피커
   				
   				dPickerArr.forEach((obj, idx)=>{
   					if(obj.style.display==='block'){
   						dp = obj;
   					}
   				});
   				
   				//데이트피커 요소들
   				let $btnApply = $(dp).find('.applyBtn');
   				let selectedVal;
   				let addDate = e.target.parentNode.parentNode; //추가될 버튼 담길 요소
   				
   				//적용버튼 클릭 시
   				$btnApply.on('click', ()=>{
   					//날짜 뽑아내기
   					selectedVal = $(dp).find('.drp-selected').text();
   					let startArr = selectedVal.split(' - ')[0].split('/');
   					let endArr = selectedVal.split(' - ')[1].split('/');
   					
   					let startDate = startArr[0]+"월 "+startArr[1]+"일";
   					let endDate = endArr[0]+"월 "+endArr[1]+"일";
   					
   					let startSql = startArr[2]+"-"+startArr[0]+"-"+startArr[1];
   					let endSql = endArr[2]+"-"+endArr[0]+"-"+endArr[1];
   					
   					//배열에 담기
   					addDateArr.push(startSql);
   					addDateArr.push(endSql);
   					
    				//추가될 버튼 요소
    				let dateHtml = '<button type="button" class="btn-cancelDate">'+startDate+' - '+endDate+'<i class="fas fa-times"></i></button>';
    				
    				//데이트피커버튼 지우고  
    				$(btnAddDate).remove();
    				$(addDate).append(dateHtml);
    				
    				let $btnCancelDate = $(addDate).find('.btn-cancelDate');
    				
    				//날짜 지우기
    				$btnCancelDate.on('click', ()=>{
    					addDateArr.length = 0; //배열 초기화
    					$btnCancelDate.remove();
    					$(addDate).append(btnAddDate);
    				});
    				
   				}); //end of click $btnApply
   				
   			}); //날짜 버튼끝
   			
   			
   			//만들기버튼 클릭
   			btnSubmit.addEventListener('click', e=>{
   				let workTitle = document.querySelector('#worklist-'+worklistNo+' textarea[name=workTitle]').value;
   				let data = {
   						worklistNo: worklistNo,
   						workTitle: workTitle,
   						workChargedMember: addMemberArr,
   						workTag: addTag,
   						workDate: addDateArr
   				};
   				
   				$.ajax({
   					url: '${pageContext.request.contextPath}/project/insertWork',
   					data: data,
   					dataType: 'html',
   					type: 'POST',
   					success: data=>{
   						console.log(data);
   						
   						let wlSection = document.querySelector('#worklist-'+worklistNo+' .worklist-contents');
   						
   						//입력창 닫기
   			    		$(workTitle).val("");
   			    		$(addWorkWrapper).removeClass("show");
   			    		
   						$(wlSection).prepend(data);
   					},
   					error: (x,s,e) => {
   						console.log(x,s,e);
   					}
   				}); 
   			}) //end of 만들기 버튼
   			
   			
   			//취소버튼 클릭
   			btnCancel.addEventListener('click', e=>{
   				$(workTitle).val("");
   				$(addWorkWrapper).removeClass("show");
   			});
   			
    	}); //end of +버튼 클릭
    }); // end of +버튼 제어 끝
}

//체크리스트 체크
function checklist(){
    let $btnCheck = $(".btn-check");

    $(".btn-check").on('click', e=>{
        let checkbox = e.target;
        let $tr = $(checkbox.parentNode.parentNode.parentNode);
        let $tdChecklist = $(checkbox.parentNode.parentNode.nextSibling.nextSibling);

        //클릭한 대상이 i태그일 경우에만 적용
        if(checkbox.tagName==='I')
            $tr.toggleClass('completed');

        //완료된 체크리스트인 경우 
        if($tr.hasClass('completed')){
            //체크박스 변경
            $(checkbox).removeClass('far fa-square');
            $(checkbox).addClass('fas fa-check-square');

            //리스트에 줄 긋기
            $tdChecklist.css('text-decoration', 'line-through');
        }
        //미완료된 체크리스트인 경우
        else{
            if(checkbox.tagName=='I'){
                //체크박스 변경
                $(checkbox).removeClass('fas fa-check-square');
                $(checkbox).addClass('far fa-square');

                //리스트에 줄 해제
                $tdChecklist.css('text-decoration', 'none');
            }
        }

    }); //end of .btn-check click
}

//서브헤더 탭 active
function tabActive(){
    let tabArr = document.querySelectorAll("#navbar-tab li");

    tabArr.forEach((obj, idx)=>{
        let $obj = $(obj);
        if($obj.hasClass('active')){
            $obj.removeClass('active');
        }
    });

    $("#tab-work").addClass("active");
}

//서브헤더 탭 페이지로 이동
function goTabMenu(){
	let contentWrapper = document.querySelector(".content-wrapper");
	let btnWork = document.querySelector("#btn-tab-work");
	let btnTimeline = document.querySelector("#btn-tab-timeline");
	let btnAnalysis = document.querySelector("#btn-tab-analysis");
	let btnAttach = document.querySelector("#btn-tab-attach");
	
	//업무 탭 클릭
	btnWork.addEventListener('click', e=>{
		location.href = "${pageContext.request.contextPath}/project/projectView.do?projectNo=${project.projectNo}";	
	});
	
	//분석 탭 클릭
	btnAnalysis.addEventListener('click', e=>{
		location.href = "${pageContext.request.contextPath}/project/projectAnalysis.do?projectNo=${project.projectNo}";	
	});
	
	//파일 탭 클릭
	btnAttach.addEventListener('click', e=>{
		$.ajax({
			url: "${pageContext.request.contextPath}/project/projectView.do?projectNo=${project.projectNo}&tab=attach",
			type: "get",
			dataType: "html",
			success: data => {
				
				$(contentWrapper).html("");
				$(contentWrapper).html(data); 
				$(contentWrapper).removeAttr('id');
				$(contentWrapper).attr('class', 'content-wrapper navbar-light');
				
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		});
	}); 
}

function setting(){
    //설정 사이드바 열기
    $('#project-setting-toggle').on('click', function(){
        var $side = $("#setting-sidebar");
        
        var projectNo =${project.projectNo}; 
        $.ajax({
			url: "${pageContext.request.contextPath}/project/projectSetting.do",
			type: "get",
			data:{projectNo:projectNo},
			dataType: "html",
			success: data => {
				
				$side.html("");
				$side.html(data); 
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		});
        
        $side.addClass('open');
        if($side.hasClass('open')) {
        	$side.stop(true).animate({right:'0px'});
        }
    });
    
    //업무 사이드바 열기
    $(".work-item").on('click', function(){
    	var $side = $("#setting-sidebar");
    	var workNo = $(this).attr('id');
    	
    	//업무리스트 타이틀
        var worklistTitle = $(this).children("#hiddenworklistTitle").val();
        //프로젝트 이름
        var projectNo = '${project.projectNo}';
        $.ajax({
			url: "${pageContext.request.contextPath}/project/workSetting.do",
			type: "get",
			data:{workNo:workNo, worklistTitle:worklistTitle, projectNo:projectNo},
			dataType: "html",
			success: data => {
				console.log(data);
				
				$side.html("");
				$side.html(data); 
			},
			error: (x,s,e) => {
				console.log(x,s,e);
			}
		});
        
        $side.addClass('open');
        if($side.hasClass('open')) {
        	$side.stop(true).animate({right:'0px'});
        }
        
    });
     
}
</script>		

<!-- Navbar Project -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light navbar-project navbar-projectView">
    <!-- Left navbar links -->
    <ul class="navbar-nav">
    <li id="go-back" class="nav-item text-center">
        <a class="nav-link" href="${pageContext.request.contextPath}/project/projectList.do"><i class="fas fa-chevron-left"></i></a>
    </li>
    <li id="project-name" class="nav-item">
		<input type="hidden" id="hiddenProjectNo" value="${project.projectNo}"/>
        <button type="button" id="btn-star">
        	<c:if test="${project.projectStarYn=='Y'}">
        	<i class="fas fa-star"></i>
        	</c:if>
        	<c:if test="${project.projectStarYn=='N'}">
        	<i class="far fa-star"></i>
        	</c:if>
        </button>
        ${project.projectTitle}
    </li>
    </ul>

    <!-- Middle navbar links -->
    <ul id="navbar-tab" class="navbar-nav ml-auto">
        <li id="tab-work" class="nav-item"><button type="button" id="btn-tab-work">업무</button></li>
        <li id="tab-timeline" class="nav-item"><button type="button" id="btn-tab-timeline">타임라인</button></li>
        <li id="tab-analysis" class="nav-item"><button type="button" id="btn-tab-analysis">분석</button></li>
        <li id="tab-attachment" class="nav-item"><button type="button" id="btn-tab-attach">파일</button></li>
    </ul>

    <!-- Right navbar links -->
    <ul id="viewRightNavbar-wrapper" class="navbar-nav ml-auto">
        <!-- 프로젝트 대화 -->
        <li class="nav-item">
            <button type="button" class="btn btn-block btn-default btn-xs nav-link">
                <i class="far fa-comments"></i> 프로젝트 대화
            </button>
        </li>
	
		<c:if test=""></c:if>
		
        <!-- 프로젝트 멤버 -->
        <li id="nav-member" class="nav-item dropdown">
            <a class="nav-link" data-toggle="dropdown" href="#">
                <i class="far fa-user"></i> ${fn:length(inMemList)}
            </a>
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
            <c:forEach items="${inMemList}" var="m">
            <a href="${pageContext.request.contextPath}/member/memberView.do?memberId=${m.memberId}" class="dropdown-item">
                <div class="media">
	                <img src="${pageContext.request.contextPath}/resources/img/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile">
	                <div class="media-body">
	                    <p class="memberName">${m.memberName}</p>
	                </div>
                </div>
            </a>
            </c:forEach>
            </div>
        </li>

        <!-- 프로젝트 설정 -->
        <li class="nav-item">
            <button type="button" class="btn btn-block btn-default btn-xs nav-link" id="project-setting-toggle">
            	<i class="fas fa-cog"></i>
            </button>
        </li>
    </ul>
</nav>
<!-- /.navbar -->

<!-- 프로젝트 설정 사이드 바-->
<aside class="control-sidebar project-setting" style="display: block;">
    
</aside> 

<!-- 오른쪽 프로젝트/업무 설정 사이드 바-->
<aside class="work-setting" id="setting-sidebar" style="display: block;">
</aside>

<!-- Content Wrapper. Contains page content -->
<div id="pjv-content-wrapper" class="content-wrapper projectView-wrapper navbar-light">
    <h2 class="sr-only">프로젝트 일정 상세보기</h2>
    <!-- Main content -->
    <div class="content view">
    <h3 class="sr-only">${project.projectTitle}</h3>
    <div class="container-fluid">
        <h4 class="sr-only">업무</h4>
        <!-- SEARCH FORM -->
        <form id="workSearchFrm" class="form-inline">
	        <div class="input-group input-group-sm">
	            <input class="form-control form-control-navbar" type="search" placeholder="업무 검색" aria-label="Search">
	            <div class="input-group-append">
	            <button class="btn btn-navbar" type="submit">
	                <i class="fas fa-search"></i>
	            </button>
	            </div>
	        </div>
        </form>
        
        <!-- 업무리스트 -->
        <c:forEach items="${wlList}" var="wl" varStatus="wlVs">
        <section class="worklist" id="worklist-${wl.worklistNo}">
            <!-- 업무리스트 타이틀 -->
            <div class="worklist-title">
                <h5>${wl.worklistTitle}</h5>
                
                <!-- 업무 생성/업무리스트 삭제: admin, 대표, 프로젝트 팀장에게만 보임 -->
                <c:if test="${'admin'==memberLoggedIn.memberId || '대표'==memberLoggedIn.jobTitle || project.projectWriter==memberLoggedIn.memberId}">
                <div class="worklist-title-btn">
	                <button type="button" class="btn-addWork" value="${wl.worklistNo}"><i class="fas fa-plus"></i></button>
	                <button type="button" class="btn-removeWorklist-modal" value="${wl.worklistNo},${wl.worklistTitle}" data-toggle="modal" data-target="#modal-worklist-remove"><i class="fas fa-times"></i></button>
                </div>
                </c:if>

                <!-- 새 업무 만들기 -->
                <div class="addWork-wrapper">
	                <form class="addWorkFrm">
	                    <!-- 업무 타이틀 작성 -->
	                    <textarea name="workTitle" class="addWork-textarea" placeholder="새 업무 만들기"></textarea>
	
	                    <!-- 하단부 버튼 모음 -->
	                    <div class="addWork-btnWrapper">
		                    <!-- 업무 설정 -->
		                    <div class="addWork-btnLeft">
		                        <!-- 업무 멤버 배정 -->
		                        <div class="add-member dropdown">
			                        <button type="button" class="nav-link btn-addWorkMember" data-toggle="dropdown"><i class="fas fa-user-plus"></i></button>
			                        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
			                            <c:forEach items="${pMemList}" var="m">
							            <a href="javascript:void(0)" class="dropdown-item drop-memTag ${m.memberId}">
							                <div class="media">
								                <img src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile">
								                <div class="media-body">
								                    <p class="memberName">${m.memberName}</p>
								                </div>
							                </div>
							            </a>
							            </c:forEach>
		                        	</div>
		                        </div>
		
		                        <!-- 태그 설정 -->
		                        <div class="add-tag dropdown">
			                        <button type="button" class="nav-link btn-addWorkTag" data-toggle="dropdown"><i class="fas fa-tag"></i></button>
			                        <div class="dropdown-menu dropdown-menu-right">
			                            <a href="javascript:void(0)" class="dropdown-item work-tag drop-workTag WT1">
			                            	<span class="btn btn-xs bg-danger WT1">priority</span>
			                            </a>
			                            <a href="javascript:void(0)" class="dropdown-item work-tag drop-workTag WT2">
			                            	<span class="btn btn-xs bg-primary WT2">important</span>
			                            </a>
			                            <a href="javascript:void(0)" class="dropdown-item work-tag drop-workTag WT3">
			                            	<span class="btn btn-xs bg-warning WT3">review</span>
			                            </a>
			                        </div>
		                        </div>
		
		                        <!-- 날짜 설정 -->
		                        <div class="add-date">
			                        <button type="button" class="btn-addWorkDate"><i class="far fa-calendar-alt"></i></button>
			                        <!-- <button type="button" class="btn-cancelDate">2월 12일 - 2월 14일 <i class="fas fa-times"></i></button> -->
		                        </div>
		                    </div>
	
		                    <!-- 취소/만들기 버튼 -->
		                    <div class="addWork-btnRight">
		                        <button type="button" class="btn-addWork-cancel">취소</button>
		                        <button type="button" class="btn-addWork-submit">만들기</button>
		                    </div>
	                    </div>
	                </form>
                </div>

                <!-- 진행 중인 업무 -->
                <div class="worklist-titleInfo">
                	<!-- 완료된 업무가 아닐 때 -->
                	<c:if test="${wlVs.index!=2}">
                	<p>진행 중인 업무 ${wl.totalWorkCompletYn}개</p>
                	</c:if>
                	<c:if test="${wlVs.index==2}">
                	<p>완료된 업무 ${wl.totalWorkCompletYn}개</p>
                	</c:if> 
                </div>
            </div><!-- /.worklist-title -->
            
            <!-- 업무리스트 컨텐츠 -->
            <div class="worklist-contents">
            	<c:set var="workList" value="${wl.workList}"/>
            	
            	<c:forEach items="${workList}" var="w" varStatus="wVs">
            	<c:if test="${(wlVs.index!=2 && w.workCompleteYn=='N') || (wlVs.index==2 && w.workCompleteYn=='Y')}">
                <!-- 업무 -->
                <section class="work-item" role="button" tabindex="0" id="${w.workNo}">
                	<input type="hidden" id="hiddenworklistTitle" value="${wl.worklistTitle}" />
	                <!-- 태그 -->
	                <c:if test="${w.workTagCode!=null}">
	                <div class="work-tag">
	                	<span class="btn btn-xs bg-${w.workTagColor}">${w.workTagTitle}</span>
	                </div>
	                </c:if>

	                <!-- 업무 타이틀 -->
	                <div class="work-title">
	                    <h6>${w.workTitle}</h6>
	                    <div class="work-importances">
	                    <c:set var="point" value="${w.workPoint}" />
	                    <c:if test="${point>0}">
		                    <c:forEach var="i" begin="1" end="${point}">
		                    <span class="importance-dot checked"></span>
		                    </c:forEach>
		                    <c:forEach var="i" begin="1" end="${5-point}">
		                    <span class="importance-dot"></span>
		                    </c:forEach>
	                    </c:if>
	                    <c:if test="${point==0}">
	                    	<c:forEach var="i" begin="1" end="5">
		                    <span class="importance-dot"></span>
		                    </c:forEach>
	                    </c:if>
	                    </div>
	                </div>

	                <!-- 체크리스트 -->
	                <c:if test="${w.checklistList!=null && !empty w.checklistList}">
	                <c:set var="clList" value="${w.checklistList}" />
	                <div class="work-checklist">
	                    <table class="tbl-checklist">
		                    <tbody>
			                	<c:forEach items="${clList}" var="chk">
				                	<c:set var="m" value="${chk.checklistChargedMember}"></c:set>
				                	<c:if test="${chk.completeYn=='Y'}">
			                        <tr class="completed">
				                		<th><button type="button" class="btn-check"><i class="fas fa-check-square"></i></button></th>
				                        <td style="text-decoration:line-through;">
				                        	<c:if test="${chk.checklistChargedMemberId!=null}">
				                            <img src="${pageContext.request.contextPath}/resources/img/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
				                            </c:if>
				                            ${chk.checklistContent}
				                        </td>
			                        </tr>
			                        </c:if>
			                        <c:if test="${chk.completeYn=='N'}">
			                        <tr>
			                        	<th><button type="button" class="btn-check"><i class="far fa-square"></i></button></th>
				                        <td>
				                        	<c:if test="${chk.checklistChargedMemberId!=null}">
				                            <img src="${pageContext.request.contextPath}/resources/img/default.jpg" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
				                            </c:if>
				                            ${chk.checklistContent}
				                        </td>
			                        </tr>
			                        </c:if>
		                        </c:forEach>
		                    </tbody>
	                    </table>                
                	</div><!-- /.work-checklist -->
					</c:if>
					
	                <!-- 날짜 설정 -->
	                <c:if test="${w.workStartDate!=null}">
	                <div class="work-deadline">
	                    <p>
	                    	<c:if test="${w.workEndDate!=null}">
	                    		<fmt:formatDate value="${w.workStartDate}" type="date" pattern="MM월dd일" /> - 
	                    		<fmt:formatDate value="${w.workEndDate}" type="date" pattern="MM월dd일" />
	                    	</c:if>
	                    	<c:if test="${w.workEndDate==null}">
	                    		<fmt:formatDate value="${w.workStartDate}" type="date" pattern="MM월dd일" />에 시작
	                    	</c:if>
	                    </p>
	                    <!-- 업무리스트 완료됨이 아닐 경우 -->
	                    <c:if test="${wlVs.index!=2 && w.workEndDate!=null}">
	                    	<c:set var="now" value="<%= new Date() %>"/>
	                    	<fmt:formatDate var="nowStr" value="${now}" type="date" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseDate var="today" value="${nowStr}" type="date" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseNumber var="today_D" value="${today.time/(1000*60*60*24)}" integerOnly="true"/>
	                    	<fmt:parseDate var="enddate" value="${w.workEndDate}" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseNumber var="enddate_D" value="${enddate.time/(1000*60*60*24)}" integerOnly="true"/>
	                    	
							<c:if test="${today_D > enddate_D}">
								<p class="over">마감일 ${today_D - enddate_D}일 지남</p>
							</c:if>               	
	                    </c:if>
	                    <!-- 업무리스트 완료됨일 경우 -->
	                    <c:if test="${wlVs.index==2}">
	                    	<p class="complete"><fmt:formatDate value="${w.workRealEndDate}" type="date" pattern="MM월dd일"/>에 완료</p>
	                    </c:if>
	                </div><!-- /.work-deadline -->
					</c:if>
					
					<!-- 완료 체크리스트 수 구하기 -->
					<c:set var="chkCnt" value="0"/>
					<c:forEach items="${w.checklistList}" var="chk">
						<c:if test="${chk.completeYn=='Y'}">
							<c:set var="chkCnt" value="${chkCnt+1}"/>
						</c:if>
					</c:forEach>
					
	                <!-- 기타 아이콘 모음 -->
	                <div class="work-etc">
	                	<!-- 체크리스트/코멘트/첨부파일 수 -->
	                	<c:if test="${fn:length(w.checklistList)==0}">
	                    	<span class="ico"><i class="far fa-list-alt"></i> 0</span>
	                    </c:if>
	                    <c:if test="${fn:length(w.checklistList)>0}">
	                    	<span class="ico"><i class="far fa-list-alt"></i> ${chkCnt}/${fn:length(w.checklistList)}</span>
	                    </c:if>
	                    <span class="ico"><i class="far fa-comment"></i> ${fn:length(w.workCommentList)}</span>
	                    <span class="ico"><i class="fas fa-paperclip"></i> ${fn:length(w.attachmentList)}</span>
	                    
	                    <!-- 업무 배정된 멤버 -->
	                    <c:if test="${w.workChargedMemberList!=null && !empty w.workChargedMemberList}">
	                    <div class="chared-member text-right">
	                    <c:forEach items="${w.workChargedMemberList}" var="m">
		                    <img src="${pageContext.request.contextPath}/resources/img/${m.renamedFileName}" alt="User Avatar" class="img-circle img-profile ico-profile" title="${m.memberName}">
	                    </c:forEach>
	                    </div>
	                    </c:if>
	                </div>

	                <!-- 커버 이미지 -->
	                <c:if test="${w.attachmentList!=null && !empty w.attachmentList}">
	                <div class="work-coverImage">
	                    <img src="${pageContext.request.contextPath}/resources/img/${w.attachmentList[0].renamedFilename}" class="img-cover" alt="test image">
	                </div>
	                </c:if>
                </section><!-- /.work-item -->
            	</c:if>	
                </c:forEach>
                
            </div><!-- /.worklist-contents -->
        </section><!-- /.worklist -->
        </c:forEach>
        
        
        <!-- 업무리스트 추가: admin, 대표, 프로젝트 팀장에게만 보임 -->
        <c:if test="${'admin'==memberLoggedIn.memberId || '대표'==memberLoggedIn.jobTitle || project.projectWriter==memberLoggedIn.memberId}">
        <section id="add-wklt-wrapper" class="worklist add-worklist" role="button" tabindex="0">
            <!-- 타이틀 -->
            <div class="worklist-title">
                <h5><i class="fas fa-plus"></i> 업무리스트 추가</h5>
                <div class="clear"></div>
            </div><!-- /.worklist-title -->
        </section><!-- /.worklist -->
		</c:if>
		
        <!-- 업무리스트 추가 폼 -->
        <section id="add-wkltfrm-wrapper" class="worklist add-worklist" role="button" tabindex="0">
            <!-- 타이틀 -->
            <div class="worklist-title">
                <form id="addWorklistFrm">
                	<input type="hidden" name="projectNo" value="${project.projectNo}" required/>
                    <input type="text" name="worklistTitle" placeholder="업무리스트 이름" required/>
                    <div class="worklist-title-btn">
                        <button type="button" id="btn-addWorklist" class="btn-addWork">
                            <i class="fas fa-plus"></i>
                        </button>
                        <button type="button" id="btn-cancel-addWorklist" class="btn-removeWorklist">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </form>
                <div class="clear"></div>
            </div><!-- /.worklist-title -->
        </section><!-- /.worklist -->

        <div class="clear"></div>
    </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- 업무리스트 삭제 모달 -->
<div class="modal fade" id="modal-worklist-remove">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <h4 class="modal-title">업무리스트 삭제</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            </div>
            <div class="modal-body">
            <p>정말 삭제하시겠습니까? [<span id="modal-worklist-title"></span>] 업무리스트는 영구 삭제됩니다.</p>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">아니오, 업무리스트를 유지합니다.</button>
            <button type="button" id="btn-removeWorklist" class="btn btn-danger">네</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>