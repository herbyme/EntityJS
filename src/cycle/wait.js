/*
The wait component delays function calls.
*/
re.c('wait')
.requires('update')
.defines({
	
	wait:function(time, callback){
		var c = 0;
		
		this.bind('update',  function(t){
			c += t;
			
			if(c >= time){
				this.callback.apply(this, Array.prototype.slice.call(arguments, 2));
				return false;
			}
		});
		
    return this;
	}
	
});