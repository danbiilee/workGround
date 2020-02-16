<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>WorkGround</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/fontawesome-free/css/all.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
  <!-- icheck bootstrap -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/icheck-bootstrap/icheck-bootstrap.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminlte.min.css">
  <!-- Google Font: Source Sans Pro -->
  <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:100,300,400,500,700,900&display=swap" rel="stylesheet">
</head>
<body class="hold-transition login-page"  style="background: white;">
<%
//쿠키관련
	boolean saveId = false;
	String memberId = "";
	Cookie[] cookies = request.getCookies();
	if(cookies != null){
		for(Cookie c : cookies){
			String k = c.getName();
			String v = c.getValue();
			if("saveId".equals(k)){
				saveId = true;
				memberId = v;
			}
		}
	}
%>
<div class="col-md-8">
  <div class="login-logo">
    <b>COMPANY NAME</b>
  </div>
  <!-- /.login-logo -->
  <!-- <div class="card">  -->
    <div class="col-sm-6" style="display:inline-block; padding: 60px; box-shadow: 0 0 1px rgba(0,0,0,.125), 0 1px 3px rgba(0,0,0,.2); height: 23rem;">
      <p class="login-box-msg" style="font-weight: 700; font-size: 22px;">로그인</p>
      <form action="${pageContext.request.contextPath}/member/memberLogin.do" method="post">
        <div class="input-group mb-3">
          <input type="text" class="form-control" name="memberId" placeholder="아이디" value="<%=saveId?memberId:""%>" required>
          <div class="input-group-append">
            <div class="input-group-text" style="background: white;">
              <span class="fas fa-user"></span>
            </div>
          </div>
        </div>
        <div class="input-group mb-3">
          <input type="password" class="form-control" name="password" placeholder="비밀번호">
          <div class="input-group-append">
            <div class="input-group-text" style="background: white;">
              <span class="fas fa-lock"></span>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-8">
            <div class="icheck-primary">
              <input type="checkbox" name="saveId" id="remember" <%=saveId?"checked":""%>>
              <label for="remember">
                아이디 저장
              </label>
            </div>
          </div>
          <!-- /.col -->
          <div class="col-4">
            <button type="submit" class="btn btn-primary btn-block">로그인</button>
          </div>
          <!-- /.col -->
        </div>
      </form>
      <!-- /.social-auth-links -->

      <p class="mb-1">
        <a href="forgot-password.html" data-toggle="modal" data-target="#modal-default">비밀번호를 잊으셨나요?</a>
      </p>
        <div class="modal fade" id="modal-default">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">비밀번호 찾기</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="${pageContext.request.contextPath}/member/forgotPassword.do" method="post">
            	<div class="modal-body">
                 <div class="input-wrapper" style="padding:2rem;">
                 	<div id="inputDiv">
	                    <label for="chk-id">아이디</label>
	                    <p style="font-size: .8rem; padding-left: .5rem;">비밀번호를 찾고자 하는 아이디를 입력해 주세요.</p>
	                    <input type="text" id="chk-id" name="memberId" class="form-control">                     
                 	</div>
                 	<div id="successDiv" style="text-align: center"></div>
                 	<div id="failDiv"></div>
                 </div>
            	</div>
	            <div class="modal-footer justify-content-between">
	              <button type="button" class="btn btn-default" data-dismiss="modal" id="closeButton">Close</button>
	              <button type="submit" class="btn btn-primary" id="nextButton">다음</button>
	            </div>
            </form>
          </div>
          <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
      </div>
      <!-- /.modal -->
    </div>
    <!-- /.login-card-body -->
    <div class="col-sm-6" style="display: inline-block; float: right; padding: 40px; background: rgb(220, 234, 247); box-shadow: 0 0 1px rgba(0,0,0,.125), 0 1px 3px rgba(0,0,0,.2); height: 23rem;">
      <h2 style="font-weight:700; font-size:3rem; color: #2d235f;">WorkGround</h2>
      <p>
		비밀번호 없이 바로 사번 복사해서 로그인하세요~<br>
		이미 로그인 한 후에 로그인 페이지로 가는거 막게하는건 아직 못했어요<br>
		admin 관리자<br>
		kh2020122 이단비(팀장)<br>
		kh2020123 유혜민<br>
		kh2020124 주보라<br>
		kh2020125 이소현<br>
		kh2020126 김효정<br>
		kh2020127 이주현
		</p>
      <p class="mb-0">아직 계정이 없으신가요?&nbsp;&nbsp;<a href="${pageContext.request.contextPath}/member/memberRegister.do" class="text-center">가입하기</a></p>
    </div>
  </div>
<!-- </div> -->
<!-- /.login-box -->

<!-- jQuery -->
<script src="${pageContext.request.contextPath}/resources/plugins/jquery/jquery.min.js"></script>
<!-- Bootstrap 4 -->
<script src="${pageContext.request.contextPath}/resources/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- AdminLTE App -->
<script src="${pageContext.request.contextPath}/resources/js/adminlte.min.js"></script>

<script>
/* function next(){
	var memberId = $("#chk-id").val();
	console.log(memberId);
	$.ajax({
		url: "${pageContext.request.contextPath}/member/forgotPassword.do?memberId="+memberId,
		type: "get",
		dataType: "json",
		contentType: "application/json; charset=utf-8", //@RequestBody 필수속성
		success: data=>{
			console.log(data);
			$("#inputDiv").css("display", "none");
			$("#chk-id").val('');
			$("#successDiv").css("display", "block");
			let html = "<div style='margin-bottom: 1.3rem;'><i class='fas fa-check-circle' style='font-size: 2rem;color: #007bff;'></i></div>";
			html += "<p style='margin-bottom: 1.6rem;'>임시비밀번호가 이메일로 전송되었습니다.</p>";
			$("#successDiv").append(html);
			$("#nextButton").css("display", "none");
		},
		error: (xhr, status, error)=>{
			console.log("ajax실패!!!", xhr, status, error);
		}
	});
}

function close(){
	console.log("zz");
	$("#inputDiv").css("display", "block");
	$("#successDiv").css("display", "none");
}

$("#closeButton").click(function(){
	$("#inputDiv").css("display", "block");
	$("#successDiv").css("display", "none");
	$("#nextButton").css("display", "block");
}); */
</script>
</body>
</html>