<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<script>
$(function(){
	bsCustomFileInput.init();
});

//설정 내용 슬라이드토글
function toggleContent(obj){
    $('.setting-option-content').slideUp();
    $('.fa-chevron-down').css('transform', 'none');

    if(!$(obj).next().is(":visible")){
        $(obj).next().slideDown();
        $(obj).find('.fa-chevron-down:eq(0)').css('transform', 'rotate(180deg)');
    }
}

var chkUpFile = 0;
function loadImg(f){
	console.dir(f);
	console.dir(f.files[0]);
	
	if(f.files && f.files[0]){
		let reader = new FileReader();
		//파일읽기, 읽기완료 시 load event발생
		reader.readAsDataURL(f.files[0]);
		
		reader.onload = e => {
			//파일컨텐츠는 e.target.result속성에 담겨있음.
			$("#img-viewer").attr("src", e.target.result);
			chkUpFile = 1;
		}
		
	}
	else{
		$("#img-viewer").attr("src", "${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}");
		chkUpFile = 0;
	}
}

function checkUpFile(){
	if(chkUpFile == 0){
		return false;
	}
	return true;
}

function checkDelete(){
	var result = confirm("정말 계정을 삭제하시겠습니까?");
	
	if(result == true){
		return true;
	}
	return false;
}

function password_validate(){
	var pwd = $("#pwd-now").val().trim();
	var pwd_real = $("#pwd-real").val();
	var pwd_new = $("#pwd-new").val().trim();
	var pwd_chk = $("#pwd-new-chk").val().trim();
	var regPassword = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
	
	if(pwd_new!=pwd_chk){
		alert("새 비밀번호와 비밀번호 확인이 일치하지 않습니다.");
		return false;
	}else if(!regPassword.test(pwd_new)){
		alert("비밀번호는 8~16자의 영문 대소문자와 숫자, 특수문자를 사용할 수 있습니다.");
		return false;
	}
	return true;
}

function email_validate(){
	var email = $("#email-new").val().trim();
	var regEmail = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
	
	if(!regEmail.test(email)){
		alert("이메일 형식에 맞지 않습니다.");
	    return false;
	}
	return true;
}

function phone_validate(){
	var phone = $("#phone-new").val().trim();
	var regPhone = /^[0-9]{10,11}$/;
	
	if(!regPhone.test(phone)){
		alert("전화번호 형식에 맞지 않습니다.('-' 제외)");
	    return false;
	}
	return true;
	
}
</script>

