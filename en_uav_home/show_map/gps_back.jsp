﻿<%@page contentType="text/html; charset=UTF-8" language="java"
	import="java.text.*,org.json.JSONObject,java.util.ArrayList,java.io.PrintWriter"
	import="java.util.HashMap,java.util.List,java.sql.*,java.util.Map,java.io.IOException"%>
<%
	//说明：本例子需要引入json.jar包和jdbc包，拷贝到Tomcat的common/lib下重启Tomcat或者应用的WEB-INF/lib下
	String deviceId=request.getParameter("device_id");
	String gpsTimeFrom=request.getParameter("gps_time_from");
	String gpsTimeTo=request.getParameter("gps_time_to");
	String action=request.getParameter("action");
	String sql="";
	System.out.println("获得的参数是：action="+action+",device_id="+deviceId+",gps_time_from="+gpsTimeFrom+",gps_time_to="+gpsTimeTo);
	//开始查询数据库
	List jsonList = new ArrayList();
	try {
		Class.forName("com.mysql.jdbc.Driver");
	} catch (ClassNotFoundException classnotfoundexception) {
		classnotfoundexception.printStackTrace();
	}
	try {
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/enuav?user=root&password=admin&useUnicode=true&characterEncoding=UTF-8");
		Statement statement = conn.createStatement();
		System.out.println("连接数据库Ok！！！");
		//构造sql语句，根据传递过来的查询条件参数，目前是deviceId和gpsTime
		sql="select * from data_list where time>'"+gpsTimeFrom+"' and time<'"+gpsTimeTo+"'and device_id like '%"+deviceId+"%' order by time";
	
		System.out.println("构造出来的sql语句是："+sql);
		ResultSet rs = statement.executeQuery(sql);
		while (rs.next()) {
			Map map = new HashMap();
			map.put("device_id",rs.getString("device_id"));
			map.put("time",rs.getString("time"));
			//map.put("recv_time",rs.getString("recvtime"));
			map.put("longitude",rs.getString("longitude"));
			map.put("latitude",rs.getString("latitude"));
                        map.put("tem",rs.getString("tem"));
                        map.put("hum",rs.getString("hum"));
                        map.put("pm",rs.getString("pm25"));
			jsonList.add(map);
		}
		statement.close();
		conn.close();
		System.out.println("数据库关闭了！！！");
	} catch (SQLException sqlexception) {
		sqlexception.printStackTrace();
	}
	//////////数据库查询完毕，得到了json数组jsonList//////////
	//下面开始构建返回的json
	JSONObject json=new JSONObject();
	json.put("aaData",jsonList);
	json.put("action",action);
	json.put("result_msg","ok");	//如果发生错误就设置成"error"等
	json.put("result_code",0);	//返回0表示正常，不等于0就表示有错误产生，错误代码
	json.put("device_id",deviceId);
	json.put("gps_time_from",gpsTimeFrom);
	json.put("gps_time_to",gpsTimeTo);
	json.put("sql",sql);
	json.put("help","请在请求url里带上device_id,gps_time_from和gps_time_to三个参数才能有查询结果<input type=button value=示范 onclick=window.location.href='gps_track_help.jsp'>");
	System.out.println("最后构造得到的json是："+json.toString());
	response.setContentType("text/html; charset=UTF-8");
	try {
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
	} catch (IOException e) {
		e.printStackTrace();
	}
	System.out.println("返回结果给调用页面了。");
%>
