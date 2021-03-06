/*
The tile component adds tile positioning functions and helper functions for tile based games.

@usage

//set tile size
re.tile.sizeX = 40;
re.tile.sizeY = 40;

//convert mouse coordinates to a tile position..
var mouse = {x:10, y:234};

re.tile.toX(mouse.x) // 0
re.tile.toY(mouse.y) 

//create tile
var tile = re.e('tile sprite tiles.png')
.tile(2, 4);

tile.posX // 2 * re.tile.sizeX == 80
tile.posY // 4 * re.tile.sizeY == 160

//create a bunch of tiles from a map

var map = 
[
[1,2,4,5,0,3,4,5,6,7],
[1,2,4,5,0,3,4,5,6,7],
[1,2,4,5,0,3,4,5,6,7],
[1,2,4,5,0,3,4,5,6,7]
];

re.e('tile sprite tiles.png', map.length * map[0].length)
.tilemap(map.length[0].length,function(x, y){
  this.tile(x, y);
  this.frame(map[y][x]);
});

@warning moving to negative tiles will cause rounding issues.
Its recommended you avoid negative maps

*/
re.tile = re.c('tile')
.statics({
    sizeX:40,
    sizeY:40,
    
    toX:function(x, size){
        size = size || this.sizeX;
        return this.toTileX(x, size) * size;
    },
    
    toY:function(y, size){
      size = size || this.sizeY;
        return this.toTileY(y, size) * size;
    },
    
    //converts the given coordinate to a tile position
    toTileX:function(x, size){
        size = size || this.sizeX;
        return (x - size * 0.5) / size + 0.5 | 0
    },
    
    toTileY:function(y, size){
        size = size || this.sizeY;
        return (y - size * 0.5) / size + 0.5 | 0
    }
    
})
.defaults({
    
    posX:0,
    posY:0
    
})
.init(function(){
  this.def({
    sizeX:re.tile.sizeX,
    sizeY:re.tile.sizeY
  });
  
})
.defines({

    tile:function(x, y){
      if(re.is(x,'object')){
        y = x.posY || x.y;
        x = x.posX || x.x;
      }
      this.tileX(x);
      this.tileY(y);
      return this;
    },
    
    tileX:function(v){
        if(re.is(v)){
          this.posX = v * this.sizeX;
            return this;
        }
        return re.tile.toTileX(this.posX, this.sizeX);
    },
    
    tileY:function(v){
        if(re.is(v)){
            this.posY = v * this.sizeY; 
            return this;
        }
        return re.tile.toTileY(this.posY, this.sizeY);
    }
    
});