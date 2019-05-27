  var tab = $("#tab");
  var tab_value = tab.val();

  $(window).on("load", function(){
    tab_set(tab_value);
    html_preview(tab_value);
    //textエリアの内容が変化したときにプレビューを更新
    $("#notab_description").on("input", function(event){
      $("#description_html").remove();
      html_preview(tab_value);
    });
    $(".tab_html").each(function(index, object){
      $("#tab" + Number(index + 1) + "_description").on("input", function(event){
        $(".tab_html").remove();
        html_preview(tab_value);
      });
    });
    //tab入力を処理する
    $("#notab_description").on('keydown', function(e){
      if (e.keyCode === 9) {
          e.preventDefault();
          var elem = e.target;
          var val = elem.value;
          var pos = elem.selectionStart;
          elem.value = val.substr(0, pos) + '\t' + val.substr(pos, val.length);
          elem.setSelectionRange(pos + 1, pos + 1);
      }
    });
    $(".tab_description").on('keydown', function(e){
      if (e.keyCode === 9) {
          e.preventDefault();
          var elem = e.target;
          var val = elem.value;
          var pos = elem.selectionStart;
          elem.value = val.substr(0, pos) + '\t' + val.substr(pos, val.length);
          elem.setSelectionRange(pos + 1, pos + 1);
      }
    });
  });
  //タブ数が変わるとhtml構造が変わるので再記述
  tab.on("input", function(event) {
    //タブの数をリセットしてから再度生成
    $(".tab_group").remove();
    var tab_value = tab.val();
    tab_set(tab_value);
    //プレビューも一旦削除して作り直す
    $("#description_html").remove();
    $(".tab_html").remove();
    html_preview(tab_value);
    //textエリアの内容が変化したときにプレビューを更新
    $("#notab_description").on("input", function(event){
      $("#description_html").remove();
      html_preview(tab_value);
    });
    $(".tab_html").each(function(index, object){
      $("#tab" + Number(index + 1) + "_description").on("input", function(event){
        $(".tab_html").remove();
        html_preview(tab_value);
      });
    });
    //tab入力を処理する
    $("#notab_description").on('keydown', function(e){
      if (e.keyCode === 9) {
          e.preventDefault();
          var elem = e.target;
          var val = elem.value;
          var pos = elem.selectionStart;
          elem.value = val.substr(0, pos) + '\t' + val.substr(pos, val.length);
          elem.setSelectionRange(pos + 1, pos + 1);
      }
    });
    $(".tab_description").on('keydown', function(e){
      if (e.keyCode === 9) {
          e.preventDefault();
          var elem = e.target;
          var val = elem.value;
          var pos = elem.selectionStart;
          elem.value = val.substr(0, pos) + '\t' + val.substr(pos, val.length);
          elem.setSelectionRange(pos + 1, pos + 1);
      }
    });
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
      '<label class="control-label" for="component_item_description" id="description_label">Description</label>'
      + '<textarea class="form-control" id="notab_description" name="component_item[description]" rows="20">'
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
      '<label class="control-label" for="component_item_tab' + Number(step) + '_text" id="tab' + Number(step) + '_label">Tab-Text' + Number(step)
      + '</label> <textarea class="form-control tab_description" name="component_item[tab' + Number(step) + '_text]" rows="20" id="tab' + Number(step) + '_description">'
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
      '<label class="control-label" for="component_item_tab' + Number(step) + '_text" id="tab' + Number(step) + '_label">Tab-Text' + Number(step)
      + '</label> <textarea class="form-control tab_description" name="component_item[tab' + Number(step) + '_text]" rows="20" id="tab' + Number(step) + '_description">'
      + desc_text + '</textarea>'
      );
      //サイズ入力欄の上に挿入
      title.insertBefore("#size");
      description.insertBefore("#size");
    }
  }
}
//texiarea内に記述したマークダウンをhtmlに変換しリアルタイム表示
function html_preview(tab_value){
  if(tab_value <= 1 || tab_value == null){
    var markdown = $("#notab_description").val();
    if(markdown && markdown.replace(/\s+/g, "") != ""){
      var preview = "######プレビュー######\n" + marked(markdown) + "##########"
    }else{
      var preview = ""
    }
    var dom = $('<div id="description_html"></div>');
    dom.html(preview);
    dom.insertBefore("#description_label");
  }else if(Number(tab_value) > 10){
    for (step = 1; step <= 10; step++){
      var markdown = $("#tab" + Number(step) + "_description").val();
      if(markdown && markdown.replace(/\s+/g, "") != ""){
        var preview = "######プレビュー######\n" + marked(markdown) + "##########"
      }else{
        var preview = ""
      }
      var dom = $('<div class="tab_html"></div>');
      dom.html(preview);
      dom.insertBefore("#tab" + Number(step) + "_label");
    }
  }else{
    for (step = 1; step <= Number(tab_value); step++){
      var markdown = $("#tab" + Number(step) + "_description").val();
      if(markdown && markdown.replace(/\s+/g, "") != ""){
        var preview = "######プレビュー######\n" + marked(markdown) + "##########"
      }else{
        var preview = ""
      }
      var dom = $('<div class="tab_html"></div>');
      dom.html(preview);
      dom.insertBefore("#tab" + Number(step) + "_label");
    }
  }
}
