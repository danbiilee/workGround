<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<style>
.btn-drop{background-color:transparent; border:0px transparent solid;}
.navbar-project .dropdown-menu{min-width: 6rem;}
#tbl-projectAttach.table.member-table td{padding: .5rem 0;}
#tbl-projectAttach.member-table img{display: inline-block; width: 40px; height: auto; margin-right: .3rem;}
.btn-admin{width: 45px !important; margin: 0 auto; font-size: .7rem;}
#tbl-projectAttach.member-table .dropdown-item{color: #dc3545; font-size: .8rem;}
#tbl-projectAttach.member-table .dropdown-item i{margin-right: .3rem;}
.comment-reply.work-comment-reply.float-right{border: 0;background: darkgray;border-radius: 3px;margin-right: .3rem;color: white;}
.comment-reply.work-comment-reply.float-right:hover{background:#dc3545;}
.comment-delete.work-comment-delete.float-right{border: 0;background: darkgray;border-radius: 3px;margin-right: .3rem;color: white}
.comment-delete.work-comment-delete.float-right:hover{background:#17a2b8;}
</style>

<script>
$(function(){
	//데이터 테이블 설정
	$('#tbl-projectAttach').DataTable({
        "paging": true,
        "lengthChange": false,
        "searching": false,
        "ordering": true,
        "info": false,
        "autoWidth": false,
    });
	
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

//멤버 프로필 페이지로 이동
function goMemberProfile(memberId){
    location.href = '${pageContext.request.contextPath}/member/memberView.do?memberId='+memberId;
}

function deleteChk(commuNo){
	var result = confirm("게시글을 삭제하시겠습니까?"); 
	if(result == true){
		location.href = "${pageContext.request.contextPath}/notice/deleteCommunity.do?commuNo="+commuNo;
	}
}
</script>	


<!-- Content Wrapper. Contains page content -->
<div id="member-list" class="content-wrapper">
    <!-- Main content -->
    <section class="content">
        <h2 style="margin-bottom: 1.4rem;">커뮤니티</h2>
        
        <button class="btn btn-block btn-outline-secondary" style="width:4rem; height:2rem; font-size:.8rem;margin-left: 58rem;" data-toggle="modal" data-target="#addBoardModal">글쓰기</button>
        <div id="member-inner" class="table-responsive p-0">
           
            <!-- 멤버리스트 -->
            <table id="tbl-projectAttach" class="table table-hover text-nowrap member-table">
                <thead>
                    <tr>
                        <th style="width: 30%">제목</th>
                        <th style="width: 17%">작성자</th>
                        <th style="width: 17%">작성날짜</th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach items="${communityList}" var="c">
                    <tr>
                        <td style="padding-left: 1.3rem;" data-toggle="modal" data-target="#boardViewModal${c.commuNo}">${c.commuTitle}</td>
                        <td onclick="goMemberProfile('${c.commuWriter}');">${c.memberName}</td>
                        <td>
                            ${c.commuDate}
                            <button class="comment-reply work-comment-reply float-right" onclick="deleteChk(${c.commuNo})">삭제</button>
                            <button class="comment-delete work-comment-delete float-right" data-toggle="modal" data-target="#updateCommuModal${c.commuNo}">수정</button>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>    
        </div>
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->		

<jsp:include page="/WEB-INF/views/notice/noticeModal.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>