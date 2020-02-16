<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<style>
.btn-drop{
    background-color:transparent;  
    border:0px transparent solid;

}
.navbar-project .dropdown-menu{min-width: 6rem;}
#noticeSearchFrm{margin: 15px 1rem 15px;}
#tbl-projectAttach.table.member-table td{padding: .5rem 0;}
#tbl-projectAttach.member-table img{display: inline-block; width: 40px; height: auto;}
.btn-admin{width: 45px; margin: 0 auto; font-size: .7rem;}
#tbl-projectAttach.member-table .dropdown-item{color: #464c59;}
.content-wrapper>.content.mem-table{padding-top: 2rem;}
.btn-outline-info:hover{background-color: rgba(0,0,0,.075); color: #17a2b8;}
</style>

<script>
$(function(){
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
	
	$("#sidebar-member").addClass("active");
}
</script>	

<!-- Navbar Member -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
    <!-- Left navbar links -->
    <!-- SEARCH FORM -->
    <form id="noticeSearchFrm" class="form-inline">
        <div class="input-group input-group-sm">
        <input class="form-control form-control-navbar" type="search" placeholder="멤버 검색하기" aria-label="Search">
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
            이름순 <span class="caret"></span>
        </a>
        <div class="dropdown-menu">
            <a class="dropdown-item" tabindex="-1" href="#">이름순</a>
            <a class="dropdown-item" tabindex="-1" href="#">부서순</a>
            <a class="dropdown-item" tabindex="-1" href="#">직급순</a>
        </div>
        </li>
    </ul>
</nav>
<!-- /.navbar -->

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <h2 class="sr-only">멤버 보기</h2>
    <!-- Main content -->
    <section class="content mem-table">
        <!-- Default box -->
        <div class="card">
            <div class="card-body table-responsive p-0">
                <table id="tbl-projectAttach" class="table table-hover text-nowrap member-table">
                    <thead>
                        <tr>
                            <th style="width: 8%"></th>
                            <th style="width: 22%">이름</th>
                            <th style="width: 17%">직급</th>
                            <th style="width: 17%">부서</th>
                            <th style="width: 26%">이메일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <!-- 관리자일 때만 -->
                                <button type="button" class="btn btn-block btn-outline-info btn-xs btn-admin">관리자</button>
                            </td>
                            <td>
                                <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                                박서준
                            </td>
                            <td>디자인팀</td>
                            <td>팀장</td>
                            <td>
                                skefwe@naver.com
                                <!-- 권한 이전 버튼: 대표 관리자한테만 보이기 -->
                                <div class="dropdown">
                                    <button type="button" class="btn-moreMenu btn-drop btn-file" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fas fa-ellipsis-v"></i></button>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <a href="#" class="dropdown-item"><i class="fas fa-users"></i> 관리자로 변경</a>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <!-- <button type="button" class="btn btn-block btn-outline-info btn-xs btn-admin">관리자</button> -->
                            </td>
                            <td>
                                <img src="${pageContext.request.contextPath}/resources/img/profile.jfif" alt="User Avatar" class="img-circle img-profile ico-profile">
                                차은우
                            </td>
                            <td>개발팀</td>
                            <td>사원</td>
                            <td>
                                cccc@naver.com
                                <!-- 권한 이전 버튼 -->
                                <div class="dropdown">
                                    <button type="button" class="btn-moreMenu btn-drop btn-file" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fas fa-ellipsis-v"></i></button>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <a href="#" class="dropdown-item"><i class="fas fa-users"></i> 관리자로 변경</a>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>    
            </div>
        </div>
        <!-- /.card -->
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->		

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>