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
    addWork(); //새 업무 만들기
    checklist(); //체크리스트 체크
    addWorklist(); //새 업무리스트 만들기
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

    btnStar.addEventListener('click', (e)=>{
        let $this = $(e.target);

        //프로젝트 중요표시 되어있는 경우
        if($this.hasClass('fas')){
            $this.removeClass('fas').addClass('far');
        }
        //프로젝트 중요표시 안되어있는 경우 
        else{
            $this.removeClass('far').addClass('fas');
        }
    });
}

//새 업무 만들기
function addWork(){
    //새 업무 만들기: +버튼 클릭
    $(".btn-addWork").on('click', e=>{
        let worklistTitle = e.target.parentNode.parentNode.parentNode;
        let $addWork = $(worklistTitle).find(".addWork-wrapper");
        $addWork.toggleClass("show");
    });

    //새 업무 만들기: 취소버튼 클릭
    $(".btn-addWork-cancel").on('click', ()=>{
        $(".addWork-wrapper").toggleClass("show");
    });

    //새업무 만들기: 날짜 설정
    $('.btn-setWorkDate').daterangepicker();
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

//새 업무리스트 만들기
function addWorklist(){
    let addWklt = document.querySelector("#add-wklt-wrapper");
    let addWkltFrm = document.querySelector("#add-wkltfrm-wrapper");
    let btnAdd = document.querySelector("#btn-addWorklist");
    let btnCancel = document.querySelector("#btn-cancel-addWorklist");

    //업무리스트 추가 클릭시 입력폼 보이기
    addWklt.addEventListener('click', ()=>{
        $(addWklt).hide();
        $(addWkltFrm).show();
    });

    //x버튼 클릭시 다시 업무리스트 추가 보이기
    btnCancel.addEventListener('click', ()=>{
        $(addWklt).show();
        $(addWkltFrm).hide();
    });

    //+버튼 클릭시 업무리스트 추가
    btnAdd.addEventListener('click', ()=>{
        console.log(111111);
        //에이작스!? 
    });
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
	
	btnWork.addEventListener('click', e=>{
		location.href = "${pageContext.request.contextPath}/project/projectView.do";	
	});
	
	btnAnalysis.addEventListener('click', e=>{
		location.href = "${pageContext.request.contextPath}/project/projectAnalysis.do";	
	});
	
	/* btnAttach.addEventListener('click', e=>{
		location.href = "${pageContext.request.contextPath}/project/projectAttachment.do";	
	}); */
	
	
	//파일 탭
	btnAttach.addEventListener('click', e=>{
		$.ajax({
			url: "${pageContext.request.contextPath}/project/projectAttachment.do",
			type: "get",
			dataType: "html",
			success: data => {
				
				$(contentWrapper).html("");
				$(contentWrapper).html(data); 
				
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
        <a class="nav-link" href=""><i class="fas fa-chevron-left"></i></a>
    </li>
    <li id="project-name" class="nav-item">
        <button type="button" id="btn-star"><i class="fas fa-star"></i></button>
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

        <!-- 프로젝트 멤버 -->
        <li id="nav-member" class="nav-item dropdown">
            <a class="nav-link" data-toggle="dropdown" href="#">
                <i class="far fa-user"></i> ${fn:length(pMemList)}
            </a>
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
            <c:forEach items="${pMemList}" var="m">
            <a href="#" class="dropdown-item">
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
        <section class="worklist">
            <!-- 업무리스트 타이틀 -->
            <div class="worklist-title">
                <h5>${wl.worklistTitle}</h5>
                <div class="worklist-title-btn">
	                <button type="button" class="btn-addWork" onclick=""><i class="fas fa-plus"></i></button>
	                <button type="button" class="btn-removeWorklist" data-toggle="modal" data-target="#modal-wroklist-remove"><i class="fas fa-times"></i></button>
                </div>

                <!-- 새 업무 만들기 -->
                <div class="addWork-wrapper">
	                <form action="" class="addWorkFrm">
	                    <!-- 업무 타이틀 작성 -->
	                    <textarea name="workTitle" class="addWork-textarea" placeholder="새 업무 만들기"></textarea>
	
	                    <!-- 하단부 버튼 모음 -->
	                    <div class="addWork-btnWrapper">
	                    <!-- 업무 설정 -->
	                    <div class="addWork-btnLeft">
	                        <!-- 업무 배정 -->
	                        <div class="add-tag dropdown">
	                        <a class="nav-link" data-toggle="dropdown" href="#">
	                            <i class="fas fa-user-plus"></i>
	                        </a>
	                        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
	                            <a href="#" class="dropdown-item">
	                            <!-- Message Start -->
	                            <div class="media">
	                                <img src="dist/img/user1-128x128.jpg" alt="User Avatar" class="img-size-50 mr-3 img-circle">
	                                <div class="media-body">
	                                <h3 class="dropdown-item-title">
	                                    Brad Diesel
	                                </h3>
	                                <p class="text-sm">Call me whenever you can...</p>
	                                <p class="text-sm text-muted"><i class="far fa-clock mr-1"></i> 1월 21일</p>
	                                </div>
	                            </div>
	                            <!-- Message End -->
	                            </a>
	                            <div class="dropdown-divider"></div>
	                            <a href="#" class="dropdown-item">
	                            <!-- Message Start -->
	                            <div class="media">
	                                <img src="dist/img/user8-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
	                                <div class="media-body">
	                                <h3 class="dropdown-item-title">
	                                    John Pierce
	                                </h3>
	                                <p class="text-sm">I got your message bro</p>
	                                <p class="text-sm text-muted"><i class="far fa-clock mr-1"></i> 1월 21일</p>
	                                </div>
	                            </div>
	                            <!-- Message End -->
	                            </a>
	                        </div>
	                        </div>
	
	                        <!-- 태그 설정 -->
	                        <div class="add-tag dropdown">
	                        <a class="nav-link" data-toggle="dropdown" href="#">
	                            <i class="fas fa-tag"></i>
	                        </a>
	                        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
	                            <a href="#" class="dropdown-item">
	                            <!-- Message Start -->
	                            <div class="media">
	                                <img src="dist/img/user1-128x128.jpg" alt="User Avatar" class="img-size-50 mr-3 img-circle">
	                                <div class="media-body">
	                                <h3 class="dropdown-item-title">
	                                    Brad Diesel
	                                </h3>
	                                <p class="text-sm">Call me whenever you can...</p>
	                                <p class="text-sm text-muted"><i class="far fa-clock mr-1"></i> 1월 21일</p>
	                                </div>
	                            </div>
	                            <!-- Message End -->
	                            </a>
	                            <div class="dropdown-divider"></div>
	                            <a href="#" class="dropdown-item">
	                            <!-- Message Start -->
	                            <div class="media">
	                                <img src="dist/img/user8-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
	                                <div class="media-body">
	                                <h3 class="dropdown-item-title">
	                                    John Pierce
	                                </h3>
	                                <p class="text-sm">I got your message bro</p>
	                                <p class="text-sm text-muted"><i class="far fa-clock mr-1"></i> 1월 21일</p>
	                                </div>
	                            </div>
	                            <!-- Message End -->
	                            </a>
	                        </div>
	                        </div>
	
	                        <!-- 날짜 설정 -->
	                        <button type="button" class="btn-setWorkDate"><i class="far fa-calendar-alt"></i></button>
	                    </div>
	
	                    <!-- 취소/만들기 버튼 -->
	                    <div class="addWork-btnRight">
	                        <button type="button" class="btn-addWork-cancel">취소</button>
	                        <button type="submit" class="btn-addWork-submit">만들기</button>
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
	                    	<fmt:formatDate value="${w.workStartDate}" type="date" pattern="MM월dd일" /> - 
	                    	<c:if test="${w.workEndDate!=null}">
	                    		<fmt:formatDate value="${w.workEndDate}" type="date" pattern="MM월dd일" />
	                    	</c:if>
	                    	<c:if test="${w.workEndDate==null}">
	                    		마감일 없음
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
        
        
        <!-- 업무리스트 추가 -->
        <section id="add-wklt-wrapper" class="worklist add-worklist" role="button" tabindex="0">
            <!-- 타이틀 -->
            <div class="worklist-title">
                <h5><i class="fas fa-plus"></i> 업무리스트 추가</h5>
                <div class="clear"></div>
            </div><!-- /.worklist-title -->
        </section><!-- /.worklist -->

        <!-- 업무리스트 추가 폼 -->
        <section id="add-wkltfrm-wrapper" class="worklist add-worklist" role="button" tabindex="0">
            <!-- 타이틀 -->
            <div class="worklist-title">
                <form action="" id="addWorklistFrm">
                    <input type="text" name="worklistTitle" placeholder="업무리스트 이름">
                    <div class="worklist-title-btn">
                        <button type="submit" id="btn-addWorklist" class="btn-addWork">
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
<div class="modal fade" id="modal-wroklist-remove">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <h4 class="modal-title">업무리스트 삭제</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            </div>
            <div class="modal-body">
            <p>정말 삭제하시겠습니까? [] 업무리스트는 영구 삭제됩니다.</p>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">아니오, 업무리스트를 유지합니다.</button>
            <button type="button" class="btn btn-danger">네</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>