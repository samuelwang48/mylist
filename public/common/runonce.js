      //constants
			
      __MAP_ROOT__ = ['web', 'index'];
      __MAP_ROUTE__ = [__MAP_ROOT__];
      //__MAP_ROUTE__.push(['todo', 'show']);
      
      __URL__ = window.location.href.split('#')[0].replace(/\?.*$/, '').replace(/\/\d+\//, '/').replace(/\/\d+$/, '');
      __BASE__ = __URL__.replace(/([https|http]:\/{2,3}[^:\/]+(?::\d+)*).*/,"$1");
      __RAILS_CA__ = __URL__.replace(__BASE__,'').replace(/^(\/)/,'').replace(/\/$/,'');
      if ( __RAILS_CA__ == '' ){
        __RAILS_CA__ = __MAP_ROOT__;
      } else { 
        __RAILS_CA__ = __RAILS_CA__.split('/');
        for ( var i = 0 ; i < __MAP_ROUTE__.length ; i++ ){
          if ( __RAILS_CA__[0] == __MAP_ROUTE__[i][0] ) { 
            if( typeof __RAILS_CA__[1] == 'undefined'){
              __RAILS_CA__ = __MAP_ROUTE__[i] 
            }else if( __RAILS_CA__[1] == __MAP_ROUTE__[i][1] ){
              __RAILS_CA__ = __MAP_ROUTE__[i] 
            }else{
              
            };
          };
        };
      };
      __RAILS_CONTROLLER__ = __RAILS_CA__[0];
      __RAILS_ACTION__  = __RAILS_CA__[1] == 'new' ? '_new' : __RAILS_CA__[1];
			
			if(__RAILS_CONTROLLER__=='profile'){
	      __RAILS_CONTROLLER__ = 'web';
	      __RAILS_ACTION__  = 'profile';
			};
      
      if(__RAILS_CONTROLLER__=='invite'){
        __RAILS_CONTROLLER__ = 'web';
        __RAILS_ACTION__  = 'invite';
      };
			
      /*
      document.write(__URL__+'<br />');
      document.write('__BASE__ = '+__BASE__+'<br />');
      document.write('__RAILS_CA__ = '+__RAILS_CA__+'<br />');
      document.write('__RAILS_CONTROLLER__ = '+__RAILS_CONTROLLER__+'<br />');
      document.write('__RAILS_ACTION__ = '+__RAILS_ACTION__+'<br />');
      //*/
			
      //*Load global stylesheet
//      document.write('<link type="text/css" href="/javascripts/css/flick/jquery-ui-1.8.9.custom.css" rel="stylesheet" media="screen"/>');
//      document.write('<link type="text/css" href="/stylesheets/default.css" rel="stylesheet" media="screen"/>');
      //*/
			
      //Load language packages and utilities
      document.write('<script type="text/javascript" src="/common/lang-en-us.js"></script>');
      document.write('<script type="text/javascript" src="/common/utils.js"></script>');
      //*/
      
      //Load jquery core
      document.write('<script type="text/javascript" src="/javascripts/jquery.js"></script>');
      document.write('<script type="text/javascript" src="/javascripts/jquery-ui.js"></script>');
      
      
			//Load JSON2
      document.write('<script type="text/javascript" src="/javascripts/json2.js"></script>');
			
      /*Load jquery ui libary
       */
//      document.write('<link type="text/css" href="/javascripts/dropdown-check-list-0.4/ui.dropdownchecklist.css" rel="stylesheet"/>');
//      document.write('<script type="text/javascript" src="/javascripts/dropdown-check-list-0.4/ui.dropdownchecklist.js"></script>');
//      
//      document.write('<link type="text/css" href="/javascripts/autocomplete/jquery.autocomplete.css" rel="stylesheet"/>');
//      document.write('<script type="text/javascript" src="/javascripts/autocomplete/jquery.autocomplete.js"></script>');
      //*/
      
      
      //*Load FE controller
      document.write('<script type="text/javascript" src="/controllers/application.js"></script>');
      document.write('<script type="text/javascript" src="/controllers/'+__RAILS_CONTROLLER__+'.js"></script>');
      //*/
      
			init_button = function(a){
        a.mouseover(function(){
          $(this).addClass('button_up')}).mouseout(function(){$(this).removeClass('button_up'); 
          $(this).removeClass('button_down')}).mouseup(function(){$(this).removeClass('button_down')}).mousedown(function(){$(this).addClass('button_down')});
			};
			
      window.onload = function(){
        init_button($('button'));
        init_button($('.button'));
        
        ACTIVE_SUBMENU = null;
        ACTIVE_SUBMENU_HOVER = false;
				FORCE_ACTIVE_SUBMENU_VISIBLE = false;
				ON_ACTIVE_SUBMENU_HIDE = function(){};
        ACTIVE_SUBMENU_HIDE = function(){ if(FORCE_ACTIVE_SUBMENU_VISIBLE){return}; if(ACTIVE_SUBMENU){ACTIVE_SUBMENU.hide(); ACTIVE_SUBMENU.prev().removeClass('mousedown').children().removeClass('arw_mousedown').removeClass('arwh_mousedown') }; ON_ACTIVE_SUBMENU_HIDE();};
        $('.dropdown').mouseover(function(){ ACTIVE_SUBMENU_HOVER = true; }).mouseout(function(){ ACTIVE_SUBMENU_HOVER = false;});
        $('.itododropdown_outer').mouseover(function(){ ACTIVE_SUBMENU_HOVER = true; }).mouseout(function(){ ACTIVE_SUBMENU_HOVER = false;});
        $('.itododropdown_outer').mousedown(function(){ ACTIVE_SUBMENU_HIDE(); ACTIVE_SUBMENU = $(this).addClass('mousedown').next().show(); $('.arwh', this).addClass('arwh_mousedown'); });

				$('body').mousedown(function(){ if(!ACTIVE_SUBMENU_HOVER){ACTIVE_SUBMENU_HIDE()}});
        
        PRESET = {};
        PRESET.EARLIER = [
          5*_MINUTE_, 10*_MINUTE_, 15*_MINUTE_, 30*_MINUTE_, 45*_MINUTE_,
          1*_HOUR_, 2*_HOUR_, 3*_HOUR_, 4*_HOUR_, 5*_HOUR_, 6*_HOUR_, 7*_HOUR_, 8*_HOUR_, 9*_HOUR_, 10*_HOUR_, 11*_HOUR_, 12*_HOUR_,
          1*_DAY_, 2*_DAY_, 3*_DAY_, 4*_DAY_, 5*_DAY_, 6*_DAY_,
          1*_WEEK_, 2*_WEEK_, 3*_WEEK_,
          1*_MONTH_, 2*_MONTH_, 3*_MONTH_
        ];
		    var myDate = new Date();
		    var today = myDate.getFullYear() + '-' + (myDate.getMonth()+1) + '-' + myDate.getDate();
		    today = today.replace(/\-(\d{1})-/,'-0$1-').replace(/\-(\d{1})$/,'-0$1');
		    PRESET.DEFAULT_DATE = today;
		    PRESET.DEFAULT_HOUR = '09:00';
				PRESET.DEFAULT_EARLIER = 5*_MINUTE_;

        //$(document).ready(function(){
        eval('if(typeof('+ __RAILS_CONTROLLER__ +') != "undefined"){$this = ' + __RAILS_CONTROLLER__ + '}');
				for(p in application){ $this[p] = application[p]; };
        $this.init();
        if(typeof(__RAILS_ACTION__) != 'undefined' && typeof($this) != 'undefined'){
          eval('if(typeof($this.' + __RAILS_ACTION__ + ') != "undefined"){ $this.' + __RAILS_ACTION__ + '(); }');
        }
				
				if(jQuery.browser.msie && parseInt(jQuery.browser.version, 10) == 6) {
				  try {
				    document.execCommand("BackgroundImageCache", false, true);
				  } catch(err) {}
				}
        //})

				
				
      }
