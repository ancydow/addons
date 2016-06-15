var form = document.forms.myform,
    elem = form.elements;

form.onsubmit = function () {
    $("#bad_users").empty();
    PDJS = new PDJSobj({
        subdomain: form.subdomain.value,
        token: form.api_token.value,
    })

    if (!elem.subdomain.value) {
        alert('Please enter your PagerDuty subdomain.')
        elem.subdomain.focus()
        return false
    }
    if (!elem.api_token.value) {
        alert('Please enter an API v1 Key.')
        elem.api_token.focus()
        return false
    }

get_users = function() {
  PDJS.api_all({
    res: "users",
    data: {},
    final_success: function(data) {
      jQuery.each(data.users, function(index, user) {
        get_next_on_call(user.name, user.id)
      })
    },
    incremental_success: function(data) {
      console.log("Got data");
    }
  })
}

get_next_on_call = function(user_name, user_id) {
  PDJS.api_all({
    res: "escalation_policies",
    data: {
    	"user_next_oncall_id" : user_id,
      "include[]" : "user_next_oncall"
    },
    final_success: function(data) {
      if(data.escalation_policies.length == 0) {
      	$("#bad_users").append("<li>" + user_name + "</li>");
      }
    },
    incremental_success: function(data) {
      console.log("Got data");
    }
  })
}

get_users()


    return false
}