<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 

<!-- 전체 공지 상세보기 모달 -->
<c:forEach items="${noticeList}" var="n" varStatus="nvs">
	<div class="modal fade" id="noticeViewModal${nvs.count}" tabindex="-1" role="dialog" aria-labelledby="noticeViewModalLabel${nvs.count }" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title"><i class="fas fa-exclamation-circle"></i>&nbsp; 전체 공지</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	        <div class="noticeView">
	          <p class="view-title">${n.noticeTitle}</p>
	          <div style="font-size: .8rem; color: gray; margin-bottom: .5rem;">게시일 ${n.noticeDate}</div>
	            <div class="view-body">
					<c:set var="nFileNameCnt" value="${fn:trim(n.noticeRenamedFileName)}"/>
			   	    <c:if test="${n.noticeRenamedFileName != null && fn:length(nFileNameCnt) != 0}">
	   	              <img class="view-img" src="${pageContext.request.contextPath}/resources/upload/notice/${n.noticeRenamedFileName}">
	   	            </c:if>
	              <p class="view-content">${n.noticeContent}</p>
	            </div>
	            <!-- /.view-body -->
	            <div class="comment-count"><i class="fas fa-comments"></i>&nbsp; 댓글 <span>(${fn:length(n.noticeCommentList)})</span></div>
	            <div class="card-footer card-comments">
 	            	<c:forEach items="${n.noticeCommentList}" var="nc">
	            		<c:if test="${nc.noticeCommentLevel == 1}">
			              <div class="card-comment comment-level1">
<%-- 			              <div class="card-comment comment-level1" id="level1area${nvs.count}"> --%>
			                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${nc.commentWriterProfile}" alt="User Image">
			                <div class="comment-text">
			                  <span class="username">${nc.commentWriterName}<span class="text-muted float-right">${nc.noticeCommentDate}</span></span>
			                  <span>${nc.noticeCommentContent}</span>
			                  <c:if test="${memberLoggedIn.memberId == 'admin' || memberLoggedIn.memberId == nc.noticeCommentWriter}">
				                  <button class="comment-delete float-right" onclick="deleteNoticeComment(${nc.noticeCommentNo});">삭제</button>
			                  </c:if>
			                  <%-- <button class="comment-reply float-right" onclick="addLevel2('level1area${nvs.count}');">답글</button> --%>
			                </div>
			              </div>
			        
<%-- 			      <div class="level-2-border">
	   	              <form action="${pageContext.request.contextPath}/notice/noticeCommentInsert.do" 
		              		method="post"
		              		onsubmit="return insertNoticeComment(noticeCommentContent.value);"
		              		class="comment-level2">
				          <div class="img-push">
				            <input type="hidden" name="noticeRef" value="${n.noticeNo}" />
				            <input type="hidden" name="noticeCommentWriter" value="${memberLoggedIn.memberId }"/>
				            <input type="hidden" name="noticeCommentLevel" value="1" />
				            <input type="hidden" name="noticeCommentRef" value="0" />
				            <input type="text" name="noticeCommentContent" class="form-control form-control-sm comment-text-area" placeholder="댓글을 입력하세요."/>
				            <input type="submit" value="등록" class="comment-submit-level2 float-right"/>
				          </div>
		              </form>
			      </div>  --%>       
			              
			              <c:forEach items="${n.noticeCommentList}" var="nc2">
			              	<c:if test="${nc2.noticeCommentLevel == 2 && nc2.noticeCommentRef == nc.noticeCommentNo}">
				              <div class="card-comment comment-level2">
				                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${nc2.commentWriterProfile}" alt="User Image">
				                <div class="comment-text">
				                  <span class="username">${nc2.commentWriterName}<span class="text-muted float-right">${nc2.noticeCommentDate}</span></span>
				                  <span>${nc2.noticeCommentContent}</span>
				                  <c:if test="${memberLoggedIn.memberId == 'admin' || memberLoggedIn.memberId == nc2.noticeCommentWriter}">
					                  <button class="comment-delete float-right" onclick="deleteNoticeComment(${nc2.noticeCommentNo});">삭제</button>
					              </c:if>
				                  <!-- <button class="comment-reply float-right">답글</button> -->
				                </div>
				              </div>
			              	</c:if>
			              </c:forEach>
	            		</c:if>
	                </c:forEach>
	            </div>
	             <div class="card-footer">
 	              <form action="${pageContext.request.contextPath}/notice/noticeCommentInsert.do" 
	              		method="post"
	              		onsubmit="return checkComment(noticeCommentContent.value);">
	                <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${memberLoggedIn.renamedFileName}">
	                <div class="img-push">
	                  <input type="hidden" name="noticeRef" value="${n.noticeNo}" />
	                  <input type="hidden" name="noticeCommentWriter" value="${memberLoggedIn.memberId }"/>
	                  <input type="hidden" name="noticeCommentLevel" value="1" />
	                  <input type="hidden" name="noticeCommentRef" value="0" />
	                  <input type="text" name="noticeCommentContent" class="form-control form-control-sm comment-text-area" placeholder="댓글을 입력하세요."/>
	                  <input class="comment-submit" type="submit" value="등록" />
	                </div>
	              </form>
	            </div> <!-- /.card-footer -->
	            <!-- 에이젝스: 실패 -->
	          </div> <!-- /.card -->
	      </div>
	    </div>
	  </div>
	</div>
