<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/club/clubViewModal.jsp"></jsp:include>

<style>
</style>

<script>
$(function(){
	
	sidebarActive(); //사이드바 활성화
	tabActive(); //서브헤더 탭 활성화
	

	
});

$( document ).ready(function() {
	
/* 	var clubNo = "${clubNo}";
	$.ajax({
		url: "${pageContext.request.contextPath}/club/selectClubPlan.do",
		dataType: "json",
		data:{"clubNo" : clubNo},
		type: "GET",
		success: data => {
			
			console.log(data);
			
		},
		error: (x,s,e)=> {
			console.log(x,s,e);
		}
	}); */
});


	
$(function () {

    /* initialize the external events
     -----------------------------------------------------------------*/
/*     function ini_events(ele) {
      ele.each(function () {

        // create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
        // it doesn't need to have a start or end
        var eventObject = {
          title: $.trim($(this).text()) // use the element's text as the event title
        }

        // store the Event Object in the DOM element so we can get to it later
        $(this).data('eventObject', eventObject)

        // make the event draggable using jQuery UI
        $(this).draggable({
          zIndex        : 1070,
          revert        : true, // will cause the event to go back to its
          revertDuration: 0  //  original position after the drag
        })

      })
    }

    ini_events($('#external-events div.external-event')) */

    /* initialize the calendar
     -----------------------------------------------------------------*/
    //Date for the calendar events (dummy data)
    var date = new Date()
    var d    = date.getDate(),
        m    = date.getMonth(),
        y    = date.getFullYear()

    var Calendar = FullCalendar.Calendar;
    var Draggable = FullCalendarInteraction.Draggable;

    var containerEl = document.getElementById('external-events');
    //var checkbox = document.getElementById('drop-remove');
    var calendarEl = document.getElementById('calendar');

    // initialize the external events
    // -----------------------------------------------------------------

/*     new Draggable(containerEl, {
      itemSelector: '.external-event',
      eventData: function(eventEl) {
        console.log(eventEl);
        return {
          title: eventEl.innerText,
          backgroundColor: window.getComputedStyle( eventEl ,null).getPropertyValue('background-color'),
          borderColor: window.getComputedStyle( eventEl ,null).getPropertyValue('background-color'),
          textColor: window.getComputedStyle( eventEl ,null).getPropertyValue('color'),
        };
      }
    }); */
	var clubPlanList = "${clubPlanList}"; //자바스크립트 변수로 선언.
	
    var calendar = new Calendar(calendarEl, {
      plugins: [ 'bootstrap', 'interaction', 'dayGrid', 'timeGrid' ],
      header    : {
        left  : 'prev,next today',
        center: 'title',
        right : 'dayGridMonth'
      },
      //Random default events
      events: [
 
    	 {
          title          : 'All Day Event',
          start          : new Date(2019, 11, 10),
          end          : new Date(2020, 1, 4),
          backgroundColor: '#f56954', //red
          borderColor    : '#f56954', //red
        },
        {
          title          : 'Long Event',
          start          : new Date(y, m, d - 5),
          end            : new Date(y, m, d - 2),
          backgroundColor: '#f39c12', //yellow
          borderColor    : '#f39c12' //yellow
        },
        {
          title          : 'Meeting',
          start          : new Date(y, m, d, 10, 30),
          backgroundColor: '#0073b7', //Blue
          borderColor    : '#0073b7' //Blue
        },
        {
          title          : 'Lunch',
          start          : new Date(y, m, d, 12, 0),
          end            : new Date(y, m, d, 14, 0),
          allDay         : false,
          backgroundColor: '#00c0ef', //Info (aqua)
          borderColor    : '#00c0ef' //Info (aqua)
        },
        {
          title          : 'Birthday Party',
          start          : new Date(y, m, d + 1, 19, 0),
          end            : new Date(y, m, d + 1, 22, 30),
          backgroundColor: '#00a65a', //Success (green)
          borderColor    : '#00a65a' //Success (green)
        },
        {
          title          : 'Click for Google',
          start          : new Date(y, m, 28),
          end            : new Date(y, m, 29),
          url            : 'http://google.com/',
          backgroundColor: '#3c8dbc', //Primary (light-blue)
          borderColor    : '#3c8dbc' //Primary (light-blue)
        } 
      ] 
      ,
      editable  : true,
      droppable : true, // this allows things to be dropped onto the calendar !!!
      drop      : function(info) {
        // is the "remove after drop" checkbox checked?
        if (checkbox.checked) {
          // if so, remove the element from the "Draggable Events" list
          info.draggedEl.parentNode.removeChild(info.draggedEl);
        }
      }    
    });

    calendar.render();
    //$('#calendar').fullCalendar()

    /* ADDING EVENTS */
    var currColor = '#3c8dbc' //Red by default
    //Color chooser button
    var colorChooser = $('#color-chooser-btn')
    $('#color-chooser > li > a').click(function (e) {
      e.preventDefault()
      //Save color
      currColor = $(this).css('color')
      //Add color effect to button
      $('#add-new-event').css({	
        'background-color': currColor,
        'border-color'    : currColor
      })
    })
    
    $('#add-new-event').click(function (e) {
      e.preventDefault()
      //Get value and make sure it is not null
      var val = $('#new-event').val()
      if (val.length == 0) {
        return
      }

  /*     //Create events
      var event = $('<div />')
      event.css({
        'background-color': currColor,
        'border-color'    : currColor,
        'color'           : '#fff'
      }).addClass('external-event')
      event.html(val) */
      $('#external-events').prepend(event)

      //Add draggable funtionality
      ini_events(event)

      //Remove event from text input
     // $('#new-event').val('')
    })
  })


