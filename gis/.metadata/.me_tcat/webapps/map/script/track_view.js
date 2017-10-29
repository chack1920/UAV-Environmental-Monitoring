//参考：http://jingyan.baidu.com/article/ed2a5d1f3fb4d309f6be17c3.html
//参考：http://www.cnblogs.com/zhangqs008/p/3677098.html

jQuery(document).ready(function() {
	Map.init();
});
var map;
var trackId;

var Map = function() {
	var initMap = function() {
		// 百度地图API功能
		trackId = GetQueryString("trackid");

		map = new BMap.Map("allmap"); // 创建Map实例
		map.centerAndZoom(new BMap.Point(104.001404, 30.55915), 15); // 初始化地图,设置中心点坐标和地图级别
		map.addControl(new BMap.MapTypeControl()); // 添加地图类型控件
		map.setCurrentCity("成都"); // 设置地图显示的城市 此项是必须设置的
		map.enableScrollWheelZoom(true); // 开启鼠标滚轮缩放
	};
	function GetQueryString(name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
		var r = window.location.search.substr(1).match(reg);
		if (r != null)
			return unescape(r[2]);
		return null;
	};

	var addLine = function() { // 添加线路
		// var gpsTimeFrom=document.getElementById("gps_time_from").value;
		// var gpsTimeTo=document.getElementById("gps_time_to").value;
		var timeFrom = "2015-09-19";
		var timeTo = "2015-09-21";
		//+"device_id="+trackId&gps_time_from=2015-09-20 15:39:00&gps_time_to=2015-09-20 18:41:00"
	
		$.post("gps_track.jsp?device_id="+trackId+"&gps_time_from="+timeFrom+"&gps_time_to="+timeTo,function(data){
		
			
			var polylinePoint = new Array();
			var json=eval("("+data+")");
            var list=json.aaData;
          
            for(var i=0;i<list.length;i++){
				/*
				 * var p0=list[i].longitude; var p1=list[i].latitude; var
				 * polylinePoint[i]=new BMap.Point(p0,p1);
				 */
				var L0 = list[i].longitude;
			
				var L1 = list[i].latitude;
				
				polylinePoint[i] = new BMap.Point(L0, L1);
			

			}
			var polyline = new BMap.Polyline(polylinePoint, {
				strokeColor : "blue",
				strokeWeight : 6,
				strokeOpacity : 0.5
			});
			map.addOverlay(polyline);// 添加线路图层
				map.centerAndZoom(polylinePoint[0], 12);// 初始化地图，设置中心点坐标和地图级别
			});
	};
	return {
		init : function() {
			initMap();
			addLine();
		},
		GetQueryString : function(name) {
			GetQueryString(name);
		}

	};
}();