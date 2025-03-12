document.addEventListener("turbo:load", function () {
  // 好きな理由の文字数カウント
  const inputTextReasonFavorite = document.getElementById('inputTextReasonFavorite');
  const characterCountReasonFavorite = document.getElementById('characterCountReasonFavorite');
  const characterCountWrapReasonFavorite = document.getElementById('characterCountWrapReasonFavorite');

  if (inputTextReasonFavorite) {
    function keyUpReasonFavorite() {
      let str = inputTextReasonFavorite.value.replace(/\r?\n/g, '');
      let num = 100 - str.length;

      characterCountReasonFavorite.textContent = num;
      if(num >= 0) {
        characterCountWrapReasonFavorite.style.color = 'black';
      } else {
        characterCountWrapReasonFavorite.style.color = 'red';
      }
    }

    // **ページロード時にカウントを更新**
    keyUpReasonFavorite();

    // **キー入力時にカウントを更新**
    inputTextReasonFavorite.addEventListener('keyup', keyUpReasonFavorite);
  }

  // 好きになったキッカケの文字数カウント
  const inputTextTriggerFavorite = document.getElementById('inputTextTriggerFavorite');
  const characterCountTriggerFavorite = document.getElementById('characterCountTriggerFavorite');
  const characterCountWrapTriggerFavorite = document.getElementById('characterCountWrapTriggerFavorite');

  if (inputTextTriggerFavorite) {
    function keyUpTriggerFavorite() {
      let str = inputTextTriggerFavorite.value.replace(/\r?\n/g, '');
      let num = 100 - str.length;

      characterCountTriggerFavorite.textContent = num;
      if(num >= 0) {
        characterCountWrapTriggerFavorite.style.color = 'black';
      } else {
        characterCountWrapTriggerFavorite.style.color = 'red';
      }
    }

    // **ページロード時にカウントを更新**
    keyUpTriggerFavorite();

    // **キー入力時にカウントを更新**
    inputTextTriggerFavorite.addEventListener('keyup', keyUpTriggerFavorite);
  }

  // 推し活履歴の文字数カウント
  const inputTextActivityHistory = document.getElementById('inputTextActivityHistory');
  const characterCountActivityHistory = document.getElementById('characterCountActivityHistory');
  const characterCountWrapActivityHistory = document.getElementById('characterCountWrapActivityHistory');

  if (inputTextActivityHistory) {
    function keyUpActivityHistory() {
      let str = inputTextActivityHistory.value.replace(/\r?\n/g, '');
      let num = 200 - str.length;

      characterCountActivityHistory.textContent = num;
      if(num >= 0) {
        characterCountWrapActivityHistory.style.color = 'black';
      } else {
        characterCountWrapActivityHistory.style.color = 'red';
      }
    }

    // **ページロード時にカウントを更新**
    keyUpActivityHistory();

    // **キー入力時にカウントを更新**
    inputTextActivityHistory.addEventListener('keyup', keyUpActivityHistory);
  }
});