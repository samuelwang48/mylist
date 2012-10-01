  
  $CACHE = {
    init: function(){
      CACHE_NAMESPACE = {};
    },
    get: function(key){
      return CACHE_NAMESPACE[key]
    },
    set: function(key, val){
      CACHE_NAMESPACE[key] = val;
    },
    destroy: function(key){
			CACHE_NAMESPACE[key] = void(0);
      delete CACHE_NAMESPACE[key];
    },
		exists: function(key){
			return (typeof(CACHE_NAMESPACE[key]) == 'undefined') ? false : true;
		}
  }
  
  $CACHE.init();
//  $CACHE.set('test', 123);
//  alert($CACHE.get('test'));
//  alert($CACHE.exists('test'));
//  $CACHE.destroy('test');
//  alert($CACHE.get('test'));
//  alert($CACHE.exists('test'));
	
  $A = function(iterable) {
    if (!iterable) return [];
    var length = iterable.length, results = new Array(length);
    while (length--) results[length] = iterable[length];
    return results;
  };

  $pageWidth = function(){
    var pageWidth = 0;
    if( typeof( window.innerWidth ) == 'number' ) {
      //Non-IE
      pageWidth = window.innerWidth;
    } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
      //IE 6+ in 'standards compliant mode'
      pageWidth = document.documentElement.clientWidth;
    } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
      //IE 4 compatible
      pageWidth = document.body.clientWidth;
    };
    return pageWidth;
  };
  
  $pageHeight = function(){
    var pageHeight = 0;
    if( typeof( window.innerWidth ) == 'number' ) {
      //Non-IE
      pageHeight = window.innerHeight;
    } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
      //IE 6+ in 'standards compliant mode'
      pageHeight = document.documentElement.clientHeight;
    } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
      //IE 4 compatible
      pageHeight = document.body.clientHeight;
    };
    return pageHeight;
  };
  
  $v_to_s = function(tpl){
    var tmpStr = tpl.replace(/[^{]*{#([^{#}]+)}[^{]*/gi, "$1,");
    tmpStr = tmpStr.split(',');
    tmpStr.pop();
    $.each(tmpStr, function(i, v) {
      tpl = tpl.replace('{#'+v+'}',eval(v));
    });
    return tpl;
  };
  
  $v_scan = function(){
    var args = $A(arguments);
    var tmpStr = args[0];
    var i = 0;
    args.shift();
    while(/%s/.test(tmpStr)){
      tmpStr = tmpStr.replace(/%s/, args[i]);
      i++;
    };
    return tmpStr;
    
  };
  
  $dir = function(url){
    setTimeout(function(){
      window.location.href = url;
    },0)
  };
	
  //cookie expiration
  $COOKIE_EXPIRES = new Date();
  $COOKIE_EXPIRES.setTime($COOKIE_EXPIRES.getTime() + 365 * (24 * 60 * 60 * 1000)); //+1 year
  $COOKIE_EXPIRES_NOW = new Date();
	$COOKIE_EXPIRES_NOW.setTime($COOKIE_EXPIRES.getTime() - 365 * (24 * 60 * 60 * 1000)); //-1 year
  //Sets a Cookie with the given name and value.
  _setCookie = function(name, value, expires, path, domain, secure) {
    var path = path || '/';
    var expires = expires || $COOKIE_EXPIRES;
    document.cookie = name + "=" + escape(value) + ((expires) ? "; expires=" + expires.toGMTString() : "") + ((path) ? "; path=" + path : "") + ((domain) ? "; domain=" + domain : "") +  ((secure) ? "; secure" : "");
  };
  //set cookie
  $setCookie = function(name, value){
    _setCookie(name, value);
    var cookies = $getCookie('CP');
    cookies = cookies ? cookies.split('|') : [];
    
		var indexOf = -1;
		for (var i = 0; i < cookies.length; i++){
			if (cookies[i]==name){
				indexOf = i;
				break;
			}
		}
		
    if(indexOf<0){
      cookies.push(name);
    };
		
    _setCookie('CP',cookies.join('|'));
  };
  //Gets the value of the specified cookie.
  $getCookie = function(name) {
    var dc = document.cookie;
    var prefix = name + "=";
    var begin = dc.indexOf("; " + prefix);
    if (begin == -1) {
      begin = dc.indexOf(prefix);
      if (begin != 0) return null;
    } else {
      begin += 2;
    };
    var end = document.cookie.indexOf(";", begin);
    if (end == -1) {
      end = dc.length;
    };
    return unescape(dc.substring(begin + prefix.length, end));
  };
  //Deletes the specified cookie.
  $deleteCookie = function(name, path, domain) {
    var path = path || '/';
    if($getCookie(name)){
      document.cookie = name + "=undefined" + ((path) ? "; path=" + path : "") + ((domain) ? "; domain=" + domain : "") + "; expires=" + $COOKIE_EXPIRES_NOW.toGMTString();
    }
  };
	
  //clear cookies
  $clearTempCookies = function(){
    var cookies = $getCookie('CP');
    if(!cookies) { return };
    cookies = cookies.split('|');
		for(var i = 0; i < cookies.length; i++){
			$deleteCookie(cookies[i])
		}
    $deleteCookie('CP');
  };
  
//  _setCookie('a','123');
//  $setCookie('b','aaa');
//  alert($getCookie('a'))
//  alert($getCookie('b'))
//  $clearTempCookies();
//  alert($getCookie('a'))
//  alert($getCookie('b'))

	$t2h = function(str){
		return str.replace(/&gt;/g, '>').replace(/&lt;/g, '<');
	};
	
	$h2t = function(str){
		return str.replace(/>/g, '&gt;').replace(/</g, '&lt;');
	};
	
  _SECOND_  = 1;
  _MINUTE_  = 60;
  _HOUR_    = 60*60;
  _DAY_     = 60*60*24;
  _WEEK_    = 60*60*24*7;
  _MONTH_   = 60*60*24*7*30;
  _YEAR_    = 60*60*24*7*30*365;
	
	$to_pretty = function(t){
		var output = '';
		
		if(t==0){
			output = "just now";
		}else if(t>= _SECOND_ && t<_MINUTE_){
      output = parseInt(t/_SECOND_) + " seconds"
		}else if(t>= _MINUTE_ && t<_HOUR_){
      output = parseInt(t/_MINUTE_) + " minutes"
		}else if(t>= _HOUR_ && t<_DAY_){
      output = parseInt(t/_HOUR_) + " hours"
		}else if(t>=_DAY_ && t<_WEEK_){
      output = parseInt(t/_DAY_) + " days"
		}else if(t>=_WEEK_ && t<_MONTH_){
      output = parseInt(t/_WEEK_) + " weeks"
		}else if(t>=_MONTH_ && t<_YEAR_){
      output = parseInt(t/_MONTH_) + " months"
		}else if(t>=_YEAR_ && t<_YEAR_*10){
      output = parseInt(t/_YEAR_) + " years"
    };
		return output.replace(/^(1\s[a-zA-Z]+)s/, '$1');
	};

	$T = function(t){
		var ta = $('#SYSTRAC');
		ta.html(ta.html()+t+'\n');
	};
	
  $$T = function(t){
    var ta = $('#SYSTRAC');
    ta.html(t);
  };
	
	
  