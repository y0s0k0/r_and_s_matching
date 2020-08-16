$(function() {
  $(document).on("turbolinks:load", function() {
    function insertImage(avatar) {
      var html = `<div class="image-preview">
                    <div class="image-preview__body">
                      <img class="image-content" src="${avatar}">
                    </div>
                    <div class="image-preview__del-btn">
                      <span>削除</span>
                    </div>
                  </div>`;
      return html;
    }

    var avatarCheck = $(".user-avatar-choice__label");
    var inputForm = $(".user-avatar-choice__input");
    var formBtn = $(".info-registration__btn");
    formBtn.prop('disabled', false);

    $(document).ready(function() {
      var targetId = $("#avatar-preview");
      var avatar = targetId.data("avatar");
      if (avatar && avatarCheck.css("display") != "none") {
        $(".user-avatar-choice__label").css("display", "none");
        targetId.append(insertImage(avatar));
      }
    });

    inputForm.on("change", function(e) {
      var file = e.target.files[0];
      var reader = new FileReader();
      reader.onload = function(e) {
        var result = e.target.result;
        $(".user-avatar-choice__label").css("display", "none");
        $("#avatar-preview").append(insertImage(result));
      }
      reader.readAsDataURL(file);
      $("#user_avatar_delete_instruction").val("nothing");
    });

    $(document).on("click", ".image-preview__del-btn", function() {
      $(this).parent().remove();
      $("#user-avatar").val(null);
      $("#user_avatar_delete_instruction").val("run");
      $(".user-avatar-choice__label").css("display", "");
    })
  });
});
