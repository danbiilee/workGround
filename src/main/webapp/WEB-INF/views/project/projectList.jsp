<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.kh.workground.project.model.vo.*, com.kh.workground.member.model.vo.* " %>
<%
	Map<String, List<Project>> projectMap = (Map<String, List<Project>>)request.getAttribute("projectMap");
	
	pageContext.setAttribute("listByDept", projectMap.get("listByDept")); //부서 전체 프로젝트(최근 프로젝트)
	pageContext.setAttribute("listByImportant", projectMap.get("listByImportant")); //중요 표시된 프로젝트 조회
	pageContext.setAttribute("listByInclude", projectMap.get("listByInclude")); //내가 속한 프로젝트
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<link rel="stylesheet" property="stylesheet" href="${pageContext.request.contextPath}/resources/css/hyemin.css">

<script>
$(function(){
	sidebarActive(); //사이드바 활성화
	addMember(); //프로젝트 팀원 추가 - multiselect.js
	delProject(); //프로젝트 삭제 
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

function sortByStatus(statusCodeElem){
	$("#sort-by-status").html(statusCodeElem.innerHTML);
	var statusCode = statusCodeElem.id;
	console.log(statusCode);
	if(statusCode == 'ALL'){
		location.href="${pageContext.request.contextPath}/project/projectList.do"
		return;
	}
	$.ajax({
		url:"${pageContext.request.contextPath}/project/projectListByStatusCode.do",
		data:{statusCode : statusCode},
		dataType:"json",
		success: data => {
			//최근 프로젝트
			let depthtml='';
		    $.each(data.listByDept,(idx,list)=>{
		    	depthtml += '<div class="col-12 col-sm-6 col-md-3"><div class="card card-hover"><a href="${pageContext.request.contextPath}/project/projectView.do?projectNo='+list.projectNo+'">'
		    					+'<div class="card-body"><div class="card-title"><h5>'+list.projectTitle+'</h5></div></div></a></div></div>'
		    });
			
			//중요 표시한 프로젝트
			let importanthtml ='';
			$.each(data.listByImportant, (idx,list)=>{
				importanthtml += '<div class="col-12 col-sm-6 col-md-3"><div class="card card-hover"><a href="${pageContext.request.contextPath}/project/projectView.do?projectNo='+list.projectNo+'">'
                		+'<div class="card-body"><div class="card-title"><h5>'+list.projectTitle+'</h5></div>'
                		+'<div class="card-star text-right"><i class="fas fa-star"></i></div>'
                		+'<div class="card-status"><span class="btn btn-block btn-sm bg-'+list.projectStatusColor+'">'+list.projectStatusTitle+'</span><span class="end-date">'; //프로젝트 상태
				if(list.projectEndDate != null){
					importanthtml += '<i class="far fa-calendar-alt"></i>'+list.projectEndDate;
				}
				importanthtml +='</span></div><div class="progress-group card-progress"><span class="progress-title"><span class="percent">11%</span> 완료</span>'
                    			+'<span class="progress-title float-right"><span>1</span>/<span>9</span> 개 업무</span><div class="progress progress-sm"><div class="progress-bar bg-info" style="width: 11%"></div>'
                    			+'</div></div></div></a></div></div>'               
			});
			
			//내가 속한 프로젝트
			let includehtml ='';
			$.each(data.listByInclude, (idx,list)=>{
				includehtml += '<div class="col-12 col-sm-6 col-md-3"><div class="card card-hover"><a href="${pageContext.request.contextPath}/project/projectView.do?projectNo='+list.projectNo+'">'
        		+'<div class="card-body"><div class="card-title"><h5>'+list.projectTitle+'</h5></div>'
        		+'<div class="card-status"><span class="btn btn-block btn-sm bg-'+list.projectStatusColor+'">'+(list.projectStatusTitle==null?"":list.projectStatusTitle)+'</span><span class="end-date">'; //프로젝트 상태
				if(list.projectEndDate != null){
					includehtml += '<i class="far fa-calendar-alt"></i>'+list.projectEndDate;
				}
				includehtml +='</span></div><div class="progress-group card-progress"><span class="progress-title"><span class="percent">11%</span> 완료</span>'
            					+'<span class="progress-title float-right"><span>1</span>/<span>9</span> 개 업무</span><div class="progress progress-sm"><div class="progress-bar bg-info" style="width: 11%"></div>'
            					+'</div></div></div></a></div></div>'     
			});
			
			$("#include-count").text('('+Object.keys(data.listByInclude).length+')');
			$("#important-count").text('('+Object.keys(data.listByImportant).length+')');
			
			$("#project-recent-content").html(''); //데이터 없을 경우 비우기 위함.
			$("#project-important-content").html(''); //데이터 없을 경우 비우기 위함.
			$("#project-include-content").html(''); //데이터 없을 경우 비우기 위함.
			
			$("#project-recent-content").html(depthtml);
			$("#project-important-content").html(importanthtml);
			$("#project-include-content").html(includehtml);
			
		},
		error : (x,s,e) => {
			console.log(x,s,e);
		}
	})
}

//프로젝트 삭제
function delProject(){
	let btnRemoveP = document.querySelector('#btn-removeProject');
	$(document).on('click', '.btn-del-project', (e)=>{
		e.preventDefault();
		
		let val = e.target.parentNode.value;
		let projectNo = val.split(',')[0];
		let title = val.split(',')[1];
		
		$('.modal-del-target').text(title);
		
		btnRemoveP.addEventListener('click', ()=>{
			location.href = '${pageContext.request.contextPath}/project/deleteProject.do?projectNo='+projectNo;
		});
	});
}

</script>


<!-- Navbar Project -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
    <!-- Left navbar links -->
    <ul class="navbar-nav">
        <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" data-toggle="dropdown" id="sort-by-status">
            전체 프로젝트 (${fn:length(listByDept)}) <span class="caret"></span>
        </a>
        <div class="dropdown-menu">
            <a class="dropdown-item sort-by-status" id="ALL" tabindex="-1" onclick="sortByStatus(this);">전체 프로젝트 (${fn:length(listByDept)})</a>
            <a class="dropdown-item sort-by-status" id="PS1" tabindex="-1" onclick="sortByStatus(this);">계획됨 (${statusCntMap['계획됨']}) <span class="status-dot bg-warning"></span></a>
            <a class="dropdown-item sort-by-status" id="PS2" tabindex="-1" onclick="sortByStatus(this);">진행중 (${statusCntMap['진행중']}) <span class="status-dot bg-success"></span></a>
            <a class="dropdown-item sort-by-status" id="PS3" tabindex="-1" onclick="sortByStatus(this);">완료됨 (${statusCntMap['완료됨']}) <span class="status-dot bg-info"></span></a>
            <a class="dropdown-item sort-by-status" id="" tabindex="-1" onclick="sortByStatus(this);">상태없음 (${statusCntMap['상태없음']})</a>
        </div>
        </li>
    </ul>

    <!-- Right navbar links -->
    <ul class="navbar-nav ml-auto navbar-nav-sort">
        <!-- 정렬 -->
        <li class="nav-item dropdown">
        정렬
        <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#">
            이름순 <span class="caret"></span>
        </a>
        <div class="dropdown-menu">
            <a class="dropdown-item" tabindex="-1" href="#">업데이트순</a>
            <a class="dropdown-item" tabindex="-1" href="#">이름순</a>
        </div>
        </li>
        <!-- 새 프로젝트 만들기 -->
        <c:if test="${memberLoggedIn.jobTitle eq '팀장'}">
        <li class="nav-item add-project">
        <button id="add-project" class="bg-info" style="font-size:0.85rem;" data-toggle="modal" data-target="#add-project-modal">
            <i class="fa fa-plus"></i>
            <span>새 프로젝트</span>
        </button>  
        </li>	
        </c:if>
    </ul>
</nav>
<!-- /.navbar -->

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <h2 class="sr-only">프로젝트 목록</h2>
    <!-- Main content -->
    <div class="content">
        <div class="container-fluid">
        <!-- 최근 프로젝트 -->
        <section id="project-recent">
            <div class="card-header" role="button" tabindex="0" onclick="toggleList(this);">
                <h3><i class="fas fa-chevron-down"></i> 최근 프로젝트</h3>
            </div><!-- /.card-header -->
            <div class="row card-content" id="project-recent-content">
            
            <c:forEach items="${listByDept}" var="p">
	            <div class="col-12 col-sm-6 col-md-3">
	                <div class="card card-hover">
	                <a href="${pageContext.request.contextPath}/project/projectView.do?projectNo=${p.projectNo}">
	                    <div class="card-body">
	                    <div class="card-title">
	                        <h5>${p.projectTitle}</h5>
	                    </div>
	                    </div>
	                </a>
	                </div><!-- /.card -->
	            </div>
	        </c:forEach> 
	        
	        </div><!-- /.card-content -->
        </section>

        <!-- 중요 표시된 프로젝트 -->
        <section id="project-important">
            <div class="card-header" role="button" tabindex="0" onclick="toggleList(this);">
            	<h3><i class="fas fa-chevron-down"></i> <i class="fas fa-star"></i> 중요 표시된 프로젝트 <span class="header-count" id="important-count">(${fn:length(listByImportant)})</span></h3>
            </div><!-- /.card-header -->
            <div class="row card-content" id="project-important-content">
            
            <c:forEach items="${listByImportant}" var="p">
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card card-hover">
                    <a href="${pageContext.request.contextPath}/project/projectView.do?projectNo=${p.projectNo}">
                    <div class="card-body star-body">
                        <!-- 타이틀 -->
                        <div class="card-title">
                        	<h5>${p.projectTitle}</h5>
                        </div>
                        <!-- 중요표시 -->
                        <div class="card-star text-right">
                        	<i class="fas fa-star"></i>
                        	<c:if test="${memberLoggedIn.memberId == p.projectWriter}">
                        	<span class="line"></span>
                        	<button type="button" class="btn-del-project" value="${p.projectNo},${p.projectTitle}" data-toggle="modal" data-target="#modal-project-remove"><i class="fas fa-times del-project"></i></button>
                        	</c:if>
                        </div>
                        <!-- 프로젝트 상태 / 마감일 -->
                        <div class="card-status">
                        	<span class="btn btn-block btn-sm bg-${p.projectStatusColor}">${p.projectStatusTitle}</span>
	                        <span class="end-date">
	                        	<c:set var="now" value="<%= new Date() %>"/>
		                    	<fmt:formatDate var="nowStr" value="${now}" type="date" pattern="yyyy-MM-dd"/>
		                    	<fmt:parseDate var="today" value="${nowStr}" type="date" pattern="yyyy-MM-dd"/>
		                    	<fmt:parseNumber var="today_D" value="${today.time/(1000*60*60*24)}" integerOnly="true"/>
		                    	<fmt:parseDate var="enddate" value="${p.projectEndDate}" pattern="yyyy-MM-dd"/>
		                    	<fmt:parseNumber var="enddate_D" value="${enddate.time/(1000*60*60*24)}" integerOnly="true"/>
		                    	
	                        	<!-- 실제완료일이 있는 경우  -->
	                        	<c:if test="${p.projectRealEndDate!=null}">
	                        	<span class="p-completed"><fmt:formatDate value="${p.projectRealEndDate}" type="date" pattern="MM월 dd일"/>에 완료</span>
	                        	</c:if>
	                        	<!-- 실제완료일 없고 마감일만 있는 경우 -->
	                        	<c:if test="${p.projectRealEndDate==null && p.projectEndDate!=null}">
	                        		<!-- 마감일 안 지난 경우 -->
	                        		<c:if test="${today_D <= enddate_D}">
		                        	<i class="far fa-calendar-alt"></i> 
		                        	${p.projectEndDate}
	                        		</c:if>
	                        		<c:if test="${today_D > enddate_D}">
		                        	<span class="p-over">마감일 ${today_D - enddate_D}일 지남</span>
	                        		</c:if>
	                        		<!-- 마감일 지난 경우 -->
	                        	</c:if>
	                        </span>
                        </div>
                        <div class="progress-group card-progress">
	                        <span class="progress-title"><span class="percent">${p.completePercent}%</span> 완료</span>
	                        <span class="progress-title float-right"><span>${p.totalProjectCompletedWorkCnt}</span>/<span>${p.totalProjectWorkCnt}</span> 개 업무</span>
	                        <div class="progress progress-sm">
	                            <div class="progress-bar bg-info" style="width: ${p.completePercent}%"></div>
	                        </div>
                        </div>
                    </div>
                    </a>
                </div><!-- /.card -->
            </div>
            </c:forEach>
            
            </div><!-- /.card-content -->
        </section>
        
        <!-- 내가 속한 프로젝트 -->
        <section id="project-in">
            <div class="card-header" role="button" tabindex="0" onclick="toggleList(this);">
            	<h3><i class="fas fa-chevron-down"></i> 내가 속한 프로젝트 <span class="header-count" id="include-count">(${fn:length(listByInclude)})</span></h3>
            </div><!-- /.card-header -->
            <div class="row card-content" id="project-include-content">
            
            <!-- 내 업무 -->
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card card-hover mywork">
                    <a href="${pageContext.request.contextPath}/project/projectView.do?projectNo=${listByInclude[0].projectNo}">
                    <div class="card-body">
                        <!-- 프로필 사진 -->
                        <img src="${pageContext.request.contextPath}/resources/img/profile/${memberLoggedIn.renamedFileName}" alt="User Avatar" class="img-circle img-profile">
                        <!-- 타이틀 -->
                        <div class="card-title text-center"><h5>${listByInclude[0].projectTitle}</h5></div>
                        <!-- 프로젝트 상태  -->
                        <div class="progress-group card-progress">
	                        <span class="progress-title"><span class="percent">${listByInclude[0].completePercent}%</span> 완료</span>
	                        <span class="progress-title float-right"><span>${listByInclude[0].totalProjectCompletedWorkCnt}</span>/<span>${listByInclude[0].totalProjectWorkCnt}</span> 개 업무</span>
	                        <div class="progress progress-sm">
	                            <div class="progress-bar bg-info" style="width: ${listByInclude[0].completePercent}%"></div>
	                        </div>
                        </div>
                    </div>
                    </a>
                </div><!-- /.card -->
            </div>
            
            <!-- 프로젝트 -->
			<c:forEach items="${listByInclude}" begin="1" var="p">
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card card-hover">
                <a href="${pageContext.request.contextPath}/project/projectView.do?projectNo=${p.projectNo}">
                <c:if test="${p.projectStarYn=='Y'}">
                    <div class="card-body star-body">
                </c:if>
                <c:if test="${p.projectStarYn=='N'}">
                    <div class="card-body">
                </c:if>
                    <!-- 타이틀 -->
                    <div class="card-title">
                        <h5>${p.projectTitle}</h5>
                    </div>

                    <!-- 중요표시 -->
                    <div class="card-star text-right">
	                    <c:if test="${p.projectStarYn=='Y'}">
                    	<i class="fas fa-star"></i>
	                    </c:if>
	                    
	                    <c:if test="${memberLoggedIn.memberId == p.projectWriter}">
	                    	<c:if test="${p.projectStarYn=='Y'}">
	                    	<span class="line"></span>
                        	<button type="button" class="btn-del-project" value="${p.projectNo},${p.projectTitle}" data-toggle="modal" data-target="#modal-project-remove"><i class="fas fa-times del-project"></i></button>
	                    	</c:if>
	                    	<c:if test="${p.projectStarYn=='N'}">
                        	<button type="button" class="btn-del-project" value="${p.projectNo},${p.projectTitle}" data-toggle="modal" data-target="#modal-project-remove"><i class="fas fa-times del-project no-star"></i></button>
	                    	</c:if>
                        </c:if>
                    </div>

                    <!-- 프로젝트 상태 / 마감일 -->
                    <div class="card-status">
                        <span class="btn btn-block btn-sm bg-${p.projectStatusColor}">${p.projectStatusTitle}</span>
                        <span class="end-date">
                        	<c:set var="now" value="<%= new Date() %>"/>
	                    	<fmt:formatDate var="nowStr" value="${now}" type="date" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseDate var="today" value="${nowStr}" type="date" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseNumber var="today_D" value="${today.time/(1000*60*60*24)}" integerOnly="true"/>
	                    	<fmt:parseDate var="enddate" value="${p.projectEndDate}" pattern="yyyy-MM-dd"/>
	                    	<fmt:parseNumber var="enddate_D" value="${enddate.time/(1000*60*60*24)}" integerOnly="true"/>
	                    	
                        	<!-- 실제완료일이 있는 경우  -->
                        	<c:if test="${p.projectRealEndDate!=null}">
                        	<span class="p-completed"><fmt:formatDate value="${p.projectRealEndDate}" type="date" pattern="MM월 dd일"/>에 완료</span>
                        	</c:if>
                        	<!-- 실제완료일 없고 마감일만 있는 경우 -->
                        	<c:if test="${p.projectRealEndDate==null && p.projectEndDate!=null}">
                        		<!-- 마감일 안 지난 경우 -->
                        		<c:if test="${today_D <= enddate_D}">
	                        	<i class="far fa-calendar-alt"></i> 
	                        	${p.projectEndDate}
                        		</c:if>
                        		<c:if test="${today_D > enddate_D}">
	                        	<span class="p-over">마감일 ${today_D - enddate_D}일 지남</span>
                        		</c:if>
                        		<!-- 마감일 지난 경우 -->
                        	</c:if>
                        </span>
                    </div>
                    <c:if test="${p.projectStarYn=='N'}">
                    <div class="progress-group card-progress star-n">
                    </c:if>
                    <c:if test="${p.projectStarYn=='Y'}">
                    <div class="progress-group card-progress">
                    </c:if>
                        <span class="progress-title"><span class="percent">${p.completePercent}%</span> 완료</span>
                        <span class="progress-title float-right"><span>${p.totalProjectCompletedWorkCnt}</span>/<span>${p.totalProjectWorkCnt}</span> 개 업무</span>
                        <div class="progress progress-sm">
                        <div class="progress-bar bg-info" style="width: ${p.completePercent}%"></div>
                        </div>
                    </div>
                    </div><!-- /.card-body -->
                </a>
                </div><!-- /.card -->
            </div>
            </c:forEach> 
            
            <!-- 새 프로젝트 추가 -->
            <c:if test="${memberLoggedIn.jobTitle eq '팀장'}">
            <div class="col-12 col-sm-6 col-md-3">
                <div class="card addpr-hover add-project" data-toggle="modal" data-target="#add-project-modal">
                <div class="card-body addpr-center">
                    <i class="fa fa-plus" style="font-size:30px;"></i>
                    <h6>새 프로젝트</h6>
                </div>
                </div><!-- /.card -->
            </div>
            </c:if>
            </div><!-- /.card-content -->
        </section>
        </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->
		
<!-- 새 프로젝트 모달창 -->
<div class="modal fade" id="add-project-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">새 프로젝트</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <!-- modal body -->
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/project/addProject.do" id="addProjectFrm" method="POST">
                <div class="form-group">
                    <label for="projectTitle" class="col-form-label">제목</label>
                    <input type="text" class="form-control" id="projectTitle" name="projectTitle" required>
                </div>
                <div class="form-group">
                    <label for="projectDescribe" class="col-form-label">설명(선택사항)</label>
                    <input type="text" class="form-control" id="projectDescribe" name="projectDesc">
                </div>
                <div class="form-group">
                    <label for="projectMember">프로젝트 멤버(선택사항)</label>
                    <div class='control-wrapper'>
                        <div class="control-styles">
                            <input type="text" tabindex="1" id="projectMember" name="projectMember"/>
                        </div>
                    </div>
                    <div class="row justify-content-md-center">
                    <button type="submit" class="btn bg-info add-submit">프로젝트 만들기</button>
                    </div>
                </div>
                </form>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>	

<!-- 프로젝트 삭제 모달 -->
<div class="modal fade" id="modal-project-remove">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <h4 class="modal-title"><span class="modal-del-target"></span> 삭제</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            </div>
            <div class="modal-body">
            <p>정말 삭제하시겠습니까? 프로젝트 [<span class="modal-del-target"></span>]는 영구 삭제됩니다.</p>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">아니오, <span class="modal-del-target"></span>를 유지합니다.</button>
            <button type="button" id="btn-removeProject" class="btn btn-danger">네</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>	

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
<script src="${pageContext.request.contextPath }/resources/js/multiselect.js"></script>