$(function() {
  $(document).on("turbolinks:load", function() {
    var myMessage = function(message) {
      var picture = message.picture != null ? `<a data-lightbox="picture-${message.id}" href="${message.picture}"><img src="${message.picture}" class="my-pic-link"></a>` : ``;
      var text = message.text != null ? `${message.text}` : ``;
      var avatar = message.user_avatar != null ? `<img src="${message.user_avatar}" class="avatar-original">` : `<img src="/assets/avatar-image.png" class="avatar-default">`;
      var html = `<div class="my-container message-margin" data-message-id="${message.id}" data-user-id="${message.user_id}">
                    <div class="my-message">
                      <div class="my-message-head">
                        <div class="my-message-head__picture">
                          ${picture}
                        </div>
                        <div class="my-message-head__text">
                          <p>
                            ${text}
                          </p>
                        </div>
                      </div>
                      <div class="my-message-foot">
                        <p>
                          ${message.created_at}
                        </p>
                      </div>
                    </div>
                    <div class="my-info">
                      <div class="my-info__avatar">
                        ${avatar}
                      </div>
                      <div class="my-info__nickname">
                        <p>
                          ${message.user_nickname}
                        </p>
                      </div>
                    </div>
                  </div>`
      return html;
    }

    var partnerMessage = function(message) {
      var picture = message.picture != null ? `<a data-lightbox="picture-${message.id}" href="${message.picture}"><img src="${message.picture}" class="my-pic-link"></a>` : ``;
      var text = message.text != null ? `${message.text}` : ``;
      var avatar = message.user_avatar != null ? `<img src="${message.user_avatar}" class="avatar-original">` : `<img src="/assets/avatar-image.png" class="avatar-default">`;
      var html = `<div class="partner-container message-margin" data-message-id="${message.id}" data-user-id="${message.user_id}">
                    <div class="partner-info">
                      <div class="partner-info__avatar">
                        ${avatar}
                      </div>
                      <div class="partner-info__nickname">
                        <p>
                          ${message.user_nickname}
                        </p>
                      </div>
                    </div>
                    <div class="partner-message">
                      <div class="partner-message-head">
                        <div class="partner-message-head__text">
                          <p>
                            ${text}
                          </p>
                        </div>
                        <div class="partner-message-head__picture">
                          ${picture}
                        </div>
                      </div>
                      <div class="partner-message-foot">
                        <p>
                          ${message.created_at}
                        </p>
                      </div>
                    </div>
                  </div>`
      return html;
    }

    function scroll() {
      $("html, body").animate({scrollTop: $(".messages-container")[0].scrollHeight});
    }

    $("#message-form").on("submit", function(e) {
      e.preventDefault();
      var message = new FormData(this);
      var url = $(this).attr("action");
      $.ajax({
        url: url,
        type: "POST",
        data: message,
        dataType: "json",
        processData: false,
        contentType: false
      })
      .done(function(data) {
        var myHtml = myMessage(data);
        $(".messages-container").append(myHtml);
        scroll();
        $("#message-form")[0].reset();
      })
      .fail(function(data) {
        alert("メッセージは送信できませんでした。\nメッセージの入力または画像を添付してください。");
      })
      .always(function(data) {
        $("#message-send-btn").prop("disabled", false);
      })
    })

    var reloadMessages = function() {
      var judgeUrl = location.pathname.search(/\/requests\/\d\/messages/);
      if (judgeUrl != -1) {
        var myLastMessageId = $(".my-container:last").data("message-id") || 0;
        var partnerLastMessageId = $(".partner-container:last").data("message-id") || 0;
        var LastMessageId = Math.max(myLastMessageId, partnerLastMessageId);
        $.ajax({
          url: "api/messages",
          type: "GET",
          dataType: "json",
          data: { id: LastMessageId }
        })
        .done(function(data) {
          data.forEach(function(message) {
            if (message.user_id == message.current_user_id) {
              var myHtml = myMessage(message);
              $(".messages-container").append(myHtml);
              scroll();
            } else {
              var partnerHtml = partnerMessage(message);
              $(".messages-container").append(partnerHtml);
              scroll();
            }
          })
        })
        .fail(function(data) {
        });
      }
    }

    $(function() {
      setInterval(reloadMessages, 5000);
    });
  });
});