describe('sprite', function(){
	
	var e;

	beforeEach(function(){
		e = re.e('sprite '+f('image').name);
    e.bisect = 16;
    e.sizeX = 2;
    e.sizeY = 2;
	});

	it('frame', function(){
		eq(e.frame(), 0)
    
    eq(e.frame(1), e)
    
    eq(e.frameX, 1)
    eq(e.frameY, 0)
    
    eq(e.frame(), 1)
	});
  
  it('draw', function(){
    is(e.draw(re.sys.context))
    
  });
  
});
