<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/club/clubViewModal.jsp"></jsp:include>

<style>
.note-editing-area {
	min-height: 100px;
}
.note-editor.note-frame {
	max-height: 148px;
}

#navbar-club #noticeSearchFrm {
	margin-left: 1rem;
}

#info-wrapper .card-body {
	padding: 3rem 1.25rem;
}

#info-wrapper .card-header {
	margin-top: 0;
}

#info-wrapper .card-title {
	color: ##464c59;
	font-size: 1rem;
	font-weight: bold;
}
/* nav new club */
#nav-new-club {
	color: white;
	border: none;
	padding: 0.35rem 0.5rem;
	margin-right: 1rem;
	border-radius: 0.25rem;
}
/* new club card */
#new-club-card {
	height: 298x;
	text-align: center;
	padding: 6rem 0rem;
}

#new-club-card .card-body {
	color: #17a2b8;
}

#new-club-card i {
	margin-bottom: .7rem;
	font-size: 30px;
}

#new-club-card:hover {
	background: #17a2b8;
}

#new-club-card:hover .card-body {
	color: #fff;
}
.h6{
position: relative; 
top:.5rem; 
left: .5rem;
}
.comment-count{margin-bottom: 0.5rem; color: rgb(93, 93, 93);}
.comment-text-area{display: inline-block; width: 90%; height: 2rem; margin-right: .3rem;}
.comment-reply{border: 0; background: darkgray; border-radius: 3px; margin-right: .3rem; color: white;}
.comment-delete{border: 0; background: darkgray; border-radius: 3px; color: white;}
.comment-submit{border: 0; background: darkgray; border-radius: 3px; width: 3rem; height: 2rem; color: white;}
.comment-submit:hover, .comment-reply:hover{background: #007bff;}
.comment-delete:hover{background: #dc3545;}
.comment-level2{margin-left: 3rem;}

.control-sidebar {
      display: block;
      top: 92px !important;
      overflow: hidden;
      background-color: #fff;
      box-shadow: -1px 6px 10px 0 rgba(0, 0, 0, .2);
      color: #696f7a;
    }

.control-sidebar,
.control-sidebar::before {
  bottom: calc(3.5rem + 1px);
  display: none;
  right: -475px;
  width: 475px;
  transition: right .3s ease-in-out, display .3s ease-in-out;
}
</style>

<script>
$(function(){
	//Summernote
	$('.textarea').summernote();
	//Date range picker
	$('#reservation').daterangepicker({
	    singleDatePicker: true,
	    showDropdowns: true,
	    locale: {
		    format: 'YYYY-MM-DD'
	    }
	  });

/* 	//Date range as a button
	$('#daterange-btn').daterangepicker(
	    {
	    ranges: {
	        'Today': [moment(), moment()],
	        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
	        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
	        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
	        'This Month': [moment().startOf('month'), moment().endOf('month')],
	        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
	    },
	    startDate: moment().subtract(29, 'days'),
	    endDate: moment()
	    },
	    function (start, end) {
	    $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'))
	    }
	);
 */	
	sidebarActive(); //사이드바 활성화
	tabActive(); //서브헤더 탭 활성화
	
});

function memberList(clubNo){
	location.href = "${pageContext.request.contextPath}/club/clubMemberList.do?clubNo="+clubNo;
}

function clubFileList(clubNo) {
	location.href = "${pageContext.request.contextPath}/club/clubFileList.do?clubNo="+clubNo;
}

//사이드바 활성화
function sidebarActive(){
	let navLinkArr = document.querySelectorAll(".sidebar .nav-link");
	
	navLinkArr.forEach((obj, idx)=>{
		let $obj = $(obj);
		if($obj.hasClass('active'))
			$obj.removeClass('active');
	});
	
	$("#sidebar-club").addClass("active");
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

    $("#tab-club").addClass("active");
}

$(function() {
	//파일 선택/취소시에 파일명 노출하기
	$("[name=upFile]").on("change", function() {
		//파일입력 취소
		if($(this).prop("files")[0] === undefined) {
			$(this).next(".custom-file-label").html("파일을 선택하세요.");
			return;
		}
		
		var fileName = $(this).prop('files')[0].name;
		$(this).next(".custom-file-label").html(fileName);
	});
	
});

function validate() {
	var title = $("[name=clubPhotoTitle]").val();
	var fileName = $(this).prop('files')[0].name;
	if(title.trim().length==0) {
		alert('제목을 입력하세요.');
		return false;
	}
	else if(fileName.length==0) {
		alert('파일을 선택하세요.');
		return false;
	}
	return true;
}

/* $(()=> {
	var clubPlanNo = $("#clubPlanNo").val();
	//console.log(clubPlanNo);

	$(".clubPlanCard").on("click", ()=> {
		
		$.ajax({
			url: "${pageContext.request.contextPath}/club/selectClubPlanAttendeeList.do", 
			data: {clubPlanNo: clubPlanNo}, 
			dataType: "json", 
			success: data=> {
				console.log(data);
				
				let html = '';
				let clubPlanNo = '';
				$(data).each((idx, a)=>{
                    html += '<div class="card card-success" style="width: 8rem; height: 3rem; padding-top: .2rem; margin-top: 1rem; display: inline-block;">';
                    html += '<div class="col-12">';
					html += '<img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/'+a.renamedFileName+'" alt="Message User Image">';
					html += '<h6 class="h6">'+a.memberName+'</h6>';
                    html += '<div class="card-tools" style="position: relative; bottom: 1.4rem; left: 3.5rem; display: inline-block;">';
                    html += '<form name="deleteClubPlanAttendeeFrm" action="${pageContext.request.contextPath}/club/deleteClubPlanAttendee.do" method="POST">';
                    html += '<input type="hidden" name="memberId" value="'+a.memberId+'">';
                    html += '<input type="hidden" name="clubPlanAttendeeNo" value="'+a.clubPlanAttendeeNo+'">';
                    html += '<input type="hidden" name="clubNo" value="${club.clubNo}">';
                    html += '<button type="submit" class="btn btn-tool" onclick="return deleteClubPlanAttendee();">';
                    html += '<i class="fas fa-times" style="color: black;"></i></button>';
                    html += '</form>';
                    html += '</div></div></div>'; 
                  	
                    clubPlanNo = a.clubPlanNo;
                    //console.log(a.memberId);
				});
				
				console.log(clubPlanNo);
				console.log("#attendeeList"+clubPlanNo);
				
				$("#attendeeList"+clubPlanNo).html(html);
				
				//console.log($("#attendeeList"));
			}, 
			error: (x, s, e)=> {
				console.log("ajax처리 실패!!", x, s, e);
			}
		});
	});
}); */

function deleteClubPlanAttendee() {
		console.log($(this));
	if(!confirm("참여를 취소하시겠습니까?")) return false;
	else {
		$("[name=deleteClubPlanAttendeeFrm]").submit();
	}
}

function confirmDelete() {
	if(!confirm("정말로 삭제하시겠습니까?")) return false;
	return true;
}

function loginAlert() {
	alert("로그인 후 이용하실 수 있습니다.");
}

function fileDownload(oName, rName, clubNo) {
	oName = encodeURIComponent(oName);
	
	location.href = "${pageContext.request.contextPath}/club/clubFileDownload.do?clubNo="+clubNo+"&oName="+oName+"&rName="+rName;
}
</script>

<!-- Navbar ClubView -->
<nav id="navbar-club"
	class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
	<!-- Left navbar links -->
	<!-- SEARCH FORM -->
	<form id="noticeSearchFrm" class="form-inline" action="${pageContext.request.contextPath }/club/searchClubContent.do" method="POST">
		<div class="input-group input-group-sm">
			<input class="form-control form-control-navbar" type="search" placeholder="${club.clubName } 검색" aria-label="Search" name="keyword">
			<input type="hidden" name="clubNo" value="${club.clubNo }" />
			<div class="input-group-append">
				<button class="btn btn-navbar" type="submit">
					<i class="fas fa-search"></i>
				</button>
			</div>
		</div>
	</form>

	<!-- Middle navbar links -->
	<ul id="navbar-tab" class="navbar-nav ml-auto">
		<li id="tab-club" class="nav-item"><button type="button">동호회</button></li>
		<li id="tab-calendar" class="nav-item"><button type="button" onclick="location.href='${pageContext.request.contextPath}/club/clubCalendar.do?clubNo='+'${club.clubNo}'">일정</button></li>
		<c:if test="${memberLoggedIn.memberId == 'admin' or isManager}">
			<li id="tab-member" class="nav-item">
			<button type="button" onclick="memberList('${club.clubNo}');">동호회멤버</button></li>
		</c:if>
		<li id="tab-attachment" class="nav-item"><button type="button" onclick="clubFileList('${club.clubNo}');">파일</button></li>
	</ul>

	<!-- Right navbar links -->
	<ul id="viewRightNavbar-wrapper" class="navbar-nav ml-auto">
		<!-- 동호회 대화 -->
		<li class="nav-item">
			<button type="button" class="btn btn-block btn-default btn-xs nav-link" data-widget="control-sidebar" data-slide="true">
				<i class="far fa-comments"></i> 동호회 대화
			</button>
		</li>

		<!-- 동호회 멤버 -->
		<li id="nav-member" class="nav-item dropdown">
		<a class="nav-link" data-toggle="dropdown" href="#"> 
			<i class="far fa-user"></i> 6
		</a>
			<div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
			  <c:if test="${not empty clubMemberList }">
			  <c:forEach items="${clubMemberList }" var="clubMember">
				<a href="${pageContext.request.contextPath }/member/memberView.do?memberId=${clubMember.empId }" class="dropdown-item"> <!-- Message Start -->
				  <div class="media">
				  	<img src="${pageContext.request.contextPath}/resources/img/profile/${clubMember.clubMemberList[0].renamedFileName }"
				  		 alt="User Avatar" class="img-circle img-profile ico-profile" />
				  	<div class="media-body">
				  		<p class="memberName">${clubMember.clubMemberList[0].memberName }</p>
				  	</div>
				  </div> <!-- Message End -->
				</a> 
			  </c:forEach>
			  </c:if>
			</div>
		</li>

		<!-- 동호회 설정 -->
		<li class="nav-item">
			<button type="button" class="btn btn-block btn-default btn-xs nav-link">
				<i class="fas fa-cog"></i>
			</button>
		</li>
	</ul>
</nav>
<!-- /.navbar -->

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
	<h2 class="sr-only">동호회 상세보기</h2>
	<!-- Main content -->
	<div class="content">
		<div class="container-fluid">
			<!-- 동호회 사진 -->
			<section class="project-recent">
				<div class="card-header" role="button" onclick="toggleList(this);">
					<h3>
						<i class="fas fa-chevron-down"></i> <i class="fas fa-images"></i> 활동사진
					</h3>
				</div>
				<c:if test="${not empty clubPhotoList }">
				  <div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
				    <div class="carousel-inner">
				    <c:forEach var="i" begin="1" end="${Math.ceil(clubPhotoCount/4) }" step="1">
				    <c:if test="${i == 1 }">
				      <div class="carousel-item active">
				        <div class="row card-content">
				        <c:if test="${clubPhotoCount<4 }">
				        <c:forEach items="${clubPhotoList }" var="clubPhoto" varStatus="vs">
				        <c:if test="${vs.index<4 }">
				  	  	  <div class="col-12 col-sm-6 col-md-3">
					  	    <div class="card">
					  		  <img src="${pageContext.request.contextPath}/resources/upload/club/${club.clubNo }/${clubPhoto.clubPhotoRenamed }"
					  			   alt="..." class="img-thumbnail" data-toggle="modal"
					  			   data-target="#clubPhoto${vs.index }">
					  		</div>
					  	  </div>
				        </c:if>
				        </c:forEach>
				          <div class="col-12 col-sm-6 col-md-3">
				              <div class="card new" id="new-club-card" data-toggle="modal" data-target="#insertPhoto">
				                <div class="card-body">
				  	              <i class="fas fa-plus"></i>
				  	              <h6>새 사진</h6>
				                </div>
				              </div>
				            </div>
				        </c:if>
				        <c:forEach items="${clubPhotoList }" var="clubPhoto" varStatus="vs">
				        <c:if test="${clubPhotoCount>=4 }">
				        <c:if test="${vs.index<4 }">
				  	  	  <div class="col-12 col-sm-6 col-md-3">
					  	    <div class="card">
					  		  <img src="${pageContext.request.contextPath}/resources/upload/club/${club.clubNo }/${clubPhoto.clubPhotoRenamed }"
					  			   alt="..." class="img-thumbnail" data-toggle="modal"
					  			   data-target="#clubPhoto${vs.index }">
					  		</div>
					  	  </div>
				        </c:if>
				        </c:if>
				        </c:forEach>
				        </div>
				      </div>
				    </c:if>
				    <c:if test="${i != 1 }">
				      <div class="carousel-item">
				        <div class="row card-content">
				        <c:if test="${i != Math.ceil(clubPhotoCount/4) }">
					    <c:forEach items="${clubPhotoList }" var="clubPhoto" varStatus="vs">
				  		<c:if test="${vs.index>=(i-1)*4 and vs.index<i*4 }">
				  	  	  <div class="col-12 col-sm-6 col-md-3">
					  	    <div class="card">
					  		  <img src="${pageContext.request.contextPath}/resources/upload/club/${club.clubNo }/${clubPhoto.clubPhotoRenamed }"
					  			   alt="..." class="img-thumbnail" data-toggle="modal"
					  			   data-target="#clubPhoto${vs.index }">
					  		</div>
					  	  </div>
				  		</c:if>
					    </c:forEach>
				        </c:if>
				        <c:if test="${i == Math.ceil(clubPhotoCount/4) }"> <!-- 마지막 슬라이드라면 조건 -->
					    <c:forEach items="${clubPhotoList }" var="clubPhoto" varStatus="vs">
				  		<c:if test="${vs.index>=(i-1)*4 and vs.index<clubPhotoCount }"> <!-- 4개씩 반복 조건 -->
				  	  	  <div class="col-12 col-sm-6 col-md-3">
					  	    <div class="card">
					  		  <img src="${pageContext.request.contextPath}/resources/upload/club/${club.clubNo }/${clubPhoto.clubPhotoRenamed }"
					  			   alt="..." class="img-thumbnail" data-toggle="modal"
					  			   data-target="#clubPhoto${vs.index }">
					  		</div>
					  	  </div>
				  		</c:if> <!-- 4개씩 반복 조건 끝 -->
					    </c:forEach>
				  		<c:if test="${clubPhotoCount%4 != 0 }"> <!-- 플러스버튼 조건 -->
				  		  <div class="col-12 col-sm-6 col-md-3">
							<div class="card new" id="new-club-card" data-toggle="modal" data-target="#insertPhoto">
							  <div class="card-body">
								<i class="fas fa-plus"></i>
								<h6>새 사진</h6>
							  </div>
							</div>
						  </div>
				  		</c:if> <!-- 플러스버튼 조건 끝 -->
				        </c:if> <!-- 마지막 슬라이드라면 조건 끝 -->
	              	    </div>
				      </div>
				    </c:if>
				    </c:forEach>
				    <c:if test="${clubPhotoCount%4 == 0 }"> <!-- 플러스버튼 조건 -->
				      <div class="carousel-item">
				        <div class="row card-content">
				          <div class="col-12 col-sm-6 col-md-3">
				  		     <div class="card new" id="new-club-card" data-toggle="modal" data-target="#insertPhoto">
				  		       <div class="card-body">
				  			     <i class="fas fa-plus"></i>
				  			     <h6>새 사진</h6>
				  		       </div>
				  		     </div>
				  	       </div>
				  	     </div>
				  	   </div>
				    </c:if> <!-- 플러스버튼 조건 끝 -->
				    </div>
				    <!-- 화살표 -->
				    <a class="carousel-control-prev" href="#carouselExampleControls" role="button" data-slide="prev">
				      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
				      <span class="sr-only">Previous</span>
				    </a>
				    <a class="carousel-control-next" href="#carouselExampleControls" role="button" data-slide="next">
				      <span class="carousel-control-next-icon" aria-hidden="true"></span>
				      <span class="sr-only">Next</span>
				    </a>
				  </div>
				</c:if>
				<c:if test="${empty clubPhotoList }">
				  <div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
				    <div class="carousel-inner">
				      <div class="carousel-item active">
				        <div class="row card-content">
				          <div class="col-12 col-sm-6 col-md-3">
				            <div class="card new" id="new-club-card" data-toggle="modal" data-target="#insertPhoto">
				              <div class="card-body">
					            <i class="fas fa-plus"></i>
					            <h6>새 사진</h6>
				              </div>
				            </div>
				          </div>
				        </div>
				      </div>
				    </div>
				  </div>
				</c:if>
				  
				  <c:forEach items="${clubPhotoList }" var="clubPhoto" varStatus="vs">
				  <!-- clubPhotoModal -->
				  <div class="modal fade cd-example-modal-lg" id="clubPhoto${vs.index }"
					   tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
					<div class="modal-dialog modal-dialog-centered modal-lg" role="document">
					  <div class="modal-content card card-outline card-info">
						<div class="modal-header">
						  <h5 class="modal-title" id="exampleModalLongTitle">${clubPhoto.clubPhotoTitle }</h5>
						  <button type="button" class="close" data-dismiss="modal"
								  aria-label="Close">
						    <span aria-hidden="true">&times;</span>
						  </button>
						</div>
						<div class="modal-body">
							<div class="form-group">
							  <span class="text-muted float-right">${clubPhoto.memberName }/${clubPhoto.memberId }</span>
							  <br />
							  <span class="text-muted float-right">${clubPhoto.clubPhotoDate }</span>
							</div>
							<div class="form-group">
							  <img src="${pageContext.request.contextPath}/resources/upload/club/${club.clubNo }/${clubPhoto.clubPhotoRenamed }"
								   alt="..." class="img-thumbnail" data-toggle="modal"
								   data-target="#clubPhoto${vs.index }">
							</div>
						</div>
						<div class="modal-footer">
						<c:if test="${not empty memberLoggedIn and (memberLoggedIn.memberId == clubPhoto.memberId or isManager)}">
						  <form name="deleteClubPhotoFrm" action="${pageContext.request.contextPath }/club/deleteClubPhoto.do" method="POST">
							<input type="hidden" name="clubNo" value="${club.clubNo }" />
							<input type="hidden" name="clubPhotoNo" value=${clubPhoto.clubPhotoNo } />
							<input type="hidden" name="clubPhotoRenamed" value=${clubPhoto.clubPhotoRenamed } />
							<button type="submit" class="btn btn-danger" onclick="return confirmDelete();">삭제</button>
						  </form>
						</c:if>
						  <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
						</div>
					  </div>
					</div>
				</div>
				</c:forEach>
			</section>
			<!-- /.card-content -->

			<!-- 동호회 소개 -->
			<section id="info-wrapper" class="project-important">
				<div class="card-header" role="button" onclick="toggleList(this);">
					<h3>
						<i class="fas fa-chevron-down"></i> <i class="fas fa-poll-h"></i>
						동호회 소개
					</h3>
				</div>
				<!-- /.card-header -->
				<div class="col-md-12" data-toggle="modal" data-target="#info">
					<div class="card">
						<div class="card-header"
							style="border-bottom: 1px solid rgba(0, 0, 0, .125);">
							<h5 class="card-title" style="padding-left: 25px;">${club.clubName }</h5>
						</div>
						<!-- /.card-header -->
						<div class="card-body">
							<p class="text-center">${club.clubIntroduce }</p>
						</div>
						<!-- ./card-body -->
					</div>
					<!-- /.card -->
				</div>
				<!-- /.col -->
			</section>
			<!-- /.card-content -->

			<!-- 동호회 일정 -->
			<section id="project-in">
				<div class="card-header" role="button" onclick="toggleList(this);">
					<h3>
						<i class="fas fa-chevron-down"></i> <i class="fas fa-calendar-alt"></i>
						이번달 일정 <span class="header-count">(${clubPlanCount })</span>
					</h3>
				</div>
				<!-- /.card-header -->
				<div class="row card-content">
					<!-- 일정 -->
					<c:if test="${not empty clubPlanList }">
						<c:forEach items="${clubPlanList }" var="clubPlan" varStatus="vs">
						  <input type="hidden" name="clubPlanNo" value="${clubPlan.clubPlanNo }" id="clubPlanNo" />
							<div class="col-12 col-sm-6 col-md-3">
								<div class="card mywork clubPlanCard" data-toggle="modal" id="clubPlanCard${clubPlan.clubPlanNo }"
									data-target="#clubPlanView${vs.index }">
									<div class="card-body">
										<!-- 타이틀 -->
										<div class="card-title text-center">
											<h5>${clubPlan.clubPlanTitle }</h5>
										</div>
										<!-- 날짜정보 -->
										<div class="card-status">
											<span class="btn btn-block btn-sm bg-${clubPlan.clubPlanColor }">${clubPlan.clubPlanState }</span>
											<span class="end-date"><i class="far fa-calendar-alt"></i>
												${clubPlan.clubPlanStart }</span>
										</div>
									</div>
								</div>
								<!-- /.card -->
							</div>

							<!-- clubPlanView Modal -->
							<div class="modal fade cd-example-modal-lg"
								id="clubPlanView${vs.index }" tabindex="-1" role="dialog"
								aria-labelledby="exampleModalCenterTitle" aria-hidden="true"
								data-backdrop="static">
								<div class="modal-dialog modal-dialog-centered modal-lg"
									role="document">
									<div class="modal-content card card-outline card-info"
										 style="max-heigth: 100%; height: auto;">
										<div class="modal-header">
											<h5 class="modal-title" id="exampleModalLongTitle">일정확인하기</h5>
											<button type="button" class="close" data-dismiss="modal"
												aria-label="Close">
												<span aria-hidden="true">&times;</span>
											</button>
										</div>
										<div class="modal-body">
											<div class="form-group">
												<label for="inputName">일정</label>
												<p style="margin-left: 10px;">${clubPlan.clubPlanTitle }</p>
											</div>
											<div class="form-group">
												<div class="mb-3">
													<label for="inputDescription">일정 내용</label>
													<div style="margin-left: 10px;">
														${clubPlan.clubPlanContent }</div>
												</div>
											</div>
											<div class="form-group">
												<label for="inputStatus">날짜</label>
												<div style="margin-left: 10px;">
													${clubPlan.clubPlanStart }</div>
											</div>
											<div class="form-group">
												<label for="inputStatus">상태</label> 
												<span class="btn btn-block btn-sm bg-${clubPlan.clubPlanColor }"
													style="margin-left: 10px; width: 70px;">
													${clubPlan.clubPlanState }
												</span>
											</div>
											<div class="form-group">
												<label for="inputClientCompany">장소</label>
												<p style="margin-left: 10px;">${clubPlan.clubPlanPlace }</p>
											</div>
											<div class="form-group">
												<label for="inputProjectLeader">담당진행자</label>
												<p style="margin-left: 10px;">${clubPlan.clubPlanManager }</p>
											</div>
											<div class="form-group">
												<label for="inputProjectLeader">참석자</label>
												  <div class="attendeeList" id="attendeeList${clubPlan.clubPlanNo }">
												  </div>
												  <c:if test="${not empty clubPlanAttendeeList }">
												  <c:forEach items="${clubPlanAttendeeList }" var="clubPlanAttendee">
												  <c:if test="${clubPlanAttendee.clubPlanNo == clubPlan.clubPlanNo }">
												  <div class="card card-success" style="width: 8rem; height: 3rem; padding-top: .2rem; margin-top: 1rem; display: inline-block;">
							                        <div class="col-12"> 
							                            <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/profile/${clubPlanAttendee.renamedFileName}" alt="Message User Image">
							                            <h6 class="h6">${clubPlanAttendee.memberName }</h6>
							                            <div class="card-tools" style="position: relative; bottom: 1.4rem; left: 3.5rem; display: inline-block;">
							                              <form name="deleteClubPlanAttendeeFrm" action="${pageContext.request.contextPath}/club/deleteClubPlanAttendee.do" method="POST">
														    <input type="hidden" name="memberId" value="${clubPlanAttendee.memberId }">
                    									    <input type="hidden" name="clubPlanAttendeeNo" value="${clubPlanAttendee.clubPlanAttendeeNo }">
                    									    <input type="hidden" name="clubNo" value="${club.clubNo}">
                    									    <input type="hidden" name="where" value="1">
							                                <button type="submit" class="btn btn-tool"><i class="fas fa-times" style="color: black;"></i></button>
							                              </form>
							                            </div>
							                        </div> 
							                      </div>
												  </c:if>
												  </c:forEach>
												  </c:if>
													<!-- 프로필 사진 -->
													<%-- <img src="${pageContext.request.contextPath}/resources/img/profile/default.jpg"
														 alt="User Avatar" class="img-circle elevation-2"
														 style="width: 50px; margin: 5px" /> --%>
											</div>
										</div>
										<div class="modal-footer">
										  <form name="insertClubPlanAttendanceFrm" action="${pageContext.request.contextPath }/club/insertClubPlanAttendee.do" method="POST">
										    <input type="hidden" name="clubPlanNo" value="${clubPlan.clubPlanNo }" />
										    <input type="hidden" name="memberId" value="${memberLoggedIn.memberId }" />
										    <input type="hidden" name="clubNo" value="${club.clubNo }" />
										    <input type="hidden" name="where" value="1" />
											<button type="submit" class="btn btn-info float-right">
												<i class="fas fa-plus"></i>
											</button>
										  </form>
										  <c:if test="${not empty memberLoggedIn and (clubPlan.memberId == memberLoggedIn.memberId or isManager)}">
											<button type="button" class="btn btn-info" data-target="#plan-modify${vs.index }" data-dismiss="modal" data-toggle="modal">수정</button>
											<form name="deleteClubPlanFrm" action="${pageContext.request.contextPath }/club/deleteClubPlan.do" method="POST">
											  <input type="hidden" name="clubPlanNo" value="${clubPlan.clubPlanNo }" />
											  <input type="hidden" name="clubNo" value="${club.clubNo }" />
											  <input type="hidden" name="where" value="1" />
											  <button type="submit" class="btn btn-danger" onclick="return confirmDelete();">삭제</button>
											</form>
										  </c:if>
											<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
										</div>
									</div>
								</div>
							</div>
							<!-- clubPlanView Modal end -->

							<!-- plan-modify Modal -->
							<div class="modal fade cd-example-modal-lg" id="plan-modify${vs.index }"
								tabindex="-1" role="dialog"
								aria-labelledby="exampleModalCenterTitle" aria-hidden="true"
								data-backdrop="static" style="overflow-y: auto;">
								<div class="modal-dialog modal-dialog-centered modal-lg"
									role="document">
									<div class="modal-content card card-outline card-info" style="max-heigth: 100%; height: auto;">
										<div class="modal-header">
											<h5 class="modal-title" id="exampleModalLongTitle">일정수정하기</h5>
											<button type="button" class="close" data-dismiss="modal"
												aria-label="Close">
												<span aria-hidden="true">&times;</span>
											</button>
										</div>
										<form name="clubPlanUpdateFrm" action="${pageContext.request.contextPath }/club/clubPlanUpdate.do" method="post">
											<input type="hidden" name="clubPlanNo" value="${clubPlan.clubPlanNo }" />
											<input type="hidden" name="clubNo" value="${clubPlan.clubNo }" />
											<input type="hidden" name="where" value="1" />
											<div class="modal-body">
												<div class="form-group">
													<label for="inputName">일정</label> 
													<input type="text"
														id="inputName" class="form-control" name="clubPlanTitle" 
														placeholder="일정을 입력하세요." value="${clubPlan.clubPlanTitle }" />
												</div>
												<div class="form-group">
													<div class="mb-3">
														<label for="inputDescription">일정 내용</label>
														<textarea id="inputDescription" class="textarea" name="clubPlanContent" 
															style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;">${clubPlan.clubPlanContent }</textarea>
													</div>
												</div>
												<!-- Date picker -->
												<div class="form-group">
													<label for="">날짜</label>
													<div class="input-group">
														<div class="input-group-prepend">
															<span class="input-group-text"><i
																class="far fa-calendar-alt"></i></span> <!-- 캘린더이미지 -->
														</div>
														<input type="text" class="form-control float-right" name="clubPlanDate"
															id="clubPlanUpdateDate${vs.index }" />
													</div>
													<!-- /.input group -->
												</div>
												<script>
												$(()=> {
													$("#clubPlanUpdateDate${vs.index }").daterangepicker({
														singleDatePicker: true,
													    showDropdowns: true, 
													    startOfWeek: 'monday', 
													    setDate: '${clubPlan.clubPlanStart}', 
													    locale: {
														    format: 'YYYY-MM-DD' 
													    }
													  });
													/* $("#clubPlanUpdateDate${vs.index }").daterangepicker('setDate', ${clubPlan.clubPlanStart}); */
												});
												</script>
												<div class="form-group">
													<label for="inputStatus">상태</label> 
													<select name="clubPlanState" class="form-control custom-select">
														<option selected disabled>선택하세요.</option>
														<option ${clubPlan.clubPlanState=='예정'?'selected':'' }>예정</option>
														<option ${clubPlan.clubPlanState=='완료'?'selected':'' }>완료</option>
														<option ${clubPlan.clubPlanState=='취소'?'selected':'' }>취소</option>
													</select>
												</div>
												<div class="form-group">
													<label for="inputClientCompany">장소</label> 
													<input type="text" id="inputClientCompany" class="form-control" name="clubPlanPlace"
														placeholder="장소를 입력하세요." value="${clubPlan.clubPlanPlace }" />
												</div>
												<div class="form-group">
													<label for="inputProjectLeader">담당진행자</label> <input
														type="text" id="inputProjectLeader" class="form-control" name="clubPlanManager"
														placeholder="담당진행자를 입력하세요." value="${clubPlan.clubPlanManager }">
												</div>
											</div>
											<div class="modal-footer">
												<button type="submit" class="btn btn-info">수정</button>
												<button type="button" class="btn btn-secondary"
													data-dismiss="modal">닫기</button>
											</div>
										</form>
									</div>
								</div>
							</div>
						</c:forEach>
					</c:if>

					<!-- 일정 추가 -->
					<div class="col-12 col-sm-6 col-md-3">
						<div class="card new" id="new-club-card" data-toggle="modal"
							data-target="#insertPlan">
							<div class="card-body">
								<i class="fas fa-plus"></i>
								<h6>새 일정</h6>
							</div>
						</div>
						<!-- /.card -->
					</div>
				</div> <!-- .row card-content -->
			</section>
			<!-- /.card-content -->



			<!-- clubNotice -->
			<section id="project-in">
				<div class="card-header" role="button" onclick="toggleList(this);">
					<h3>
						<i class="fas fa-chevron-down"></i> <i
							class="fas fa-exclamation-circle"></i> 공지사항 <span
							class="header-count">(${clubNoticeCount })</span>
					</h3>
				</div>
				<!-- /.card-header -->
					<div class="row card-content">
					<c:if test="${not empty clubNoticeList }">
					<c:forEach items="${clubNoticeList }" var="clubNotice" varStatus="vs">
						<!-- 공지사항 -->
						<div class="col-12 col-sm-6 col-md-3">
							<div class="card mywork">
								<div class="card-body" data-toggle="modal" data-target="#notice${vs.index }">
									<!-- 제목 -->
									<div class="card-title" style="margin-bottom: 50px;">
										<h5>${clubNotice.clubNoticeTitle }</h5>
									</div>
									<!-- 프로필 사진 -->
									<img src="${pageContext.request.contextPath}/resources/img/profile/${clubNotice.renamedFileName }"
										 alt="User Avatar" class="img-circle img-profile">
									<!-- 타이틀 -->
									<div class="card-title text-center">
										<h5>${clubNotice.memberName }/${clubNotice.memberId }</h5>
									</div>
								</div>
							</div>
							<!-- /.card -->
						</div>
		
					<!-- notice Modal -->
					<div class="modal fade cd-example-modal-lg" id="notice${vs.index }" tabindex="-1"
						role="dialog" aria-labelledby="exampleModalCenterTitle"
						aria-hidden="true">
						<div class="modal-dialog modal-dialog-centered modal-lg"
							role="document">
							<div class="modal-content card card-outline card-info" style="max-heigth: 100%; height: auto;">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal"
										aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
								<div class="modal-body">
									<div class="form-group">
										<h5 class="modal-title" id="exampleModalLongTitle">
											${clubNotice.clubNoticeTitle }
										</h5>
										<span class="text-muted float-right">${clubNotice.clubNoticeDate }</span>
									</div>
									<div class="form-group">
										<br />
									</div>
									<c:if test="${clubNotice.clubNoticeRenamed ne null }">
									  <div class="form-group" onclick="fileDownload('${clubNotice.clubNoticeOriginal}', '${clubNotice.clubNoticeRenamed }', '${club.clubNo }');">
									  	<i class="far fa-file"></i>
									    ${clubNotice.clubNoticeOriginal }
									  </div>
									</c:if>
									<div class="form-group">
										${clubNotice.clubNoticeContent }
									</div>
									<div class="form-group">
										<br />
									</div>
									<!-- NoticeModalComment -->
									<div class="comment-count"><i class="fas fa-comments"></i>&nbsp; 댓글</div>
						            <div class="card-footer card-comments">
									
									<c:if test="${not empty clubNoticeCommentList }">
									<c:forEach items="${clubNoticeCommentList }" var="clubNoticeComment">
									<c:if test="${clubNoticeComment.clubNoticeNo == clubNotice.clubNoticeNo }">
									<c:if test="${clubNoticeComment.clubNoticeCommentLevel == 1 }">
						                <div class="card-comment">
						                  <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${clubNoticeComment.renamedFileName }" alt="User Image">
						                  <div class="comment-text">
						                    <span class="username">${clubNoticeComment.memberName }<span class="text-muted float-right">${clubNoticeComment.clubNoticeCommentDate }</span></span>
						                    <span>${clubNoticeComment.clubNoticeCommentContent }</span>
						                    <c:if test="${not empty memberLoggedIn and (clubNoticeComment.memberId==memberLoggedIn.memberId or isManager) }">
						                      <form name="deleteClubNoticeCommentFrm" action="${pageContext.request.contextPath }/club/deleteClubNoticeComment.do" method="POST">
						                        <input type="hidden" name="clubNoticeCommentNo" value="${clubNoticeComment.clubNoticeCommentNo }" />
						                        <input type="hidden" name="clubNo" value="${club.clubNo }" />
						                        <button type="submit" class="comment-delete float-right" onclick="return confirmDelete();">삭제</button>
						                      </form>
						                    </c:if>
						                  </div>
						                </div>
									</c:if>
									</c:if>
									</c:forEach>
									</c:if>
						            </div>
						            <!-- 댓글 작성 -->
						            <div class="card-footer">
						            <form name="insertClubNoticeCommentFrm" action="${pageContext.request.contextPath }/club/insertClubNoticeComment.do" method="post">
						                <c:if test="${not empty memberLoggedIn }">
						                  <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${memberLoggedIn.renamedFileName}">
						                </c:if>
						                <c:if test="${empty memberLoggedIn }">
						                  <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/default.jpg">
						                </c:if>
						                <div class="img-push">
						                  <input type="hidden" name="clubNo" value="${clubNotice.clubNo }" />
						                  <input type="hidden" name="clubNoticeNo" value="${clubNotice.clubNoticeNo }" />
						                  <input type="hidden" name="clubNoticeCommentLevel" value="1" />
						                  <input type="hidden" name="clubMemberNo" value="${clubNotice.clubMemberNo }" />
						                  <input type="text" class="form-control form-control-sm comment-text-area" name="clubNoticeCommentContent" placeholder="댓글을 입력하세요.">
						                  <input type="submit" class="comment-submit" value="등록">
						                </div>
						            </form>
						            </div> 
								</div>
								<div class="modal-footer">
									<c:if test="${not empty memberLoggedIn and (memberLoggedIn.memberId == clubNotice.memberId or isManager) }">
									<form name="deleteClubNoticeFrm" action="${pageContext.request.contextPath}/club/deleteClubNotice.do" method="POST">
										<input type="hidden" name="clubNo" value="${club.clubNo }" />
										<input type="hidden" name="clubNoticeNo" value="${clubNotice.clubNoticeNo }" />
										<input type="hidden" name="clubNoticeRenamed" value="${clubNotice.clubNoticeRenamed }" />
										<button type="submit" class="btn btn-danger" onclick="return confirmDelete();" >삭제</button>
									</form>
									<button type="button" class="btn btn-info"
										data-dismiss="modal" data-toggle="modal"
										data-target="#notice-modify${vs.index }">수정</button>
									</c:if>
									<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
								</div>
							</div>
						</div>
					</div>
					
					<!-- #notice-modify modal -->
					<div class="modal fade cd-example-modal-lg" id="notice-modify${vs.index }"
						tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel"
						aria-hidden="true" data-backdrop="static">
						<div class="modal-dialog modal-dialog-centered modal-lg">
							<div class="modal-content card card-outline card-info" style="max-heigth: 100%; height: auto;"">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
								<form name="clubNoticeUpdateFrm" action="${pageContext.request.contextPath }/club/clubNoticeUpdate.do" enctype="multipart/form-data" method="POST">
									<input type="hidden" name="clubNoticeNo" value="${clubNotice.clubNoticeNo }" />
									<input type="hidden" name="clubNo" value="${clubNotice.clubNo }" />
									<div class="modal-body">
										<div class="form-group">
											<label for="inputClientCompany">제목</label> 
											<input type="text" id="inputClientCompany" class="form-control" name="clubNoticeTitle"
												   placeholder="제목을 입력하세요." value="${clubNotice.clubNoticeTitle }" />
										</div>
										  <div class="form-group">
										  	<label for="exampleInputFile">파일</label>
										  	<div class="input-group">
								                <!-- <input type="file" class="form-control-file" id="exampleFormControlFile1" name="updateFile"> -->
										  		<div class="custom-file">
										  			<input type="file" class="custom-file-input" name=upFile id="exampleInputFile"> 
										  			<label class="custom-file-label" for="exampleInputFile">파일을 선택하세요.</label>
										  		</div>
										  	</div>
										  	<div class="input-group">
								                <span class="fname">기존 첨부파일 : ${clubNotice.clubNoticeOriginal!=null?clubNotice.clubNoticeOriginal:""}</span>
								                <input type="hidden" name="clubNoticeOriginal" value="${clubNotice.clubNoticeOriginal!=null?clubNotice.clubNoticeOriginal:""} "/>
								                <input type="hidden" name="clubNoticeRenamed" value="${clubNotice.clubNoticeRenamed!=null?clubNotice.clubNoticeRenamed:""} "/>
											</div>
											<div class="input-group">
												<c:if test="${clubNotice.clubNoticeRenamed ne null }">
								               		<span class="deleteFileSpan">
									               		<input type="checkbox" name="delFileChk" id="delFileChk" />
									               		<label for="delFileChk">첨부파일삭제</label>	               		
								               		</span>
												</c:if>
										  	</div>
										  </div>
										<div class="form-group">
											<label for="inputClientCompany">공지내용</label> 
											<div class="card-body pad">
												<div class="mb-3">
													<textarea class="textarea" name="clubNoticeContent"
															  style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;">${clubNotice.clubNoticeContent }</textarea>
												</div>
											</div>
										</div>
									</div>
									<div class="modal-footer">
										<button type="submit" class="btn btn-info">수정</button>
										<button type="button" class="btn btn-secondary"
											data-dismiss="modal">닫기</button>
									</div>
								</form>
							</div>
						</div>
					</div>
				</c:forEach>
				</c:if>
				
				<!-- 공지 추가 -->
				<div class="col-12 col-sm-6 col-md-3">
					<div class="card new" id="new-club-card" data-toggle="modal"
						data-target="#insertNotice">
						<div class="card-body">
							<i class="fas fa-plus"></i>
							<h6>새 공지</h6>
						</div>
					</div>
					<!-- /.card -->
				</div>
				</div>
			</section>
			<!-- /.card-content -->
		</div>
		<!-- /.container-fluid -->
	</div>
	<!-- /.content -->
</div>
<!-- /.content-wrapper -->

<aside class="control-sidebar project-setting" style="display: block;">
    <!-- Control sidebar content goes here -->
    <div class="p-3">
      <div class="card-header">
                            <div class="post">
                                <div class="user-block">
                                    <img class="img-circle" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="user image">
                                    <span class="username">
                                        <h3>동호회이름</h3>
                                    </span>
                                </div>
                            </div>
                        </div><!-- /.card-header -->
                        <div class="card-body">        
                            <!-- Conversations are loaded here -->
                            <div class="direct-chat-messages" style="height:25rem">
                            <!-- Message. Default to the left -->
                                <div class="direct-chat-msg">
                                    <div class="direct-chat-infos clearfix">
                                        <span class="direct-chat-name float-left">다른동호회멤버&nbsp;&nbsp;</span>
                                        <span class="direct-chat-timestamp float-left">2:00 pm</span>
                                    </div>
                                    <!-- /.direct-chat-infos -->
                                    <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                                    <!-- /.direct-chat-img -->
                                    <div class="direct-chat-text">
                                        Is this template really for free? That's unbelievable!
                                    </div>
                                    <!-- /.direct-chat-text -->
                                </div>
                                <!-- /.direct-chat-msg -->
                        
                                <!-- Message to the right -->
                                <div class="direct-chat-msg right">
                                    <div class="direct-chat-infos clearfix">
                                        <span class="direct-chat-name float-right">나</span>
                                        <span class="direct-chat-timestamp float-right">2:05 pm &nbsp;&nbsp;</span>
                                    </div>
                                    <!-- /.direct-chat-infos -->
                                    <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user2-160x160.jpg" alt="Message User Image">
                                    <!-- /.direct-chat-img -->
                                    <div class="direct-chat-text">
                                        You better believe it!
                                    </div>
                                    <!-- /.direct-chat-text -->
                                </div> 

                                <div class="direct-chat-msg">
                                    <div class="direct-chat-infos clearfix">
                                        <span class="direct-chat-name float-left">이주현&nbsp;&nbsp;</span>
                                        <span class="direct-chat-timestamp float-left">2:00 pm</span>
                                    </div>
                                    <!-- /.direct-chat-infos -->
                                    <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                                    <!-- /.direct-chat-img -->
                                    <div class="direct-chat-text">
                                        Is this template really for free? That's unbelievable!
                                    </div>
                                    <!-- /.direct-chat-text -->
                                </div>

                                <div class="direct-chat-msg right">
                                    <div class="direct-chat-infos clearfix">
                                        <span class="direct-chat-name float-right">김효정</span>
                                        <span class="direct-chat-timestamp float-right">2:05 pm &nbsp;&nbsp;</span>
                                    </div>
                                    <!-- /.direct-chat-infos -->
                                    <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user2-160x160.jpg" alt="Message User Image">
                                    <!-- /.direct-chat-img -->
                                    <div class="direct-chat-text">
                                        You better believe it!
                                    </div>
                                    <!-- /.direct-chat-text -->
                                </div> 

                                <div class="direct-chat-msg">
                                    <div class="direct-chat-infos clearfix">
                                        <span class="direct-chat-name float-left">이주현&nbsp;&nbsp;</span>
                                        <span class="direct-chat-timestamp float-left">2:00 pm</span>
                                    </div>
                                    <!-- /.direct-chat-infos -->
                                    <img class="direct-chat-img" src="${pageContext.request.contextPath}/resources/img/user1-128x128.jpg" alt="Message User Image">
                                    <!-- /.direct-chat-img -->
                                    <div class="direct-chat-text">
                                        Is this template really for free? That's unbelievable!
                                    </div>
                                    <!-- /.direct-chat-text -->
                                </div>
                                <!-- /.direct-chat-msg -->
                            </div><!-- /.direct-chat-messages -->
                        </div>
                        <!-- /.card-body -->
                        <div class="card-body pad">
                            <div class="mb-3">
                                <textarea class="textarea" placeholder="Place some text here"
                                        style="width: 100%; height: 200px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"></textarea>
                            </div>
                        </div>
    </div>
  </aside>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>