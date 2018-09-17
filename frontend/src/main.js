// The application will create a renderer using WebGL, if possible,
// with a fallback to a canvas render. It will also setup the ticker
// and the root stage PIXI.Container
const app = new PIXI.Application();

// The application will create a canvas element for you that you
// can then insert into the DOM
document.body.appendChild(app.view);


const makeGridGraphics = () => {
  const graphics = new PIXI.Graphics();
  //app.stage.addChild(graphics);

  let w = app.renderer.width;
  let h = app.renderer.height;
  let g = w / 26; // 32 squares and a margin on each side

  let orange = 0xffb200;
  let blue = 0x42dff4;

  graphics.lineStyle(2, blue, 0, 1);

  // grid

  graphics.lineStyle(2, blue, 0.5, 1);
  graphics.beginFill(0x000000, 0);

  for (var i=0; i<24; i++) {
    for (var j=0; j<16; j++) {
      graphics.drawRect(g*(i+1), g*(j+1), g, g);
    }
  }

  return graphics;

};

const drawHighlightedSquares = (graphics, highlighted) => {

  graphics.clear();

  let w = app.renderer.width;
  let h = app.renderer.height;
  let g = w / 26; // 32 squares and a margin on each side

  let orange = 0xffb200;
  let blue = 0x42dff4;

  graphics.lineStyle(2, blue, 0, 1);

  // backgrounds for hightlighted squares

  graphics.beginFill(orange, 0.8);

  highlighted.forEach((o) => {
    let x = o.x;
    let y = o.y;
    graphics.drawRect(g*(x+1), g*(y+1), g, g);
  });

};

const initialData = [{x:10,y:3},{x:10,y:4},{x:11,y:4}];

let grid = makeGridGraphics();
app.stage.addChild(grid);

const highlighted_graphics = new PIXI.Graphics();
app.stage.addChild(highlighted_graphics);
drawHighlightedSquares(highlighted_graphics, initialData);

const update = (serverData) => {
  let newData = serverData.map((x) => x); // currently redundant
  drawHighlightedSquares(highlighted_graphics, newData);
};

// jQuery for command input

$( "#commandform" ).submit(function( event ) {
  //alert( "Handler for .submit() called." );
  let text = $("#commandtext").val();

  let query = { "command": text };

  $.ajax({
    type: "POST",
    contentType:"application/json", //; charset=utf-8",
    url: '/command',
    data: JSON.stringify(query),
    dataType: 'json'
  }).done((data) => {
    console.log(`Received: ${data}`);
    Object.keys(data).forEach((k) => {
      console.log(data[k]);
    });
    update(data);
  }).fail((err) => {
    console.log(`${err.responseText}`);
  });

  $("#commandtext").val("");
  event.preventDefault();
});
