web = {
	init: function(){
    this.enLightenTextInput($('textarea.noBorder, input.noBorder'))
	},
	index: function(){
		
	},
	settings: function(){
		this.date_user_birthday = $('#settings_user_birthday').datepicker({
      dateFormat: 'yy-mm-dd'
    });
		
		this.enLightenTextInput($('.fieldBorder .noBorder'));
		
		$('.itodotabs a').click(function(){
			$('.itodotabs a.current').removeClass('current');
			
			
			var t = $(this).addClass('current').attr('_tab');
			$('.itodotab_content').each(function(i, o){
				var c = $(o);
				if(c.attr('_for') == t){
					c.show();
				}else{
					c.hide();
				}
			})
		})
		
		
		
	},
	profile: function(){
		$('#navlist').addClass('current');
    $CACHE.set('profile_tab_lists', $('#siteBody .tdlblk').html());
	},
	home: function(){
    var currenttab = $getCookie('HT');
    
    if (currenttab == 'l') {
      $CACHE.set(__RAILS_ACTION__+'_tab_lists', $('#siteBody .tdlblk').html());
    }else if (currenttab == 't') {
      $CACHE.set(__RAILS_ACTION__+'_tracking_lists', $('#siteBody .tdlblk').html());
    }else if (currenttab == 'g') {
      $CACHE.set(__RAILS_ACTION__+'_tab_log_timeline', $('#siteBody .tdlblk').html());
    }else{
      $CACHE.set(__RAILS_ACTION__+'_tab_lists', $('#siteBody .tdlblk').html());
		}
	},
  getMoreLists: function(o){
    var id = $('#user_id').val();
    var oldhtml = $(o).html();
    $(o).html("Loading...").attr("disabled", "disabled");
    var params = {};
    params.page_num = $(o).attr("num");
    params.authenticity_token = AUTH_TOKEN;
    $.ajax({
       type: "POST",
       url: '/web/'+__RAILS_ACTION__+'_more_lists/'+id,
       data: params,
       success: function(data){
         if(data.replace(/ /g,'') == ""){
           $(o).html("No more list").removeClass('button_up').addClass('button_disabled');
         }else{
           $("#moreTbody").append($(data));
           $(o).html(oldhtml).attr("num",parseInt(params.page_num)+1).removeAttr("disabled").removeClass('button_up');
         }
				 $CACHE.set(__RAILS_ACTION__+'_tab_lists', $('#siteBody .tdlblk').html());
       },
       failture: function(msg){
         alert("failure:"+msg);
       }
    });
  },
  getMoreTrackings: function(o){
    var id = $('#user_id').val();
    var oldhtml = $(o).html();
    $(o).html("Loading...").attr("disabled", "disabled");
    var params = {};
    params.page_num = $(o).attr("num");
    params.authenticity_token = AUTH_TOKEN;
    $.ajax({
       type: "POST",
       url: '/web/'+__RAILS_ACTION__+'_more_trackings/'+id,
       data: params,
       success: function(data){
         if(data.replace(/ /g,'') == ""){
           $(o).html("No more tracking").removeClass('button_up').addClass('button_disabled');
         }else{
           $("#moreTbody").append($(data));
           $(o).html(oldhtml).attr("num",parseInt(params.page_num)+1).removeAttr("disabled").removeClass('button_up');
         }
         $CACHE.set(__RAILS_ACTION__+'_tab_trackings', $('#siteBody .tdlblk').html());
       },
       failture: function(msg){
         alert("failure:"+msg);
       }
    });
  },
	saveAccountSettings: function(){
    $('.button_save').attr('disabled',1).removeClass('button_up').addClass('button_disabled');
		
		var currentTab = $('.itodotabs .current').attr('_tab');
		var con = $('.itodotab_content[_for='+currentTab+']');
		
		
		var inputs = $('.noBorder[name|=user], input[type=radio]:checked, .x-form-text, select', con);
		var data = {}
    data.authenticity_token = AUTH_TOKEN;
		data.user = {};
		
		inputs.each(function(i,o){
      data.user[o.name.replace(/^.*\[/,'').replace(/\].*$/,'')] = o.value;
		})
		
		data.user.tab = currentTab;
		data.user = JSON.stringify(data.user);
		
    if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Saving your account settings...');
    
    $.ajax({
      type: "POST",
      url: "/web/update_settings/",
      data: data,
      dataType: 'json',
      success: function(data){
				if(data.errors){
					var e = '';
					$(data.errors.sort()).each(function(i,o){
						e += '<div class="m"><div class="b"></div>'+o.join(' ').replace(/^[0-9]+/, '')+'</div>';
					})
					$('.error_messages', con).html('').append($(e)).show();
					
          if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
	        var noti = $this.notify('Error. Please correct your data and try again');
				}else{
					$('.error_messages', con).hide();
					
	        if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
          var noti = $this.notify('Settings are updated!');
					
					if (currentTab == 'password'){
						inputs.val('');
					}
					
				}
				
        TIMER = setTimeout(function(){noti.hide(); },3999);
        $('.button_save').removeClass('button_disabled').attr('disabled',0);
				

      }
    });
	},
  loadLists: function(tb){
		var id = $('#user_id').val();
		var _this = this;
		this.resetHomeTab(tb);
		
    if (__RAILS_ACTION__ == 'home') {
			$setCookie('HT', 'l');
		}
		
		if ($CACHE.exists(__RAILS_ACTION__+'_tab_lists') == true){
			$('#siteBody .tdlblk').html($CACHE.get(__RAILS_ACTION__+'_tab_lists')).show();
			
			init_button($('#siteBody .tdlblk button'));
		}else{
      if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
      var noti = $this.notify('Loading');
			
	    $.get('/web/'+__RAILS_ACTION__+'_load_lists/'+id, function(data){
	      noti.hide();
				$('#siteBody .tdlblk').html(data).show();

				init_button($('#siteBody .tdlblk button'));
				
        $CACHE.set(__RAILS_ACTION__+'_tab_lists', $('#siteBody .tdlblk').html());
	    });
		}
  },
  loadTrackings: function(tb){
    var id = $('#user_id').val();
		var _this = this;
    this.resetHomeTab(tb);
		
		if (__RAILS_ACTION__=='home'){
      $setCookie('HT', 't');
		}
		
		if ($CACHE.exists(__RAILS_ACTION__+'_tab_trackings') == true){
			$('#siteBody .tdlblk').html($CACHE.get(__RAILS_ACTION__+'_tab_trackings')).show();
			
      init_button($('#siteBody .tdlblk button'));
		}else{
      if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
      var noti = $this.notify('Loading');
	    
	    $.get('/web/'+__RAILS_ACTION__+'_load_trackings/'+id, {}, function(data){
	      noti.hide();
        $('#siteBody .tdlblk').html(data).show();
			
        init_button($('#siteBody .tdlblk button'));
				
	      $CACHE.set(__RAILS_ACTION__+'_tab_trackings', $('#siteBody .tdlblk').html());
	    });
		}
  },
	loadLogTimeline: function(tb){
		ACTIVE_SUBMENU_HIDE();
		
		var tb = $(tb).parent().parent().prev();
		
    var id = $('#user_id').val();
    var _this = this;
    this.resetHomeTab(tb);
		
    if (__RAILS_ACTION__=='home'){
      $setCookie('HT', 'g');
    }
		
    if ($CACHE.exists(__RAILS_ACTION__+'_tab_log_timeline') == true){
      $('#siteBody .tdlblk').html($CACHE.get(__RAILS_ACTION__+'_tab_log_timeline')).show();
      
      init_button($('#siteBody .tdlblk button'));
    }else{
      if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
      var noti = $this.notify('Loading');
      
      $.get('/web/'+__RAILS_ACTION__+'_load_log_timeline/'+id, {}, function(data){
        noti.hide();
        $('#siteBody .tdlblk').html(data).show();
      
        init_button($('#siteBody .tdlblk button'));
        
        $CACHE.set(__RAILS_ACTION__+'_tab_log_timeline', $('#siteBody .tdlblk').html());
      });
    }
	},
	resetHomeTab: function(tb){
		$('.subNav a.current').removeClass('current');
		$('.pendingTrackingCon').hide();
		$(tb).addClass('current');
		$('#siteBody .tdlblk').hide();
	},
	acceptTracking: function(id, b, o){
		var con = o.parentNode.parentNode;
		data = {}
		data.authenticity_token = AUTH_TOKEN;
		data.accepted = b;
		
		$(con).remove();
		
		if($('.pendingTrackingCon .tracking').length == 0){
			$('.pendingTrackingCon').hide();
		}
		
		var created_at = $('.created_at', con).html();
		$('.created_at', con).remove();
		
		if(b == 1){
			$("#moreTbody").prepend($('<tr><td>'+$('.todoname', con).html()+'</td><td class="created" valign="top">'+created_at+'</td></tr>'))
		}
		
		var pending = $('.subNav .pending div');
		var pending_left = parseInt(pending.text())-1;
		if(pending_left==0){
			$('.subNav .pending').remove();
		}else{
      pending.html(pending_left);
		}
		
    $.ajax({
       type: "POST",
       url: "/web/accept_tracking/"+id,
       data: data,
       success: function(data){
         
       },
       failture: function(msg){
         alert("failure:"+msg);
       }
    });
	},
	homeLoadContactsFromGroup: function(gid, o){
//    if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
//    var noti = $this.notify('Loading');
		ACTIVE_SUBMENU.prev().html($(o).text());
		ACTIVE_SUBMENU_HIDE();
//    data = {}
//    data.authenticity_token = AUTH_TOKEN;
		
//    $.ajax({
//       type: "POST",
//       url: '/web/home_load_contacts/'+gid,
//       data: data,
//       success: function(html){
			 	 $setCookie('GI', gid);
//	       TIMER = setTimeout(function(){noti.hide()},0);
//         $('#user_home_contacts').html(html);
//       },
//       failture: function(msg){
//        
//       }
//    });
    if(gid==''){
			$('.contactItem').show();
		}else{
	    $('.contactItem').hide();
	    $('.contactItem[_gid*="'+gid+'"]').show();
		}
	}
}
