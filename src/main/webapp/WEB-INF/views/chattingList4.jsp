<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
$('#openAlarm').click(function (e) {
	   // JSP 파일을 가져와서 모달 창에 표시
	   $.get("./alarmList.go", function(data) {
	   	console.log(data);
	   	console.log("#alarmContent");
	       $("#alarmContent").html(data);
	   });
	});
	
$.ajax({
	type:'post',
	url:'adminCheck.do',
	dataType:'JSON',
    success : function(data){
    	console.log(data.admin);
    	if(data.admin !== 4){
    		$('.btn_gnb.admin').css('display', 'none');
    	}
    },
    error: function(e){
    	console.log(e);
    }
});
</script>
		