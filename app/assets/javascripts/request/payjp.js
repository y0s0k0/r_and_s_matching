$(document).on("turbolinks:load", function() {
  $("#customer_name").keyup(function() {
    var inputName = $(this).val();
    $(this).val(inputName.toUpperCase());
  });

  Payjp.setPublicKey("pk_test_23ae1385f130beccbdfe5e01");
  var form = $("#card-input"),
      number = $("#card_number"),
      name = $("#customer_name"),
      expMonth = $("#exp_month"),
      expYear = $("#exp_year"),
      securityCode = $("#security_code");

  $("#registration-form").click(function() {
    form.find("input[type=submit]").prop("disabled", true);
    var card = {
      number: number.val(),
      name: name.val(),
      exp_month: expMonth.val(),
      exp_year: expYear.val(),
      cvc: securityCode.val()
    };

    Payjp.createToken(card, function(status, response) {
      if (status == 200) {
        number.removeAttr("name");
        name.removeAttr("name");
        expMonth.removeAttr("name");
        expYear.removeAttr("name");
        securityCode.removeAttr("name");
        var token = response.id;
        form.append($('<input type="hidden" name="payjp-token">').val(token));
        form.get(0).submit();
        alert("カードの登録が完了しました。");
      }
      else {
        form.find("#registration-form").prop("disabled", false);
        alert("カード情報が正しくありません。\n入力内容を確認し、正しく入力してください。");
      }
    });
  });
});