<!-- Content Wrapper. Contains page content -->
<div id="user-settings" class="content-wrapper">
    <section class="content">
        <h2>계정 설정</h2>
        <div class="container-fluid">
            <!-- 탭 -->
            <ul class="nav nav-tabs" id="custom-content-below-tab" role="tablist">
            	<!-- 설정탭은 본인만 볼 수 있도록 -->
            	<c:if test="${m.memberId == memberLoggedIn.memberId}">
                <li class="nav-item">
                	<c:if test="${active=='setting'}">
                    <a class="nav-link active" id="custom-content-below-setting-tab" data-toggle="pill" href="#custom-content-below-setting" role="tab" aria-controls="custom-content-below-setting" aria-selected="true">설정</a>
                    </c:if>
                    <c:if test="${active!='setting'}">
                    <a class="nav-link" id="custom-content-below-setting-tab" data-toggle="pill" href="#custom-content-below-setting" role="tab" aria-controls="custom-content-below-setting" aria-selected="true">설정</a>
                    </c:if>
                </li>
                </c:if>
                <li class="nav-item">
                	<c:if test="${active=='profile'}">
                    <a class="nav-link active" id="custom-content-below-profile-tab" data-toggle="pill" href="#custom-content-below-profile" role="tab" aria-controls="custom-content-below-profile" aria-selected="false">프로필</a>
                    </c:if>
                    <c:if test="${active!='profile'}">
                    <a class="nav-link" id="custom-content-below-profile-tab" data-toggle="pill" href="#custom-content-below-profile" role="tab" aria-controls="custom-content-below-profile" aria-selected="false">프로필</a>
                    </c:if>
                </li>
            </ul>
            <!-- 탭-컨텐츠 -->
            <div class="tab-content" id="custom-content-below-tabContent">
                <!-- 설정 -->
                <!-- 설정탭은 본인만 볼 수 있도록 -->
            <c:if test="${m.memberId == memberLoggedIn.memberId}">
            <c:if test="${active=='setting'}">
                <div class="tab-pane fade show active" id="custom-content-below-setting" role="tabpanel" aria-labelledby="custom-content-below-setting-tab">
            </c:if>
            <c:if test="${active!='setting'}">
                <div class="tab-pane fade" id="custom-content-below-setting" role="tabpanel" aria-labelledby="custom-content-below-setting-tab">
            </c:if>
                    <div id="setting-inner">
                        <!-- 이메일 변경 -->
                        <div class="setting-option">
                            <div class="setting-option-header" onclick="toggleContent(this);">
                                <h3>이메일 변경</h3>
                                <i class="fas fa-chevron-down"></i>
                            </div>
                            <div class="setting-option-content">
                                <form action="${pageContext.request.contextPath}/member/updateEmail.do?memberId=${m.memberId}" method="post">
                                    <div class="input-wrapper">
                                        <label for="email-now">현재 이메일 주소</label>
                                        <input type="email" id="email-now" value="${m.email}" class="form-control" disabled>
                                    </div>
                                    <div class="input-wrapper">
                                        <label for="email-new">새 이메일 주소</label>
                                        <input type="email" name="email" id="email-new" class="form-control" required>
                                    </div>
                                    <button type="submit" class="btn-update" onclick="return email_validate();">이메일 업데이트</button>
                                </form>                                
                            </div>
                        </div>

                        <!-- 전화번호 변경 -->
                        <div class="setting-option">
                            <div class="setting-option-header" onclick="toggleContent(this);">
                                <h3>전화번호 변경</h3>
                                <i class="fas fa-chevron-down"></i>
                            </div>
                            <div class="setting-option-content">
                                <form action="${pageContext.request.contextPath}/member/updatePhone.do?memberId=${m.memberId}" method="post">
                                    <div class="input-wrapper">
                                        <label for="phone-now">현재 전화번호</label>
                                        <input type="tel" id="phone-now" value="${m.phone}" class="form-control" disabled>
                                    </div>
                                    <div class="input-wrapper">
                                        <label for="phone-new">새 전화번호</label>
                                        <input type="tel" name="phone" id="phone-new" class="form-control" required>
                                    </div>
                                    <button type="submit" class="btn-update" onclick="return phone_validate();">전화번호 업데이트</button>
                                </form>                                
                            </div>
                        </div>

                        <!-- 비밀번호 변경 -->
                        <div class="setting-option">
                            <div class="setting-option-header" onclick="toggleContent(this);">
                                <h3>비밀번호 변경</h3>
                                <i class="fas fa-chevron-down"></i>
                            </div>
                            <div class="setting-option-content">
                                <form action="${pageContext.request.contextPath}/member/updatePassword.do?memberId=${m.memberId}" method="post">
                                    <div class="input-wrapper">
                                        <label for="pwd-now">현재 비밀번호</label>
                                        <input type="password" id="pwd-now" name="password_now" class="form-control" required>
                                        <input type="hidden" value="${m.password}" id="pwd-real" />
                                    </div>
                                    <div class="input-wrapper">
                                        <label for="pwd-new">새 비밀번호</label>
                                        <input type="password" name="password_new" id="pwd-new" class="form-control" required>
                                    </div>
                                    <p id="warningPwd" style="font-size:.7rem; position:relative; top:-.5rem; margin-bottom:.2rem; margin-left:.4rem; display:none;">
        								비밀번호는 8~15자리 숫자/문자/특수문자를 포함해야합니다.
        							</p>
                                    <div class="input-wrapper">
                                        <label for="pwd-new-chk">새 비밀번호 확인</label>
                                        <input type="password" name="password_chk" id="pwd-new-chk" class="form-control" required>
                                    </div>
                                    <button type="submit" class="btn-update" onclick="return password_validate();">비밀번호 업데이트</button>
                                </form>                                
                            </div>
                        </div>

                        <!-- 계정 삭제 -->
                        <div class="setting-option">
                            <div class="setting-option-header" onclick="toggleContent(this);">
                                <h3>계정 삭제</h3>
                                <i class="fas fa-chevron-down"></i>
                            </div>
                            <div class="setting-option-content">
                                <p>한 번 삭제된 계정은 다시 복구할 수 없습니다. 계정이 삭제되면, 현재 계정에서 생성된 모든 데이터에 더이상 엑세스할 수 없습니다. 삭제 후, Workground를 다시 이용하고자 한다면, 새로 가입해주셔야합니다.</p>
                                <form action="${pageContext.request.contextPath}/member/deleteMember.do?memberId=${m.memberId}" method="post" onsubmit="return checkDelete();">
                                    <button type="submit" class="btn-update delete">계정 삭제하기</button>
                                </form>                                
                            </div>
                        </div>
                    </div>
                </div>
			</c:if>
				
                <!-- 프로필 -->
            <c:if test="${active=='profile'}">
                <div class="tab-pane fade show active" id="custom-content-below-profile" role="tabpanel" aria-labelledby="custom-content-below-profile-tab">
            </c:if>
            <c:if test="${active!='profile'}">
                <div class="tab-pane fade" id="custom-content-below-profile" role="tabpanel" aria-labelledby="custom-content-below-profile-tab">
            </c:if>
                    <div id="profile-inner" style="background: white;">
                        <div class="card-body" style="padding: 2rem 1.25rem;">
                            <div class="active tab-pane" id="activity">
                                <!-- Post -->
                                <div class="post">
	                                <form action="${pageContext.request.contextPath}/member/updateProfileImg.do?memberId=${m.memberId}"
	                                	  method="post"
      									  enctype="multipart/form-data"
      									  onsubmit="return checkUpFile();">
	                                	<c:if test="${m.memberId == memberLoggedIn.memberId}">
		                                <button type="submit" class="btn-update" style="position:absolute;top:22rem;left:14.6rem;">사진 업데이트</button>
		                                </c:if>
		                                <div id="custom-file-wrapper" style="float: left; margin-left: 1.5rem;">
		                                    <img class="img-fluid" src="${pageContext.request.contextPath}/resources/img/profile/${m.renamedFileName}" alt="user image" id="img-viewer" style="max-height:9rem; width:100%;">
		                                    <input type="hidden" name="oldRenamedFileName" value="${m.renamedFileName}"/>
		                                    <!-- 사진 업데이트는 본인만 볼 수 있도록 -->
		    								<c:if test="${m.memberId == memberLoggedIn.memberId}">
		                                    <div class="custom-file" style="background: black; opacity: 0.7; position: relative; bottom: 2.3rem; text-align: center; transition: .08s">
		                                        <label for="customFile" style="color: white; padding-top: 0.5rem; font-size: .75rem; cursor: pointer;">
		                                            <i class="fas fa-camera-retro" style="margin-right: .3rem;"></i>사진 업데이트
		                                        </label>
		                                    </div>
		                                    <div class="form-group" style="display:none;">
		                                        <div class="custom-file" >
			                                        <label class="custom-file-label" for="customFile">Choose file</label>
			                                        <input type="file" class="custom-file-input" id="customFile" name="upFile" onchange="loadImg(this);">
		                                        </div>
		                                    </div>
		                                    </c:if>
		                                </div><!-- /.col -->
		                                <div class="col-sm-6" style="float: left; margin-left: 3rem;">
                                            <!-- text input -->
                                            <div class="form-group">
                                                <label>사번</label>
                                                <input type="text" class="form-control" value="${m.memberId}" readOnly>
                                            </div>
                                            <div class="form-group">
                                                <label>이름</label>
                                                <input type="text" class="form-control" value="${m.memberName}" readOnly>
                                            </div>
                                            <div class="form-group">
                                                <label>부서</label>
                                                <input type="text" class="form-control" value="${m.deptTitle}" readOnly>
                                            </div>
                                            <div class="form-group">
                                                <label>직함</label>
                                                <input type="text" class="form-control" value="${m.jobTitle}" readOnly>
                                            </div>
                                            <div class="form-group">
                                                <label>이메일</label>
                                                <input type="email" class="form-control" value="${m.email}" readOnly>
                                            </div>
                                            <div class="form-group">
                                                <label>전화번호</label>
                                                <input type="tel" class="form-control" value="${m.phone}" readOnly>
                                            </div>
                                            <div class="form-group">
                                                <label>생년월일</label>
                                                <input type="text" class="form-control" value="${m.dateOfBirth}" readOnly>
                                            </div>
                                        </div><!-- /.col -->
	                                </form>
                                </div>
                                <!-- /.post -->
                            </div>
                        </div><!-- /.card-body -->
                    </div>
                </div><!-- /.프로필 -->
            </div>
        </div><!-- /.container-fluid -->
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->		

<script>
$("#pwd-new").keyup(function(){
	var pwd_new = $(this).val().trim();
	var regPassword = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
	
	if(!regPassword.test(pwd_new)){
		$("#warningPwd").css("display", "block");
	}
	else{
		$("#warningPwd").css("display", "none");
	}
});	
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>