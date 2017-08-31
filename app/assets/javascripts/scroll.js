function scrollLastCommentIntoView() {
  const comments = document.querySelectorAll('.media-comment');
  const lastComment = comments[comments.length - 1];
  lastComment.scrollIntoView();
}
