#import('dart:html');

#source('Util.dart');

class writename {
  var project_name;
  ImageElement elem;
  int x;
  int y;
  int points = 0;
  int BARRA = 15;
  int total_height;
  int total_width;
  var hr = true;
  var vr = true;
  int last_ball = 0;
  
  static final List<String> PNGS = const [
      "images/ball-d9d9d9.png",
      "images/ball-009a49.png", "images/ball-13acfa.png",
      "images/ball-265897.png", "images/ball-b6b4b5.png",
      "images/ball-c0000b.png", "images/ball-c9c9c9.png"];

  int TAMANHO_ALTURA_IMAGEM = 14;
  int TAMANHO_LARGURA_IMAGEM = 14;
  int width_size;
  int height_size;
  int distance_from_top;
  double PROPORCAO_TELA = .1; 
  int millis = 10;
  bool stop;
  
  writename() {
    this.project_name = "DART Hackaton 2012 - Sao Paulo - Brazil";
  }

  void run() {
    write(this.project_name);
    createButton();
    createBox();
    ini();
    keyboard();
    window.setInterval((){
      if( !stop ){
        randomVelocity();
        limitations();
      }
    }, millis);
  }
  
  explodeBall() {
    elem.src = writename.PNGS[last_ball];
    Util.abs(elem);
    Util.pos(elem, x.toDouble(), y.toDouble());
    document.body.query("#box").nodes.add(elem);
  }
  
  void ini(){
    elem = null;
    elem = new Element.tag('img');
    x = 0;
    y = 0;
    zeroPoints();
    stop = false;
    hr = true;
    vr = true;
    create_bar();
    explodeBall();
  }
  
  create_bar() {
    DivElement bar = new Element.tag('div');
    bar.attributes["id"] = 'bar';
    double bar_size = (total_width*PROPORCAO_TELA);
    bar.style.width = bar_size.toString()+"px";
    bar.style.height = "5px";
    bar.style.backgroundColor = "#FF0000";
    Util.abs(bar);
    distance_from_top = (height_size-5);
    Util.pos(bar, 0.toDouble(), distance_from_top.toDouble());
    document.query("#box").nodes.add( bar );  
  }
  
  createBox(){
    Element box = document.query("#box");
    height_size = box.$dom_clientHeight;
    width_size = box.$dom_clientWidth;
    total_height = height_size - TAMANHO_ALTURA_IMAGEM;
    total_width  = width_size  - TAMANHO_LARGURA_IMAGEM;
    Util.rel( box );
  }
  
  createButton(){
    ButtonElement botao = new Element.tag('button');
    botao.attributes['id'] = "play";
    botao.innerHTML = "Play";
    botao.on.click.add( (e) {
      Element box = document.query("#box");
      box.innerHTML = "";
      ini();
    } );
    botao.value = "Play";
    document.query("#play-button").nodes.add( botao );
  }

  keyLeftPress(){
    Element bar = document.query("#bar");
    String lp = bar.style.left;
    lp = lp.replaceAll("px", "");
    double left_pos = Math.parseDouble(lp);
    
    left_pos -= BARRA;
    if( left_pos >= 0 )
      Util.pos(bar, left_pos, distance_from_top.toDouble());
  }
  
  keyRightPress(){
    Element bar = document.query("#bar");
    String lp = bar.style.left;
    lp = lp.replaceAll("px", "");
    double left_pos = Math.parseDouble(lp);

    String tm = bar.style.width;
    tm = tm.replaceAll("px", "");
    double tamanho = Math.parseDouble(tm);

    left_pos += BARRA;
    double largura = width_size - tamanho;
    
    // print( bar.style.left + " tamanho: " + tamanho + " total_width: " + total_width + " largura: " + largura );
    if( left_pos <= largura )
      Util.pos(bar, left_pos, distance_from_top.toDouble());
  }
  
  keyboard(){
    window.on.keyDown.add((KeyboardEvent event) { 
      switch (event.keyCode){
        case 37:
          keyLeftPress();
          break;
        case 39:
          keyRightPress();
          break;
      }
    });
  }
  
  randomVelocity(){
    x = hr ? x+1 : x-1;
    y = vr ? y+1 : y-1;
    // print( "x: " + x + " y: " + y + " hr: " + hr + " vr: " + vr );
    Util.pos(elem, x.toDouble(), y.toDouble());
  }
  
  limitations(){
    var loose = false;
    
    Element bar = document.query("#bar");
    String lp = bar.style.left;
    
    if( x == total_width ){
      muda_direction('horizontal', false);
    } 
    if( x == 0 ){
      muda_direction('horizontal', true);
    } 
    if( y == total_height ){
      String tm = bar.style.width;
      tm = tm.replaceAll("px", "");
      double tamanho = Math.parseDouble(tm);
      
      String bar_left = bar.style.left;
      bar_left = bar_left.replaceAll("px", "");
      double pos_bar_left = Math.parseDouble(bar_left);

      String bar_top = bar.style.top;
      bar_top = bar_top.replaceAll("px", "");
      double pos_bar_top = Math.parseDouble(bar_top);

      String ball_left = elem.style.left;
      ball_left = ball_left.replaceAll("px", "");
      double pos_ball_left = Math.parseDouble(ball_left);

      String ball_top = elem.style.top;
      ball_top = ball_top.replaceAll("px", "");
      double pos_ball_top = Math.parseDouble(ball_top);

      double resultado = (pos_bar_left+tamanho);
      //print( "pos_ball_left: " + pos_ball_left + " pos_bar_left: " + pos_bar_left + " resultado: " + resultado );   
      pos_ball_left += 3;
      resultado += 3;
      //print( "pos_ball_left: " + pos_ball_left + " pos_bar_left: " + pos_bar_left + " resultado: " + resultado );   
      
      if( pos_ball_left >= pos_bar_left && pos_ball_left <= resultado ) {
        loose = false;
        addPoints();
      } else {
        loose=true;
      }
      if( loose )
        youLose();
      else
        muda_direction('vertical', false);
    }
    if( y == 0 ){
      muda_direction('vertical', true);
    }
  }
  
  youLose(){
    window.alert("Game Over! \n HA-HA! ");
    stop = true;
    document.query("#box").innerHTML="";
  }
  
  addPoints(){
    points += 10;
    document.query("#points").innerHTML = points.toString();
  }
  
  zeroPoints(){
    points = 0;
    document.query("#points").innerHTML = "0";
  }
  
  muda_direction(lado, param) {
    //print( last_ball );
    //print( writename.PNGS.length );
    if( lado == 'horizontal' ){
      elem.src = writename.PNGS[last_ball];
      hr = param;
    }
    if( lado == 'vertical' ){
      elem.src = writename.PNGS[last_ball];
      vr = param;
    }
    last_ball++;
    if( last_ball == writename.PNGS.length ){
      last_ball = 0;
    }
    
  }
  
  void write(String message) {
    document.query('#status').innerHTML = message;
  }
  
}

void main() {
  new writename().run();
}
