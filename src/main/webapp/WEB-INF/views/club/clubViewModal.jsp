<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- insertPhoto Modal -->
<div class="modal fade cd-example-modal-lg" id="insertPhoto"
	tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel"
	aria-hidden="true" data-backdrop="static">
	<div class="modal-dialog modal-dialog-centered modal-lg">
		<div class="modal-content card card-outline card-info">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLongTitle">사진추가하기</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<form name="clubPhotoFrm" action="${pageContext.request.contextPath }/club/clubPhotoForm.do" method="POST" enctype="multipart/form-data" onsubmit="return validate();">
				<div class="modal-body">
					<input type="hidden" name="clubNo" value="${club.clubNo }" />
					<input type="hidden" name="memberId" value="${memberLoggedIn.memberId }" />
					<div class="form-group">
						<label for="exampleInputFile">사진제목</label> 
						<input type="text" name="clubPhotoTitle" class="form-control" placeholder="제목을 입력하세요." required="required">
					</div>
					<div class="form-group">
						<label for="exampleInputFile">사진파일</label>
						<div class="input-group">
							<div class="custom-file">
								<input type="file" class="custom-file-input" name=upFile id="exampleInputFile" required="required"> 
								<label class="custom-file-label" for="exampleInputFile">파일을 선택하세요.</label>
							</div>
							<!-- <div class="input-group-append">
	                  <span class="input-group-text" id="">Upload</span>
	                </div> -->
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="submit" class="btn btn-info">추가</button>
					<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
				</div>
			</form>
		</div>
	</div>
</div>



<!-- info Modal -->
<div class="modal fade cd-example-modal-lg" id="info" tabindex="-1" role="dialog"
	aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered modal-lg" role="document">
		<div class="modal-content card card-outline card-info">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLongTitle">${club.clubName }</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<br> ${club.clubIntroduce }
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-info" 
						data-target="#info-modify" 
						data-dismiss="modal"
						data-toggle="modal">수정</button>
				<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>

<!-- info-modify Modal -->
<div class="modal fade cd-example-modal-lg" id="info-modify" tabindex="-1" role="dialog"
	aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered modal-lg" role="document">
		<div class="modal-content card card-outline card-info">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<form name="clubIntroduceUpdateFrm" action="${pageContext.request.contextPath }/club/clubIntroduceUpdate.do" method="POST">
				<input type="hidden" name="clubNo" value="${club.clubNo }" />
				<div class="modal-body">
					<div class="form-group">
						<div class="mb-3">
							<label for="inputDescription">동호회 이름</label>
							<h5 class="modal-title" id="exampleModalLongTitle"><input type="text" name="clubName" class="form-control" value="${club.clubName }" name="" id="" /></h5>
						</div>
					</div>
					<div class="form-group">
						<div class="mb-3">
							<label for="inputDescription">동호회 소개</label>
							<textarea id="inputDescription" class="textarea" name="clubIntroduce" 
									  style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;">${club.clubIntroduce }</textarea>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="submit" class="btn btn-info">수정</button>
					<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
				</div>
			</form>
		</div>
	</div>
</div>


	
<!-- insertPlan Modal -->
<div class="modal fade cd-example-modal-lg" id="insertPlan"
	tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle"
	aria-hidden="true" data-backdrop="static">
	<div class="modal-dialog modal-dialog-centered modal-lg"
		role="document">
		<div class="modal-content card card-outline card-info">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLongTitle">일정추가하기</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<form name="clubPlanInsertFrm" action="${pageContext.request.contextPath }/club/clubPlanInsert.do" method="post">
				<input type="hidden" name="clubNo" value="${club.clubNo }" />
				<input type="hidden" name="memberId" value="${memberLoggedIn.memberId }" />
				<div class="modal-body">
					<div class="form-group">
						<label for="inputName">일정</label> 
						<input type="text" name="clubPlanTitle" 
							id="inputName" class="form-control" placeholder="일정을 입력하세요.">
					</div>
					<div class="form-group">
						<div class="mb-3">
							<label for="inputDescription">일정 내용</label>
							<textarea id="inputDescription" name="clubPlanContent" class="textarea"
								style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"></textarea>
						</div>
					</div>
					<!-- Date picker -->
					<div class="form-group">
						<label for="">날짜</label>
						<div class="input-group">
							<div class="input-group-prepend">
								<span class="input-group-text"><i
									class="far fa-calendar-alt"></i></span>
							</div>
							<input type="text" name="clubPlanDate" class="form-control float-right"
								id="reservation">
						</div>
						<!-- /.input group -->
					</div>
					<!-- /.form group -->
					<div class="form-group">
						<label for="inputStatus">상태</label> 
						<select name="clubPlanState" class="form-control custom-select">
							<option selected disabled>선택하세요.</option>
							<option selected>예정</option>
							<option>완료</option>
							<option>취소</option>
						</select>
					</div>
					<div class="form-group">
						<label for="inputClientCompany">장소</label> 
						<input type="text" name="clubPlanPlace"
							id="inputClientCompany" class="form-control"
							placeholder="장소를 입력하세요." />
					</div>
					<div class="form-group">
						<label for="inputProjectLeader">담당진행자</label> 
						<input type="text" name="clubPlanManager"
							id="inputProjectLeader" class="form-control"
							placeholder="담당진행자를 입력하세요." />
					</div>
				</div>
				<div class="modal-footer">
					<button type="submit" class="btn btn-info">추가</button>
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">닫기</button>
				</div>
			</form>
		</div>
	</div>
</div>


<!-- #notice-input modal -->
<div class="modal fade cd-example-modal-lg" id="insertNotice"
	tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel"
	aria-hidden="true" data-backdrop="static">
	<div class="modal-dialog modal-dialog-centered modal-lg">
		<div class="modal-content card card-outline card-info">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<form name="clubNoticeInsertFrm" action="${pageContext.request.contextPath }/club/insertClubNotice.do" enctype="multipart/form-data" method="POST">
				<input type="hidden" name="clubNo" value="${club.clubNo }" />
				<input type="hidden" name="memberId" value="${memberLoggedIn.memberId }" />
				<div class="modal-body">
					<div class="form-group">
						<label for="inputClientCompany">제목</label>
						<input type="text" name="clubNoticeTitle" class="form-control" placeholder="제목을 입력하세요.">
					</div>
					<div class="form-group">
						<label for="exampleInputFile">파일</label>
						<div class="input-group">
							<div class="custom-file">
								<input type="file" class="custom-file-input" name=upFile id="exampleInputFile"> 
								<label class="custom-file-label" for="exampleInputFile">파일을 선택하세요.</label>
							</div>
						</div>
					</div>
					
					<div class="form-group">
						<label for="inputClientCompany">공지내용</label>
						<div class="card-body pad">
							<div class="mb-3">
								<textarea class="textarea" name="clubNoticeContent"
									style="width: 100%; height: 500px; font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"></textarea>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="submit" class="btn btn-info">추가</button>
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">닫기</button>
				</div>
			</form>
		</div>
	</div>
</div>
