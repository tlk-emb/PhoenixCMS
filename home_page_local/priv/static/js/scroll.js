//スピードなどの設定
var scrollOptions = {
    pageTopBtn : 'scroll_top_btn', // トップへ戻るボタンのID名（”名”のみで＃はつけない）
    hamburger : "navmenu1", // ハンバーガーメニューのID名
    showScroll : 200, // ボタンの出現するスクロール位置 PX単位
    scrollSpeed : 10, //早い→5　普通→10 ゆっくり→20
    navScrollSpeed : 5,
    fadeSpeed : 10, // 早い 5 〜 30 ゆっくり
    blank : 10 // ナビゲーションバーでスクロールした際にコンテンツの上何px余白をとるか
};

//トップボタンからのスクロール
window.addEventListener("load", function(){

var btn = document.getElementById(scrollOptions.pageTopBtn);

// クリックイベント
btn.onclick = function(){
    // 現在のスクロール位置を取得する
    var x_window = document.body.scrollLeft || document.documentElement.scrollLeft;
    var y_window = document.body.scrollTop  || document.documentElement.scrollTop;
    // スクロール位置を pageTop() 関数へ渡して呼び出す
    pageTop(x_window, y_window);
    return false;
}

// ページトップへ戻るアニメーション
var topScroll_timer;
function pageTop(x_w, y_w){
    if (y_w >= 1) {
        var scTop = Math.floor(y_w - (y_w / (scrollOptions.scrollSpeed * 2)));
        window.scrollTo(x_w, scTop);
        topScroll_timer = setTimeout(function(){pageTop(x_w, scTop)}, scrollOptions.scrollSpeed);
        // ↑ y の値が1以下になるまで y/定数分だけスクロールアップするのを
        // scrollSpeed の設定時間ごとに繰り返す
    } else {
        clearTimeout(topScroll_timer);
        // ↑ y の値が1以下になったらタイマーを止めて数値を引くのをやめる
        window.scrollTo(x_w, 0);
    }
}

// スクロール毎にフェードイン/アウトを管理するイベント
btn.style.opacity = 0;
btn.style.filter = "alpha(opacity:0)";
window.onscroll = function(){
    var winSc = document.body.scrollTop || document.documentElement.scrollTop;
    if(winSc >= scrollOptions.showScroll){
        clearTimeout(fadeOut_timer);
        var opaValue = parseFloat(btn.style.opacity);
        fadeInTimer(opaValue);
        btn.style.pointerEvents = "auto";
        btn.style.cursor = "pointer";
    } else {
        clearTimeout(fadeIn_timer);
        var opaValue = parseFloat(btn.style.opacity);
        fadeOutTimer(opaValue);
        btn.style.pointerEvents = "none";
        btn.style.cursor = "default";
    }
}

// フェイドインアニメーション設定
var fadeIn_timer;
function fadeInTimer(opaValue){
    if (opaValue < 0.8){
        opaValue = opaValue + 0.05;
        btn.style.filter = "alpha(opacity:"+(opaValue*100)+")";
        btn.style.opacity = opaValue;
        fadeIn_timer = setTimeout(function(){fadeInTimer(opaValue);}, scrollOptions.fadeSpeed);
        // ↑opaValue が1になるまで透明度を 0.05 ずつ足して行くのを
        //  fadeSpeed に設定された時間毎に繰り返す
    } else {
        clearTimeout(fadeIn_timer);
        // ↑opaValue が1になったら繰り返し処理を止める
        btn.style.filter = "alpha(opacity:100)";
        btn.style.opacity = 0.8;
    }
}

// フェイドアウトアニメーション設定
var fadeOut_timer;
function fadeOutTimer(opaValue){
    if ( opaValue >= 0.05){
        opaValue = opaValue - 0.05;
        btn.style.filter = "alpha(opacity:"+(opaValue*100)+")";
        btn.style.opacity = opaValue;
        fadeOut_timer = setTimeout(function(){ fadeOutTimer(opaValue); }, scrollOptions.fadeSpeed);
        // opaValue が1になるまで透明度を 0.05 ずつ引いて行くのを
        //  fadeSpeed に設定された時間毎に繰り返す
    } else {
        clearTimeout(fadeIn_timer);
        // ↑ opaValue が0.05以下になったら繰り返し処理を止めて
        // 完全な0にしておく（↓）
        btn.style.filter = "alpha(opacity:0)";
        btn.style.opacity = 0;
    }
}
})

//ナビゲーションバーからのスクロール
function navJump(position){
  //ナビゲーションバーを閉じる
  var hamburger = document.getElementById(scrollOptions.hamburger);
  //console.log(hamburger.classList)
  hamburger.classList.remove("show");

  var contentId = String(position) + "_nav_jump"; // コンテンツのID
  var element = document.getElementById(contentId);
  var rect = element.getBoundingClientRect();//コンテンツの画面上端からの絶対座標
  //var goal_x = 0;
  var goalY = window.pageYOffset + rect.top;//ページの上端からの絶対y座標
  //現在のスクロール位置を取得する
  //var current_x = document.body.scrollLeft || document.documentElement.scrollLeft;
  var currentY = document.body.scrollTop  || document.documentElement.scrollTop;
  navScroll(0, goalY, currentY);
  return false;
}

// ナビゲーションバーからスクロールするアニメーション
var navScroll_timer;
function navScroll(x, gy, cy){
      var distance = gy - cy - scrollOptions.blank;
      if (distance >= 1) {
          var scNav = Math.ceil(cy + (distance / (scrollOptions.scrollSpeed * 2)));
          window.scrollTo(x, scNav);
          navScroll_timer = setTimeout(function(){navScroll(x, gy, scNav)}, scrollOptions.navScrollSpeed);
          // ↑ distanceの値が1以下になるまで y/定数分だけスクロールアップするのを
          // scrollSpeed の設定時間ごとに繰り返す
      } else {
          clearTimeout(navScroll_timer);
          // ↑ y の値が1以下になったらタイマーを止めて数値を引くのをやめる
          window.scrollTo(x, gy - scrollOptions.blank);
      }
}
