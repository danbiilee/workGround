<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<style>
/* 공지, 게시판 카드 */
#noticeSearchFrm{margin: 15px 1rem 15px;} /*공지, 게시판 검색*/
div.content-wrapper>div.content{padding-bottom: 5rem;} /*페이지 아래 길이 늘려주기*/
div.header-line{padding: 1rem .5rem .8rem; margin: 1rem 0 .5rem; color: rgba(0,0,0,.5);}
div.header-line h6{font-weight: bold;}
i.fa-plus-square{float: right; font-size: 2rem; margin-right: .5rem; cursor: pointer; color: darkgray;} /*공지, 게시판 추가 버튼*/
i.fa-plus-square:hover{color: gray;}
.card{height: 20rem;}
.card-body{overflow: hidden;} /*카드내용 밖으로 넘어감 처리*/
img.card-img-top{height: 10rem; object-fit: cover; margin-bottom: 1.5rem; border-radius: 5px;}
.card-title{margin-bottom: .5rem; font-size: 1rem; font-weight: bold;}
.carousel-item-next, .carousel-item-prev, .carousel-item.active{display: flex;}
.carousel-indicators{bottom: -3rem;} 
.carousel-indicators li{background-color: gray;}
i.slide-arrow{color: rgb(199, 195, 195); font-size: 2rem; cursor: pointer; position: absolute; top: 45%;}
i.slide-arrow:hover{color:gray;}
i.slide-arrow-left{left: -2rem;}
i.slide-arrow-right{right: -1rem;}
.btn-moreMenu{position: absolute; border: 0; background: #00ff0000; color: darkgray; font-size: .8rem; right: .1rem; top: .3rem;} /*수정, 삭제*/
.btn-moreMenu:hover{color: gray;}
a.dropdown-item{color: gray;}
span#myDept{width: 1rem; height: 1rem; border: 2px solid lightgray; background: white; border-radius: 5px; padding: 0 .3rem;}
/* 공지, 게시판 상세보기 모달 */
div.modal-dialog{max-width: 50%;}
.modal-header .close{margin: -1.5rem -1rem -1.5rem auto;}
.modal-header .close>span{font-size: 2rem;}
.modal-title{color: #5a5454;}
.noticeView, .deptNoticeView, .boardView{margin-bottom: 1rem;}
.user-block{float: none;}
.view-img{width: 100%; display: block; margin: 0 auto;}
.noticeView>.view-title, .deptNoticeView>.view-title, .boardView>.view-title{margin-bottom: 1rem; padding-bottom: .5rem; border-bottom: 1px solid lightgray;}
p.view-title{font-size: 1.2rem; font-weight: bold;}
p.view-content{margin: 1rem 1rem 2.5rem;}
.comment-count{margin: 2.5rem 0 0.5rem; color: rgb(93, 93, 93);}
.comment-text-area{display: inline-block; width: 90%; height: 2rem; margin-right: .3rem;}
.comment-reply{border: 0; background: darkgray; border-radius: 3px; margin-right: .3rem; color: white;}
.comment-delete{border: 0; background: darkgray; border-radius: 3px; color: white;}
.comment-submit{border: 0; background: darkgray; border-radius: 3px; width: 3rem; height: 2rem; color: white;}
.comment-submit:hover, .comment-reply:hover{background: #007bff;}
.comment-delete:hover{background: #dc3545;}
.comment-level2{margin-left: 3rem;}
.btn-outline-success{border: 0; background: darkgray; border-radius: 3px; color: white;}
.btn-outline-success:hover{background: #007bff;}
.note-editor.note-frame{border: 1px solid #ced4da; width: 100%; height: 100%;} /*텍스트 에디터*/
.note-editable{height: 10rem;}

.fname{background: white; position: relative; bottom: 1.5rem; left: 4.6rem; padding-right:10rem;}
.deleteFileSpan{position: absolute; left: 2.4rem; bottom: 0.8rem;}
/* 답글 텍스트 */
form.comment-level2{margin: 1rem 0 1rem 7rem;}
.comment-submit-level2{border: 0; background: darkgray; border-radius: 3px; margin-right: .3rem; color: white; height: 2rem; width: 2.5rem}
.comment-submit-level2:hover{background: #007bff;}
div.level-2-border{border-bottom: 1px solid #e9ecef;}

</style>

<script>
$(()=>{
	
	$("[name=updateFile]").change(function(){
		console.log($(this).val());
		console.log($(".fname"));
		var filename = $(this).val();
		if($(this).val() != ""){
			console.log("zz");
	 		//$(".fname").hide();
	 		$(".fname").html(filename.substring(filename.lastIndexOf("\\")+1));
			$("#delFileChk").hide().next().hide();
		}else{
			$(".fname").show();
			console.log("aa");
			$("#delFileChk").show().next().show();
		}
	})
	
});

$(function(){
  // Summernote
  $('.textarea').summernote();
  
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
	
	$("#sidebar-notice").addClass("active");
}

function deleteChk(noticeNo){
	var result = confirm("게시글을 삭제하시겠습니까?"); 
	if(result == true){
		location.href = "${pageContext.request.contextPath}/notice/deleteNotice.do?noticeNo="+noticeNo;
	}
}

function deleteChkforCommu(commuNo){
	var result = confirm("게시글을 삭제하시겠습니까?"); 
	if(result == true){
		location.href = "${pageContext.request.contextPath}/notice/deleteCommunity.do?commuNo="+commuNo;
	}
}

//답글 클릭 시
/* function addLevel2(level1_id){
	var area_level1 = level1_id;
	alert(area_level1);
} */


//공지 댓글 삭제
function deleteNoticeComment(noticeCommentNo){
	if(!confirm("정말 삭제하시겠습니까?"))
		return;
	location.href = "${pageContext.request.contextPath}/notice/noticeCommentDelete.do?noticeCommentNo="+noticeCommentNo;
}

//게시판 댓글 삭제
function deleteCommunityComment(communityCommentNo){
	if(!confirm("정말 삭제하시겠습니까?"))
		return;
	location.href = "${pageContext.request.contextPath}/community/communityCommentDelete.do?communityCommentNo="+communityCommentNo;

}

//댓글 유효성 검사
function checkComment(commentContent){
	if(commentContent.trim() == 0){
		alert("댓글을 입력하지 않으셨습니다!");
		return false;
	}
	return true;
} 

</script>


<!-- #############주현 할 일############
[할 일]
#댓글 -> ajax? / 대댓글?#
@ - 관리자: 모든 게시물 수정/삭제 가능?
- 카드 내용 ...
- 이미지 없을 때 내용 가운데로?
- DB 내용 정리
- 상세보기 작성자 클릭 시 프로필 이동?
@ - **부서별공지, 자유게시판 작성자 이름으로
@ - 슬라이드 바 개수 맞추기!!
- 바가 헤더 앞으로 나옴 / 카드 호버시 안 움직임
@- 바 누르는 거 이상함
 -->
 
 <!-- @@
  공지 이름 / 아이콘 바꾸기  / 예외처리 -->

<!-- 효정 할 일
-수정 시, 기존파일 보이게 하기
 -->

<!-- Navbar NoticeList -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
  <!-- Left navbar links -->
  <!-- SEARCH FORM -->
  <form id="noticeSearchFrm" class="form-inline">
    <div class="input-group input-group-sm">
      <input class="form-control form-control-navbar" type="search" placeholder="공지 및 게시판 검색" aria-label="Search">
      <div class="input-group-append">
        <button class="btn btn-navbar" type="submit">
          <i class="fas fa-search"></i>
        </button>
      </div>
    </div>
  </form>

  <!-- Right navbar links -->
  <ul class="navbar-nav ml-auto navbar-nav-sort">
    <li class="nav-item dropdown">
      정렬
      <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#">
        업데이트순 <span class="caret"></span>
      </a>
      <div class="dropdown-menu">
        <a class="dropdown-item" tabindex="-1" href="#">업데이트순</a>
        <a class="dropdown-item" tabindex="-1" href="#">제목순</a>
      </div>
    </li>
  </ul>
</nav>
<!-- /.navbar -->		

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
  <h2 class="sr-only">공지 목록</h2>
  <!-- Main content -->
  <div class="content">
    <div class="container-fluid">
      <!-- 전체공지 -->
      <section class="notice-area">
        <div class="header-line">
          <h6><i class="fas fa-exclamation-circle"></i>&nbsp; 전체 공지 <span class="header-count">(${fn:length(noticeList)})</span>
              <i class="fas fa-plus-square" data-toggle="modal" data-target="#addNoticeModal" ${memberLoggedIn.jobTitle=='관리자'?'"style=display:block;"':"style=display:none;"}></i></h6>
        </div><!-- /.card-header -->
        <div id="notice_indicators" class="carousel slide" data-ride="carousel" data-interval="false">
          <ol class="carousel-indicators">
<!-- 		<li data-target="#notice_indicators" data-slide-to="0" class="active"></li>
			<li data-target="#notice_indicators" data-slide-to="1"></li>
            <li data-target="#notice_indicators" data-slide-to="2"></li> -->
          	<!-- 리스트 비어있지 않으면 첫 번째 바는 무조건 나옴 -->
          	<c:if test="${noticeList != null}">
	            <li data-target="#notice_indicators" data-slide-to="0" class="active"></li>
          	</c:if>
          	<!-- barCnt: 바개수 올림 (공지 개수/4 올림) -->
			<c:set var="noticeBarCnt" value="${fn:length(noticeList)/4}"/>
          	<c:forEach var="i" begin="1" end="${noticeBarCnt+(1-(noticeBarCnt%1))%1-1}" step="1">
	            <li data-target="#notice_indicators" data-slide-to="${i}"></li>
          	</c:forEach>
          </ol>
          <div class="carousel-inner">          
            <!-- row1 -->
            <c:forEach items="${noticeList }" var="n" varStatus="nvs">
            	<c:if test="${nvs.count == 1}">
              	<div class="row card-content carousel-item active">
          	</c:if>
          	<c:if test="${nvs.count % 4 == 1 && nvs.count != 1}">
              	<div class="row card-content carousel-item">
          	</c:if>
   	        <div class="col-12 col-sm-6 col-md-3">
   	          <div class="card">
   	            <!-- Default droprleft button -->
   	            <div class="dropleft">
   	              <button class="btn-moreMenu" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" ${memberLoggedIn.memberId == n.noticeWriter?"style = display:block;":"style = display:none;"}><i class="fas fa-ellipsis-v"></i></button>
   	              <div class="dropdown-menu">
   	                <a href="#" class="dropdown-item" data-toggle="modal" data-target="#updateNoticeModal${nvs.count}">공지 수정</a>
   	                <%-- <a href="${pageContext.request.contextPath}/notice/deleteNotice.do?noticeNo=${n.noticeNo}" class="dropdown-item">공지 삭제</a> --%>
   	              	<a href="javascript:void(0)" id="deleteChk" onclick="deleteChk(${n.noticeNo})" class="dropdown-item">공지 삭제</a>
   	              </div>
   	            </div>
   	            <div class="card-body" data-toggle="modal" data-target="#noticeViewModal${nvs.count}">
					<c:set var="nFileNameCnt" value="${fn:trim(n.noticeRenamedFileName)}"/>
			   	    <c:if test="${n.noticeRenamedFileName != null && fn:length(nFileNameCnt) != 0}">
	   	              <img src="${pageContext.request.contextPath}/resources/upload/notice/${n.noticeRenamedFileName}" class="card-img-top">
	   	            </c:if>
	   	              <h5 class="card-title">${n.noticeTitle }</h5>
	   	              <p class="card-text">${n.noticeContent }</p>
   	            </div>
   	          </div><!-- /.card -->
   	        </div>
            	<c:if test="${nvs.count % 4 == 0 || nvs.last}">
   				</div>
          	</c:if>
            </c:forEach>
          </div> <!-- /.carousel-inner notice-carousel  -->
          <!-- <a href="#notice_indicators" data-slide="prev"> -->
          <i class="fas fa-angle-left slide-arrow slide-arrow-left" data-target="#notice_indicators" data-slide="prev"></i>
          <!-- </a> -->
          <!-- <a href="#notice_indicators" data-slide="next"> -->
          <i class="fas fa-angle-right slide-arrow slide-arrow-right" data-target="#notice_indicators" data-slide="next"></i>
          <!-- </a> -->
        </div> <!--slide-->
      </section>

      <!-- 내가 속한 부서 공지 -->
      <!-- 로그인한 멤버의 부서대로 리스트 불러와 deptNoticeList라는 변수에 담겠다.-->
      <c:set var="deptNoticeList" value="${memberLoggedIn.deptCode=='D1'?planningDeptNoticeList:memberLoggedIn.deptCode=='D2'?designDeptNoticeList:developmentDeptNoticeList}"/>
      <section class="myDeptNotice-area">
        <div class="header-line" style="margin-top: 4rem;">
          <h6><span id="myDept"><i class="fas fa-user"></i> &nbsp;${memberLoggedIn.deptCode=='D1'?"기획":memberLoggedIn.deptCode=='D2'?"디자인":"개발" }</span>
              &nbsp; 내가 속한 부서의 공지 <span class="header-count">(${fn:length(deptNoticeList)})</span>
              <i class="fas fa-plus-square" data-toggle="modal" data-target="#addNoticeForDeptModal"></i></h6>
        </div><!-- /.card-header -->
        <div id="myDeptNotice_indicators" class="carousel slide" data-ride="carousel" data-interval="false">
          <ol class="carousel-indicators">
<!-- 	    <li data-target="#myDeptNotice_indicators" data-slide-to="0" class="active"></li>
           	<li data-target="#myDeptNotice_indicators" data-slide-to="1"></li>
            <li data-target="#myDeptNotice_indicators" data-slide-to="2"></li> -->
            
            <!-- 리스트 비어있지 않으면 첫 번째 바는 무조건 나옴 -->
          	<c:if test="${deptNoticeList != null}">
	            <li data-target="#myDeptNotice_indicators" data-slide-to="0" class="active"></li>
          	</c:if>
          	<!-- barCnt: 바개수 올림 (공지 개수/4 올림) -->
			<c:set var="deptNoticeBarCnt" value="${fn:length(deptNoticeList)/4}"/>
          	<c:forEach var="i" begin="1" end="${deptNoticeBarCnt+(1-(deptNoticeBarCnt%1))%1-1}" step="1">
	            <li data-target="#myDeptNotice_indicators" data-slide-to="${i}"></li>
          	</c:forEach>
          </ol>
          <div class="carousel-inner">
            <c:forEach items="${deptNoticeList}" var="deptn" varStatus="deptnvs">
	            <c:if test="${deptnvs.count == 1}">
	              	<div class="row card-content carousel-item active">
	          	</c:if>
	          	<c:if test="${deptnvs.count % 4 == 1 && deptnvs.count != 1}">
	              	<div class="row card-content carousel-item">
	          	</c:if>
	   	        <div class="col-12 col-sm-6 col-md-3">
	   	          <div class="card">
	   	            <!-- Default droprleft button -->
	   	            <div class="dropleft">
	   	              <button class="btn-moreMenu" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" ${memberLoggedIn.memberId==deptn.noticeWriter || memberLoggedIn.memberId=='admin'?"style=display:block;":"style=display:none;"}><i class="fas fa-ellipsis-v"></i></button>
	   	              <div class="dropdown-menu">
	   	                <a href="#" class="dropdown-item" data-toggle="modal" data-target="#updateDeptNoticeModal${deptnvs.count}">공지 수정</a>
	   	                <%-- <a href="${pageContext.request.contextPath}/notice/deleteNotice.do?noticeNo=${deptn.noticeNo}" class="dropdown-item">공지 삭제</a> --%>
	   	                <a href="javascript:void(0)" id="deleteChk" onclick="deleteChk(${deptn.noticeNo})" class="dropdown-item">공지 삭제</a>
	   	              </div>
	   	            </div>
	   	            <div class="card-body" data-toggle="modal" data-target="#myDeptNoticeViewModal${deptnvs.count}">
	   	           	  <c:set var="deptnFileNameCnt" value="${fn:trim(deptn.noticeRenamedFileName)}"/>
		   	          <c:if test="${deptn.noticeRenamedFileName != null && fn:length(deptnFileNameCnt) != 0}">
		   	            <img src="${pageContext.request.contextPath}/resources/upload/notice/${deptn.noticeRenamedFileName}" class="card-img-top">
					  </c:if>
	   	              <h5 class="card-title">${deptn.noticeTitle }</h5>
	   	              <p class="card-text">${deptn.noticeContent }</p>
	   	            </div>
	   	          </div><!-- /.card -->
	   	        </div>
	            <c:if test="${deptnvs.count % 4 == 0 || deptnvs.last}">
	   				</div>
	          	</c:if>
            </c:forEach>
          </div> <!--/.carousel inner-->
          <!-- <a href="#notice_indicators" data-slide="prev"> -->
          <i class="fas fa-angle-left slide-arrow slide-arrow-left" data-target="#myDeptNotice_indicators" data-slide="prev"></i>
          <!-- </a> -->
          <!-- <a href="#notice_indicators" data-slide="next"> -->
          <i class="fas fa-angle-right slide-arrow slide-arrow-right" data-target="#myDeptNotice_indicators" data-slide="next"></i>
          <!-- </a> -->
        </div> <!--slide-->
      </section>

      <!-- 자유게시판 -->
      <section class="board-area">
        <div class="header-line" style="margin-top: 4rem;">
          <h6><i class="fas fa-sticky-note"></i>&nbsp; 자유게시판 <span class="header-count">(${fn:length(communityList)})</span>
              <i class="fas fa-plus-square" data-toggle="modal" data-target="#addBoardModal"></i></h6>
        </div><!-- /.card-header -->
        <div id="board_indicators" class="carousel slide" data-ride="carousel" data-interval="false">
          <ol class="carousel-indicators">
<!--             <li data-target="#board_indicators" data-slide-to="0" class="active"></li>
            <li data-target="#board_indicators" data-slide-to="1"></li>
            <li data-target="#board_indicators" data-slide-to="2"></li> -->
          	<!-- 리스트 비어있지 않으면 첫 번째 바는 무조건 나옴 -->
          	<c:if test="${communityList != null}">
	            <li data-target="#board_indicators" data-slide-to="0" class="active"></li>
          	</c:if>
          	<!-- barCnt: 바개수 올림 (공지 개수/4 올림) -->
			<c:set var="boardBarCnt" value="${fn:length(communityList)/4}"/>
          	<c:forEach var="i" begin="1" end="${boardBarCnt+(1-(boardBarCnt%1))%1-1}" step="1">
	            <li data-target="#board_indicators" data-slide-to="${i}"></li>
          	</c:forEach>
          </ol>
          <div class="carousel-inner">
            <!-- row1 -->
            <c:forEach items="${communityList}" var="c" varStatus="cvs">
	            <c:if test="${cvs.count == 1}">
	              	<div class="row card-content carousel-item active">
	          	</c:if>
	          	<c:if test="${cvs.count % 4 == 1 && cvs.count != 1}">
	              	<div class="row card-content carousel-item">
	          	</c:if>
	   	        <div class="col-12 col-sm-6 col-md-3">
	   	          <div class="card">
	   	            <!-- Default droprleft button -->
	   	            <div class="dropleft">
	   	              <button class="btn-moreMenu" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" ${memberLoggedIn.memberId==c.commuWriter || memberLoggedIn.memberId=='admin'?"style=display:block;":"style=display:none;"}><i class="fas fa-ellipsis-v"></i></button>
	   	              <div class="dropdown-menu">
	   	                <a href="#" class="dropdown-item" data-toggle="modal" data-target="#updateCommuModal${cvs.count}">게시글 수정</a>
	   	                <%-- <a href="${pageContext.request.contextPath}/notice/deleteCommunity.do?commuNo=${c.commuNo}" class="dropdown-item">게시글 삭제</a> --%>
	   	                <a href="javascript:void(0)" id="deleteChk" onclick="deleteChkforCommu(${c.commuNo})" class="dropdown-item">게시글 삭제</a>
	   	              </div>
	   	            </div>
	   	            <div class="card-body" data-toggle="modal" data-target="#boardViewModal${cvs.count}">
	   	           	  <c:set var="cFileNameCnt" value="${fn:trim(c.commuRenamedFileName)}"/>
		   	          <c:if test="${c.commuRenamedFileName != null && fn:length(cFileNameCnt) != 0}">
		   	            <img src="${pageContext.request.contextPath}/resources/upload/community/${c.commuRenamedFileName}" class="card-img-top">
					  </c:if>
	   	              <h5 class="card-title">${c.commuTitle }</h5>
	   	              <p class="card-text">${c.commuContent }</p>
	   	            </div>
	   	          </div><!-- /.card -->
	   	        </div>
	            <c:if test="${cvs.count % 4 == 0 || cvs.last}">
	   				</div>
	          	</c:if>
            </c:forEach>
          </div> <!--/.carousel-inner-->
          <a href="#board_indicators" data-slide="prev">
            <i class="fas fa-angle-left slide-arrow slide-arrow-left"></i>
          </a>
          <a href="#board_indicators" data-slide="next">
            <i class="fas fa-angle-right slide-arrow slide-arrow-right"></i>
          </a>
        </div> <!--slide-->
      </section>

    </div><!-- /.container-fluid -->
  </div><!-- /.content -->
</div>
<!-- /.content-wrapper -->


<jsp:include page="/WEB-INF/views/notice/noticeModal.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>