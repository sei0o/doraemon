module Doraemon
  @@routes = {}
  @@current_path = [] # 現在いる階層を表すスタック

  def self.included klass
    puts "\\ぼくドラえもん/".blue
  end

  def doraemon env
    path = env["PATH_INFO"]
    method = env["REQUEST_METHOD"].downcase.to_sym
    
    proc = get_proc path
    p proc
    
    if proc.is_a?(Hash) && proc[method].is_a?(Proc) # 合致するpathがあれば
      return 200, header, [proc[method].call(env)]
    else
      return 404, header, ["<h1>404 Not Found</h1>"]
    end
  end
  
  def get path = "/", &block
    remove_slash path
    init_path path
    unless @@current_path.empty?
      @@routes[@@current_path.last][path][:get] = block
    else
      @@routes[path][:get] = block
    end
  end
  
  def post path = "/", &block
    remove_slash path
    init_path path
    unless @@current_path.empty?
      @@routes[@@current_path.last][path][:post] = block
    else
      @@routes[path][:post] = block
    end
  end
  
  def path path
    remove_slash path
    
    @@current_path << path # 階層を追加
    @@routes[@@current_path.last] ||= {}
    yield
    @@current_path.pop # 一個上の階層に戻る
  end
  
  private
  
    def header
      {"Content-Type" => "text/html"}
    end
  
    def init_path path
      unless @@current_path.empty?
        @@routes[@@current_path.last][path] ||= { get: {}, post: {} }
      else
        @@routes[path] ||= { get: {}, post: {} }
      end
    end
    
    def remove_slash path
      path.gsub!(/(^\/|\/$)/, "") # 先頭と末尾の/を取り除く
    end
      
    def get_proc path, routes = @@routes
      dir_levels = path.split "/"
      dir_levels.shift if dir_levels[0] == ""
      dir_levels << "" # injectを1回多くさせる
      
      proc = dir_levels.inject do |here, child|
        puts here.blue
        
        if (routes[here] || {} ).keys[0].is_a? Symbol
          # :get や :postのあるところへたどり着いた
          puts "FOUND PROC: #{here}".green
          pp routes, here
          break routes[here] 
        end
        
        if routes[here]
          here.split("/").each do |level|
            dir_levels.delete level
          end
          children = dir_levels
          
          puts "FOUND: #{here} next: #{children}".green
          
          break get_proc children.join("/"), routes[here] # もう一個下の階層を探索して抜ける
        else # 見つからなかった
          # もう一個下の階層と合わせる
          puts "NOT FOUND: #{here}".red
          
          here + "/" + child
        end
      end
      
      proc
    end
end

Object.send :include, Doraemon