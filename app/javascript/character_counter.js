function keyUpTitle(e) {
  let str = inputTextTitle.value;
  // 改行で文字のカウントが起きない設定。改行を空白に置き換えてくれるため、カウントされない。
  str = str.replace(/\r?\n/g, '');

  // カウント数を減らす記述。
  let num = 50 - str.length;
  // ID属性を取得して、現在のカウント数を代入する記述。
  const characterCountTitle = document.getElementById('characterCountTitle');
  characterCountTitle.textContent = num;
  // 文字数が0（最大値をオーバー）してしまうと警告として赤文字になるように設定。
  const characterCountWrapTitle = document.getElementById('characterCountWrapTitle');
  if(num >= 0) {
    characterCountWrapTitle.style.color = 'black';
  } else {
    characterCountWrapTitle.style.color = 'red';
  }
}

const inputTextTitle = document.getElementById('inputTextTitle');
inputTextTitle.addEventListener('keyup', keyUpTitle, false);


function keyUpNotice(e) {
  let str = inputTextNotice.value;
  // 改行で文字のカウントが起きない設定。改行を空白に置き換えてくれるため、カウントされない。
  str = str.replace(/\r?\n/g, '');

  // カウント数を減らす記述。
  let num = 100 - str.length;
  // ID属性を取得して、現在のカウント数を代入する記述。
  const characterCountNotice = document.getElementById('characterCountNotice');
  characterCountNotice.textContent = num;
  // 文字数が0（最大値をオーバー）してしまうと警告として赤文字になるように設定。
  const characterCountWrapNotice = document.getElementById('characterCountWrapNotice');
  if(num >= 0) {
    characterCountWrapNotice.style.color = 'black';
  } else {
    characterCountWrapNotice.style.color = 'red';
  }
}

const inputTextNotice = document.getElementById('inputTextNotice');
inputTextNotice.addEventListener('keyup', keyUpNotice, false);
