window_load();
window.addEventListener("resize", window_load);


function window_load(){
  var sW;
   sW = window.innerWidth - 48;
  //line-""エレメントが存在すれば取得(line-1は0pxなのでスルー)
  for(var i = 2; i < 12; i++){
    if(document.getElementById("line-" + String(i)) != null){
      line = document.getElementsByClassName("line-" + String(i));
      for(var j = 0; j < line.length; j++){
        if(sW >= 720){
          line[j].style.marginLeft = String(sW / (12 * (i - 1))) + "px";
        }else{
          line[j].style.marginLeft = "0px";
        }
      }
    }
  }
}