</script>
<body class="hold-transition sidebar-mini">
	<!-- Navbar ClubView -->
	<nav id="navbar-club"
		class="main-header navbar navbar-expand navbar-white navbar-light navbar-project">
		<!-- Left navbar links -->
		<!-- SEARCH FORM -->
		<form id="noticeSearchFrm" class="form-inline">
			<div class="input-group input-group-sm">
				<input class="form-control form-control-navbar" type="search"
					placeholder="oo동호회 검색" aria-label="Search">
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
			<li id="tab-calendar" class="nav-item"><button type="button">일정</button></li>
			<c:if
				test="${memberLoggedIn.memberId == 'admin' or club.clubManagerId == memberLoggedIn.memberId}">
				<li id="tab-member" class="nav-item">
					<button type="button" onclick="memberList('${club.clubNo}');">동호회멤버</button>
				</li>
			</c:if>
			<li id="tab-attachment" class="nav-item"><button type="button">파일</button></li>
		</ul>

		<!-- Right navbar links -->
		<ul id="viewRightNavbar-wrapper" class="navbar-nav ml-auto">
			<!-- 동호회 대화 -->
			<li class="nav-item">
				<button type="button"
					class="btn btn-block btn-default btn-xs nav-link">
					<i class="far fa-comments"></i> 동호회 대화
				</button>
			</li>

			<!-- 동호회 멤버 -->
			<li id="nav-member" class="nav-item dropdown"><a
				class="nav-link" data-toggle="dropdown" href="#"> <i
					class="far fa-user"></i> 6
			</a>
				<div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
					<a href="#" class="dropdown-item"> <!-- Message Start -->
						<div class="media">
							<img
								src="${pageContext.request.contextPath}/resources/img/profile.jfif"
								alt="User Avatar" class="img-circle img-profile ico-profile" />
							<div class="media-body">
								<p class="memberName">Brad Diesel</p>
							</div>
						</div> <!-- Message End -->
					</a> <a href="#" class="dropdown-item"> <!-- Message Start -->
						<div class="media">
							<img
								src="${pageContext.request.contextPath}/resources/img/profile.jfif"
								alt="User Avatar" class="img-circle img-profile ico-profile">
							<div class="media-body">
								<p class="memberName">Brad Diesel</p>
							</div>
						</div> <!-- Message End -->
					</a> <a href="#" class="dropdown-item"> <!-- Message Start -->
						<div class="media">
							<img
								src="${pageContext.request.contextPath}/resources/img/profile.jfif"
								alt="User Avatar" class="img-circle img-profile ico-profile">
							<div class="media-body">
								<p class="memberName">Brad Diesel</p>
							</div>
						</div> <!-- Message End -->
					</a> <a href="#" class="dropdown-item"> <!-- Message Start -->
						<div class="media">
							<img
								src="${pageContext.request.contextPath}/resources/img/profile.jfif"
								alt="User Avatar" class="img-circle img-profile ico-profile">
							<div class="media-body">
								<div class="media-body">
									<p class="memberName">Brad Diesel</p>
								</div>
							</div>
						</div> <!-- Message End -->
					</a> <a href="#" class="dropdown-item"> <!-- Message Start -->
						<div class="media">
							<img
								src="${pageContext.request.contextPath}/resources/img/profile.jfif"
								alt="User Avatar" class="img-circle img-profile ico-profile">
							<div class="media-body">
								<p class="memberName">Brad Diesel</p>
							</div>
						</div> <!-- Message End -->
					</a>
				</div></li>

			<!-- 동호회 설정 -->
			<li class="nav-item">
				<button type="button"
					class="btn btn-block btn-default btn-xs nav-link">
					<i class="fas fa-cog"></i>
				</button>
			</li>
		</ul>
	</nav>
	<!-- /.navbar -->

	<!-- Content Wrapper. Contains page content -->
	<div class="content-wrapper">
		<!-- Content Header (Page header) -->
		<section class="content-header">
			<div class="container-fluid">
				<div class="row mb-2">
					
				</div>
			</div>
			<!-- /.container-fluid -->
		</section>

		<!-- Main content -->
		<section class="content">
			<div class="container-fluid">

				<div class="col-md-9" style="margin: 0 auto">
					<div class="card">

						<div class="card-body">
							<!-- the events -->
							<div id="external-events">
								<div id="calendar"></div>
							</div>
						</div>
						<!-- /.card-body -->
					</div>
					<!-- /.card -->

				</div>
			</div>
			<!-- /.container-fluid -->
		</section>
	
		<!-- /.content -->
	</div>
	<!-- div content wrapper -->

</body>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>