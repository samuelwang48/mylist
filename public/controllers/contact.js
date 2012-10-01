contact = {
  init: function(){
    $('#navcontacts').addClass('current');
		
    $('#contact_fields_con .fieldBorder .noBorder').focus(function(){
      $(this.parentNode).addClass('fieldBorder_hover').next().show();
    }).blur(function(){
      $(this.parentNode).removeClass('fieldBorder_hover').next().hide();
    })
		
		this.enLightenTextInput($('.autoWidth, textarea.noBorder, input.noBorder'));
		
		
		
    $('.contactsCon input[type="text"]').each(function(){this.tabIndex=1;})
    $('.contactsCon textarea').each(function(){this.tabIndex=2;})
		
		$('.autoWidth').each(function(i,o){
			$(o).keydown(function(){
				var _this = this;
				setTimeout(function(){
	        var aw = $('<span style="font:bold 20px arial">'+_this.value.replace(/\s/g,'&nbsp;')+'</span>');
	        $('#SYS_SWAP').append(aw);
					$(_this).css('width', (aw[0].offsetWidth+2<60?60:aw[0].offsetWidth+2)+'px');
	        aw.remove();
				},0)
			}).trigger('keydown').show();
			
		});
		
		$('#name_auto_width_con').css('visibility', 'visible');
		
		if(typeof ITODO_CONTACT_CURRENTGROUP == 'undefined'){
			$('#chgid0').addClass('current');
		}else{
      $('#chgid'+ITODO_CONTACT_CURRENTGROUP).addClass('current');
		}
		
  },
	home: function(){
		$('#bulk_chk_o').click(function(){
      if(this.checked){
        $('.contactsCon .list .chk input').attr('checked',1).parent().parent().addClass('chked');
      }else{
        $('.contactsCon .list .chk input').attr('checked',0).parent().parent().removeClass('chked');
				$(this).css('opacity', 1);
      }
		})
		
    $('.contactsCon .list .chk input').change(function(){

		})
	},
	newGroup: function(o){
		var _this = this;
		$('<a class="g"><input class="hover" value="New Group..."/></a>').insertBefore(o);
		var inp = $('input', o.parentNode).blur(function(){
      if(this.value == 'New Group...'){
        $(this.parentNode).remove();
      }else if(this.value.replace(/\s+/,'') == ''){
        $(this.parentNode).remove();
      }else{
        try { this.parentNode.innerHTML = this.value + ' (0)'; _this.saveNewGroup(this); } catch(e) {}
      }
		}).keydown(function(){
			if(event.keyCode==13){
        if(this.value == 'New Group...'){
          $(this.parentNode).remove();
        }else if(this.value.replace(/\s+/,'') == ''){
	        $(this.parentNode).remove();
	      }else{
          try { this.parentNode.innerHTML = this.value + ' (0)'; _this.saveNewGroup(this); } catch(e) {}
        }
      }
		})
		setTimeout(function(){inp[0].select();},200);
	},
	saveNewGroup: function(o){
		var data = {groupname: o.value};
    data.authenticity_token = AUTH_TOKEN;
		
		if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
		var noti = $this.notify('Saving...');
		
    $.ajax({
      type: "POST",
      url: "/contact/new_group",
      data: data,
      dataType: 'json',
      success: function(data){
        if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
				$this.notify('New group added!');
				
        TIMER = setTimeout(function(){noti.fadeOut(); },3999);
      }
    });
	},
  add: function(){
    $('.gn').mouseover(function(){$('.clos', this).css('opacity',1)}).mouseout(function(){$('.clos', this).css('opacity',0.2)});
    $this.fieldDropDownEvent($('.fieldname .dropdown a'));
    $this.inputBlurEvent($('.contactsCon table input'));
  },
	add_local: function(){
		this.add();
	},
  edit: function(){
    this.add();
  },
	fieldDropDownEvent: function(a){
    a.mousedown(function(){
      var con = $('span',$(this).parent().parent().prev())
      
      if(this.innerHTML == 'Custom...'){
        con.html('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input class="hover" value="'+this.innerHTML+'"/>');
        
        $('input', con).blur(function(){
          if(this.value == 'Custom...'){
            this.parentNode.innerHTML = $(this.parentNode.parentNode).attr('_type');
          }else{
            this.parentNode.innerHTML = this.value;
          }
        }).keydown(function(){if(event.keyCode==13){
          if(this.value == 'Custom...'){
            this.parentNode.innerHTML = $(this.parentNode.parentNode).attr('_type');
          }else{
            this.parentNode.innerHTML = this.value;
          }
        }})
        
        setTimeout(function(){$('input', con)[0].select();},200);
      }else{
        con.html(this.innerHTML);
      }
      
      ACTIVE_SUBMENU_HIDE();
    })
	},
	addContactField: function(o,t){
		var des = $(o.parentNode.parentNode);
		var ori = des.prev();
		
		var _new = ori.clone().insertAfter(ori);
		des.remove();
		
		var input = $('input', _new);
		
    $('.dropdown', _new).mouseover(function(){ ACTIVE_SUBMENU_HOVER = true; }).mouseout(function(){ ACTIVE_SUBMENU_HOVER = false; })
    $('.arw', _new)
		  .mouseover(function(){ ACTIVE_SUBMENU_HOVER = true; var o=$(this); var p=$(this.parentNode); o.attr('_href', p.attr('href')); p.attr('href','javascript:void(0)'); }).mouseout(function(){ ACTIVE_SUBMENU_HOVER = false; var o=$(this); var p=$(this.parentNode); p.attr('href', o.attr('_href')); })
      .mousedown(function(){ ACTIVE_SUBMENU_HIDE(); ACTIVE_SUBMENU = $(this.parentNode).addClass('mousedown').next().show(); $(this).addClass('arw_mousedown'); })
    $('.itododropdown_outer', _new)
		  .mouseover(function(){ ACTIVE_SUBMENU_HOVER = true; }).mouseout(function(){ ACTIVE_SUBMENU_HOVER = false; })
      .mousedown(function(){ ACTIVE_SUBMENU_HIDE(); ACTIVE_SUBMENU = $(this).addClass('mousedown').next().show(); $('.arwh', this).addClass('arwh_mousedown'); })
		
		$('.itododropdown_outer span', _new).html(t);
		
		$this.fieldDropDownEvent($('.fieldname .dropdown a', _new));
		
		input.focus(function(){$(this.parentNode).addClass('fieldBorder_hover').next().show()}).blur(function(){$(this.parentNode).removeClass('fieldBorder_hover').next().hide()})
    input.val('')[0].select();
		
		
		
		$this.inputBlurEvent(input);
	},
	inputBlurEvent: function(a){
		a.blur(function(){
		  var con = $(this.parentNode.parentNode.parentNode);
		  var type = $('.itododropdown_outer', con).attr('_type');
		  var con_next = con.next();
			var con_prev = con.prev();
		  if(this.value.length>0){
		    if(con_next.attr('class')!='add' && con_next.attr('_type')!=type){
		      $('<tr class="add"><td></td><td><a href="javascript:void(0)" onclick="$this.addContactField(this, \''+type+'\')">Add '+type.toLowerCase()+'</a></td></tr>').insertAfter(con);
		    }
		  }else{
				if(con_prev.length == 0 && con_next.attr('_type')!=type){
					con_next.remove();
				}else if(con_next.attr('class')!='add' && con_prev.attr('_type')==type && con_next.attr('_type')==type){
          con.remove();
        }else if(con_next.attr('class')!='add' && con_prev.attr('_type')==type ){
          $('<tr class="add"><td></td><td><a href="javascript:void(0)" onclick="$this.addContactField(this, \''+type+'\')">Add '+type.toLowerCase()+'</a></td></tr>').insertAfter(con);
          con.remove();
        }else{
					con.remove();
				}
				
		  }
		})
	},
	filterByText: function(v){
    v = v.toLowerCase();
    if(v!=''){$('#clearFilterText').show()}else{$('#clearFilterText').hide()}
    $('div.fullname').each(function(i, o){ 
      if(o.innerHTML.toLowerCase().indexOf(v)>-1){
        o.parentNode.parentNode.style.display = '';
      }else{
        o.parentNode.parentNode.style.display = 'none';
      }
			$(o).parent().prev().children().attr('checked', 0);
			$(o).parent().parent().removeClass('chked');
			$('#bulk_chk_o').attr('checked',0).css('opacity', 1);
    })
	},
	chkItem: function(o){
		var child = o.childNodes[0];
		var val = child.checked ? 0 : 1;
		child = $(child).attr('checked', val); 
		
    if(val == 1){
      child.parent().parent().addClass('chked');
    }else{
      child.parent().parent().removeClass('chked');
    }
    
    var a = $('.contactsCon .list .chk input:checked').length;
    var b = $('.contactsCon .list .chk input').length;
    if (a==b) {
      $('#bulk_chk_o').css('opacity', 1).attr('checked', 1);
    }else if (a<b){
      if (a == 0) {
        $('#bulk_chk_o').css('opacity', 1).attr('checked', 0);
      }else{
        $('#bulk_chk_o').css('opacity', 0.3).attr('checked', 1);
      }
    }
	},
	addContact: function(){
    $('.button_save').attr('disabled',1).removeClass('button_up').addClass('button_disabled');
		if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Saving...');
		
		var data = {}
    data.authenticity_token = AUTH_TOKEN;
    data.contact_fields = [];
		data.contact_groups = [];
		
		$('.contact_groups').each(function(i,o){
			if (o.checked) {
				data.contact_groups.push(o.value);
			}
		})
		
    $('#contact_fields_con .fieldname').each(function(i,o){
      var itm = {}
      var o_p = $(o).parent();
      itm.type = o_p.attr('_type');
      itm.field_name = $('.itododropdown_outer span', o_p).text();
      itm.field_value = $('input.noBorder', o_p).val();
			data.contact_fields.push(itm);
    })
		
		data.contact_fields.push({type:'Note', field_name:'Note', field_value:$('#contact_field_note').val()})
		
		data.firstname = $('#contact_firstname').val();
    data.lastname = $('#contact_lastname').val();
		data.local_user_id = $('#contact_local_user_id').val();
    data.contact_groups = JSON.stringify(data.contact_groups);
    data.contact_fields = JSON.stringify(data.contact_fields);
		
		
		
    $.ajax({
      type: "POST",
      url: "/contact/create",
      data: data,
      dataType: 'json',
      success: function(data){
				$dir('/contact/edit/'+data.id)
      }
    });
	},
  updateContact: function(){
    $('.button_save').attr('disabled',1).removeClass('button_up').addClass('button_disabled');
		
		if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Saving...');
    
    var data = {}
    data.authenticity_token = AUTH_TOKEN;
		data.id = $('#contact_id').val();
    data.contact_fields = [];
    data.contact_groups = [];
    
    $('.contact_groups').each(function(i,o){
      if (o.checked) {
        data.contact_groups.push(o.value);
      }
    })
    
    $('#contact_fields_con .fieldname').each(function(i,o){
      var itm = {}
      var o_p = $(o).parent();
      itm.type = o_p.attr('_type');
			itm.id = $('input.contact_field_id', o_p).val();
      itm.field_name = $('.itododropdown_outer span', o_p).text();
      itm.field_value = $('input.noBorder', o_p).val();
      data.contact_fields.push(itm);
    })
    
		var cf_note = $('#contact_field_note');
    data.contact_fields.push({type:'Note', id:cf_note.attr('_cfid'), field_name:'Note', field_value:cf_note.val()})
    
    data.firstname = $('#contact_firstname').val();
    data.lastname = $('#contact_lastname').val();
    data.local_user_id = $('#contact_local_user_id').val();
    data.contact_groups = JSON.stringify(data.contact_groups);
    data.contact_fields = JSON.stringify(data.contact_fields);
    
    $.ajax({
      type: "POST",
      url: "/contact/update",
      data: data,
      dataType: 'json',
      success: function(data){
				$dir('/contact/edit/'+data.id)
      }
    });
  },
	deleteContact: function(){
		if (!confirm('Delete Contact will remove the connection from this person. Do you still want to delete it?')) {return }
		
    $('.button_delete').attr('disabled',1).removeClass('button_up').addClass('button_disabled');
		
    if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Deleting...');
		
    var data = {}
    data.authenticity_token = AUTH_TOKEN;
		data.id = $('#contact_id').val();
		
    $.ajax({
      type: "POST",
      url: "/contact/delete",
      data: data,
      dataType: 'json',
      success: function(data){
        $dir('/contact/home')
      }
    });
	},
	bulkDelete: function(){
    if (!confirm('Delete Contact will remove the connection from this person. Do you still want to delete it?')) {return }
    
		ACTIVE_SUBMENU_HIDE();
		
    if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Deleting...');
    
    var data = {}
    data.authenticity_token = AUTH_TOKEN;
    data.id = JSON.stringify($.map($('.chk input:checked'), function(i){return i.value}));
    
    $.ajax({
      type: "POST",
      url: "/contact/bulk_delete",
      data: data,
      dataType: 'json',
      success: function(data){
        if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
        var noti = $this.notify(data.contacts_id.length+' Contacts deleted! <a href="">Undo</a>');
        TIMER = setTimeout(function(){noti.fadeOut(); },1000*30);
				
				var counts = $('.contact_group_count');
				var total_count = 0;
				$(data.group_counts).each(function(i,o){
					counts[i].innerHTML = o;
					total_count += parseInt(o);
				})
				
        $(data.contacts_id).each(function(i,o){$('#contact_row_id_'+o).remove()})
				
				$('#bulk_chk_o').attr('checked',0).css('opacity', 1);
				//$dir('/contact/home')
      }
    });
	},
	bulkGrouping: function(gid){
    ACTIVE_SUBMENU_HIDE();
		
    if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Grouping...');
    
    var data = {}
    data.authenticity_token = AUTH_TOKEN;
    data.id = JSON.stringify($.map($('.chk input:checked'), function(i){return i.value}));
    data.contact_groups = gid;
		
    $.ajax({
      type: "POST",
      url: "/contact/bulk_grouping",
      data: data,
      dataType: 'json',
      success: function(data){
        if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
        var noti = $this.notify(data.contacts_id.length+' Contacts have been grouped!');
        TIMER = setTimeout(function(){noti.fadeOut(); },1000*30);
        
        var counts = $('.contact_group_count');
        var total_count = 0;
        $(data.group_counts).each(function(i,o){
          counts[i].innerHTML = o;
          total_count += parseInt(o);
        })
				
        $(data.contacts_id).each(function(i,o){
					$('#contact_row_id_'+o+' td:last').append($('<div class="gn">'+data.group_name+'</div>'))
				})
				
				//$dir('/contact/home')
      }
    });
	},
	renameGroup: function(o){
		var btn = $('#current_contact_group');
    var oval = btn.text().replace(/^\s*Group : /, '').replace(/\s+$/, '');
		var con = $(o.parentNode);
		con.html('<div style="margin:5px 10px 10px 10px">Rename to:<br /><input class="rename_hover" style="width:125px; margin:0;" value="'+oval+'"/></div>')
		con.append($('<div style="margin:0px 10px 10px 10px; text-align:center; "><button class="apply">Apply</button> <button class="cancel" onclick="$this.cancelRenameGroup(this)">Cancel</button></div>'))
		
		var buttons = $('button', con);
		init_button(buttons);
		
    
    ON_ACTIVE_SUBMENU_HIDE = function(){
      con.html('<a href="javascript:void(0)" onclick="$this.renameGroup(this)">Rename</a>');
    }
		
		
    var inp = $('input', con).keydown(function(){
      if(event.keyCode==13){
        if(this.value == oval){
          //do nothing
        }else if(this.value.replace(/\s+/,'') == ''){
					//do nothing
				}else{
					//do apply
					try {
            var navg = $('#chgid'+ITODO_CONTACT_CURRENTGROUP);
					  btn.html(btn.html().replace(oval, this.value));
						navg.html(navg.html().replace(oval, this.value));
						$this.renameGroupApply(this.value);
					} catch(e) {}
					
          ON_ACTIVE_SUBMENU_HIDE();
          //try { this.parentNode.innerHTML = this.value + ' (0)'; _this.saveNewGroup(this); } catch(e) {}
        }
      }
    })
		
    $('.apply', con).click(function(){
	    if(inp[0].value == oval){
	      //do nothing
	    }else if(inp[0].value.replace(/\s+/,'') == ''){
        //do nothing
      }else{
	      //do apply
	      try {
	        var navg = $('#chgid'+ITODO_CONTACT_CURRENTGROUP);
	        btn.html(btn.html().replace(oval, inp[0].value));
	        navg.html(navg.html().replace(oval, inp[0].value));
	        $this.renameGroupApply(inp[0].value);
	      } catch(e) {}
	      
	      ON_ACTIVE_SUBMENU_HIDE();
	      //try { this.parentNode.innerHTML = this.value + ' (0)'; _this.saveNewGroup(this); } catch(e) {}
	    }
    })
		
    setTimeout(function(){inp[0].select();},200);
	},
	cancelRenameGroup: function(o){
    var con = $(o.parentNode.parentNode);
		con.html('<a href="javascript:void(0)" onclick="$this.renameGroup(this)">Rename</a>');
	},
	renameGroupApply: function(s){
    //ACTIVE_SUBMENU_HIDE();
    
    if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Applying new group name...');
    
    var data = {}
    data.authenticity_token = AUTH_TOKEN;
    data.contact_groups = ITODO_CONTACT_CURRENTGROUP;
    data.name = s;
    
    $.ajax({
      type: "POST",
      url: "/contact/rename_group",
      data: data,
      dataType: 'json',
      success: function(data){
        if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
        var noti = $this.notify('Group has been renamed!');
        TIMER = setTimeout(function(){noti.fadeOut(); },3999);
        
        //$dir('/contact/home')
      }
    });
	},
	deleteGroup: function(){
		if (!confirm('Group will be removed while all contacts under this group will still remain. Do you still want to delete it?')) {return }
    //ACTIVE_SUBMENU_HIDE();
    
    if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Deleting new group name...');
    
    var data = {}
    data.authenticity_token = AUTH_TOKEN;
    data.contact_groups = ITODO_CONTACT_CURRENTGROUP;
    
    $.ajax({
      type: "POST",
      url: "/contact/delete_group",
      data: data,
      dataType: 'json',
      success: function(data){
        if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
        var noti = $this.notify('Group has been deleted! Redirecting');
        TIMER = setTimeout(function(){noti.fadeOut(); },3999);
        
        $dir('/contact/home')
      }
    });
	},
	invite: function(){
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
    });
		
	},
	inviteContact: function(o){
		var con = $('.chk input', o.parentNode.parentNode);
		
		this.redirectToInvite([con.val()]);

	},
	inviteContactForm: function(){
		var con = $('#contact_id');
		
		this.redirectToInvite([con.val()]);
	},
	bulkInvite: function(){
		var a = [];
    var invites = $('.chk input:checked');
		invites.each(function(i,o){
			a.push(o.value);
		})
		this.redirectToInvite(a);
	},
  redirectToInvite: function(e){		
    var fm = document.createElement('form');
    fm.action = '/contact/invite';
    fm.method = 'post';
    
    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'authenticity_token';
    input.value = AUTH_TOKEN;
    fm.appendChild(input);
    
    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'id';
    input.value = JSON.stringify(e);
    fm.appendChild(input);
    
    document.getElementsByTagName('body')[0].appendChild(fm);
    fm.submit();
		
  },
	sendInvitation: function(){
    $('.button_save').attr('disabled',1).removeClass('button_up').addClass('button_disabled');
    if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Sending...');
    
    var data = {}
    data.authenticity_token = AUTH_TOKEN;
		data.invited_contacts = [];
		
		$('.chkbox:checked').each(function(i,o){
			var o = $(o);
			var c = {};
      var email = $('input', $(o).parent().next().next()).val().replace(/\s+/,'');
			c.id = o.val();
			c.email = email;
			
			data.invited_contacts.push(c);
		})
    
    data.invited_contacts = JSON.stringify(data.invited_contacts);
		data.invited_emails = $('#ta_invited_emails').val();
    
    $.ajax({
      type: "POST",
      url: "/contact/send_invitation",
      data: data,
      dataType: 'json',
      success: function(data){
				if(data.email_error){
					$('p.error').html(data.email_error).show();
          $('.button_save').attr('disabled',0).removeClass('button_disabled');
					
	        if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
	        var noti = $this.notify('Invitations are not sent due to some errors.');
	        TIMER = setTimeout(function(){noti.fadeOut(); },9999);
				}else{
          $('p.error').hide();
	        if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
	        var noti = $this.notify('Invitations are successfully sent! Redirecting...');
					$dir('/contact/home');
				}
      }
    });
	}
}















