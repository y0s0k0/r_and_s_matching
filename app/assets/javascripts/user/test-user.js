$(function() {
  $(document).on("turbolinks:load", function() {
    $(".test-user-check").on("click", function() {
      var check = $(this).prop("checked");
      console.log(check);
      var email = $("#login-email");
      var password = $("#login-password");
      if (check) {
        email.val("test@gmail.com");
        password.val("testtest");
      } else {
        email.val("");
        password.val("");
      }
    });
  });
});