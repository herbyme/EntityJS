describe('hit', function(){
	
	var e;

	beforeEach(function(){
		e = re.e('hit');
	});

	it('should hit', function(){
    e.sizeX = 40;
    e.sizeY = 40;
    ok(e.hit(20, 3, 40, 40))
    
	});
  
  it('should not hit', function(){
    
    not(e.hit(41, 0, 40, 40))
  })
  
  it('should hit object', function(){
    
    not(e.hit({posX:100, posY:0, sizeX:30, sizeY:30}))
    
    not(e.hit({x:100, y:0, w:30, h:30}))
  })
  
});
