function setupCharacterCountArticle() {
  // タイトルの文字数カウント
  const inputTextTitle = document.getElementById('inputTextTitle');
  const characterCountTitle = document.getElementById('characterCountTitle');
  const characterCountWrapTitle = document.getElementById('characterCountWrapTitle');

  if (inputTextTitle) {
    function keyUpTitle() {
      let str = inputTextTitle.value.replace(/\r?\n/g, '');
      let num = 50 - str.length;

      characterCountTitle.textContent = num;
      if(num >= 0) {
        characterCountWrapTitle.style.color = 'black';
      } else {
        characterCountWrapTitle.style.color = 'red';
      }
    }

    // **ページロード時にカウントを更新**
    keyUpTitle();

    // **キー入力時にカウントを更新**
    inputTextTitle.addEventListener('keyup', keyUpTitle);
  }

  // お知らせの文字数カウント
  const inputTextNotice = document.getElementById('inputTextNotice');
  const characterCountNotice = document.getElementById('characterCountNotice');
  const characterCountWrapNotice = document.getElementById('characterCountWrapNotice');

  if (inputTextNotice) {
    function keyUpNotice() {
      let str = inputTextNotice.value.replace(/\r?\n/g, '');
      let num = 100 - str.length;

      characterCountNotice.textContent = num;
      if(num >= 0) {
        characterCountWrapNotice.style.color = 'black';
      } else {
        characterCountWrapNotice.style.color = 'red';
      }
    }

    // **ページロード時にカウントを更新**
    keyUpNotice();

    // **キー入力時にカウントを更新**
    inputTextNotice.addEventListener('keyup', keyUpNotice);
  }
};

// **ページロード時・Turbo遷移後にセットアップ**
document.addEventListener("turbo:load", setupCharacterCountArticle);
document.addEventListener("turbo:frame-load", setupCharacterCountArticle);
document.addEventListener("turbo:render", setupCharacterCountArticle);
