require 'spec_helper'

describe 'Assets' do
  
  before(:each) do
    setup_mygame
    
    files = factory(:assets)
    
    @data_file = Entityjs::Config.assets_folder+'/blag/bob.json'
    files.push @data_file
    
    @sounds_file = Entityjs::Config.sounds_folder+'/fold/secret1.mp3'
    files.push @sounds_file
    
    Dir.stub(:'[]').and_return(files)
    IO.stub(:read).and_return('{"test":0, "array":[1,2,3]}')
  end
  
  after(:all) do
    teardown_mygame
  end
  
  it 'should return all images' do
    
    r = Entityjs::Assets.search('images')
    r.each do |i|
      i.should match /images/
      i.should_not match /levels|sounds|assets/
      i.should match /^*\.(png|gif|jpg|jpeg)$/i
    end
    
  end
  
  it 'should return all sounds' do
    
    r = Entityjs::Assets.search('sounds')
    r.each do |i|
      i.should match /sounds/
      i.should_not match /levels|images|assets/
      i.should match /^*\.(mp3|aac|wav|ogg)$/i
    end
    
    r.should include(@sounds_file.gsub('assets/', ''))
    
  end
  
  it 'should return all datas' do
    
    r = Entityjs::Assets.search('*')
    r.each do |i|
      i.should match /levels|blag/
      i.should_not match /sounds|images|assets/
      i.should match /^*\.(#{Entityjs::Assets.valid_datas.join('|')})$/i
    end
    
    r.should include(@data_file.gsub('assets/', ''))
  end
  
  it 'should generate sounds to js' do
    r = Entityjs::Assets.sounds_to_js
    r.should match /\[*\]/
    
  end
  
  it 'should generate images to js' do
    r = Entityjs::Assets.images_to_js
    r.should match /\[*\]/
    
  end
  
  it 'should generate datas to js' do
    r = Entityjs::Assets.datas_to_js
    r.should match /re\.e\('/
    
  end
  
  it 'should convert xml to json' do
    
    File.stub(:extname).and_return('.xml')
    IO.stub(:read).and_return('<?xml ?><root><alice sid="4"><bob sid="1">charlie</bob><bob sid="2">david</bob></alice></root>')
    
    r = Entityjs::Assets.data_to_json('convert.xml')
    
    r.should match /alice/
    r.should_not match /root/
    r.should_not match /<\?xml.*\?>/
  end
  
  it 'should convert tmx to json' do
    File.stub(:extname).and_return('.tmx')
    IO.stub(:read).and_return(%q(
    <?xml version="1.0" encoding="UTF-8"?>
<map version="1.0" orientation="orthogonal" width="37" height="15" tilewidth="25" tileheight="25">
 <tileset firstgid="1" name="Sheet" tilewidth="25" tileheight="25">
  <image source="tiles.png" width="200" height="25"/>
 </tileset>
 <tileset firstgid="9" name="Objects" tilewidth="25" tileheight="25">
  <image source="items.png" width="250" height="50"/>
 </tileset>
 <layer name="Back" width="37" height="15" opacity="0.43">
  <data encoding="csv">
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,8,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,6,2,2,2,5,0,0,0,0,0,0,8,8,0,
0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,6,1,1,1,1,3,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,1,1,1,1,1,3,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,3,0,0,0,8,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,1,1,1,1,1,1,3,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,6,5,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,3,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,6,2,2,1,3,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,3,0,0,0,0,0,0,0,0,0,
0,0,0,6,2,1,1,1,1,3,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,3,0,0,0,0,0,0,6,2,5,
0,0,6,1,1,1,1,1,1,3,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,3,0,0,0,0,0,0,1,1,3,
0,6,1,1,1,1,1,1,1,3,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,3,0,0,0,0,0,6,1,1,3,
0,4,1,1,1,1,1,1,1,3,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,3,0,0,0,0,6,1,1,1,3,
0,4,1,1,1,1,1,1,1,3,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,3,0,0,0,0,4,1,1,1,3
</data>
 </layer>
 <layer name="Front" width="37" height="15">
  <data encoding="csv">
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,7,7,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,5,0,0,0,0,0,0,0,0,0,0,0,
2,2,2,2,5,0,0,0,0,0,6,2,2,5,0,0,0,0,0,0,0,6,2,2,1,1,2,2,2,5,0,0,0,0,6,2,2,
1,1,1,1,3,0,0,0,0,6,1,1,1,1,5,0,0,0,0,0,0,4,1,1,1,1,1,1,1,1,5,0,0,0,4,1,1,
1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
</data>
 </layer>
 <layer name="Objects" width="37" height="15">
  <data encoding="csv">
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,20,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,23,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,23,0,0,0,0,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,19,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,19,0,0,23,0,0,0,0,0,
0,0,0,0,0,0,0,23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,19,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,21,0,0,23,0,0,0,23,0,0,0,0,0,0,0,0,19,0,0,0,0,0,0,0,0,
0,0,0,0,0,16,16,16,16,16,0,0,0,0,16,16,16,16,16,16,16,0,0,0,0,0,0,0,0,0,16,16,16,16,0,0,0,
0,0,0,0,0,15,15,15,15,0,0,0,0,0,0,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,15,15,15,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
</data>
 </layer>
</map>
))
    
    r = Entityjs::Assets.data_to_json('map.tmx')
    
    r.should_not match /map/
    r.should match /"\$":\[\[0/
  end
  
  it 'should generate to js' do
    r = Entityjs::Assets.to_js
    r.should match /re\.assets/
    
  end
  
end