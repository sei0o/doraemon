get "about" do
  "ぼく<strong>どらえもん</strong>"
end

path "nobita" do
  get "diary" do
    "3/10 ねていた<br>" + 
    "3/11 ねた<br>" +
    "3/12 Rackでフレームワークを作った"
  end
end