</c:forEach>


<!-- 부서별 공지 상세보기 모달 -->
<c:forEach items="${memberLoggedIn.deptCode=='D1'?planningDeptNoticeList:memberLoggedIn.deptCode=='D2'?designDeptNoticeList:developmentDeptNoticeList}" var="deptn" varStatus="deptnvs">
	<div class="modal fade" id="myDeptNoticeViewModal${deptnvs.count}" tabindex="-1" role="dialog" aria-labelledby="myDeptNoticeViewModalLabel${deptnvs.count}" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title"><span id="myDept"><i class="fas fa-user"></i> &nbsp;${memberLoggedIn.deptCode=='D1'?"기획":memberLoggedIn.deptCode=='D2'?"디자인":"개발" }</span>&nbsp; 부서별 공지</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	        <div class="deptNoticeView">
	          <p class="view-title">${deptn.noticeTitle}</p>
	          <div class="user-block" style="margin-bottom: .5rem;">
	            <img class="img-circle" src="${pageContext.request.contextPath}/resources/img/profile/${deptn.renamedFileName}" alt="User Image">
	            <span class="username"><a href="#" style="color: black;">작성자 ${deptn.memberName}</a></span>
	            <span class="description">게시일 ${deptn.noticeDate}</span>
	          </div>
	            <div class="view-body">
	   	           	<c:set var="deptnFileNameCnt" value="${fn:trim(deptn.noticeRenamedFileName)}"/>
		   	        <c:if test="${deptn.noticeRenamedFileName != null && fn:length(deptnFileNameCnt) != 0}">
		   	          <img class="view-img" src="${pageContext.request.contextPath}/resources/upload/notice/${deptn.noticeRenamedFileName}">
					</c:if>
	              <p class="view-content">${deptn.noticeContent}</p>
	            </div>
	            <!-- /.view-body -->
	            <div class="comment-count"><i class="fas fa-comments"></i>&nbsp; 댓글 <span>(${fn:length(deptn.noticeCommentList)})</span></div>
	            <div class="card-footer card-comments">
	            	<c:forEach items="${deptn.noticeCommentList}" var="deptnc">
	            		<c:if test="${deptnc.noticeCommentLevel == 1}">
			              <div class="card-comment comment-level1">
			                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${deptnc.commentWriterProfile}" alt="User Image">
			                <div class="comment-text">
			                  <span class="username">${deptnc.commentWriterName}<span class="text-muted float-right">${deptnc.noticeCommentDate}</span></span>
			                  <span>${deptnc.noticeCommentContent}</span>
			                  <c:if test="${memberLoggedIn.memberId == 'admin' || memberLoggedIn.memberId == deptnc.noticeCommentWriter}">
				                  <button class="comment-delete float-right" onclick="deleteNoticeComment(${deptnc.noticeCommentNo});">삭제</button>
			                  </c:if>
			                  <!-- <button class="comment-reply float-right">답글</button> -->
			                </div>
			              </div>
			              
			              <c:forEach items="${deptn.noticeCommentList}" var="deptnc2">
			              	<c:if test="${deptnc2.noticeCommentLevel == 2 && deptnc2.noticeCommentRef == deptnc.noticeCommentNo}">
				              <div class="card-comment comment-level2">
				                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${deptnc2.commentWriterProfile}" alt="User Image">
				                <div class="comment-text">
				                  <span class="username">${deptnc2.commentWriterName}<span class="text-muted float-right">${deptnc2.noticeCommentDate}</span></span>
				                  <span>${deptnc2.noticeCommentContent}</span>
				                  <c:if test="${memberLoggedIn.memberId == 'admin' || memberLoggedIn.memberId == deptnc2.noticeCommentWriter}">
					                  <button class="comment-delete float-right" onclick="deleteNoticeComment(${deptnc2.noticeCommentNo});">삭제</button>
					              </c:if>
				                  <!-- <button class="comment-reply float-right">답글</button> -->
				                </div>
				              </div>
							</c:if>
						  </c:forEach>
	            		</c:if>
	            	</c:forEach>
	            </div>
	             <div class="card-footer">
 	              <form action="${pageContext.request.contextPath}/notice/noticeCommentInsert.do" 
	              		method="post"
	              		onsubmit="return checkComment(noticeCommentContent.value);">
	                <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${memberLoggedIn.renamedFileName}">
	                <div class="img-push">
	                  <input type="hidden" name="noticeRef" value="${deptn.noticeNo}" />
	                  <input type="hidden" name="noticeCommentWriter" value="${memberLoggedIn.memberId }"/>
	                  <input type="hidden" name="noticeCommentLevel" value="1" />
	                  <input type="hidden" name="noticeCommentRef" value="0" />
	                  <input type="text" name="noticeCommentContent" class="form-control form-control-sm comment-text-area" placeholder="댓글을 입력하세요."/>
	                  <input class="comment-submit" type="submit" value="등록" />
	                </div>
	              </form>
	            </div> <!-- /.card-footer -->
	          </div> <!-- /.card -->
	      </div>
	    </div>
	  </div>
	</div>
