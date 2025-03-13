document.addEventListener("turbo:load", function () {
  // タイトルの文字数カウント
  const inputTextComment = document.getElementById('inputTextComment');
  const characterCountComment = document.getElementById('characterCountComment');
  const characterCountWrapComment = document.getElementById('characterCountWrapComment');
  

  if (inputTextComment) {
    function keyUpComment() {
      let str = inputTextComment.value.replace(/\r?\n/g, '');
      let num = 1000 - str.length;

      characterCountComment.textContent = num;
      if(num >= 0) {
        characterCountWrapComment.style.color = 'black';
      } else {
        characterCountWrapComment.style.color = 'red';
      }
    }

    // **ページロード時にカウントを更新**
    keyUpComment();

    // **キー入力時にカウントを更新**
    inputTextComment.addEventListener('keyup', keyUpComment);
  }
});