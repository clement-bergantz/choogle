function scrollLastCommentIntoView() {
  const comments = document.querySelectorAll('.media-comment');
  const lastComment = comments[comments.length - 1];
  $(".media-list").animate({scrollTop: $(".media-list").prop("scrollHeight")}, 1000);
}
