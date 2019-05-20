  var tab = $("#tab");
  var tab_value = tab.val();
  $(window).on("load", function(){
    tab_set(tab_value);
  });
  tab.on("input", function(event) {
    //タブの数をリセットしてから再度生成
    $('.tab_group').remove();
    var tab_value = tab.val();
      tab_set(tab_value);
  });

function tab_set(tab_value){
  item_id = $("#item_id").html();
  if(Number(tab_value) <= 1 || Number(tab_value) == null){
    //タブ数が1のとき、普通にdescriptionを表示
    var description = $("<div></div>", {
      "class": "form-group tab_group"
    });
    var text = $("#description").html();
    description.html(
      '<label class="control-label" for="component_item_description">Description</label>'
      + '<textarea class="form-control" id="component_item_description" name="component_item[description]" rows="20">'
      +text+'</textarea>'
    );
    description.insertBefore("#size");

  }else if(Number(tab_value) > 10){
    for (step = 1; step <= 10; step++){
      //タブ数が10以上のとき、10とみなす
      var title_text = $("#" + Number(item_id) + "_tt" + Number(step)).html();
      var title = $("<div></div>", {
        "class": "form-group tab_group"
      });
      title.html(
        '<label class="control-label" for="component_item_tab' + Number(step) + '_title">Tab-Title' + Number(step)
          + '</label> <textarea class="form-control" name="component_item[tab' + Number(step) + '_title]" rows="1">'
          + title_text + '</textarea>'
        );

      var desc_text = $("#" + Number(item_id) + "_tc" + Number(step)).html();
      var description = $("<div></div>", {
        "class": "form-group tab_group"
      });
      description.html(
      '<label class="control-label" for="component_item_tab' + Number(step) + '_text">Tab-Text' + Number(step)
      + '</label> <textarea class="form-control" name="component_item[tab' + Number(step) + '_text]" rows="20">'
      + desc_text + '</textarea>'
      );
      //サイズ入力欄の上に挿入
      title.insertBefore("#size");
      description.insertBefore("#size");
    }
  }else{
    for (step = 1; step <= Number(tab_value); step++){
      //タブの数だけtab_titleとtab_text入力フォームを生成
      var title_text = $("#" + Number(item_id) + "_tt" + Number(step)).html();
      var title = $("<div></div>", {
        "class": "form-group tab_group"
      });
      title.html(
        '<label class="control-label" for="component_item_tab' + Number(step) + '_title">Tab-Title' + Number(step)
          + '</label> <textarea class="form-control" name="component_item[tab' + Number(step) + '_title]" rows="1">'
          + title_text + '</textarea>'
        );

      var desc_text = $("#" + Number(item_id) + "_tc" + Number(step)).html();
      var description = $("<div></div>", {
        "class": "form-group tab_group"
      });
      description.html(
      '<label class="control-label" for="component_item_tab' + Number(step) + '_text">Tab-Text' + Number(step)
      + '</label> <textarea class="form-control" name="component_item[tab' + Number(step) + '_text]" rows="20">'
      + desc_text + '</textarea>'
      );
      //サイズ入力欄の上に挿入
      title.insertBefore("#size");
      description.insertBefore("#size");
    }
  }
}
