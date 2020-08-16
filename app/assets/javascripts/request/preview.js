$(function() {
  $(document).on("turbolinks:load", function() {
    function insertImage(id, image) {
      var html = `<div class="image-preview" data-id=${id}>
                    <div class="image-preview__body">
                      <img class="image-content" src="${image}">
                    </div>
                    <div class="image-preview__del-btn">
                      <span>削除</span>
                    </div>
                  </div>`;
      return html;
    }
  
    var inputForm = $(".request-form-image-choice__body");
    var path = location.pathname;
    
    $(document).ready(function() {
      for (var i = 0; i < 3; i++) {
        var targetId = $(`#preview-${i}`);
        var image = targetId.data("image");
        var imageCheck = $(`#label-image-${i}`);
        if (image && imageCheck.css("display") != "none") {
          $(`#label-image-${i}`).css("display", "none");
          targetId.append(insertImage(i, image));
        }
      }
    });
    
    inputForm.on("change", function(e) {
      var file = e.target.files[0];
      var input = $(this);
      var inputValue = input.attr("value");
      var targetLabel = input.siblings();
      var reader = new FileReader();
      reader.onload = function(e) {
        var result = e.target.result;
        targetLabel.css("display", "none");
        $(`#preview-${inputValue}`).append(insertImage(inputValue, result));
      }
      reader.readAsDataURL(file);
      $(`#delete-instruction-${inputValue}`).val("nothing");
    });

    $(document).on("click", ".image-preview__del-btn", function() {
      var targetId = $(this).parent().data("id");
      var deleteTarget = $(this).parent();
      var newReg = /\/requests\/new/;
      var result = path.match(newReg);
      deleteTarget.remove();
      $(`#request_posts_attributes_${targetId}_image`).val(null);
      result == null ? $(`#delete-instruction-${targetId}`).val("run") : ``;
      $(`#label-image-${targetId}`).css("display", "");
    });
  });
});