</c:forEach>


<!-- 게시판 상세보기 모달 -->
<c:forEach items="${communityList}" var="c" varStatus="cvs">
	<div class="modal fade" id="boardViewModal${cvs.count}" tabindex="-1" role="dialog" aria-labelledby="boardModalLabel${cvs.count }" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title"><i class="fas fa-sticky-note"></i>&nbsp; 자유게시판</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	        <div class="boardView">
	          <p class="view-title">${c.commuTitle }</p>
	          <div class="user-block" style="margin-bottom: .5rem;">
	          	<img class="img-circle" src="${pageContext.request.contextPath}/resources/img/profile/${c.renamedFileName}" alt="User Image">
	            <span class="username"><a href="#" style="color: black;">작성자 ${c.memberName }</a></span>
	            <span class="description">게시일 ${c.commuDate }</span>
	          </div>
	            <div class="view-body">
	   	           	<c:set var="cFileNameCnt" value="${fn:trim(c.commuRenamedFileName)}"/>
		   	        <c:if test="${c.commuRenamedFileName != null && fn:length(cFileNameCnt) != 0}">
		   	          <img class="view-img" src="${pageContext.request.contextPath}/resources/upload/community/${c.commuRenamedFileName}" alt="">
					</c:if>
	              <p class="view-content">${c.commuContent }</p>
	            </div>
	            <!-- /.view-body -->
	            <div class="comment-count"><i class="fas fa-comments"></i>&nbsp; 댓글 <span>(${fn:length(c.communityCommentList)})</span></div>
	            <div class="card-footer card-comments">
 	            	<c:forEach items="${c.communityCommentList}" var="cc">
	            		<c:if test="${cc.commuCommentLevel == 1}">
			              <div class="card-comment comment-level1">
			                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${cc.commentWriterProfile}" alt="User Image">
			                <div class="comment-text">
			                  <span class="username">${cc.commentWriterName}<span class="text-muted float-right">${cc.commuCommentDate}</span></span>
			                  <span>${cc.commuCommentContent}</span>
			                  <c:if test="${memberLoggedIn.memberId == 'admin' || memberLoggedIn.memberId == cc.commuCommentWriter}">
				                  <button class="comment-delete float-right" onclick="deleteCommunityComment(${cc.commuCommentNo});">삭제</button>
			                  </c:if>
			                  <!-- <button class="comment-reply float-right">답글</button> -->
			                </div>
			              </div>
			              <c:forEach items="${c.communityCommentList}" var="cc2">
			              	<c:if test="${cc2.commuCommentLevel == 2 && cc2.commuCommentRef == cc.commuCommentNo}">
				              <div class="card-comment comment-level2">
				                <img class="img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${cc2.commentWriterProfile}" alt="User Image">
				                <div class="comment-text">
				                  <span class="username">${cc2.commentWriterName}<span class="text-muted float-right">${cc2.commuCommentDate}</span></span>
				                  <span>${cc2.commuCommentContent}</span>
				                  <c:if test="${memberLoggedIn.memberId == 'admin' || memberLoggedIn.memberId == cc2.commuCommentWriter}">
					                  <button class="comment-delete float-right" onclick="deleteCommunityComment(${cc2.commuCommentNo});">삭제</button>
					              </c:if>
				                  <!-- <button class="comment-reply float-right">답글</button> -->
				                </div>
				              </div>
			              	</c:if>
			              </c:forEach>
	            		</c:if>
	            	</c:forEach>
	            </div>
	             <div class="card-footer">
 	              <form action="${pageContext.request.contextPath}/community/communityCommentInsert.do" 
	              		method="post"
	              		onsubmit="return checkComment(commuCommentContent.value);">
	                <img class="img-fluid img-circle img-sm" src="${pageContext.request.contextPath}/resources/img/profile/${memberLoggedIn.renamedFileName}">
	                <div class="img-push">
	                  <input type="hidden" name="commuRef" value="${c.commuNo}" />
	                  <input type="hidden" name="commuCommentWriter" value="${memberLoggedIn.memberId }"/>
	                  <input type="hidden" name="commuCommentLevel" value="1" />
	                  <input type="hidden" name="commuCommentRef" value="0" />
	                  <input type="text" name="commuCommentContent" class="form-control form-control-sm comment-text-area" placeholder="댓글을 입력하세요."/>
	                  <input class="comment-submit" type="submit" value="등록" />
	                </div>
	              </form>
	            </div> <!-- /.card-footer -->
	          </div> <!-- /.card -->
	      </div>
	    </div>
	  </div>
	</div>
