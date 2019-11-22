window_load();
window.addEventListener("resize", window_load);


function window_load(){ //要素間のマージンを調整する
  //調整完了まで要素を表示しない

  //OSでwindow幅の処理が違う
    if(navigator.userAgent.indexOf('Mac') >= 0){
      sW = window.innerWidth - 48;
      //line-""エレメントが存在すれば取得(line-1は0pxなのでスルー)
      for(var i = 2; i < 12; i++){
        if(document.getElementById("line-" + String(i)) != null){
          var line = $(".line-" + Number(i));
          for(var j = 0; j < line.length; j++){
            if(sW >= 720){
              line[j].style.marginLeft = String(sW / (12 * (i - 1))) + "px";
            }else{
              line[j].style.marginLeft = "0px";
            }
          }
        }
      }
    }else if(navigator.userAgent.indexOf('Win') >= 0){
      sW = window.innerWidth - 49;
      //line-""エレメントが存在すれば取得(line-1は0pxなのでスルー)
      for(var i = 2; i < 12; i++){
        if(document.getElementById("line-" + String(i)) != null){
          var line = $(".line-" + Number(i));
          for(var j = 0; j < line.length; j++){
            if(sW >= 719){
              line[j].style.marginLeft = String(sW / (12 * (i - 1))) + "px";
            }else{
              line[j].style.marginLeft = "0px";
            }
          }
        }
    }
  }
  //完了後、要素(mainとfooter)を表示
  var main = document.getElementById("main");
  var footer = document.getElementById("footer");
  main.removeAttribute("hidden");
  footer.removeAttribute("hidden");

}
