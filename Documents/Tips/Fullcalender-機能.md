# Fullcalender 機能
Fullcalendarを使うためには `momentJS` が必要。



```javascript

$('#calender').fullcalendar('renderEvents', event, true); //renderする？
$('#calender').fullcalendar('renderEvents', event, true); //renderする？

$('#calender').fullcalendar({
	header :{ left, center, right},
	navLinks: true, //日付の数字をクリックできるように
	selectHelper: true,
	defaultView: 'agendaWeek', //一週ごとに
	allDaySlot: false, //一日中できる？
	minTime:,
	maxTime:,
	selectable: true, //新しいイベント作成可能
	events: '/events.json' //カレンダーに表示するデータを取得する取得もと。　ここにkey,value形でデータを宣言してもいい
	editable: true, //編集可能
	eventStartEditable: false, #Drag & Drop false
	eventOverlap: false,　//登録されているイベントとイベントでの重複禁止
  selectOverlap: false, //新しいイベントの登録の重複禁止 
	
	select:function(start, end){} // 中でajax処理を組むことができる。
	eventClick: function(event){} //存在するイベントをクリックした際。
	eventResize: function(event){} //存在するイベントをリサイズする。
	eventDrop: function(event){} //Drag & Drop した際の処理

});
```