</c:forEach>


<!-- 공지 추가 모달 -->
<!-- 관리자: 전체/부서별 공지 작성 가능 -->
<!-- 부서별: 자기 부서는 selected / 나머지 부서 disabled -->
<div class="modal fade" id="addNoticeModal" tabindex="-1" role="dialog" aria-labelledby="addNoticeModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 공지 작성</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="${pageContext.request.contextPath}/notice/noticeFormEnd.do"
      		method="post"
      		enctype="multipart/form-data">
        <div class="modal-body">
          <div class="addNotice" style="padding: 1rem;">
            <div class="form-group">
              <label for="inputDept">부서</label>
              <select class="form-control custom-select" name="deptCode">
                 <option value="all" selected>전체</option>
				<option value="D1">기획부</option>
                <option value="D2">디자인부</option>
                <option value="D3">개발부</option>
              </select>
            </div>
            <div class="form-group">
              <label for="inputName">공지 제목</label>
              <input type="text" id="inputName" name="noticeTitle" class="form-control" required>
            </div>
            <div class="form-group" style="display:none;">
              <label for="inputName">글쓴이</label>
              <input type="text" id="inputName" name="noticeWriter" value="${memberLoggedIn.memberId}" class="form-control">
            </div>
            <!-- <div class="form-group">
              <label for="inputDescription">공지 카드 내용</label>
              <input type="text" class="form-control" maxlength="35" placeholder="35자 이내로 입력하세요.">
            </div> -->
            <div class="form-group">
              <label for="inputDescription">공지 내용</label>
              <textarea class="textarea" name="noticeContent" required></textarea>
            </div>
            <div class="form-group">
              <label for="exampleFormControlFile1">파일 첨부</label>
              <input type="file" class="form-control-file" id="exampleFormControlFile1" name="upFile">
            </div>
          </div><!-- /.card-body -->
        </div> <!--/.modal-body-->
        <div class="modal-footer">
          <button type="submit" class="btn btn-outline-success">작성</button>
          <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 내가 속한 부서의 공지 추가 모달 -->
