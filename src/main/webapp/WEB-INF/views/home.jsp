<%@page import="com.one.mat.member.dto.ProfileDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<meta charset="UTF-8">
<title>홈 화면</title>
<style>
    .sidebar {
        height: 100%;
        width: 250px;
        position: fixed;
        top: 0;
        left: 0;
        background-color: #255,255,255;
        padding-top: 20px;
    }

    .sidebar h2 {
        color: black;
        text-align: center;
    }

    .sidebar ul {
        list-style: none;
        padding: 0;
    }

    .sidebar ul li {
        padding: 10px;
        text-align: center;
    }

    .sidebar a {
        color: black;
        text-decoration: none;
    }

    .content {
        margin-left: 260px;
        padding: 20px;
        text-align: center; /* "우리 동네 리스트"를 가운데 정렬 */
    }
</style>
<link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>

 <!-- Sidebar -->
    <div class="sidebar">
        <h2>매칭해주개</h2>
        <ul>
            <li><a href="">홈</a></li>
            <li><a href="joinAgree.go">회원가입</a>
            <li><a href="login.go">로그인</a></li>
            <li><a href="logout.do">로그아웃</a></li>
            <li><a href="chattingList.go">채팅</a></li>
            <li><a href="recvMatchingList.go">매칭리스트</a></li>
            <li><a href="boardList.go">커뮤니티</a></li>
            <li><a href="myProfileList.do">마이프로필</a>
            <li><a href="alarmList.go">알람</a></li>
            
            <li><a href="adminList.go">관리자페이지</a></li>
        </ul>
    </div>

    <div class="content">
    <h3>우리 동네 리스트</h3>
    <a href="#">매칭리스트 img</a>
    <div id="firstMatchData">
        <p id="member_dongAddr"></p>
        <p id="member_gender"></p>
        <p id="pro_dogName"></p>
        <p id="pro_dogAge"></p>
        <p id="pro_dogGender"></p>
        <p id="pro_dogDesc"></p>
    </div>
    <table>
        <tbody id="matchingList"></tbody>
    </table>
    <!-- <div id="charList"></div> -->
    <button id="nextButton">다음</button>
    <button id="prevButton">이전</button>
    <button id="matchingdel">매칭리스트 삭제</button>
    <button id="matchingreq" >매칭요청 보내기</button>
    <button id="openModal" >모달 열기</button>
    <button id="closeModal">모달 닫기</button>
    <!-- 모달을 불러올 위치 -->
    <div id="modalContent"></div>
</div>
</body>	
<script>

var matchingData = []; // 매칭 데이터 배열
var currentIndex = 0; // 현재 표시 중인 데이터 인덱스

// 페이지 로딩 시 데이터 가져오기
matchinglist();
// matchingCharList();

// 매칭 리스트
function matchinglist() {
    $.ajax({
        type: 'get',
        url: 'MatchingList.do',
        data: {},
        dataType: 'json',
        success: function (data) {
            console.log(data);
            console.log("성공");

            matchingData = data.matchingList;
						console.log("matchingData : "+matchingData);
            // 페이지 로딩 시 첫 번째 매칭 데이터 표시
            showMatchingData(currentIndex);
        },
        error: function (e) {
            console.log(e);
            console.log("실패");
        }
    });
}

// 다음 버튼 클릭 시 다음 매칭 데이터 표시
$('#nextButton').click(function () {
    currentIndex = (currentIndex + 1) % matchingData.length;
    showMatchingData(currentIndex);
});

// 이전 버튼 클릭 시 이전 매칭 데이터 표시
$('#prevButton').click(function () {
    currentIndex = (currentIndex - 1) % matchingData.length;
    console.log("인덱스 -1 = "+currentIndex);
    if(currentIndex < 0){
   	 currentIndex = matchingData.length-1;
   	 console.log("마지막 인덱스 = "+currentIndex);
     showMatchingData(currentIndex);
    }else{
   	 showMatchingData(currentIndex);
    }
});

// 삭제 버튼 클릭시 리스트에서 삭제
$('#matchingdel').click(function () {
	matchingData.splice(currentIndex,1);
	showMatchingData(currentIndex);
	
});

// 매칭요청 버튼 클릭시 매칭요청 보내기
$('#matchingreq').click(function () {
	console.log("매칭 버튼 클릭");
   	 
        var currentMatch = matchingData[currentIndex];
        var request = {
      		  pro_idx: currentMatch.pro_idx
        };
        
         $.ajax({
            type: 'POST',  // HTTP 요청 방식 선택 (GET, POST 등)
            url: 'HomeSend.do',  // 서버로 요청을 보낼 URL
            data: JSON.stringify(request),  // 데이터를 JSON 형식으로 변환하여 보냅니다
            contentType: 'application/json',  // 보내는 데이터의 유형 (JSON)
            dataType: 'Json',  // 서버로부터의 응답 데이터 타입 (JSON)
            success: function (response) {
            		console.log("stringify 성공 : " + JSON.stringify(request));
                console.log('매칭 요청 성공:', response);
                alert("매칭 요청이 발송되었습니다");
            },
            error: function (e) {
                // 오류 발생 시 처리하는 로직을 작성합니다
                console.error('매칭 요청 실패:', e);
                console.log("stringify 실패 : " + JSON.stringify(request));
            }
        }); 
    });

function showMatchingData(index) {
    var currentMatch = matchingData[index];
    $('#pro_dogName').text('강아지 이름: ' + currentMatch.pro_dogName);
    $('#pro_dogAge').text('강아지 나이: ' + currentMatch.pro_dogAge);
    $('#pro_dogGender').text('강아지 성별: ' + currentMatch.pro_dogGender);
    $('#pro_dogDesc').text('강아지 설명: ' + currentMatch.pro_dogDesc);
    $('#member_dongAddr').text('동 주소: ' + currentMatch.member_dongAddr);
    $('#member_gender').text('성별: ' + currentMatch.member_gender);
    
} 



$('#openModal').click(function () {
   var currentMatch = matchingData[currentIndex];
   var pro_idx = currentMatch.pro_idx;

   // JSP 파일을 가져와서 모달 창에 표시
   $.get("./memberDetailList.go?pro_idx=" + pro_idx, function(data) {
   	console.log(data);
   	console.log("#modalContent");
       $("#modalContent").html(data);
   });
});


// 성향 리스트
/* function matchingCharList() {
   $.ajax({
       type: 'get',
       url: 'matchingCharList.do',
       data: {},
       dataType: 'json',
       success: function (data) {
           console.log(data);
           console.log("성공");

           
           charList(data);
       },
       error: function (e) {
           console.log(e);
           console.log("실패");
       }
   });
}

//성향 정보 표시
/* function charList(charTypeList) {
   var content = '';
   charTypeList.forEach(function (charType) {
       content += charType + '<br>';
   });

   // 결과를 원하는 위치에 표시
   $('#charList').html(content);
}  */

var msg = "${msg}";
if(msg != ""){
	alert(msg);
}
</script>
</html>