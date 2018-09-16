
const drawTiledBackground = () => {
  
  console.log('grid???');

  // create a texture from an image path
  
  var texture = PIXI.Texture.fromImage('images/pico8_cheat_sheet.png');

  /* create a tiling sprite ...
   * requires a texture, a width and a height
   * in WebGL the image size should preferably be a power of two
   */
  var tilingSprite = new PIXI.extras.TilingSprite(
    texture,
    app.screen.width,
    app.screen.height
  );
  app.stage.addChild(tilingSprite);

  tilingSprite.tileScale.x = 0.1;
  tilingSprite.tileScale.y = 0.1;

  var count = 0;

  /*
  app.ticker.add(function() {

    count += 0.005;

    tilingSprite.tileScale.x = 2 + Math.sin(count);
    tilingSprite.tileScale.y = 2 + Math.cos(count);

    tilingSprite.tilePosition.x += 1;
    tilingSprite.tilePosition.y += 1;
  */

};

const drawRotateyThing = () => {
  const bunny = new PIXI.Sprite(resources.bunny.texture);

  // Setup the position of the bunny
  let baseX = app.renderer.width / 2;
  let baseY = app.renderer.height / 2;
  bunny.x = baseX;
  bunny.y = baseY;

  // Rotate around the center
  bunny.anchor.x = 0.5;
  bunny.anchor.y = 0.5;

  // Add the bunny to the scene we are building
  app.stage.addChild(bunny);

  var t = 0;
  // Listen for frame updates
  app.ticker.add(() => {
    // each frame we spin the bunny around a bit
    bunny.rotation += 0.01;
    //console.log("hey");
    t += 1;
    bunny.x = baseX + 100 * Math.sin(t/100);
    bunny.y = baseY + 100 * Math.cos(t/100);
    //console.log(`${bunny.x}, ${bunny.y}`);

  });
};

// load the texture we need
PIXI.loader.add('bunny', 'images/random.png').load((loader, resources) => {
  // This creates a texture from a 'bunny.png' image

});

