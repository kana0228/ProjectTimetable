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
//= require_tree .
//= require data-confirm-modal

$('#calendar').fullCalendar({
  //ヘッダーの設定
    header: {
        left: 'today agendaDay,agendaWeek',
        center: 'title',
        right: 'prev next'
    },
    navLinks: true,
    selectHelper: true,
    defaultView: 'agendaDay',
    allDaySlot: false, 
    minTime: "05:00:00",
    maxTime: "29:00:00",
    selectable: true,
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
                
                //$('#newEventAndDateModal').modal('show');
                alert("success");
                
            },
            error: function(data) {
                alert("errror");
            }  
    	 });
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
                
                console.log(data.title)
                $("#newEventAndDateModal input[name=title]").val(data.title);
               
                $('#newEventAndDateModal').modal('show');//ここで再度開きなおしてもうまくいかない
                 
                //window.location.href = '/main_page/show';//同上
                // alert("success");
            },
            error: function(data) {
                alert("errror");
            }            
        });    	
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
	   }
});


