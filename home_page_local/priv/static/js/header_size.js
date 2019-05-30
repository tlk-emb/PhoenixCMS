window.addEventListener("load", function(){
  var os = navigator.userAgent;
  //OSで解像度がちがう
  if(os.indexOf('Mobile') >= 0){
    if(os.indexOf('iPhone') >= 0 || os.indexOf('Android') >= 0){
      if(os.indexOf('OS 12') <= 0){//iOS5~8plus, android
        var btns = document.getElementsByClassName("tool-btn");
        for(var i = 0; i < btns.length; i++){
          btns[i].style.fontSize = "11px";
        }
      }
    }else{
    }
  }
})