<!-- 관리자: 전체/부서별 공지 작성 가능 -->
<!-- 부서별: 자기 부서는 selected / 나머지 부서 disabled -->
<div class="modal fade" id="addNoticeForDeptModal" tabindex="-1" role="dialog" aria-labelledby="addNoticeForDeptModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 공지 작성</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="${pageContext.request.contextPath}/notice/noticeFormEnd.do"
      		method="post"
      		enctype="multipart/form-data">
        <div class="modal-body">
          <div class="addNotice" style="padding: 1rem;">
            <div class="form-group">
              <label for="inputDept">부서</label>
              <select class="form-control custom-select" name="deptCode" ${memberLoggedIn.jobTitle=='관리자'?'"style=display:block;"':"style=display:none;"}>
                <option value="all" selected>전체</option>
				<option value="D1" ${memberLoggedIn.deptCode=='D1'?'selected="selected"':''}>기획부</option>
                <option value="D2" ${memberLoggedIn.deptCode=='D2'?'selected="selected"':''}>디자인부</option>
                <option value="D3" ${memberLoggedIn.deptCode=='D3'?'selected="selected"':''}>개발부</option>
              </select>
              <input type="text" class="form-control"
              		 ${memberLoggedIn.jobTitle=='관리자'?"style=display:none;":"style=display:block;"} 
              		 value="${memberLoggedIn.deptCode=='D1'?'기획부':memberLoggedIn.deptCode=='D2'?'디자인부':'개발부'}"
              		 readonly/>
            </div>
            <div class="form-group">
              <label for="inputName">공지 제목</label>
              <input type="text" id="inputName" name="noticeTitle" class="form-control" required>
            </div>
            <div class="form-group" style="display:none;">
              <label for="inputWriter">글쓴이</label>
              <input type="text" id="inputName" name="noticeWriter" value="${memberLoggedIn.memberId}" class="form-control">
            </div>
            <!-- <div class="form-group">
              <label for="inputDescription">공지 카드 내용</label>
              <input type="text" class="form-control" maxlength="35" placeholder="35자 이내로 입력하세요.">
            </div> -->
            <div class="form-group">
              <label for="inputDescription">공지 내용</label>
              <textarea class="textarea" name="noticeContent" required></textarea>
            </div>
            <div class="form-group">
              <label for="exampleFormControlFile1">파일 첨부</label>
              <input type="file" class="form-control-file" id="exampleFormControlFile1" name="upFile">
            </div>
          </div><!-- /.card-body -->
        </div> <!--/.modal-body-->
        <div class="modal-footer">
          <button type="submit" class="btn btn-outline-success">작성</button>
          <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
        </div>
      </form>
    </div>
  </div>
