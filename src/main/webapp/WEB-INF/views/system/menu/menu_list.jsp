<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
<title>메뉴관리</title>
<style type="text/css">
ul.menu_depth1 > li,
ul.menu_depth2 > li,
ul.menu_depth3 > li {margin: 5px 0;}

ul.menu_depth1 > li > a,
ul.menu_depth2 > li > a,
ul.menu_depth3 > li > a {display: inline-block; border:1px solid #ddd; padding:3px 10px; text-decoration: none; color:#333;}

ul.menu_depth1 > li > a.not_used,
ul.menu_depth2 > li > a.not_used,
ul.menu_depth3 > li > a.not_used {color: #ddd;}

ul.menu_depth1 > li > a.selected,
ul.menu_depth2 > li > a.selected,
ul.menu_depth3 > li > a.selected {background: #eef7ff;}

ul.menu_depth2,
ul.menu_depth3 {padding-left: 50px;}	

.ui-state-highlight {height:25px; background:#eef7ff; border-color: #eef7ff; }
</style>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%-- menu_detail 용 스크립트 --%>
<script>
$(document).on("click", "#btnSave", function(e){
	
	e.preventDefault();
	var frm = $("#regFrm"),
		boolRs = "Y",
		mode = $("#mode").val();
	
	//필수 입력값 검증
	$("#regFrm input").each(function(index){
		
		var input = $(this);
		var isRequired = input.prop("required");
		
		input.parent().removeClass("has-error");
		
// 		if(isRequired){
// 			if(isEmpty(input.val())){
// 				alert("필수 입력항목을 입력하시기 바랍니다.");
// 				input.parent().addClass("has-error");
// 				input.focus();
// 				boolRs = "N";
// 				return false;
// 			}
// 		} 
	});
	
	if(boolRs == "N") return false;
	
	if(confirm("저장하시겠습니까?")){
		var vUrl = "/menu/regist";
		if(mode == "EDIT") { vUrl = "/menu/update"; }
		
		$.ajax({
			url: vUrl,
			type: "get",
			data: $("#regFrm").serializeObject(),
			dataType: "json",
			async: false,
			success: function(data){
				alert(data.message);
				if(data.code=="ok"){
					pasteMenuDetail($("#stmmPageId").val());	
					 $('#divReloadLayer').load();
				}
			}
		});
	}
	else{
		return false;
	}
});

$(document).on("click", "#btnInit", function(){
	pasteMenuDetail('');
});

$(document).on("click", "#btnDelete", function(){
	var pageId = $("#stmmPageId").val();
	
	if(confirm("삭제하시겠습니까?")){
		$.ajax({
			url: "/menu/delete",
			type: "post",
			data: JSON.stringify({stmmPageId : pageId}),
			contentType : "application/json;charset=UTF-8",
			dataType: "json",
			async: false,
			success: function(data){
				alert(data.message);
				if(data.code=="ok"){
					location.reload();	
				}
			}
		});
	}
});

</script>
</head>
<body>
	<div id="gridWrapper" style="height:100%; width:100%;">
			<div class="col-sm-3 sections" style="height:100%;">
			<h5>
				<i class="fas fa-list"></i>
				메뉴 목록
				&nbsp;
				<small><a class="" href="javascript:pasteMenuDetail('')"><i class="fas fa-plus"></i>&nbsp;추가</a></small>
			</h5>
			
			<div id="divReloadLayer" class="panel panel-default" style="height:calc(100% - 100px); overflow-y: auto;">
				<div class="panel-body">
					<!-- 대메뉴 -->
					<ul id="menuList" class="list-unstyled menu_depth1">
						<c:forEach var="depth1" items="${menus.list}">
							<c:if test="${depth1.stmmMenuLvl eq 'DEPTH1'}">
								<li>
									<a class="frame_collapse_menus data_menus" href="#${depth1.stmmPageId}" 
									   data-toggle="collapse" aria-expanded="false" aria-controls="${depth1.stmmPageId}" 
									   data-status="${depth1.stmmIsUse}"
									   data-id="${depth1.stmmPageId}"
									   data-order="${depth1.stmmDispOrd}">
										<i class="fas fa-caret-right"></i> &nbsp;
										${depth1.stmmPageTitle}
									</a>										
									<!-- 2차 메뉴 -->
									<ul class="list-unstyled collapse menu_depth2" id="${depth1.stmmPageId}">
										<c:forEach var="depth2" items="${menus.list}">
											<c:if test="${depth2.stmmMenuLvl eq 'DEPTH2' and depth1.stmmPageId eq depth2.stmmParentId}">
												<li>
													<a class="frame_collapse_menus data_menus" href="#${depth2.stmmPageId}" 
													   data-toggle="collapse" aria-expanded="false" aria-controls="${depth2.stmmPageId}"
													   data-status="${depth2.stmmIsUse}"
									   				   data-id="${depth2.stmmPageId}"
									   				   data-order="${depth2.stmmDispOrd}">
														<i class="fas fa-caret-right"></i> &nbsp;
														${depth2.stmmPageTitle}
													</a>
													<!-- 3차 메뉴 -->
													<ul class="list-unstyled collapse menu_depth3" id="${depth2.stmmPageId}">
														<c:forEach var="depth3" items="${menus.list}">
															<c:if test="${depth3.stmmMenuLvl eq 'DEPTH3' and depth2.stmmPageId eq depth3.stmmParentId}">
																<li>
																	<a class="data_menus" href="javascript:void(0);"
																	   data-status="${depth3.stmmIsUse}"
									   								   data-id="${depth3.stmmPageId}"
									   								   data-order="${depth3.stmmDispOrd}">
																		<i class="far fa-file-alt"></i> &nbsp;
																		${depth3.stmmPageTitle}
																	</a>
																</li>
															</c:if>
														</c:forEach>														
													</ul>
													<!-- 3차 메뉴 -->	
												</li>												
											</c:if>
										</c:forEach>
									</ul>
									<!-- 2차 메뉴 -->									
								</li>
							</c:if>
						</c:forEach>
					</ul>
					<!-- 대메뉴 -->
				</div>
			</div>
			
			<p class="text-right">					
				<button id="btnSortSave" class="btn btn-sm btn-primary">저장</button>
				<button id="btnSortInit" class="btn btn-sm btn-default">초기화</button>
			</p>
			
			<script>
				
				
				
				$(function () {
					$("a").each(function(index){
						var _this = $(this);
						if(_this.data("status") == "N"){
							_this.addClass("not_used");
						}
					});
			    });
				
				$(document).on("click", ".frame_collapse_menus", function(){
// 					var _this = $(this),
// 						isExpanded = _this.attr("aria-expanded"),
// 						_icon = _this.find("i");
					
// 					if(isExpanded == "true"){
// 						_icon.removeClass("fa-caret-right");
// 						_icon.addClass("fa-caret-down");
// 					}
// 					else{
// 						_icon.removeClass("fa-caret-down");
// 						_icon.addClass("fa-caret-right");
// 					}
				});
				
				$(document).on("dblclick", ".data_menus", function(){
					var _this = $(this),
						pageId = _this.data("id");
					
					$(".data_menus").each(function(index){
						$(this).removeClass("selected");
					});
					_this.addClass("selected");
					
					preA();
					
					pasteMenuDetail(pageId);
				});				
				
				function preA(){
					alert();
				}
				
				function pasteMenuDetail(pageId){
					var url = "/menu/detail";
					$("#loadedForm").empty();	
					$("#loadedForm").load(url, {"pageId": pageId});
				}
				
				$(function(){
					$(".menu_depth1, .menu_depth2, .menu_depth3").sortable({
						placeholder: "ui-state-highlight"
				    });
				});
				
				//	순서변경
				$(document).on("click", "#btnSortSave", function(){

					$("ul.menu_depth1 > li > a").each(function(index){
						var _this = $(this),
							_order = index+1;
						
						saveDisplayOrder(_this, _order);
					});
					
					$("ul.menu_depth2 > li > a").each(function(index){
						var _this = $(this),
							_order = index+1;
						
						saveDisplayOrder(_this, _order);
					});
					
					$("ul.menu_depth3 > li > a").each(function(index){
						var _this = $(this),
							_order = index+1;
						
						saveDisplayOrder(_this, _order);
					});
					
					alert("메뉴 순서 변경이 완료되었습니다.\n화면을 새로고침(ctrl + R) 하시거나\n재 로그인하시면 변경된 내용을 확인 하실 수 있습니다.");
					var iframeWrapper = $("#iframe_wrapper", parent.document);							
					reloadActiveIframe(iframeWrapper);
				});
				
				function saveDisplayOrder(obj, _index){
					var _this = obj,
						pageId = _this.data("id"),
						originOrder = _this.data("order"),
						changedOrder = _index;
					
					if(originOrder != changedOrder){
						
						$.ajax({
							url: "/menu/updateOrder",
							type: "get",
							data: {
								stmmPageId: pageId,
								stmmDispOrd: changedOrder
							},
							dataType: "json",
							async: false,
							success: function(data){
// 								alert(data.message);
							}
						});
					}
				}
				
				$(document).on("click", "#btnSortInit", function(){
					if(confirm("화면이 새로고침 됩니다.\n새로고침 하시겠습니까?")){
						//var iframeWrapper = $("#iframe_wrapper", parent.document);
						//reloadActiveIframe(iframeWrapper);
						location.reload();
					}
				});
				
				</script>
			
		</div>
		<div class="col-sm-9 sections" style="height:100%;">
			<h5>
				<i class="fas fa-edit"></i>
				메뉴 상세정보 및 수정
			</h5>
			
			<div class="alert alert-info" role="alert">						
				<p>* 메뉴를 추가하시려면 좌측 상단의 [ +추가 ] 메뉴를 클릭하시기 바랍니다.</p>
				<p>* 메뉴 정보를 수정하시려면 좌측의 메뉴를 <span class="text-danger">더블 클릭</span>하시기 바랍니다.</p>
				<p>* 메뉴의 정렬 순서를 변경하시려면 좌측 메뉴를 드래그 하신 후 하단의 저장버튼을 클릭하시기 바랍니다.</p>
				<p>* 변경된 내용은 화면을 새로고침(ctrl + R) 하시거나 재 로그인하시면 확인 하실 수 있습니다.</p>
			</div>
			
			<div id="loadedForm"></div>
			
		</div>
	</div>
</body>
</html>