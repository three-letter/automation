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
    if(type>0 && type<3)
      $("#operate_video").show();
    else
      $("#operate_video").hide();
  });
  //ajax方式重建索引
  $("#operate_build_btn").click(function(){
    $("#operate_build_form").submit();
    var build_html = '<div style="width:200px;" class="progress progress-striped active"><div class="bar" style="width: 100%;">索引重建中,请稍后...</div></div>';
    $("#operate_build_area").html(build_html);
  });
});



