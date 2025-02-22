window.addEventListener("trix-file-accept", function(event) {
  // 画像の拡張子をチェック
  const acceptedTypes = ['image/jpg', 'image/jpeg', 'image/png']
  if (!acceptedTypes.includes(event.file.type)) {
    event.preventDefault()
    alert("添付できる拡張子は、jpg、jpeg、pngのみです")
  }
  // 画像のbyte数をチェック
  const maxFileSize = 1024 * 1024; // 1MB
  if (event.file.size > maxFileSize) {
    event.preventDefault();
    alert("1MB以上の画像は投稿できません");
  }

  const maxFileCount = 5;
  const fileCount = document.getElementsByTagName("figure").length;
  if (fileCount > maxFileCount) {
    event.preventDefault();
    alert("1回の投稿では6枚が上限です");
  }
})