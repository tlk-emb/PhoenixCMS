
$(function(){
  var $tab = $("#tab");
  $tab.on("input", function(event) {
    var tab_value = $tab.val();
    for (step = 0; step < Number(tab_value); step++){
      //タブの数だけdescription入力フォームを生成
      document.createElement("div")
      $('#size').before(
        '<div class="form-group" >
          <%= label f, :description, class: "control-label" %>
          <%= textarea f, :description, class: "form-control", rows: 20 %>
          <%= error_tag f, :description %>
        </div>'
      );

    }
  })
})
