<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>


	<script>
		$(function () {
			//这是bootstrap日期控件（bootstrap-datetimepicker.zh-CN.js）封装好的函数，直接引入乱码，所以直接贴到前端
			$.fn.datetimepicker.dates['zh-CN'] = {
				days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
				daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
				daysMin:  ["日", "一", "二", "三", "四", "五", "六", "日"],
				months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
				monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
				today: "今天",
				suffix: [],
				meridiem: ["上午", "下午"]
			};
			//页面加载完毕后触发一个方法
			//默认展开列表的第一页，每页展现两条记录
			pageList(1,2);

			//bootstrap日期拾取器
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			//为创建按钮绑定事件，打开添加操作的模态窗口
			$("#addBtn").click(function () {


				/*
				* 操作模态窗口：获取模态窗口对象，调用其modal方法，传递show/hide参数
				* */

				//向后端发送请求，获取用户列表
				$.ajax({
					url:"workbench/activity/getUser.do",
					type:"get",
					dataType:"json",
					success:function (data) {
						//console.log(data);
						var html = "<option></option>";

						//遍历出来的每一个n，就是每一个user对象
						$.each(data,function (i,n) {

							html += "<option value='"+n.id+"'>"+n.name+"</option>";

						})

						$("#create-owner").html(html);
						//取得当前登录用户的id
						//在js中使用el表达式，el表达式一定要套用在字符串中
						var id = "${user.id}";

						$("#create-owner").val(id);
						//所有的下拉框处理完毕后，展现模态窗口
						$("#createActivityModal").modal("show");
					}

				})


			})

			//向后台添加市场活动
			$("#saveBtn").click(function () {
				$.ajax({
					url:"workbench/activity/save.do",
					data:{
						"owner" : $.trim($("#create-owner").val()),
						"name" : $.trim($("#create-name").val()),
						"startDate" : $.trim($("#create-startDate").val()),
						"endDate" : $.trim($("#create-endDate").val()),
						"cost" : $.trim($("#create-cost").val()),
						"description" : $.trim($("#create-description").val())

					},
					type:"post",
					dataType:"json",
					success:function (data) {
						if(data.success){
							//添加成功后
							//刷新市场活动信息列表（局部刷新）
							pageList(1,2);

							/*
                            *
                            * $("#activityPage").bs_pagination('getOption', 'currentPage'):
                            * 		操作后停留在当前页
                            *
                            * $("#activityPage").bs_pagination('getOption', 'rowsPerPage')
                            * 		操作后维持已经设置好的每页展现的记录数
                            *
                            * 这两个参数不需要我们进行任何的修改操作
                            * 	直接使用即可
                            *
                            *
                            *
                            * */

							//做完添加操作后，应该回到第一页，维持每页展现的记录数

							//pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));



							//清空添加操作模态窗口中的数据
							//提交表单
							//$("#activityAddForm").submit();

							/*

                                注意：
                                    我们拿到了form表单的jquery对象
                                    对于表单的jquery对象，提供了submit()方法让我们提交表单
                                    但是表单的jquery对象，没有为我们提供reset()方法让我们重置表单（坑：idea为我们提示了有reset()方法）

                                    虽然jquery对象没有为我们提供reset方法，但是原生js为我们提供了reset方法
                                    所以我们要将jquery对象转换为原生dom对象

                                    jquery对象转换为dom对象：
                                        jquery对象[下标]

                                    dom对象转换为jquery对象：
                                        $(dom)


                             */
							$("#activityAddForm")[0].reset();

							//关闭添加操作的模态窗口
							$("#createActivityModal").modal("hide");

							//alert("添加成功！")
						}else{
							alert("市场活动添加失败！")
						}
					}
				})
			})

			//点击查询按钮查询市场活动
			$("#searchBtn").click(function () {
				/*

				点击查询按钮的时候，我们应该将搜索框中的信息保存起来,保存到隐藏域中


			 */

				$("#hidden-name").val($.trim($("#search-name").val()));
				$("#hidden-owner").val($.trim($("#search-owner").val()));
				$("#hidden-startDate").val($.trim($("#search-startDate").val()));
				$("#hidden-endDate").val($.trim($("#search-endDate").val()));

				//默认显示最新的两条数据
				pageList(1,2);
			})

			//添加全选框操作
			$("#qx").click(function () {
				//获取分页中其它单选框元素,根据全选框的选中状态改变
				$("input[name=xz]").prop("checked",this.checked)

			})

			//通过其它单选框改变全选框的状态
			$("#activityBody").on("click",$("input[name=xz]"),function () {
				//改变全选框的选中状态
				$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked".length));
			})

			//删除市场活动
			$("#deleteBtn").click(function () {

				//找到复选框中所有挑√的复选框的jquery对象
				var $xz = $("input[name=xz]:checked");

				if($xz.length==0) {

					alert("请选择需要删除的记录！");

					//肯定选了，而且有可能是1条，有可能是多条
				}else{
					if(confirm("确定删除这些记录吗？")){
						//url:workbench/activity/delete.do?id=xxx&id=xxx&id=xxx

						//拼接参数
						var param = "";

						//将$xz中的每一个dom对象遍历出来，取其value值，就相当于取得了需要删除的记录的id
						for(var i=0;i<$xz.length;i++){

							param += "id="+$($xz[i]).val();

							//如果不是最后一个元素，需要在后面追加一个&符
							if(i<$xz.length-1){

								param += "&";

							}

						}

						//alert(param);
						$.ajax({

							url : "workbench/activity/delete.do",
							data : param,
							type : "post",
							dataType : "json",
							success : function (data) {

								/*
                                    data
                                        {"success":true/false}
                                 */
								if(data.success){

									//删除成功后
									//回到第一页，维持每页展现的记录数
									pageList(1,2);


								}else{

									alert("删除市场活动失败");

								}
							}
						})
					}
				}
			})

			//修改市场活动
			//从后端取出用户列表和选中的市场活动
			$("#editBtn").click(function () {

				//找到复选框中所有挑√的复选框的jquery对象
				var $xz = $("input[name=xz]:checked");

				if($xz.length == 0){
					alert("请选择需要修改的市场活动记录！")
				}else if($xz.length > 1){
					alert("一次只能修改一条记录！")
				}else{
					//只选择了一条记录，向后台发送ajax请求获取用户列表和市场活动记录
					var id = $xz.val();
					//console.log(id);

					$.ajax({

							url : "workbench/activity/getUserAndActivity.do",
							data : {
								"id":id
							},
							type : "get",
							dataType : "json",
							success : function (data) {

								/*
								* 前端需要的是uList和activity对象信息
								* data
								* {"uList":[{"张三"},{"李四"}，...],"a":[{id},{name},...]}
								* */
								//向下拉列表中拼接数据
								var html = "<option></option>";

								$.each(data.uList,function (i,n) {
									html += "<option value='"+n.id+"'>"+n.name+"</option>";
								})

								$("#edit-owner").html(html);

								//向修改模态窗口中的各个元素赋值
								$("#edit-id").val(data.a.id);//用一个隐藏域存储id信息
								$("#edit-name").val(data.a.name);
								$("#edit-owner").val(data.a.owner);
								$("#edit-startDate").val(data.a.startDate);
								$("#edit-endDate").val(data.a.endDate);
								$("#edit-cost").val(data.a.cost);
								$("#edit-description").val(data.a.description);

								//处理完元素之后，弹出模态窗口
								$("#editActivityModal").modal("show");

							}
					})

				}
			})

			//为市场活动更新按钮绑定事件
			$("#updateBtn").click(function () {

				//向后端发送ajax请求
				$.ajax({
					url:"workbench/activity/update.do",
					data:{
						"id" : $.trim($("#edit-id").val()),
						"owner" : $.trim($("#edit-owner").val()),
						"name" : $.trim($("#edit-name").val()),
						"startDate" : $.trim($("#edit-startDate").val()),
						"endDate" : $.trim($("#edit-endDate").val()),
						"cost" : $.trim($("#edit-cost").val()),
						"description" : $.trim($("#edit-description").val())

					},
					type:"post",
					dataType:"json",
					success:function (data) {
						if(data.success){
							//添加成功后
							//刷新市场活动信息列表（局部刷新）
							pageList(1,2);


							//关闭添加操作的模态窗口
							$("#editActivityModal").modal("hide");

							//alert("更新成功！")
						}else{
							alert("市场活动更新失败！")
						}
					}
				})

			})
		});

		//用于处理分页逻辑的函数
		function pageList(pageNo,pageSize) {

			//将全选框设置为未选中
			$("#qx").prop("checked",false);

			//向后端发起Ajax请求
			$.ajax({

				url: "workbench/activity/pageList.do",
				data:{
					"pageNo" : pageNo,
					"pageSize" : pageSize,
					"owner" : $.trim($("#search-owner").val()),
					"name" : $.trim($("#search-name").val()),
					"startDate" : $.trim($("#search-startDate").val()),
					"endDate" : $.trim($("#search-endDate").val())
				},
				type: "get",
				dataType: "json",
				success:function (data) {
					/*
					data
						[{市场活动1},{2},{3}] List<Activity> aList
						分页插件需要的：查询出来的总记录数
						{"total":100} int total
						{"total":100,"dataList":[{市场活动1},{2},{3}]}
				 */

					//console.log(data);
					var html = "";

					//每一个n就是每一个市场活动对象
					$.each(data.dataList,function (i,n) {

						html += '<tr class="active">';
						html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
						html += '<td>'+n.owner+'</td>';
						html += '<td>'+n.startDate+'</td>';
						html += '<td>'+n.endDate+'</td>';
						html += '</tr>';
					})

					$("#activityBody").html(html);

					//计算总页数
					var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;

					//数据处理完毕后，结合分页查询，对前端展现分页信息
					$("#activityPage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // 每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: data.total, // 总记录条数

						visiblePageLinks: 3, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						//该回调函数时在，点击分页组件的时候触发的
						onChangePage : function(event, data){
							pageList(data.currentPage , data.rowsPerPage);
						}
					});
				}

			})
		}
	</script>
