// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

$(document).ready(function(){ 
  
  //选择索引重建的类型
  $("#operate_type").change(function(){
    var type = $(this).val();
    $("#type").val(type);
    if(type == "video.show")
      $("#type_hide").show();
    else
      $("#type_hide").hide();
  });
  
  //视频子类型的赋值
  $("*[name='type_video']").each(function(){
    $(this).click(function(){
      var type = $(this).val();
      $("#type").val(type);
    });
  });

  //待更新字段的节目起始ID赋值
  $("*[name='state_c']").each(function(){
    $(this).click(function(){
      var state = $(this).val();
      if(state == 0){
        $("#state").val("");
        $("#state").hide();
      }else{
        $("#state").show();
      }
    });    
  });

  //ajax方式重建索引
  $("#operate_build_btn").click(function(){
    $("#operate_build_form").submit();
    var build_html = '<div style="width:200px;" class="progress progress-striped active"><div class="bar" style="width: 100%;">索引重建中,请稍后...</div></div>';
    $("#operate_build_area").html(build_html);
  });
  
  //若有消息则右上角显示信封
  var jug = new Juggernaut;
  jug.subscribe("/video_ids/msg", function(data){
      if(data!=null && data.length>0)
				$("#msg-area").html("<a href='#' class='brand'>"+data+"</a>");
  });
  
  //ajax方式查询中间层节目信息
  $("#ds_show_input").blur(
    function(){
    var show_id = $("#ds_show_input").val();
    if(show_id.length == 0)
      alert("节目ID不能为空！");
    else
      $("#ds_show_input_form").submit();
  });

});

  //根据grant_type显示对应的输入项
  $("#app_info_grant_type_input").change(function(){
    var cur = $(this).val();
    $("#app_info_grant_type_input option").each(function(){
      var type = $(this).val();
    if(type == cur)
        $("#"+type).show();
      else
        $("#"+type).hide();
    });
  });

  //根据playlog_type显示对应的输入项
  $("#playlog_type_input").change(function(){
    var cur = $(this).val();
    $("#playlog_type_input option").each(function(){
      var type = $(this).val();
      if(cur == type)
        $("#playlog_"+type).show();
      else
        $("#playlog_"+type).hide();
    });
  });

  //根据demand的param类型显示对应的输入项
  $("*[name='demand_param_type']").each(function(){
    var p_div = $(this).parent();
    $(this).change(function(){
      var type = $(this).val();
      var html = ''
      if(type == 0)
        $(this).next().next().remove();
      else
        html = '<p><input name="children_host" class="input-xxlarge" type="text" placeholder="请输入获取该参数值的接口地址 参数 以及返回结果key 用空格分开"></p>'; 
      p_div.append($(html));
    });
  });

