</div>
<!-- 게시판 추가 모달 -->
<div class="modal fade" id="addBoardModal" tabindex="-1" role="dialog" aria-labelledby="addBoardModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 게시글 작성</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <form action="${pageContext.request.contextPath}/notice/communityFormEnd.do"
      		method="post"
      		enctype="multipart/form-data">
          <div class="modal-body">
              <div class="addNotice" style="padding: 1rem;">
                <div class="form-group">
                  <label for="inputName">게시글 제목</label>
                  <input type="text" id="inputName" name="commuTitle" class="form-control" maxlength="15" placeholder="15자 이내로 입력하세요." required>
                </div>
                <div class="form-group" style="display:none;">
             		<label for="inputWriter">글쓴이</label>
              		<input type="text" id="inputName" name="commuWriter" value="${memberLoggedIn.memberId}" class="form-control">
            	</div>
                <!-- <div class="form-group">
                  <label for="inputDescription">게시글 카드 내용</label>
                  <input type="text" class="form-control" maxlength="35" placeholder="35자 이내로 입력하세요.">
                </div> -->
                <div class="form-group">
                  <label for="inputDescription">게시글 내용</label>
                  <textarea class="textarea" name="commuContent" required></textarea>
                </div>
                <div class="form-group">
                  <label for="exampleFormControlFile1">파일 첨부</label>
                  <input type="file" class="form-control-file" id="exampleFormControlFile1" name="upFile">
                </div>
              </div><!-- /.card-body -->
          </div> <!--/.modal-body-->
          <div class="modal-footer">
            <button type="submit" class="btn btn-outline-success">작성</button>
            <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
          </div>
        </form>
      </div>
    </div>
</div>

<!-- 공지수정 모달 -->
<!-- 관리자: 전체공지만 수정 / 부서별공지는 내가속한 부서에서 수정 -->
<!-- 부서별 옵션: 내가속한 부서만 selected 그 외엔 disabled -->
<c:forEach items="${noticeList}" var="n" varStatus="nvs">
	<div class="modal fade" id="updateNoticeModal${nvs.count}" tabindex="-1" role="dialog" aria-labelledby="updateNoticeModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 공지 수정</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <form action="${pageContext.request.contextPath}/notice/updateNotice.do?noticeNo=${n.noticeNo}"
      			method="post"
      			enctype="multipart/form-data">
	        <div class="modal-body">
	            <div class="addNotice" style="padding: 1rem;">
	              <div class="form-group">
	                <label for="inputDept">부서</label>
	                <select class="form-control custom-select" name="deptCode">
	                 	<option value="all" selected>전체</option>
						<option value="D1">기획부</option>
		                <option value="D2">디자인부</option>
		                <option value="D3">개발부</option>
              	  	</select>
	              </div>
	              <div class="form-group">
	                <label for="inputName">공지 제목</label>
	                <input type="text" id="inputName" class="form-control" value="${n.noticeTitle}" name="noticeTitle" required>
	              </div>
	              <div class="form-group" style="display:none;">
		              <label for="inputWriter">글쓴이</label>
		              <input type="text" id="inputName" name="noticeWriter" value="${memberLoggedIn.memberId}" class="form-control">
            	  </div>
	              <!-- <div class="form-group">
	                <label for="inputDescription">공지 카드 내용</label>
	                <input type="text" class="form-control" maxlength="35" placeholder="35자 이내로 입력하세요." value="파이널 프로젝트가 본격적으로 시작되었습니다! 다들 화이팅!">
	              </div> -->
	              <div class="form-group">
	                <label for="inputDescription">공지 내용</label>
	                <textarea class="textarea" name="noticeContent" required>${n.noticeContent}</textarea>
	              </div>
	              <div class="form-group">
	                <label for="exampleFormControlFile1">파일 첨부</label>
	                <input type="file" class="form-control-file" id="exampleFormControlFile1" name="updateFile">
	                <span class="fname">${n.noticeOriginalFileName!=null?n.noticeOriginalFileName:""}</span>
	                <input type="hidden" name="noticeOriginalFileName" value="${n.noticeOriginalFileName!=null?n.noticeOriginalFileName:""} "/>
	                <input type="hidden" name="noticeRenamedFileName" value="${n.noticeRenamedFileName!=null?n.noticeRenamedFileName:""} "/>
	               	<c:if test="${n.noticeOriginalFileName!=null}">
	               		<span class="deleteFileSpan">
		               		<input type="checkbox" name="delFileChk" id="delFileChk" />
		               		<label for="delFileChk">첨부파일삭제</label>	               		
	               		</span>
	               	</c:if>
	              </div>
	            </div><!-- /.card-body -->
	        </div> <!--/.modal-body-->
	        <div class="modal-footer">
	          <button type="submit" class="btn btn-outline-success">수정</button>
	          <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
	        </div>
	      </form>
	    </div>
	  </div>
	</div>
