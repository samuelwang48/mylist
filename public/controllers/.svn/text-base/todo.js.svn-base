todo = {
  init: function(){
		STOP_TOGGLE = 0;
		DRAGGING = 0;
		ARROW_DRAG = $('#arrow_insert');
		GANTT_START = typeof(GANTT_START)=='undefined' ? null : GANTT_START;
		GANTT_DUE = typeof(GANTT_DUE)=='undefined' ? null : GANTT_DUE;
		GANTT_FULLWIDTH = typeof(GANTT_FULLWIDTH)=='undefined' ? 260 : GANTT_FULLWIDTH;
		GANTT_UNITWIDTH = typeof(GANTT_UNITWIDTH)=='undefined' ? null : GANTT_UNITWIDTH;
		GANTT_DURATION = typeof(GANTT_DURATION)=='undefined' ? null : GANTT_DURATION;
		
		var _this = this;
		$this.fun()
		
		$('#navtodo').addClass('current');
    
    $(PRESET.EARLIER).each(function(i,o){
      
      $('<option value="'+o+'">'+$to_pretty(o)+'</option>').appendTo('#reminder_earlier')
    })
    
    this.date_picker = $('#reminder_d').datepicker({
			dateFormat: 'yy-mm-dd'
		});
		
		this.time_picker = $('#reminder_t');
		
    this.enLightenTextInput($('.fieldBorder .noBorder'));
		
    $('.cpkr_contact a').click(function(){
      _this.pselectContactClick(this);
    })
    
    $('#cpkr_pick').click(function(){
      _this.ppickContacts();
    })
  },
  _new: function(){
		
    $('.dtd_item')
      .mouseover(function(){$(this).addClass('dtd_item_hover')})
      .mouseout(function(){$(this).removeClass('dtd_item_hover')});
			
	  this.enLightenTextInput($('.fieldBorder textarea'));
  },
  show: function(){
    $('.dtd_item')
      .mouseover(function(){$(this).addClass('dtd_item_hover')})
      .mouseout(function(){$(this).removeClass('dtd_item_hover')});
  },
	orderChangeable: function(handlers){
		var _this = this;
    var by = this.by;
    var ey = this.ey;
		var dragging_con = this.dragging_con;
		
    handlers.mouseover(function(){
      STOP_TOGGLE = 1;
    }).mouseout(function(){
      STOP_TOGGLE = 0;
    }).mousedown(function(event){
      DRAGGING = 1;
      var con = this.parentNode.parentNode;
      var con_parent = $(con).parent();
      _this.currentSelectedItem = con_parent;
      _this.todoItems = $('#todoItemsList .dtr');
      _this.todoItemsIsFolded = [];
      
      var t = by;
      _this.todoItems.each(function(i,o){
        if(/dtr_quickview/.test(o.className)){
          t = t + 21;
        }else{
          t = t + 101;
        }
        _this.todoItemsIsFolded.push(t);
      })
      
      event.preventDefault();
			
      $('body').addClass('moving')[0].onselectstart = function(){return false}
      dragging_con.css('left', event.pageX + 'px').css('top', event.pageY + 'px').append(con_parent.clone().css('margin-left', '-22px')).show();
      $(con).removeClass('dtd_item_hover');
    })		
	},
	backToTop: function(){
		//var top = this.listPane_top;
		var top = 0;
    if(/MSIE [6-7]/.test(navigator.userAgent)){
      $('#html_body')[0].scrollTop = top;
    }else{
      $(document).scrollTop(top);
		}
	},
  edit: function(){
		var arrow = ARROW_DRAG;
		var items = $('.dtd_item');
		var todoItemsList = $('#todoItemsList');
		var dragging_con = $('#dragging_con');
    var _this = this;
		this.dragging_con = dragging_con;
    this.by = todoItemsList.position().top + 10;
    this.ey = todoItemsList.position().top + $('#todoItemsList').height() + 10;
		var by = this.by;
		var ey = this.ey;
		var listPane = $('#inlineListFilter');
		var listPane_top = listPane.position().top;
		this.listPane_top = listPane_top;
    //var listPane_left = listPane.position().left;
		var fixed_listPane = $('#fixedListFilter');
		this.st = 0;
		if (/MSIE [6-7]/.test(navigator.userAgent)) {
			this.st = $('#html_body').scrollTop();
		}
		
    items.mouseover(function(){
			if (DRAGGING==0){
				  var _this = $(this);
          _this.addClass('dtd_item_hover');
          if ( _this.parent().hasClass('dtr_quickview') ){
            $('#taskCon_' + _this.attr('item_id')).addClass('taskConHover');
          }
				}
			})
      .mouseout(function(){
        if (DRAGGING == 0) {
          var _this = $(this);
					_this.removeClass('dtd_item_hover');
					if ( _this.parent().hasClass('dtr_quickview') ){
            $('#taskCon_' + _this.attr('item_id')).removeClass('taskConHover');
          }
				}
			});
			
		
    $('.dtr_quickview').click(function(){ _this.goEditMode(this); });
    
		this.orderChangeable($('.handdrag, .itm_toggler div'));
		
		if(/MSIE [6-7]/.test(navigator.userAgent)){
      var fixed_listPane = fixed_listPane[0];
			
      $('#html_body').scroll(function(){
        _this.st = $(this).scrollTop();
        fixed_listPane.style.left = listPane.position().left + 'px';
        if($(this).scrollTop()>=listPane_top){
					//if(fixed_listPane.style.display != 'none'){return};
          ACTIVE_SUBMENU_HIDE();
					fixed_listPane.style.display = 'block';
					//if()
          //fixed_listPane.css('left', listPane.position().left).show();
        }else{
          fixed_listPane.style.display = 'none';
          //fixed_listPane.hide();
        }
      }).resize(function(){
				fixed_listPane.style.left = listPane.position().left + 'px';
      })
		}else{
			fixed_listPane.css('left', listPane.position().left);
	    $(window).scroll(function(){
        if($(this).scrollTop()>=listPane_top){
          //if(fixed_listPane[0].style.display != 'none'){return};
					ACTIVE_SUBMENU_HIDE();
	        fixed_listPane.show();
	      }else{
	        fixed_listPane.hide();
	      }
	    })
			$(window).resize(function(){
        fixed_listPane.css('left', listPane.position().left);
      })
		}
		
		$(document).mouseup(function(){
			if ( DRAGGING == 1 ){
	      $('body').removeClass('moving')[0].onselectstart = function(){}
				dragging_con.hide().html('');
				if (_this.currentSelectedItem[0] == _this.todoItems[_this.current_pos]){
					
				}else if (_this.current_pos >= _this.todoItems.length){
				  var from = _this.currentSelectedItem;
					from.parent().append(from);
					
					var from_id = $('input[type=checkbox]', from).val();
					var from_bar = $('#taskCon_'+from_id);
					from_bar.parent().append(from_bar);
					
          _this.updateItemBulletsNew();
				}else{
				  var from = _this.currentSelectedItem;
				  var insertBefore = _this.todoItems[_this.current_pos];
	        from.insertBefore(insertBefore);
	        
	        var from_id = $('input[type=checkbox]', from).val();
	        var insertBefore_id = $('input[type=checkbox]', insertBefore).val();
	        var from_bar = $('#taskCon_'+from_id);
	        var insertBefore_bar = $('#taskCon_'+insertBefore_id);
          from_bar.insertBefore(insertBefore_bar);
          
          _this.updateItemBulletsNew();
				}
				
				
      }
      DRAGGING = 0;
			setTimeout(function(){
        arrow.hide();
			},0);
		})
		$('body').mousemove(function(event){
			if (DRAGGING == 1){
				var cy = event.pageY + _this.st;
				
				var real_pos = 0;
        var len = _this.todoItemsIsFolded.length;
				if(cy<=_this.todoItemsIsFolded[0]){
					real_pos = 0;
				}else if(cy>=_this.todoItemsIsFolded[len-1]){
					real_pos = len;
				}else{
	        for(var i = 0; i < len ; i++){
	          if(cy>_this.todoItemsIsFolded[i] && cy<=_this.todoItemsIsFolded[i+1]){
							real_pos = i + 1;
							break;
						}
	        }
				}
				
        var current_pos = real_pos;//parseInt((cy - by)/21)
        _this.current_pos = current_pos;

			
				if (current_pos<=0){
					setTimeout(function(){
          //arrow.css('margin-top', '0px');
					//arrow.insertBefore(_this.todoItems[current_pos]).show();
					arrow.css('top', by+'px').show();
					},0)
				}else if (current_pos>0 && current_pos<len){
          setTimeout(function(){
          //arrow.css('margin-top', '0px');
          //arrow.insertBefore(_this.todoItems[current_pos]).show();
          arrow.css('top', _this.todoItemsIsFolded[current_pos-1]+'px').show();
          },0)
				}else{
          //arrow.css('margin-top', '0px');
					//arrow.insertBefore($('#endItemsList')).show();
          arrow.css('top', _this.todoItemsIsFolded[len-1]+4+'px').show();
				}
				
				dragging_con.css('left', event.pageX + 'px').css('top', event.pageY + _this.st + 'px');
        //$('#todo_name')[0].value = current_pos;//event.pageY + ' | ' + $(document).height() + ' | ' + $(window).height();
			}
		})
		
		_this.DURATION_PANEL_HOVER = 0;
    _this.dP = $('#itodoDurationPanel');
    
    _this.PREDECESSOR_PANEL_HOVER = 0;
    _this.preP = $('#itodoPredecessorPanel');
		
		$('#itodoDurationPanel, #ui-datepicker-div, .itemDurationLink').mouseover(function(){
			_this.DURATION_PANEL_HOVER = 1;
		}).mouseout(function(){
      _this.DURATION_PANEL_HOVER = 0;
		})
		
    $('#itodoPredecessorPanel, .itemPredecessorLink').mouseover(function(){
      _this.PREDECESSOR_PANEL_HOVER = 1;
    }).mouseout(function(){
      _this.PREDECESSOR_PANEL_HOVER = 0;
    })
		
		$('.itemDurationLink').mousedown(function(){
			var o = $(this);
			_this.dP.css('top', o.position().top +18 + 'px').css('left', o.position().left -3 + 'px').show();
			$('button:last', _this.dP).attr('item_id', $('input[type=checkbox]',o.parent().parent()).val());
			$('#item_start').datepicker('setDate', o.attr('start'));
			$('#item_due').datepicker('setDate', o.attr('due'));
		})
		
    $('.itemPredecessorLink').mousedown(function(){
      var o = $(this);
      _this.preP.css('top', o.position().top +18 + 'px').css('left', o.position().left -3 + 'px').show();
      $('button:last', _this.preP).attr('item_id', $('input[type=checkbox]',o.parent().parent()).val());
      $('#item_predecessor').val(o.attr('predecessor'));
    })
		
		$('.noBorder', _this.dP).datepicker({
      dateFormat: 'yy-mm-dd'
    });
		
    $('body').mousedown(function(){ if(!_this.DURATION_PANEL_HOVER){_this.durationPanelHide()}});
    $('body').mousedown(function(){ if(!_this.PREDECESSOR_PANEL_HOVER){_this.predecessorPanelHide()}});
    
    _this.GanttChart.showToday();
  },
  GanttChart: {
    update: function(task){
      if(task.start == null || task.due == null){
        
      }else{
        var duration = (task.due - task.start)/1000/_DAY_;
        var barCon = $('#taskCon_'+task.id).show();
        var bar = $('.tbar', barCon)
        bar.attr('start', task.start.getFullYear()+'-'+(task.start.getMonth()+1)+'-'+task.start.getDate());
        bar.attr('due', task.due.getFullYear()+'-'+(task.due.getMonth()+1)+'-'+task.due.getDate());
        bar.attr('duration', duration);

        GANTT_START = task.start < GANTT_START ? task.start : GANTT_START;
        GANTT_DUE = task.due > GANTT_DUE ? task.due : GANTT_DUE;
        GANTT_DURATION = (GANTT_DUE - GANTT_START)/1000/_DAY_;
        GANTT_UNITWIDTH = GANTT_FULLWIDTH/GANTT_DURATION;
        
        this.flush();
        this.showToday();
      }
    },
    flush: function(){
      $('.taskCon:visible .tbar').each(function(i,o){
        var o = $(o);
        var start = o.attr('start').split('-');
        var task_start = new Date(start[0], start[1]-1, start[2]);
        
        var duration = parseInt(o.attr('duration'));
        var bar_width = GANTT_UNITWIDTH * duration;
        var before = (task_start - GANTT_START)/1000/_DAY_;
        var bar_margin_left = before * GANTT_UNITWIDTH;
        
        o.width(bar_width).css('margin-left', bar_margin_left);
      })
    },
    showToday: function(){
      var today = new Date();
      if(GANTT_START < today && GANTT_DUE > today){
        var before = (today - GANTT_START)/1000/_DAY_;
        var bar_margin_left = before * GANTT_UNITWIDTH;
        var con = $('#ganttChartCon');
        if (this.todayPointer){
          this.todayPointer.css('margin-left', bar_margin_left);
        }else{
          this.todayPointer = $('<div class="todayPointer" style="height:'+con.height()+'px; width:1px; background:#555; position:absolute; margin-left:'+bar_margin_left+'px;"></div>').prependTo(con);
        }
      }
    }
  },
  setDuration: function(o){
    var noti = $('#notifier');
    var data = {};
    var item_id = $(o).attr('item_id');
    data.item_id = item_id;
    data.start = $('#item_start').val();
    data.due = $('#item_due').val();
    data.authenticity_token = AUTH_TOKEN;
    
    var ganttTask = {}
    ganttTask.id = item_id;
    ganttTask.start = $('#item_start').datepicker( "getDate" );
    ganttTask.due = $('#item_due').datepicker( "getDate" );
    
    $this.GanttChart.update(ganttTask);
    
    if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Sending data...');
    
    $.ajax({
      type: "POST",
      url: "/todo/set_duration/",
      data: data,
      dataType: 'json',
      success: function(data){
        $('#itemDuration_'+item_id).attr('start', data.start).attr('due', data.due);
        
        if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
        var noti = $this.notify('Item Duration has been set!');
        TIMER = setTimeout(function(){noti.hide()},5999);
      }
    });
    
  },
  setPredecessor: function(o){
    var noti = $('#notifier');
    var data = {}
    var item_id = $(o).attr('item_id');
    data.item_id = item_id;
    data.predecessor = $('#item_predecessor').val();
    data.authenticity_token = AUTH_TOKEN;
    
    if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Sending data...');
    
    $.ajax({
      type: "POST",
      url: "/todo/set_predecessor/",
      data: data,
      dataType: 'json',
      success: function(data){
        $('#itemPredecessor_'+item_id).attr('predecessor', data.predecessor);
        
        if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
        var noti = $this.notify('Item Predecessor has been set!');
        TIMER = setTimeout(function(){noti.hide()},5999);
      }
    });
    
  },
  durationPanelHide: function(){
    this.dP.hide();
  },
  predecessorPanelHide: function(){
    this.preP.hide();
  },
  animate: function(t, o, DH, s, f){
      this.timers = this.timers ? this.timers : {};
      if(this.timers[t]){
        clearTimeout(this.timers[t]);
        this.timers[t] = void(0);
      }
		
      var interval = 5;
      var STEP = s ? s : 5;
      var OH = o.offsetHeight;
      var DH = DH;
      var step = DH >= OH ? STEP : 0-STEP;
      var _this = this;		
      this.timers[t] = setInterval(function(){
        OH = OH + step; 
        if (((OH < DH)&&step>0)||((OH > DH)&&step<0)) {
          o.style.height = OH + 'px';
        }else{
          clearTimeout(_this.timers[t]);
          _this.timers[t] = void(0);
          o.style.height = DH + 'px';
          if (f) { f() };
        }
      },interval)
  },
  goEditMode: function(con, animate){
    if(STOP_TOGGLE == 1){
      return
    }
    var con = $(con);
    con.removeClass('dtr_quickview');
		
    var tog = $('.itm_toggler', con).show().css('margin', '-1px -1px 3px -1px');
    var dtd_item = $('.dtd_item', con);
		$('#taskCon_' + dtd_item.attr('item_id')).addClass('taskConHover');
		
    if (animate == 0) {
      tog.css('height', '12px');
      dtd_item.css('height', '86px');
    }else{
      this.animate('t1', tog[0], 12);
      this.animate('t2', dtd_item[0], 85, 50);
    }
		
    var con_ta = $('.itm_description', con);
    con.unbind("click");
    if(con_ta.attr('readonly')=='1'){return}
		
    if(/^\s*<div/i.test(con_ta[0].innerHTML)) {
      var hd_input = $('input',con_ta)[0];
      $('<textarea class="itm_ta itm_val_con" id="'+hd_input.id+'" name="'+hd_input.name+'">'+$h2t(hd_input.value)+'</textarea>').appendTo(con_ta.empty())
      if($('.dtr:last')[0]==con[0]){$('#dtr_new').css('margin-top','-15px');};
      //setTimeout(function(){t.focus()},0)
			
    }
    var t = $('textarea',con);
    this.enLightenTextInput(t);
  },
  goReadMode: function(con, animate){
    var con = $(con);
		
		var tog = $('.itm_toggler', con).css('margin', '-3px -3px 3px -3px');
    var dtd_item = $('.dtd_item', con);
    $('#taskCon_' + dtd_item.attr('item_id')).removeClass('taskConHover');
		
		if (animate == 0){
			tog.hide(); 
			con.addClass('dtr_quickview');
      tog.css('height', '20px');
      dtd_item.css('height', '20px');
    }else{
      this.animate('t1', tog[0],22, 0, function(){tog.hide(); con.addClass('dtr_quickview'); });
      this.animate('t2', dtd_item[0], 20, 50);
    }
		
    var con_ta = $('.itm_description', con);
    if(/^\s*<textarea/i.test(con_ta[0].innerHTML)){
      var ta = $("textarea",con_ta);
      var hi_input = $('<input class="itm_val_con" type="hidden">').attr('id',ta[0].id).attr('name',ta[0].name).val(ta.val());
      $('<div class="itm_ta">'+$h2t(hi_input.val())+'</div>').prepend(hi_input).appendTo(con_ta.empty());
      
    }
    var _this = this;
    setTimeout(function(){con.click(function(){ _this.goEditMode(this);});},0);
  },
  foldItem: function(obj){
    if(STOP_TOGGLE == 1){
			return
		}
		con = $(obj.parentNode.parentNode);
    this.goReadMode(con);
  },
  toggleView: function(mode){
		
		var _this = this;
    if (mode == 'expand') {
      $('.dtr_quickview').each(function(i,o){ _this.goEditMode(this, 0); })
    }else{
      $('.dtr').each(function(){ _this.goReadMode(this, 0); })
    }
  },
  home: function(){
    
  },
  updateChecklistPageTitle: function(str){
    $('#checklist_page_title').html($h2t(str));
  },
  insertItemBefore: function(obj){
		$('#filterText').val(''); this.filterByText(''); this.displayItems('all');
    var _self = $(obj.parentNode.parentNode.parentNode);
    var _newItem = _self.clone().insertBefore(_self);
    
    this.orderChangeable($('.handdrag, .itm_toggler div', _newItem));
    this.setFocusToNewItem(_newItem);
    this.updateItemBulletsNew();
  },
  appendMoreItem: function(obj){
		$('#filterText').val(''); this.filterByText(''); this.displayItems('all');
    
    var _self = $('.dtr:last');
    var _newItem = _self.clone().insertBefore($('#endItemsList'));
    
		this.orderChangeable($('.handdrag', _newItem));
    this.setFocusToNewItem(_newItem);
    this.updateItemBulletsNew();
  },
	deleteItem: function(obj){
		var _self = $(obj.parentNode.parentNode.parentNode);
		_self.remove();
    this.updateItemBulletsNew();
		
	},
  updateItemBulletsNew: function(){
    $.each($('.dtd_num'), function(i, o) { 
      var ta = $('.itm_val_con', $(o).next())[0];
      if (ta) {
        ta.name = ta.name.replace(/_.*$/, '_' + (i + 1) + ']');
        ta.id = ta.name.replace(/\[/g, '_').replace(/\]/g, '');
        $('input[type=checkbox]', $(o).next()).attr('id', ta.id + '_chk');
        $('label', $(o).next()).attr('for', ta.id + '_chk');
      }
      
      $(o).html(i+1);
    });
		
		this.updateListProgress();
  },
  setFocusToNewItem: function(_newItem){
		var _this = this;
    $('.dtd_item', _newItem)
      .mouseover(function(){$(this).addClass('dtd_item_hover')})
      .mouseout(function(){$(this).removeClass('dtd_item_hover')});
    
    this.goEditMode(_newItem, 0);
		try{
    $('.iopt_created', _newItem).text('');
    $('.iopt_reminder', _newItem).hide();
    $('.modify_reminder', _newItem).hide();
		$('.iopt_reminder_btn a', _newItem)[0].onclick = function(){_this.popupReminder(this)};
    }catch(e){}
		
		
		
    this.checkItem($('input:checkbox', _newItem).attr('checked',false).val(0)[0]);
    
    var ta = $('textarea:first', _newItem)[0];
    ta.name = ta.name.replace(/[0-9]+_[0-9]+/, '0_');
    
    $(ta).val('').focus();
  },
  changeView: function(mode){
    var itemlist = $('#todoItemsList');
    if(mode == 'grid'){
      itemlist.addClass('gridView');
      itemlist.removeClass('quickView');
    }else if(mode == 'quick'){
      itemlist.addClass('quickView');
      itemlist.removeClass('gridView');
    }else{
      itemlist.removeClass('gridView');
      itemlist.removeClass('quickView');
    }
  },
	updateListProgress: function(){
		var total = parseInt($('.dtd_num:last').text());
		var chked = parseInt($('.itm_options input[type=checkbox]:checked').length);
		var percentage = parseInt((chked/total)*100);
		var w = $('.dti_options .barcon').width();
		
		$('.dti_options .barin').width(w*percentage/100);
		$('.dti_options .bartx').html(percentage + '%');
	},
  checkItem: function(o){
    if (!$(o)[0].checked) {
      $(o.parentNode.parentNode.parentNode).removeClass('finished').addClass('notfinished');
      var checker = $('span', $(o).next()).text('Done');
      if (o.value==0){
        var ta = $('textarea', o.parentNode.parentNode);
        ta[0].name = ta[0].name.replace(/([0-9]+_[0-9]+)(_[0-9]+)?\]/,'$1_0]');
				ta[0].id = ta[0].name.replace(/\[/g, '_').replace(/\]/g, '');
        return
      }
      $.ajax({
        type: "POST",
        url: "/todo/item_undo/"+o.value,
        data: {authenticity_token:AUTH_TOKEN},
        success: function(msg){
          
        }
      });
    }
    else {
      $(o.parentNode.parentNode.parentNode).removeClass('notfinished').addClass('finished');
      var checker = $('span', $(o).next()).text('Undo');
      if (o.value==0){
        var ta = $('textarea', o.parentNode.parentNode);
        ta[0].name = ta[0].name.replace(/([0-9]+_[0-9]+)(_[0-9]+)?\]/,'$1_1]');
        ta[0].id = ta[0].name.replace(/\[/g, '_').replace(/\]/g, '');
        return
      }
      $.ajax({
        type: "POST",
        url: "/todo/item_done/"+o.value,
        data: {authenticity_token:AUTH_TOKEN},
        success: function(msg){
          
        }
      });
    }
		this.updateListProgress();
  },
  popupReminder: function(obj, dat){
		var _this = this;
    var con = obj.parentNode.parentNode.parentNode;
    var ta_con = $('.itm_description', con).clone();
		var ta_content = $('textarea', con).val();
		var reminder_title = '';
    if(typeof dat != 'undefined'){
      reminder_title = 'Edit a Reminder';
			$('#reminder_button').html('Update').unbind('click').click(function(){_this.setReminder(obj, dat.reminder.id)}).next().show();
			var sel = $('#reminder_m1_sel')[0];
      sel.options[0].selected = dat.reminder.method_email_def;
      sel.options[1].selected = dat.reminder.method_email_alt;
      ta_content = dat.reminder.event;
			this.date_picker.datepicker("setDate" , dat.reminder.occurence.replace(/([\-\d]+)\D.*$/,'$1'));
			$('option[value="'+dat.reminder.occurence.replace(/[\-\d]+\D(\d{2}:\d{2}).*$/,'$1')+'"]', this.time_picker)[0].selected = 1;
      //this.date_picker.setValue(dat.reminder.occurence.replace(/([\-\d]+)\D.*$/,'$1'));
			//this.time_picker.setValue(dat.reminder.occurence.replace(/[\-\d]+\D(\d{2}:\d{2}).*$/,'$1'));
      $('#reminder_earlier option[value="'+dat.reminder.seconds_before+'"]')[0].selected = true;
    }else{
      reminder_title = 'Set a Reminder';
			$('#reminder_button').html('Create').unbind('click').click(function(){_this.setReminder(obj)}).next().hide();
      this.date_picker.datepicker("setDate" , PRESET.DEFAULT_DATE);
			$('option[value="'+PRESET.DEFAULT_HOUR+'"]', this.time_picker)[0].selected = 1;
			//this.date_picker.setValue(PRESET.DEFAULT_DATE);
      //this.time_picker.setValue(PRESET.DEFAULT_HOUR);
			$('#reminder_earlier option[value="'+PRESET.DEFAULT_EARLIER+'"]')[0].selected = true;
		}
    $(ta_con).appendTo($('#reminder_ta').html(''));
    var new_ta = $('textarea', ta_con);
    new_ta.val(ta_content).addClass('noBorder').width(460).height(60);
    
		if (typeof this.win_reminder == 'undefined') {
			this.win_reminder = $('#tpl_reminder').dialog({
				title: reminder_title,
				width: 510,
				modal: true,
				resizable: false
			});
		}else{
			$('#ui-dialog-title-tpl_reminder').html(reminder_title);
			this.win_reminder.dialog( "open" );
		}
  },
  setReminder: function(obj, id){
		var _this = this;
    var noti = $('#notifier');
    var con = $('#reminder_ta');
    var event_content = $('textarea', con);
    var item_id = event_content[0].name.replace(/(.*\[)(\d*)(\_\d*\])/, '$2');
    var method_phone_def = $('#reminder_m0')[0].checked;
    var method_email = $('#reminder_m1')[0].checked;
    var method_email_def = false;
    var method_email_alt = false;
    if (method_email == true){
      if ($('#reminder_m1_sel').val() == 'email_def') {
        method_email_def = true;
      }else if ($('#reminder_m1_sel').val() == 'email_alt'){
        method_email_alt = true;
      }
    }
    
    var reminder_object = {}
    if(id){reminder_object.reminder_id = id};
    reminder_object.todo_id = $('#reminder_todo_id').val();
    reminder_object.item_id = item_id;
    reminder_object.event = event_content.val();
    reminder_object.method_phone_def = method_phone_def;
    reminder_object.method_email_def = method_email_def;
    reminder_object.method_email_alt = method_email_alt;
    reminder_object.occurence = this.date_picker.val() + ' ' + this.time_picker.val() + ':00';
    reminder_object.seconds_before = $('#reminder_earlier').val();
    reminder_object.authenticity_token = AUTH_TOKEN;
    
		if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Sending data...');
		
    $.ajax({
      type: "POST",
      url: "/reminder/update/",
      data: reminder_object,
      dataType: 'json',
      success: function(data){
				$('.modify_reminder', obj.parentNode).unbind('click').click(function(){_this.popupReminder(obj, data)});
				$('.iopt_reminder', obj.parentNode.parentNode).attr('title', data.reminder.occurence.replace(/[\sa-zA-Z]/g,' ')).show();
				
				if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
        var noti = $this.notify('new Reminder has been set! &nbsp;<a href="">View it now</a>');
        TIMER = setTimeout(function(){noti.hide()},5999);
      }
    });
    
    
    this.win_reminder.dialog('close');
  },
  displayItems: function(filter){
    var fnone = $('#fnone')[0];
    switch (filter) {
      case 'none':{
        $('.displayFilter').each(function(i, o){
          o.checked = (o.id == 'fnone') ? true : false;
        })
        $('#todoItemsList').removeClass('finishedonly').removeClass('notfinishedonly').addClass('noneofthem');
        break;
      }
      case 'all':{
        $('.displayFilter').each(function(i, o){
          o.checked = (o.id == 'fall') ? true : false;
        })
        $('#todoItemsList')
				  .removeClass('finishedonly')
					.removeClass('notfinishedonly')
					.removeClass('noneofthem')
        break;
      }
      case 'finished':{
        $('.displayFilter').each(function(i, o){
          o.checked = (o.id == 'ffinished') ? true : false;
        })
        $('#todoItemsList')
				  .removeClass('noneofthem')
					.removeClass('notfinishedonly')
					.addClass('finishedonly');
        break;
      }
      case 'notfinished':{
        $('.displayFilter').each(function(i, o){
          o.checked = (o.id == 'fnotfinished') ? true : false;
        })
        $('#todoItemsList')
				  .removeClass('noneofthem')
					.removeClass('finishedonly')
					.addClass('notfinishedonly');
        break;
      }
      default:{
        
        break;
      }
    }
		//fnone.checked = $('.displayFilter:checked').length == 0 || fnone.checked ? true : false;
  },
  filterByText: function(v){
    v = v.toLowerCase();
    if(v!=''){$('#clearFilterText').show()}else{$('#clearFilterText').hide()}
    $('.itm_ta').each(function(i, o){ 
		  var text = (o.tagName == 'DIV') ? o.innerText : o.value;
      if(text.toLowerCase().indexOf(v)>-1){
        o.parentNode.parentNode.parentNode.style.display = '';
      }else{
        o.parentNode.parentNode.parentNode.style.display = 'none';
      }
    })
  },
  validForm: function(obj){
    
  },
  saveTodo: function(id){
		$('.button_save').attr('disabled',1).removeClass('button_up').addClass('button_disabled');
    var dtr = $("div.dtr");
    var todo = {};
    todo.name = $("#todo_name").val();
    todo.description = $("#todo_description").val(); 
    var items = [];
    dtr.each(function(tr){
      var dinput = "";
      if($("textarea", this).length!=0){
        dinput = $("textarea", this);
      }else if($("input.itm_val_con:hidden", this).length != 0){
        dinput = $("input.itm_val_con:hidden", this);
      }
      if(dinput != ""){
				items.push([dinput[0].id, dinput.val()]);
      }
    });
    var data = {}; 
    data.id = id;
    data.authenticity_token = AUTH_TOKEN;
    data.items = JSON.stringify(items);
    data.todo = JSON.stringify(todo);
    
		if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Saving...');
    $.ajax({
      type: "POST",
      url: "/todo/save",
      data: data,
      dataType: 'json',
      success: function(data){
        $(data).each(function(i,o){
					var itm = $('#items_0_'+o.item.sort).attr('id','items_'+o.item.id+'_'+o.item.sort).attr('name','items['+o.item.id+'_'+o.item.sort+']');
          var itm_chk = $('#items_0_'+o.item.sort+'_chk').attr('id','items_'+o.item.id+'_'+o.item.sort+'_chk').val(o.item.id);
			    $('.modify_reminder', itm.parentNode).css('display','');
				})
        if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
        $this.notify('Success!');
        TIMER = setTimeout(function(){noti.fadeOut(); $('.button_save').removeClass('button_disabled').attr('disabled',0); },3999);
      }
    });
  },
	pselectPresetPerm: function(a){
		$('#pcon tr').slice(1,3).each(function(i,o){
			var p = a[i];
			$('td',o)[1].childNodes[0].innerHTML = p[0]==1 ? '<div class="check"></div>' : '';
      $('td',o)[2].childNodes[0].innerHTML = p[1]==1 ? '<div class="check"></div>' : '';
      $('td',o)[3].childNodes[0].innerHTML = p[2]==1 ? '<div class="check"></div>' : '';
      
		})
	},
	pselectperm: function(o){
		var manual = $('#shareOptionC');
		if(manual.length>0){
			manual[0].checked = 1;
		}
		
		var o = $(o);
		if(/check/.test(o.html())){
			o.html('')
		}else{
			o.html('<div class="check"></div>')
		}
	},
	beforeNewTodoSave: function(){
		var c = $('#pcon tr');
    var contacts = [];
    c.each(function(i,o){
      var cid = $(o).attr('cid');
      var r = /check/.test($('td',o)[1].innerHTML);
      var w = /check/.test($('td',o)[2].innerHTML);
      var d = /check/.test($('td',o)[3].innerHTML);
      if(o.className == 'p_public'){
        //alert('-1,'+r+','+w+','+d)
        contacts.push({cid:-1, r:r, w:w, d:d});
      }else if(o.className == 'p_mycontacts'){
        contacts.push({cid:-2, r:r, w:w, d:d});
      }else{
        if(/cid_/.test(cid)){
          var cid = cid.replace(/cid_/,'');
          //alert(cid+','+r+','+w+','+d)
          contacts.push({cid:cid, r:r, w:w, d:d});
        }
      }
    });
		
		$('#todo_permission').val(JSON.stringify(contacts));
		$('#new_todo').submit();
	},
	saveTodoPermissions: function(id){
		$('#button_share_settings').attr('disabled',1).removeClass('button_up').addClass('button_disabled');
		var c = $('#pcon tr');
		var data = {};
		data.id = id;
		data.authenticity_token = AUTH_TOKEN;
		data.msg = $('#contact_picker_msg').val();
		var contacts = [];
		c.each(function(i,o){
			var cid = $(o).attr('cid');
      var r = /check/.test($('td',o)[1].innerHTML);
      var w = /check/.test($('td',o)[2].innerHTML);
      var d = /check/.test($('td',o)[3].innerHTML);
      if(o.className == 'p_public'){
        //alert('-1,'+r+','+w+','+d)
        contacts.push({cid:-1, r:r, w:w, d:d});
      }else if(o.className == 'p_mycontacts'){
        contacts.push({cid:-2, r:r, w:w, d:d});
			}else{
				if(/cid_/.test(cid)){
          var cid = cid.replace(/cid_/,'');
          //alert(cid+','+r+','+w+','+d)
          contacts.push({cid:cid, r:r, w:w, d:d});
				}
			}
		})
		
		data.contacts = JSON.stringify(contacts);
		
		if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Saving Share Settings...');
    $.ajax({
      type: "POST",
      url: "/todo/savePermissions",
      data: data,
      dataType: 'json',
      success: function(data){
        
				if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
        var noti = $this.notify('Share Settings saved!');
        TIMER = setTimeout(function(){noti.fadeOut(); $('#button_share_settings').removeClass('button_disabled').attr('disabled',0); },3999);
      }
    });
		
	},
	deleteTodo: function(id){
		if (!confirm('Delete Todo List will delete all associated Action Items and Reminders. Do you still want to delete it?')) {return }
		$('.button_delete').attr('disabled',1).removeClass('button_up').addClass('button_disabled');
		
    var data = {};
    data.id = id;
    data.authenticity_token = AUTH_TOKEN;
		
		if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Deleting...');
    $.ajax({
      type: "POST",
      url: "/todo/delete",
      data: data,
      dataType: 'json',
      success: function(data){
        
				if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
        var noti = $this.notify('Todo is deleted! Redirecting to home...');
        TIMER = setTimeout(function(){ $dir('/web/home')},0);
      }
    });
	},
	startTrackingTodo: function(id){
    var btn = $('.button_tracking').attr('disabled',1).removeClass('button_up').addClass('button_disabled');
    
    var data = {};
    data.id = id;
    data.authenticity_token = AUTH_TOKEN;
    
    if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('You are tracking this Todolist now!');
    TIMER = setTimeout(function(){
			noti.fadeOut(); 
    },3999);
		
		btn.unbind('mouseover').unbind('mouseout').unbind('click').attr('onclick','').attr('onmouseover','').attr('onmouseout','')
		.html('Tracking').removeClass('button_disabled').addClass('button_down_persist').attr('disabled',0).mouseover(function(){
			this.innerHTML = 'Stop Tracking';
		}).mouseout(function(){
			this.innerHTML = 'Tracking';
		}).click(function(){
			$this.stopTrackingTodo(id);
		})
		
    init_button(btn);
		
    $.ajax({
      type: "POST",
      url: "/todo/start_tracking",
      data: data,
      dataType: 'json',
      success: function(data){
        
      }
    });
	},
	stopTrackingTodo: function(id){
    var btn = $('.button_tracking').attr('disabled',1).removeClass('button_up').addClass('button_disabled');
		
    var data = {};
    data.id = id;
    data.authenticity_token = AUTH_TOKEN;
    
    if(typeof TIMER != 'undefined'){clearTimeout(TIMER)};
    var noti = $this.notify('Tracking is stopped!');
    TIMER = setTimeout(function(){
      noti.fadeOut(); 
    },3999);
		
    btn.unbind('mouseover').unbind('mouseout').unbind('click').attr('onclick','').attr('onmouseover','').attr('onmouseout','')
		  .html('Track').removeClass('button_disabled').removeClass('button_down_persist').attr('disabled',0).click(function(){
      $this.startTrackingTodo(id);
    })
		
    init_button(btn);
		
    $.ajax({
      type: "POST",
      url: "/todo/stop_tracking",
      data: data,
      dataType: 'json',
      success: function(data){
        
      }
    });
	},
	saveListAs: function(id){
		var fm = document.createElement('form');
		fm.action = '/todo/new';
		fm.method = 'post';
		
    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'authenticity_token';
    input.value = AUTH_TOKEN;
    fm.appendChild(input);
		
    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'id';
    input.value = id;
    fm.appendChild(input);
		
		document.getElementsByTagName('body')[0].appendChild(fm);
		fm.submit();
	}
}
