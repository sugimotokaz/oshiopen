document.addEventListener("turbo:load", function () {
  // タイトルの文字数カウント
  const inputTextSelfIntroduction = document.getElementById('inputTextSelfIntroduction');
  const characterCountSelfIntroduction = document.getElementById('characterCountSelfIntroduction');
  const characterCountWrapSelfIntroduction = document.getElementById('characterCountWrapSelfIntroduction');
  

  if (inputTextSelfIntroduction) {
    function keyUpSelfIntroduction() {
      let str = inputTextSelfIntroduction.value.replace(/\r?\n/g, '');
      let num = 1000 - str.length;

      characterCountSelfIntroduction.textContent = num;
      if(num >= 0) {
        characterCountWrapSelfIntroduction.style.color = 'black';
      } else {
        characterCountWrapSelfIntroduction.style.color = 'red';
      }
    }

    // **ページロード時にカウントを更新**
    keyUpSelfIntroduction();

    // **キー入力時にカウントを更新**
    inputTextSelfIntroduction.addEventListener('keyup', keyUpSelfIntroduction);
  }
});
