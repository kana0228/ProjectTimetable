// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery.js
//= require bootstrap.min.js
//= require moment
//= require rails-ujs
//= require fullcalendar.js
//= require activestorage
//= require wow.js
//= require jquery.mb.YTPlayer.js
//= require isotope.pkgd.js
//= require imagesloaded.pkgd.js
//= require jquery.flexslider.js
//= require owl.carousel.min.js
//= require jquery.magnific-popup.js
//= require plugins.js
//= require main.js
//= require date.format.js
//= require_tree .
//= require data-confirm-modal

$('#eventDelete').click(function(e) {
        var eventId = document.getElementById("event_id").value;
        console.log("Delete Button clicked");
        $.ajax({
            url: "/main_page/delete",
            type: "GET",
            data: {
                id: eventId
            },
            success: function(data) {
                $("#newEventAndDateModal").modal("hide");
                var event = $.ajax("/events.json");
                console.log(event);
               $("#calendar").fullCalendar("renderEvents", event, true );
               $("#calendar").fullCalendar("refetchEvents");
            },
            error: function(data) {
            }  
        });
    });


$('#calendar').fullCalendar({
  //ヘッダーの設定
    header: {
        left: 'today agendaDay,agendaWeek',
        center: 'title',
        right: 'prev next'
    },
    navLinks: true,
    selectHelper: true,
    defaultView: 'agendaWeek',
    allDaySlot: false, 
    minTime: "00:00:00",
    maxTime: "24:00:00",
    selectable: true,
    
//空いている空間に洗濯して追加する処理
    select: function(start, end) {
    	$('#calendar').fullCalendar('getView').start;
		$('#calendar').fullCalendar('getView').end;
    	//$('#newEventAndDateModal').modal('show');//narukiyo delete
    	
// narukiyo add start	
// カレンダー内の枠をクリックしたときにmain_page_showのアクションをたたく
    	 $.ajax({
            url: "/main_page/show",
            type: "GET",
            data:{
              event_sonzai_flg:0
            },
            success: function(data) {
                //momentJSを利用して、Fullcalendarで取得したstart�endを変換します。
                //momentJSはfullcalendarをインストールした際、一緒に設定していました。�"));
                //時間以外は前回表示の値を削除するために空文字を設定しています。
                console.log(moment(start).format("YYYYMMDD")); 
                console.log(moment(start).format("HH:mm"));
                $("#date").val(moment(start).format("YYYY-MM-DD"));
                $("#event_start").val(moment(start).format("HH:mm"));
                $("#event_end").val(moment(end).format("HH:mm"));
                $("#event_title").val("");
                // $("#event_category_id").val("");
                $("#event_useless_flag").prop('checked', false);
                $("#event_id").val("");
                $("#eventDelete").remove();
                $('#newEventAndDateModal').modal('show');
                //alert("success");
                
            },
            error: function(data) {
                alert("errror");
            }  
    	 });
//空いている空間に洗濯して追加する処理
// narukiyo add end    	 
      // 日の枠内を選択したときの処理
	    // var title = prompt('予定を入力してください:');
	    // var category = prompt('カテゴリーを入力してください:');
	    // var uselessflg = prompt('無駄な時間でしたか？Yes／Noで記入してください:');
	    // if ( title && category && (uselessflg == 'Yes' || uselessflg == 'No')) {//タイトルまたはカテゴリーの入力があるとき
	
		   // //イベントの登録 renderEventメソッド
		   // $('#calendar').fullCalendar('renderEvent',
		  	//   {
		  	// 	  title: title,
		  	// 	  category:category,
		  	// 	  uselessflg:uselessflg,
		   //	  	　start: start,
			  //	  end: end,
			  //	  allDay: allDay
		  	//   },
			  //true // make the event "stick"
		   // );
    	// }
    	// if(uselessflg && uselessflg != "Yes" && uselessflg != "No"){
	    // 	alert("YesかNoで入力してください。");
	    // }
	    // if(title=="" || category =="" || uselessflg == ""){
	    // 	alert("未入力の項目があります。");
	    // }
    },
    events: '/events.json',
    editable: true,
    //Drag & Dropをfalseに。
    eventStartEditable: false,　
//存在するイベントを選択して修正する処理
    eventClick: function(event) { //イベントをクリックしたときに実行
            
// narukiyo add start    
// カレンダー内のイベントをクリックしたときにmain_page_showのアクションをたたく
        $.ajax({
            url: "/main_page/show",
            type: "GET",
            data:{ 
                event_sonzai_flg:1,
                id:event.id
            },
            success: function(data) {
                //.format()はdate.format.jsから読んでいます。ネットで拾いました。
                //ただ処理が少しおかしいかなと。
                console.log("data.start");
                console.log(data.start) //dataはちゃんとサーバーから取得している。Chromeで確認済み
                var dateStart = data.start;
                dateStart = dateStart.split("T");
                var dateEnd = data.end;
                dateEnd = dateEnd.split("T");
                $("#date").val(dateStart[0]);
                console.log(dateStart[0]);
                console.log("dateStart");
                console.log(dateStart[1].substring(0, dateStart[1].length - 8));
                $("#event_start").val(dateStart[1].substring(0, dateStart[1].length - 8));
                $("#event_end").val(dateEnd[1].substring(0, dateStart[1].length - 8));
                $("#event_title").val(data.title);
                $("#event_category_id").val(data.category_id);
                $("#event_useless_flag").prop('checked', data.useless_flag);
                $("#event_id").val(data.id)
                $("#eventDelete").remove();
                $(".modal-footer").append("<button id='eventDelete' class='btn btn-danger'>Delete</button>");
                $('#newEventAndDateModal').modal('show');//ここ��再度開きなおしてもうまくいかない
                 
                //window.location.href = '/main_page/show';//同上
                // alert("sのselectorで値を設定します。
            },
            error: function(data) {
                alert("errror");
            }            
        });    	
        

//存在するイベントを選択して修正する処理
// narukiyo add end        
    	// $('#newEventAndDateModal').modal('show'); // narukiyo delete
	    //var title = prompt('予定を入力してください:', event.title);
	    //var category = prompt('カテゴリーを入力してください:', event.category);
	    //var uselessflg = prompt('無駄な時間でしたか？Yes／Noで記入してください:',event.uselessflg);
	    //if((uselessflg != "") && (uselessflg != 'Yes' && uselessflg != 'No')){
	    //	alert("YesかNoで入力してください。今の変更は取り消されます。");
	    //}
	    //if(title=="" || category =="" || uselessflg == ""){
	    //	alert("未入力の項目がある為、今の変更は取り消されます。");
	    //}
	    //if((title!="" && category!="" ) && (uselessflg == "Yes" || uselessflg == "No")){
		//    event.title = title;
		//    event.category = category;
		//    event.uselessflg = uselessflg;
    	//	$('#calendar').fullCalendar('updateEvent', event); //イベント（予定）の修正
	    //}else if (title=="" && category =="" && uselessflg == ""){
    	//	$('#calendar').fullCalendar("removeEvents", event.id); //イベント（予定）の削除             
	    //}      
	   },
//Dragした際の処理	   
   eventResize: function(event) {
        console.log("eventDrop");
     $.ajax({
            url: "/main_page/show",
            type: "GET",
            data:{ 
                event_sonzai_flg:1,
                id:event.id
            },
            success: function(data) {
                //.format()はdate.format.jsから読んでいます。ネットで拾いました。
                //ただ処理が少しおかしいかなと。
                console.log("data.start");
                console.log(data.start) //dataはちゃんとサーバーから取得している。Chromeで確認済み
                var dateStart = data.start;
                dateStart = dateStart.split("T");
                var dateEnd = data.end;
                dateEnd = dateEnd.split("T");
                $("#date").val(dateStart[0]);
                console.log(moment(event.start).format("YYYYMMDD")); 
                console.log(moment(event.start).format("HH:mm"));
                $("#date").val(moment(event.start).format("YYYY-MM-DD"));
                $("#event_start").val(moment(event.start).format("HH:mm"));
                $("#event_end").val(moment(event.end).format("HH:mm"));
                $("#event_title").val(data.title);
                $("#event_category_id").val(data.category_id);
                $("#event_useless_flag").prop('checked', data.useless_flag);
                $("#event_id").val(data.id)
                $("#eventDelete").remove();
                $(".modal-footer").append("<button id='eventDelete' class='btn btn-danger'>Delete</button>");
                $('#newEventAndDateModal').modal('show');//ここ��再度開きなおしてもうまくいかない
                 
                //window.location.href = '/main_page/show';//同上
                // alert("sのselectorで値を設定します。
            },
            error: function(data) {
                alert("errror");
            }            
        }); 
//Dragした際の処理
            },
// //Drag&Dropした際の処理
//     eventDrop: function(event) {
//         console.log("eventDrop");
//      $.ajax({
//             url: "/main_page/show",
//             type: "GET",
//             data:{ 
//                 event_sonzai_flg:1,
//                 id:event.id
//             },
//             success: function(data) {
//                 //.format()はdate.format.jsから読んでいます。ネットで拾いました。
//                 //ただ処理が少しおかしいかなと。
//                 console.log("data.start");
//                 console.log(data.start) //dataはちゃんとサーバーから取得している。Chromeで確認済み
//                 var dateStart = data.start;
//                 dateStart = dateStart.split("T");
//                 var dateEnd = data.end;
//                 dateEnd = dateEnd.split("T");
//                 $("#date").val(dateStart[0]);
//                 console.log(moment(event.start).format("YYYYMMDD")); 
//                 console.log(moment(event.start).format("HH:mm"));
//                 $("#date").val(moment(event.start).format("YYYY-MM-DD"));
//                 $("#event_start").val(moment(event.start).format("HH:mm"));
//                 $("#event_end").val(moment(event.end).format("HH:mm"));
//                 $("#event_title").val(data.title);
//                 $("#event_category_id").val(data.category_id);
//                 $("#event_useless_flag").prop('checked', data.useless_flag);
//                 $("#event_id").val(data.id)
               
//                 $('#newEventAndDateModal').modal('show');//ここ��再度開きなおしてもうまくいかない
                 
//                 //window.location.href = '/main_page/show';//同上
//                 // alert("sのselectorで値を設定します。
//             },
//             error: function(data) {
//                 alert("errror");
//             }            
//         }); 
//     }
});


