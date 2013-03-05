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
  //href为#id的链接以toggle方式隐藏显示
  $("a").each(function(){
    $(this).click(function(){
      obj = $(this).attr("href");
      if(obj.indexOf("#") == 0)
        $(obj).toggle();
    });
  });

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
  //var jug = new Juggernaut;
  //jug.subscribe("/video_ids/msg", function(data){
  //    if(data!=null && data.length>0)
	//			$("#msg-area").html("<a href='#' class='brand'>"+data+"</a>");
  //});
  
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

  $("*[name='interface[][:param]']").live("blur", function(){
      var param = $(this).val();
      if(param.length == 0)
        $(this).next().hide();
      else
        $(this).next().show();
  });

  $("select[name='interface[][:type]']").live("change", function(){
      var p_div = $(this).parent();
      var type = $(this).val();
      var html = ''
      if(type == 0)
        p_div.children("p").remove();
      else{
        html = '<p>';
        html += '<input name="interface[][:host]" class="input-large" type="text" placeholder="接口地址">';
        html += '<input class="input-small" type="text" value="" name="interface[][:param]" placeholder="接口参数">';
        html += '<select style="display:none" class="span1" name="interface[][:type]">';
        html += '<option value="0">手输</option>';
        html += '<option value="1">接口</option>';
        html += '</select>';
        html += '<input class="input-small" type="text" value="" name="interface[][:result]" placeholder="返回结果">';
        html += '<input type="hidden" value="'+$(this).prev().val()+'" name="interface[][:parent]">';
        html += '</p>'; 
      }
      p_div.append($(html));
  });

  //动态添加demand参数
  $("#demand_param_add").click(function(){
     var p_div = $(this).parent();
     var html = '';
     html += '<div class="control-group">';
     html += '<label class="control-label">Params</label>';
     html += '<div class="controls">';
     html += '<input class="input-small" name="demand[][:param]" type="text" value="" />';
     html += '<select class="span1" name="demand[][:type]">';
     html += '<option value="0">手输</option>';
     html += '<option value="1">接口</option>';
     html += '</select>';
     html += '</div> </div>';
     p_div.append($(html));

  });

  //动态显示filedb的视频信息
  $("*[name='filedb_datasource']").click(function(){
    host = ''
    $("*[name='filedb_host']").each(function(){
      if($(this).attr("checked") == "checked")
        host = $(this).val(); 
    });
    source = $(this).val();
    $.ajax({
        url: "/filedb/show",
        type: "GET",
        data: "filedb_host="+host+"&filedb_datasource="+source,
        success:function(data){
        }
    });
  });

  $("*[name='filedb_vid']").each(function(){
     var values = $("#filedb_values").val();
     if(values.length == 0)
        values = ","
     var value = $(this).val();
//if($(this).attr("checked") == "checked")
        
  });










  $("*[name='demand[][:param]']").live("blur", function(){
      var param = $(this).val();
      if(param.length == 0)
        $(this).next().hide();
      else
        $(this).next().show();
  });

  $("select[name='demand[][:type]']").live("change", function(){
      var p_div = $(this).parent();
      var type = $(this).val();
      var html = ''
      if(type == 0)
        p_div.children("p").remove();
      else{
        html = '<p>';
        html += '<input name="interface[][:host]" class="input-large" type="text" placeholder="接口地址">';
        html += '<input class="input-small" type="text" value="" name="interface[][:param]" placeholder="接口参数">';
        html += '<select style="display:none" class="span1" name="interface[][:type]">';
        html += '<option value="0">手输</option>';
        html += '<option value="1">接口</option>';
        html += '</select>';
        html += '<input class="input-small" type="text" value="" name="interface[][:result]" placeholder="返回结果">';
        html += '<input type="hidden" value="'+$(this).prev().val()+'" name="interface[][:parent]">';
        html += '</p>'; 
      }
      p_div.append($(html));
  });


    //playpolicy js操作
    var test_envir_q = 0;
    var test_point_q = 'p2p';
    $("*[name='test_envir']").each(function(){
      $(this).click(function(){
        var test_envir = $(this).val(); 
        test_envir_q = test_envir;
        $.ajax({
            url: "/playpolicy/change_envir",
            type: "GET",
            data: "test_envir="+test_envir+'&test_point='+test_point_q,
            success:function(data){
            }
        });
     });
    });

    $("*[name='test_point']").each(function(){
      $(this).click(function(){
        var test_point = $(this).val(); 
        test_point_q = test_point;
        $.ajax({
            url: "/playpolicy/change_point",
            type: "GET",
            data: "test_envir="+test_envir_q+"&test_point="+test_point,
            success:function(data){
            }
        });
     });
    });

    // test api 
    $("*[name='choose_case_box']").each(function(){
       $(this).click(function(){
         var cho = $(this).val();
         var chk = $(this).attr("checked");
         if(chk == "checked"){
            var html = '<input type="hidden" name="choose_case[]" value="' + cho + '">';
            $(this).append($(html));
         }else
          $(this).children("input").remove();
       }); 
    });
    

  //ajax方式查询消息中心
  $("#operate_seq_btn").click(function(){
    $("#operate_seq_form").submit();
    var seq_html = '<div style="width:200px;" class="progress progress-striped active"><div class="bar" style="width: 100%;">正在查询消息中心,请稍后...</div></div>';
    $("#operate_seq_area").html(seq_html);
  });

  //ajax方式创建并投放广告
  $("#ad_shortcut_btn").click(function(){
    $("#ad_shortcut_form").submit();
    var build_html = '<div style="width:200px;" class="progress progress-striped active"><div class="bar" style="width: 100%;">广告创建投放中,请稍后...</div></div>';
    $("#ad_shortcut_area").html(build_html);
  });
