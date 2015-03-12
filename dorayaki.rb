class Dorayaki
  def initialize app, amount, height
    @app = app
    @amount = amount
    @height = height
  end
  
  def call env
    status, header, body = @app.call(env)
    
    @amount.times do
      body.unshift "<img src='http://blog-imgs-60-origin.fc2.com/k/a/k/kakopipe/doraemon732.jpg' style='height: #{@height}px'>"
    end
    
    [ status, header, body ]
  end
end