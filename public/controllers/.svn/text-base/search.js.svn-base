search = {
	init: function(){
    
    $('.fieldBorder .noBorder').focus(function(){
      $(this.parentNode).addClass('fieldBorder_hover');
    }).blur(function(){
      $(this.parentNode).removeClass('fieldBorder_hover');
    })
		
	},
	people: function(){
    $('#findPplInput').focus();
		
	},
	validateEmail: function(v){
	  v = v.replace(/^\s+/,'').replace(/\s+$/,'');
    var p = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;  
    return p.test(v)
  },
	doSearchPeople: function(){
		var btn = $('#searchPeopleBtn');
    
		if(this.validateEmail($('#findPplInput').val())){
			//do submit
      if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
      var noti = $this.notify('Searching People...');
			$('#searchPeopleError').hide();
			btn.addClass('button_disabled').attr('disabled',1);
			
			var data = {};
			data.authenticity_token = AUTH_TOKEN;
			data.queryString = $('#findPplInput').val().replace(/^\s+/,'').replace(/\s+$/,'');
	    $.ajax({
	      type: "POST",
	      url: "/search/peopleByEmail",
	      data: data,
	      success: function(data){
          //if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
          //noti.hide();
          //btn.removeClass('button_disabled').attr('disabled',0);
					
	        if(data=='null'){
            $('.searchPeopleResult').html('<div class="searchPeopleInfo">Sorry, the person is not an itodo.it member yet. <br /><br />Do you want to invite him now?</div>')
					}else{
            if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
            var noti = $this.notify('Found! Redirecting...');
            $dir(data)
					}
					init_button($('.searchPeopleResult button'));
	      }
	    });
			
		}else{
			$('#searchPeopleError').show();
			$('#findPplInput').focus();
		}
	},
	addContact: function(btn){
		var data = {}
		data.user_id = $('.searchPeopleInfo .user_id').val();
		$dir('/contact/add/'+data.user_id);
	}
}
