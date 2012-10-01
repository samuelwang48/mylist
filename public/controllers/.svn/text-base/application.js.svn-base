application = {
	fun: function(){
	
	},
	logout: function(){
		
		$clearTempCookies();
		$dir('/web/logout');
	},
	pselectContactFilter: function(v){
    v = v.toLowerCase();
    if(v!=''){$('#cpkr_clearFilterText').show()}else{$('#cpkr_clearFilterText').hide()};
    $('.cpkr_contact').each(function(i, o){ 
      var text = (o.tagName == 'DIV') ? $(o).text() : o.value;
      if(text.toLowerCase().indexOf(v)>-1){
        o.style.display = '';
      }else{
        o.style.display = 'none';
      }
    })
	},
  ppickContacts:function(){
    $this.win_contactpicker.dialog('close');
    var pcon = $('#pcon_selected');
    var ls = $('#pcon_selected tr:last');
    $('.selectedContactItem').each(function(i,o){
      var o = $(o);
      if ($('tr[cid=' + o.attr('id') + ']', pcon).length == 0) {
        var tr = ls.clone().insertBefore(ls).attr('cid', o.attr('id'));
        var td = $('td', tr);
        $(td[0]).html(o.html());
        $(td[1]).html('<a href="javascript:void(0)" class="sel" onclick="$this.pselectperm(this)"><div class="check"></div></a>');
      }
    })
  },
  pselectContactClick:function(o){
    var _this_ = o;
    var o = $(_this_);
    var cpkr_selected_con = $('.cpkr_selected');
    var a = $('.selectedContactItem', cpkr_selected_con).length;
    if (_this_.className == 'selected') {
      o.removeClass('selected');
      var p = $('#'+o.attr('cid'));
      
      if(p.prev().html() == ',&nbsp;'){
        p.prev().remove();
      };
      if($A($('.selectedContactItem', cpkr_selected_con)).indexOf(p[0])==0){
        p.next().remove();
      };
      
      p.remove();
    }else{
      o.addClass('selected');
      var n = $('<a class="selectedContactItem" id="'+o.attr('cid')+'" href="javascript:void(0)">' + $(_this_).text().replace(/\s+$/,'') + '</a>');
      n.click(function(){
        var p = $(this);
        var o = $('#l'+this.id);
        o.removeClass('selected');
        
        if(p.prev().html() == ',&nbsp;'){
          p.prev().remove();
        };
        if($A($('.selectedContactItem', cpkr_selected_con)).indexOf(p[0])==0){
          p.next().remove();
        };
        
        p.remove();
      });
      if (a>0){
        cpkr_selected_con.append('<span>,&nbsp;</span>');
      };
      cpkr_selected_con.append(n);
    }
  },
  pselectGroup: function(){
    //$('#pcon').animate({height: '400px'})
    var title = 'Contact Picker';
		$('.cpkr_selected').html('');
		$('.cpkr_contact').show().children().removeClass('selected');
		$('#cpkr_group_select')[0].options[0].selected = 1;
    if (typeof this.win_contactpicker == 'undefined') {
      this.win_contactpicker = $('#contact_picker').dialog({
        title: title,
        width: 278,
        modal: true,
        resizable: false,
				close: function(){FORCE_ACTIVE_SUBMENU_VISIBLE = false;}
      });
    }else{
      this.win_contactpicker.dialog( "open" );
    };
    FORCE_ACTIVE_SUBMENU_VISIBLE = true;
  },
  pchangeGroup: function(){
    var r = $('#cpkr_group_select option:selected').val();
    if (r == 'all'){
      $('.cpkr_contact').show();
    }else{
      r = r.split(',');
      $('.cpkr_contact').each(function(i,j){
        var o = j.childNodes[0];
        if(r.indexOf(o.id.replace(/lcid_/,''))>-1){
          $(j).show();
        }else{
          $(j).hide();
        }
      })
    }
  },
  pcontactSelect: function(r){
    var _this = this;
    $('.cpkr_contact').each(function(i,j){
      if(j.style.display != 'none'){
        var c = j.childNodes[0];
        if(r=='all'){
          if (!$(c).hasClass('selected')) {
            $(c).removeClass('selected');
            _this.pselectContactClick(c);
          }
        }else{
          if ($(c).hasClass('selected')) {
            $(c).addClass('selected');
            _this.pselectContactClick(c);
          }
        }
      }
    })
  },
	enLightenTextInput: function(a){
		a.focus(function(){
			//$T(1);
      $(this.parentNode).addClass('fieldBorder_hover');
    }).blur(function(){
      $(this.parentNode).removeClass('fieldBorder_hover');
    })
	},
	notify: function(t){
		var o = $('#notifier');
		o.html(t);
    setTimeout(function(){o.hide()},10);
    setTimeout(function(){o.show()},20);
		return o;
	}
}
