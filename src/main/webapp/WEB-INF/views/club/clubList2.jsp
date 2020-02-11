<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<script>



$(function(){
	
	
	$("#new-club-card").click(function(){
	  $("#modal-new-club").modal();
	});
	
	$("#nav-new-club").click(function(){
	  $("#modal-new-club").modal();
	});
	

	// Summernote
	$('.textarea').summernote()
	
		  
	sidebarActive(); //사이드바 활성화
});



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
</script>

<style>
/*card*/
.card-club-image img {
	margin-top: 0.5rem;
	width: 100%;
	height: 200px;
}

.card-enroll-date {
	margin-top: 0.5rem;
	float: right;
}

.card-stand {
	margin-top: 0.5rem;
}

/*modal*/
.modal-club-info {
	color: gray;
}

#modal-image-slider img {
	width: 70%;
	height: 300px;
	margin-bottom: 2rem;
}

#up-btn {
	margin-top: 0.5rem;
	color: #464c59;
}
/*club-form*/
.form-check {
	margin: 0.7rem;
}

#btn-sub {
	margin: 1rem 0 2rem;
	text-align: center;
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

/*meeting-cycle*/
#meeting-cycle {
	width: 20%;
}
</style>

<!-- Navbar Club -->
<nav
	class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
	<!-- Left navbar links -->
	<ul class="navbar-nav">
		<li class="nav-item dropdown"><a class="nav-link dropdown-toggle"
			data-toggle="dropdown" href="#"> 카테고리 <span class="caret"></span>
		</a>
			<div class="dropdown-menu">
				<a class="dropdown-item" tabindex="-1" href="#">사회</a> <a
					class="dropdown-item" tabindex="-1" href="#">취미</a> <a
					class="dropdown-item" tabindex="-1" href="#">음식</a> <a
					class="dropdown-item" tabindex="-1" href="#">운동</a> <a
					class="dropdown-item" tabindex="-1" href="#">문학</a> <a
					class="dropdown-item" tabindex="-1" href="#">기타</a>

			</div></li>
	</ul>

	<!-- Right navbar links -->
	<ul class="navbar-nav ml-auto navbar-nav-sort">
		<li class="nav-item dropdown">정렬 <a
			class="nav-link dropdown-toggle" data-toggle="dropdown" href="#">
				이름순 <span class="caret"></span>
		</a>
			<div class="dropdown-menu">
				<a class="dropdown-item" tabindex="-1" href="#">등록일순</a> <a
					class="dropdown-item" tabindex="-1" href="#">이름순</a>
			</div>
		</li>
		<!-- 새 동호회 만들기 -->
		<li class="nav-item">
			<button id="nav-new-club" class="bg-info" style="font-size: 0.85rem;"
				data-toggle="modal" data-target="#add-project-modal">
				<i class="fa fa-plus"></i> <span>새 동호회</span>
			</button>
		</li>
	</ul>