</c:forEach>
<!-- 내가 속한 부서 공지 수정 모달 -->
<c:forEach items="${memberLoggedIn.deptCode=='D1'?planningDeptNoticeList:memberLoggedIn.deptCode=='D2'?designDeptNoticeList:developmentDeptNoticeList}" var="deptn" varStatus="deptnvs">
	<div class="modal fade" id="updateDeptNoticeModal${deptnvs.count}" tabindex="-1" role="dialog" aria-labelledby="updateNoticeModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 공지 수정</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <form action="${pageContext.request.contextPath}/notice/updateNotice.do?noticeNo=${deptn.noticeNo}"
      			method="post"
      			enctype="multipart/form-data">
	        <div class="modal-body">
	            <div class="addNotice" style="padding: 1rem;">
	              <div class="form-group">
		              <label for="inputDept">부서</label>
		              <select class="form-control custom-select" name="deptCode" ${memberLoggedIn.jobTitle=='관리자'?'"style=display:block;"':"style=display:none;"}>
		                <option value="all" selected>전체</option>
						<option value="D1" ${memberLoggedIn.deptCode=='D1'?'selected="selected"':''}>기획부</option>
		                <option value="D2" ${memberLoggedIn.deptCode=='D2'?'selected="selected"':''}>디자인부</option>
		                <option value="D3" ${memberLoggedIn.deptCode=='D3'?'selected="selected"':''}>개발부</option>
		              </select>
              		<input type="text" class="form-control"
		              	   ${memberLoggedIn.jobTitle=='관리자'?"style=display:none;":"style=display:block;"} 
		              	   value="${memberLoggedIn.deptCode=='D1'?'기획부':memberLoggedIn.deptCode=='D2'?'디자인부':'개발부'}"
		              	   readonly/>
            	 </div>
	              <div class="form-group">
	                <label for="inputName">공지 제목</label>
	                <input type="text" id="inputName" class="form-control" value="${deptn.noticeTitle}" name="noticeTitle" required>
	              </div>
	              <div class="form-group" style="display:none;">
		              <label for="inputWriter">글쓴이</label>
		              <input type="text" id="inputName" name="noticeWriter" value="${memberLoggedIn.memberId}" class="form-control">
            	  </div>
	              <!-- <div class="form-group">
	                <label for="inputDescription">공지 카드 내용</label>
	                <input type="text" class="form-control" maxlength="35" placeholder="35자 이내로 입력하세요." value="파이널 프로젝트가 본격적으로 시작되었습니다! 다들 화이팅!">
	              </div> -->
	              <div class="form-group">
	                <label for="inputDescription">공지 내용</label>
	                <textarea class="textarea" name="noticeContent" required>${deptn.noticeContent}</textarea>
	              </div>
	              <div class="form-group">
	                <label for="exampleFormControlFile1">파일 첨부</label>
	                <input type="file" class="form-control-file" id="exampleFormControlFile1" name="updateFile">
	                <span class="fname">${deptn.noticeOriginalFileName!=null?deptn.noticeOriginalFileName:""}</span>
	                <input type="hidden" name="noticeOriginalFileName" value="${deptn.noticeOriginalFileName!=null?deptn.noticeOriginalFileName:""} "/>
	                <input type="hidden" name="noticeRenamedFileName" value="${deptn.noticeRenamedFileName!=null?deptn.noticeRenamedFileName:""} "/>
	               	<c:if test="${deptn.noticeOriginalFileName!=null}">
	               		<span class="deleteFileSpan">
		               		<input type="checkbox" name="delFileChk" id="delFileChk" />
		               		<label for="delFileChk">첨부파일삭제</label>	               		
	               		</span>
	               	</c:if>
	              </div>
	            </div><!-- /.card-body -->
	        </div> <!--/.modal-body-->
	        <div class="modal-footer">
	          <button type="submit" class="btn btn-outline-success">수정</button>
	          <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
	        </div>
	      </form>
	    </div>
	  </div>
	</div>