</head>
<body>

	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-startDate"/>
	<input type="hidden" id="hidden-endDate"/>


	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">

						<%--存储修改窗口的id信息隐藏域--%>
						<input type="hidden" id="edit-id"/>

						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
							<label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<!--

									关于文本域textarea：
										（1）一定是要以标签对的形式来呈现,正常状态下标签对要紧紧的挨着
										（2）textarea虽然是以标签对的形式来呈现的，但是它也是属于表单元素范畴
												我们所有的对于textarea的取值和赋值操作，应该统一使用val()方法（而不是html()方法）

								-->
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activityAddForm" class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">



								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" >
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<!--

						data-dismiss="modal"
							表示关闭模态窗口

					-->
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	

	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon ">开始日期</div>
					  <input class="form-control time" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon ">结束日期</div>
					  <input class="form-control time" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<!--

						点击创建按钮，观察两个属性和属性值

						data-toggle="modal"：
							表示触发该按钮，将要打开一个模态窗口

						data-target="#createActivityModal"：
							表示要打开哪个模态窗口，通过#id的形式找到该窗口


						现在我们是以属性和属性值的方式写在了button元素中，用来打开模态窗口
						但是这样做是有问题的：
							问题在于没有办法对按钮的功能进行扩充

						所以未来的实际项目开发，对于触发模态窗口的操作，一定不要写死在元素当中，
						应该由我们自己写js代码来操作
					-->
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">

				<div id="activityPage"></div>

			</div>
			
		</div>
		
	</div>
</body>
</html>