</nav>
<!-- /.navbar -->

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
	<!-- Main content -->
	<div class="content">
		<div class="container-fluid">

			<!-- 동호회 목록 -->
			<section class="club-all-list">
				<div class="card-header" role="button" onclick="toggleList(this);">
					<h3>
						<i class="fas fa-chevron-down"></i> 동호회 목록 <span
							class="header-count">(${clubCount })</span>
					</h3>
				</div>
				<!-- /.card-header -->

				<div class="row card-content">

					<c:forEach items="${clubList}" var="club">
						<div class="col-12 col-sm-6 col-md-3">
							<div class="card club card-hover">
								<div class="card-body">

									<div class="card-title">${club.clubName }</div>

									<c:set var="mg" value="${club.clubManagerId }"></c:set>
									<c:if test="${!empty memberLoggedIn}">
										<c:if
											test="${memberLoggedIn.memberId eq mg or memberLoggedIn.memberId eq 'admin'}">
											<!-- 삭제 버튼 -->
											<div class="card-tools text-right">

												<button type="button" class="btn btn-tool"
													data-card-widget="remove"
													onclick="location.href = '${pageContext.request.contextPath}/club/deleteClub.do?clubNo=${club.clubNo }'">
													<i class="fas fa-times"></i>
												</button>
											</div>


										</c:if>
									</c:if>

									<div class="card-club-image">
										<c:choose>
											<c:when
												test="${club.clubPhotoList[0].clubPhotoRenamed ne null}">
												<img
													src="${pageContext.request.contextPath}/resources/upload/club/21/${club.clubPhotoList[0].clubPhotoRenamed}"
													alt=""
													<%-- onclick="location.href = '${pageContext.request.contextPath}/club/clubView.do?clubNo=${club.clubNo }'" --%>
													data-toggle="modal"
													data-target="#modal-club-${club.clubNo }">


											</c:when>

											<c:otherwise>
												<img
													src="${pageContext.request.contextPath}/resources/img/club/clubAll.JPG"
													alt=""
													<%-- onclick="location.href = '${pageContext.request.contextPath}/club/clubView.do?clubNo=${club.clubNo }'" --%>
													data-toggle="modal"
													data-target="#modal-club-${club.clubNo }">
											</c:otherwise>
										</c:choose>

									</div>
									<c:if test="${!empty memberLoggedIn}">
										<c:if
											test="${memberLoggedIn.memberId eq mg or memberLoggedIn.memberId eq admin}">
											<!-- 수정 버튼 -->
											<button type="button" id="up-btn" data-toggle="modal"
												data-target="#modal-update-${club.clubNo }">
												<i class="fas fa-edit"></i>
											</button>
										</c:if>
									</c:if>


									<div class="card-enroll-date">
										<span class="enroll-date">${club.clubEnrollDate }</span>
									</div>
								</div>
							</div>
							<!-- /.card -->
						</div>
						<!-- modal Club 부분 -->
						<div class="modal fade" id="modal-club-${club.clubNo }">
							<div class="modal-dialog modal-lg">
								<div class="modal-content">
									<div class="modal-header">
										<h4 class="modal-title">${club.clubName }</h4>

										<button type="button" class="close" data-dismiss="modal"
											aria-label="Close">
											<span aria-hidden="true">&times;</span>
										</button>
									</div>
									<div class="modal-body">

										<div id="modal-image-slider" class="carousel slide"
											data-ride="carousel">

											<div class="carousel-inner">

												<c:choose>

													<c:when
														test="${club.clubPhotoList[0].clubPhotoRenamed ne null}">

														<div class="carousel-item active">
															<img class="d-block w-100"
																src="${pageContext.request.contextPath}/resources/upload/club/21/${club.clubPhotoList[0].clubPhotoRenamed}"
																alt="First slide">
														</div>
													</c:when>
													
													<c:otherwise>
														<div class="carousel-item active">
															<img class="d-block w-100"
																src="${pageContext.request.contextPath}/resources/img/club/clubAll.JPG"
																alt="First slide">
														</div>
													
													</c:otherwise>
												</c:choose>
												<c:if
													test="${club.clubPhotoList[1].clubPhotoRenamed ne null}">
													<div class="carousel-item">
														<img class="d-block w-100"
															src="${pageContext.request.contextPath}/resources/upload/club/21/${club.clubPhotoList[1].clubPhotoRenamed}"
															alt="Second slide">
													</div>
												</c:if>
												<c:if
													test="${club.clubPhotoList[2].clubPhotoRenamed ne null}">
													<div class="carousel-item">
														<img class="d-block w-100"
															src="${pageContext.request.contextPath}/resources/upload/club/21/${club.clubPhotoList[2].clubPhotoRenamed}"
															alt="Third slide">
													</div>
												</c:if>
											</div>

											<a class="carousel-control-prev" href="#modal-image-slider"
												role="button" data-slide="prev"> <span
												class="carousel-control-prev-icon" aria-hidden="true"></span>
												<span class="sr-only">Previous</span>
											</a> <a class="carousel-control-next" href="#modal-image-slider"
												role="button" data-slide="next"> <span
												class="carousel-control-next-icon" aria-hidden="true"></span>
												<span class="sr-only">Next</span>
											</a>

										</div>



										<span class="modal-text">${club.clubIntroduce }</span>

										<hr>
										<div class="modal-club-info">
											<span>담당대표 사번 - </span>&nbsp; <span>${club.clubManagerId }</span>
											<br> <span>모임주기 - </span>&nbsp; <span>${club.clubMeetingCycle}</span>
											<br> <span>모임날짜 - </span>&nbsp; <span>${club.clubMeetingDate}</span>
											<br> <span>개설일 - </span>&nbsp; <span>${club.clubEnrollDate }</span>
										</div>

									</div>

									<div class="modal-footer justify-content-between">
										<button type="button" class="btn btn-default"
											data-dismiss="modal">Close</button>

										<c:if test="${!empty memberLoggedIn}">
											<c:choose>
												<c:when
													test="${memberLoggedIn.memberId eq mg or memberLoggedIn.memberId eq admin}">

												</c:when>

												<c:otherwise>
													<%
														int count = 0;
													%>
													<form role="form"
														action="${pageContext.request.contextPath}/club/insertClubMember.do"
														method="post" enctype="multipart/form-data">
														<input type="hidden" name="clubNo" value="${club.clubNo }" />
														<input type="hidden" name="memberId"
															value="${memberLoggedIn.memberId }" />

														<c:forEach items="${myAndStandClub}" var="myAndStand">

															<c:if test="${myAndStand.clubNo == club.clubNo }">
																<%
																	count++;
																%>
															</c:if>

														</c:forEach>
														<%
															if (count == 0) {
														%>
														<button type="submit" class="btn btn-primary" id="join">가입하기</button>
														<%
															} else {
																				count = 0;
														%>
														<%
															}
														%>

													</form>
												</c:otherwise>
											</c:choose>
										</c:if>
									</div>
								</div>
								<!-- /.modal-content -->
							</div>
							<!-- /.modal-dialog -->
						</div>
						<!-- /.modal -->


						<!-- new Club modal -->
						<!-- modal 부분 -->
						<div class="modal fade" id="modal-new-club" data-backdrop="static">
							<div class="modal-dialog modal-lg">
								<div class="modal-content">
									<div class="modal-header">
										<h4 class="modal-title">동호회 개설</h4>

										<button type="button" class="close" data-dismiss="modal"
											aria-label="Close">
											<span aria-hidden="true">&times;</span>
										</button>

									</div>
									<div class="modal-body">
										<div>
											<!-- form start -->
											<form role="form" id="new-club-form"
												action="${pageContext.request.contextPath}/club/insertNewClub.do"
												method="post" enctype="multipart/form-data">

												<!-- 아이디값 히든으로 넘겨주기  -->
												<input type="hidden" name="clubManagerId"
													value="${memberLoggedIn.memberId}" />

												<div class="form-group">
													<label>이름</label> <input type="text" name="clubName"
														class="form-control" required>
												</div>
												<div class="form-group">
													<div class="mb-3">
														<label for="introduce">소개</label>
														<textarea id="introduce" name="clubIntroduce"
															class="textarea"
															style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"
															placeholder="소개글을 작성해주세요" required>${club.clubIntroduce }</textarea>
													</div>
												</div>


												<div class="form-group">
													<label>모임주기</label> <select class="form-control"
														name="clubMeetingCycle">
														<option>매주</option>
														<option>격주</option>
													</select>
												</div>
												<label for="check-week">모임 요일</label>
												<div id="check-week" class="input-group">
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="clubMeetingDate" id="meetingDate0" value="월"
															checked> <label class="form-check-label"
															for="meetingDate0">월</label>
													</div>
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="clubMeetingDate" id="meetingDate1" value="화">
														<label class="form-check-label" for="meetingDate1">화</label>
													</div>
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="clubMeetingDate" id="meetingDate2" value="수">
														<label class="form-check-label" for="meetingDate2">수</label>
													</div>
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="clubMeetingDate" id="meetingDate3" value="목">
														<label class="form-check-label" for="meetingDate3">목</label>
													</div>
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="clubMeetingDate" id="meetingDate4" value="금">
														<label class="form-check-label" for="meetingDate4">금</label>
													</div>
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="clubMeetingDate" id="meetingDate5" value="토">
														<label class="form-check-label" for="meetingDate5">토</label>
													</div>
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="clubMeetingDate" id="meetingDate6" value="일">
														<label class="form-check-label" for="meetingDate6">일</label>
													</div>
												</div>
												<!-- /.input-group -->

												<label for="radio-category">카테고리</label>
												<div id="radio-category" class="input-group">
													<div class="form-check">
														<input class="form-check-input" type="radio"
															name="clubCategory" id="clubCategory0" value="사회" checked>
														<label class="form-check-label" for="clubCategory0">사회</label>
													</div>
													<div class="form-check">
														<input class="form-check-input" type="radio"
															name="clubCategory" id="clubCategory1" value="취미">
														<label class="form-check-label" for="clubCategory1">취미</label>
													</div>
													<div class="form-check">
														<input class="form-check-input" type="radio"
															name="clubCategory" id="clubCategory2" value="음식">
														<label class="form-check-label" for="clubCategory2">음식</label>
													</div>
													<div class="form-check">
														<input class="form-check-input" type="radio"
															name="clubCategory" id="clubCategory3" value="운동">
														<label class="form-check-label" for="clubCategory3">운동</label>
													</div>
													<div class="form-check">
														<input class="form-check-input" type="radio"
															name="clubCategory" id="clubCategory4" value="문학">
														<label class="form-check-label" for="clubCategory4">문학</label>
													</div>
													<div class="form-check">
														<input class="form-check-input" type="radio"
															name="clubCategory" id="clubCategory5" value="기타">
														<label class="form-check-label" for="clubCategory5">기타</label>
													</div>

												</div>

												<div id="btn-sub">
													<button type="submit" id="join-btn" class="btn btn-primary">생성하기</button>
												</div>
											</form>
											<!-- form end -->
										</div>
									</div>
									<!-- /.modal-body -->
								</div>
								<!-- /.modal-content -->
							</div>
							<!-- /.modal-dialog -->
						</div>
						<!-- /.modal -->

						<!--  modal 수정 -->
						<!-- modal 부분 -->
						<div class="modal fade" id="modal-update-${club.clubNo }"
							data-backdrop="static">
							<div class="modal-dialog modal-lg">
								<div class="modal-content">
									<div class="modal-header">
										<h4 class="modal-title">동호회 정보 수정</h4>

										<button type="button" class="close" data-dismiss="modal"
											aria-label="Close">
											<span aria-hidden="true">&times;</span>
										</button>

									</div>
									<div class="modal-body">
										<div>
											<!-- form start -->
											<form role="form" id="update-club-form"
												action="${pageContext.request.contextPath}/club/updateClub.do"
												method="post" enctype="multipart/form-data">

												<!-- clubNo 값 히든으로 넘겨주기  -->
												<input type="hidden" name="clubNo" value="${club.clubNo}" />

												<div class="form-group">
													<label>이름</label> <input type="text" name="clubName"
														class="form-control" value="${club.clubName }" required>
												</div>
												<div class="form-group">
													<div class="mb-3">
														<label for="introduce">소개</label>
														<textarea id="introduce" name="clubIntroduce"
															class="textarea"
															style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;">${club.clubIntroduce }</textarea>
													</div>
												</div>



												<div class="form-group">
													<label>모임주기</label> <select class="form-control"
														name="meetingCycle">
														<option
															<c:if test="${club.clubMeetingCycle eq '매주'}">selected</c:if>>매주</option>
														<option
															<c:if test="${club.clubMeetingCycle eq '격주'}">selected</c:if>>격주</option>
													</select>
												</div>


												<c:set var="dateStr" value="${club.clubMeetingDate }"></c:set>
												<label for="check-week">모임 요일</label>
												<div id="check-week" class="input-group">
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="meetingDate" id="meetingDate0" value="월"
															<c:if test="${fn:contains(dateStr,'월') }">checked</c:if>>
														<label class="form-check-label" for="meetingDate0">월</label>
													</div>
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="meetingDate" id="meetingDate1" value="화"
															<c:if test="${fn:contains(dateStr,'화') }">checked</c:if>>
														<label class="form-check-label" for="meetingDate1">화</label>
													</div>
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="meetingDate" id="meetingDate2" value="수"
															<c:if test="${fn:contains(dateStr,'수') }">checked</c:if>>
														<label class="form-check-label" for="meetingDate2">수</label>
													</div>
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="meetingDate" id="meetingDate3" value="목"
															<c:if test="${fn:contains(dateStr,'목') }">checked</c:if>>
														<label class="form-check-label" for="meetingDate3">목</label>
													</div>
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="meetingDate" id="meetingDate4" value="금"
															<c:if test="${fn:contains(dateStr,'금') }">checked</c:if>>
														<label class="form-check-label" for="meetingDate4">금</label>
													</div>
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="meetingDate" id="meetingDate5" value="토"
															<c:if test="${fn:contains(dateStr,'토') }">checked</c:if>>
														<label class="form-check-label" for="meetingDate5">토</label>
													</div>
													<div class="form-check">
														<input type="checkbox" class="form-check-input"
															name="meetingDate" id="meetingDate6" value="일"
															<c:if test="${fn:contains(dateStr,'일') }">checked</c:if>>
														<label class="form-check-label" for="meetingDate6">일</label>
													</div>
												</div>
												<!-- /.input-group -->

												<label for="radio-category">카테고리</label>
												<div id="radio-category" class="input-group">

													<div class="form-check">
														<input class="form-check-input" type="radio"
															name="clubCategory" id="clubCategory1" value="사회"
															<c:if test="${club.clubCategory eq '사회'}">checked</c:if>>
														<label class="form-check-label" for="clubCategory1">사회</label>
													</div>
													<div class="form-check">
														<input class="form-check-input" type="radio"
															name="clubCategory" id="clubCategory2" value="음식"
															<c:if test="${club.clubCategory eq '음식'}">checked</c:if>>
														<label class="form-check-label" for="clubCategory2">음식</label>
													</div>
													<div class="form-check">
														<input class="form-check-input" type="radio"
															name="clubCategory" id="clubCategory3" value="운동"
															<c:if test="${club.clubCategory eq '운동'}">checked</c:if>>
														<label class="form-check-label" for="clubCategory3">운동</label>
													</div>
													<div class="form-check">
														<input class="form-check-input" type="radio"
															name="clubCategory" id="clubCategory4" value="문학"
															<c:if test="${club.clubCategory eq '문학'}">checked</c:if>>
														<label class="form-check-label" for="clubCategory4">문학</label>
													</div>
													<div class="form-check">
														<input class="form-check-input" type="radio"
															name="clubCategory" id="clubCategory5" value="기타"
															<c:if test="${club.clubCategory eq '기타'}">checked</c:if>>
														<label class="form-check-label" for="clubCategory5">기타</label>
													</div>

												</div>

												<div id="btn-sub">
													<button type="submit" id="update-btn"
														class="btn btn-primary">수정하기</button>
												</div>
											</form>
											<!-- form end -->
										</div>
									</div>
									<!-- /.modal-body -->
								</div>
								<!-- /.modal-content -->
							</div>
							<!-- /.modal-dialog -->
						</div>
						<!-- /.modal -->
					</c:forEach>

					<div class="col-12 col-sm-6 col-md-3">
						<div class="card new" id="new-club-card">
							<div class="card-body">
								<i class="fas fa-plus"></i>
								<h6>새 동호회</h6>
							</div>
						</div>
						<!-- /.card -->
					</div>

				</div>
			</section>

			<!-- 내가 가입한 동호회 목록 -->
			<section class="my-club">
				<div class="card-header" role="button" onclick="toggleList(this);">
					<h3>
						<i class="fas fa-chevron-down"></i> 내가 가입한 동호회 <span
							class="header-count">(2)</span>
					</h3>
				</div>

				<!-- /.card-header -->
				<div class="row card-content">



					<c:forEach var="my" items="${myClub}">

						<div class="col-12 col-sm-6 col-md-3">
							<div class="card club card-hover">

								<div class="card-body">
									<div class="card-title">
										<h5>${my.clubName }</h5>
									</div>

									<c:set var="mg" value="${my.clubManagerId }"></c:set>
									<c:if test="${!empty memberLoggedIn}">
										<c:if
											test="${memberLoggedIn.memberId eq mg or memberLoggedIn.memberId eq admin}">
											<!-- 삭제 버튼 -->
											<div class="card-tools text-right">
												<button type="button" class="btn btn-tool"
													data-card-widget="remove">
													<i class="fas fa-times"></i>
												</button>
											</div>
										</c:if>
									</c:if>

									<div class="card-club-image">
										<img
											src="${pageContext.request.contextPath}/resources/img/fs.JPG"
											onclick="location.href = '${pageContext.request.contextPath}/club/clubView.do?clubNo=${my.clubNo }'"
											alt="">
									</div>
									<div class="card-enroll-date">
										<span class="enroll-date">${my.clubEnrollDate }</span>
									</div>

									<c:if test="${!empty memberLoggedIn }">
										<c:if
											test="${memberLoggedIn.memberId eq mg or memberLoggedIn.memberId eq admin}">
											<!-- 수정 버튼 -->
											<button type="button" id="up-btn" data-toggle="modal"
												data-target="#modal-update-${my.clubNo }">
												<i class="fas fa-edit"></i>
											</button>
										</c:if>
									</c:if>
								</div>

							</div>
							<!-- /.card -->
						</div>
					</c:forEach>

				</div>
			</section>

			<!-- 승인 대기중인 동아리 목록 -->
			<section class="stand-by-club">
				<div class="card-header" role="button" onclick="toggleList(this);">
					<h3>
						<i class="fas fa-chevron-down"></i> 승인 대기중인 동호회 <span
							class="header-count">(1)</span>
					</h3>
				</div>
				<!-- /.card-header -->

				<div class="row card-content">
					<c:forEach var="standBy" items="${standByClub}">

						<div class="col-12 col-sm-6 col-md-3">
							<div class="card club card-hover">

								<div class="card-body">
									<div class="card-title">
										<h5>${standBy.clubName }</h5>
									</div>

									<c:set var="mg" value="${standBy.clubManagerId }"></c:set>
									<c:if test="${!empty memberLoggedIn}">
										<c:if
											test="${memberLoggedIn.memberId eq mg or memberLoggedIn.memberId eq admin}">
											<!-- 삭제 버튼 -->
											<div class="card-tools text-right">
												<button type="button" class="btn btn-tool"
													data-card-widget="remove">
													<i class="fas fa-times"></i>
												</button>
											</div>
										</c:if>
									</c:if>

									<div class="card-club-image">
										<img
											src="${pageContext.request.contextPath}/resources/img/fs.JPG"
											data-toggle="modal"
											data-target="#modal-club-${standBy.clubNo }" alt="">
									</div>
									<div class="card-enroll-date">
										<span class="enroll-date">${standBy.clubEnrollDate }</span>
									</div>

									<c:if test="${!empty memberLoggedIn }">
										<c:if
											test="${memberLoggedIn.memberId eq mg or memberLoggedIn.memberId eq admin}">
											<!-- 수정 버튼 -->
											<button type="button" id="up-btn" data-toggle="modal"
												data-target="#modal-update-${standBy.clubNo }">
												<i class="fas fa-edit"></i>
											</button>
										</c:if>
									</c:if>
								</div>

							</div>
							<!-- /.card -->
						</div>
					</c:forEach>
				</div>
			</section>

		</div>
		<!-- /.container-fluid -->
	</div>
	<!-- /.content -->
</div>
<!-- /.content-wrapper -->





<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>