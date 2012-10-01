require 'rubygems'
require 'jsmin'
require 'cssmin'

desc "Minify and Merge JavaScript & CSS Files"

task :minmer do
  conf = RAILS_ROOT + '/config/environment.rb'
  IO.readlines(conf).each{|c|
    if /ITODO_CDN_HOST/ =~ c
      ITODO_CDN_HOST = c.split('=')[1].gsub(/[\s"]/,'')
    end
  }
  
  js_root = RAILS_ROOT + '/public'
  runonce = js_root + '/common/runonce.js'
  minified = ''
  #merge all the js files in runonce.js and minify it
  
  IO.readlines(runonce).each{|f|
    if (/__RAILS_CONTROLLER__\+'\.js/ =~ f) != nil
      minified += "document.write('<script type=\"text/javascript\" src=\""+ITODO_CDN_HOST+"/common/dependencies.js\"></script>');\n"
    end
    (minified += f) if (/^[^\/\/].*<script/ =~ f) == nil || (/__RAILS_CONTROLLER__/ =~ f) != nil
  }
  
  File.open(runonce.gsub(/\.js/, '.min.js'), 'w'){|f|f.puts minified}
  File.open(runonce.gsub(/\.js/, '.min.js'), 'r'){|file|minified = JSMin.minify(file)}
  File.open(runonce.gsub(/\.js/, '.min.js'), 'w'){|f|f.puts minified}
  
  #runonce is minified
  puts '/common/runonce.js is minified'
  
  flist = []
  IO.readlines(runonce).each{|f|
    flist.push(f.gsub(/(.*src=")([\/\.\-a-zA-Z0-9]+)(".*)/, '\2')) unless (/^[^\/\/].*<script/ =~ f) == nil || (/__RAILS_CONTROLLER__/ =~ f) != nil
  }
  
  dependencies = ''
  
  flist.each{|fl|
    fname = js_root + fl.gsub!(/[\s]/, '')
    File.open(fname, 'r') {|file| 
      minified = JSMin.minify(file)
      dependencies += minified
    }
    #File.open(fname.gsub(/\.js/, '.min.js'), 'w'){|f|f.puts minified}
    #puts fl + ' is minified'
  }
  
  File.open(js_root + '/common/dependencies.js', 'w'){|f|f.puts dependencies}
  puts '/common/dependencies.js is generated'
  
  #css files
  css = []
  css.push RAILS_ROOT + '/public/stylesheets/default.css'
  css.push RAILS_ROOT + '/public/stylesheets/default_ie.css'
  css.push RAILS_ROOT + '/public/stylesheets/default_ie8.css'
  css.push RAILS_ROOT + '/public/stylesheets/jquery-ui-1.8.9.custom.css'
  
  all_cssminified = ''
  css.each{|c|
    cssminified = ''
    File.open(c, 'r') {|file| 
      cssminified = CSSMin.minify(file).gsub(/\/images\//, ITODO_CDN_HOST+'/images/')
      if (/ie/ =~ c) == nil
        #non ie, do min and mer
        all_cssminified += cssminified
      else
        #ie, min only
        File.open(c.gsub(/\.css/, '.min.css'), 'w'){|f|f.puts cssminified}
        puts c.gsub(RAILS_ROOT+'/public','') + ' is minified'
      end
    }
    #File.open(c.gsub(/\.css/, '.min.css'), 'w'){|f|f.puts cssminified}
    #puts c.gsub(RAILS_ROOT+'/public','') + ' is minified'
  }
  
  File.open(RAILS_ROOT + '/public/stylesheets/all.min.css', 'w'){|f|f.puts all_cssminified}
  puts '/stylesheets/all.min.css is generated'
  
  
  
  
  
  
  
  
  
  
end