</c:forEach>
<!-- 게시판 수정 모달 -->
<c:forEach items="${communityList}" var="c" varStatus="cvs">
	<div class="modal fade" id="updateCommuModal${cvs.count}" tabindex="-1" role="dialog" aria-labelledby="updateBoardModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title"><i class="fas fa-edit"></i>&nbsp; 게시글 수정</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	       <form action="${pageContext.request.contextPath}/notice/updateCommunity.do?commuNo=${c.commuNo}"
      			method="post"
      			enctype="multipart/form-data">
	        <div class="modal-body">
	            <div class="addNotice" style="padding: 1rem;">
	              <div class="form-group">
                  	<label for="inputName">게시글 제목</label>
                  	<input type="text" id="inputName" name="commuTitle" value="${c.commuTitle}" class="form-control" maxlength="15" placeholder="15자 이내로 입력하세요." required>
                  </div>
                  <div class="form-group" style="display:none;">
             		<label for="inputWriter">글쓴이</label>
              		<input type="text" id="inputName" name="commuWriter" value="${memberLoggedIn.memberId}" class="form-control">
            	  </div>
                  <div class="form-group">
                    <label for="inputDescription">게시글 내용</label>
                    <textarea class="textarea" name="commuContent" required>${c.commuContent}</textarea>
                  </div>
                  <div class="form-group">
                    <label for="exampleFormControlFile1">파일 첨부</label>
                    <input type="file" class="form-control-file" id="exampleFormControlFile1" name="updateFile">
	                <span class="fname">${c.commuOriginalFileName!=null?c.commuOriginalFileName:""}</span>
	                <input type="hidden" name="commuOriginalFileName" value="${c.commuOriginalFileName!=null?c.commuOriginalFileName:""} "/>
	                <input type="hidden" name="commuRenamedFileName" value="${c.commuRenamedFileName!=null?c.commuRenamedFileName:""} "/>
	               	<c:if test="${c.commuOriginalFileName!=null}">
	               		<span class="deleteFileSpan">
		               		<input type="checkbox" name="delFileChk" id="delFileChk" />
		               		<label for="delFileChk">첨부파일삭제</label>	               		
	               		</span>
	               	</c:if>
                  </div>
	            </div><!-- /.card-body -->
	        </div> <!--/.modal-body-->
	        <div class="modal-footer">
	          <button type="submit" class="btn btn-outline-success">수정</button>
	          <button type="button" class="btn btn-outline-success" data-dismiss="modal">취소</button>
	        </div>
	      </form>
	    </div>
	  </div>
	</div>
</c:forEach>