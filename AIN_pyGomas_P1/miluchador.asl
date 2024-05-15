//MiLuchador 
//Luchador Alberto Valverde Galdón

//Creencias Iniciales

rombo([20,0,130],[130,0,240],[240,0,130],[130,0,20]).

+flag(F): team(200)
  <-
  !calculoPosicionRomboCercana;
  ?dist1(D1);
  ?dist2(D2);
  ?dist3(D3);
  ?dist4(D4);
  .min([D1,D2,D3,D4], Minimo);

  ?rombo(Rumbos);
  .length(Rumbos,Long);
  +total_control_points(Long);
  +patrolling;

  +miradas(0);
  +nofijado;

  ?health(H);
  +vidaIni(H);
  ?ammo(A);
  +balasIni(A);
  !vida;

  if(Minimo == D1){
    +patroll_point(0);
    .goto([20,0,130]);
  };

  if(Minimo == D2){
    +patroll_point(1);
    .goto([130,0,240]);
  };

  if(Minimo == D3){
    +patroll_point(2);
    .goto([240,0,130]);
  };

  if(Minimo == D4){
    +patroll_point(3);
    .goto([130,0,20]);
  };

  +mirando([[0,0,0],[250,0,0],[250,0,250],[0,0,250]]);
  +estado(0);
  +estado2(0).


+!calculoPosicionRomboCercana 
<-
  ?position([X,Y,Z]);
  +dist1(((X-20)**2+(Z-130)**2)**(0.5));
  +dist2(((X-130)**2+(Z-240)**2)**(0.5));
  +dist3(((X-240)**2+(Z-130)**2)**(0.5));
  +dist4(((X-130)**2+(Z-20)**2)**(0.5)).

+!vida: health(H) & ammo(AA) & vidaIni(X) & (H < X) & (H > 65) 
<- 
  .stop;
  +medisparan; 
  -+miradas(0);
  !agirar; 
  -+vidaIni(H); 
  ?patroll_point(P);
  ?rombo(Rumbos);
  .nth(P,Rumbos,A);
  .goto(A);
  !!vida.

+!vida: health(H) & ammo(AA) & vidaIni(X) & (H <= 65 | AA ==0)
<- 
  +yendocentro;
  .print("Yendo al centro"); 
  .goto([125,0,125]).

+!vida: health(H) & ammo(AA) 
<-
  !!vida.

+target_reached(T): patrolling & team(200) & aporpaquete & health(H) & ammo(A) 
<-
  .print("Paquete cogido");
  -aporpaquete;
  +nofijado;
  if(A>=80 & H>=80){
    .print("Vuelvo a casa"); 
    -yendocentro;
    ?patroll_point(P); 
    -+patroll_point(P+1);
    ?health(H2);
    -+vidaIni(H2); 
    !!vida;
  } 
  else{
    .print("buscando paquetes");
    +buscando;
    .wait(500);
    .turn(1.5708);
    .wait(500);
    .turn(1.5708);
    .wait(500);
    .turn(1.5708);
  };
  -target_reached(T).

+target_reached(T): patrolling & team(200) & yendocentro 
<-
  .print("He llegado al centro, me quedo quieto en pos: ", T); 
  -yendocentro;
  .print("buscando paquetes");
  +buscando;
  .wait(500);
  .turn(1.5708);
  .wait(500);
  .turn(1.5708);
  .wait(500);
  .turn(1.5708);
  +centroconseguido; 
  -target_reached(T).

+target_reached(T): patrolling & team(200) 
<-
  .print("Me quedo quieto en pos: ", T);
  !agirar; 
  -+miradas(0);
  ?patroll_point(P); 
  -+patroll_point(P+1);
  -target_reached(T).

+patroll_point(P): total_control_points(T) & P<T 
<-
  ?rombo(Rumbos);
  .nth(P,Rumbos,A);
  .goto(A).

+patroll_point(P): total_control_points(T) & P==T
<-
  -patroll_point(P);
  +patroll_point(0).

+packs_in_fov(ID,Type,Angle,Distance,Health,Position): Type < 1003 & fijado
<-
  -fijado;
  .print("Estoy yendo a por un paquete").

+packs_in_fov(ID,Type,Angle,Distance,Health,Position): Type < 1003 & health(H) & ammo(A) & (A \== 100 | H \== 100) & buscando & nofijado
<-
  .print("Otro paquete visto");
  +aporpaquete;
  -nofijado;
  +fijado;
  -buscando;
  .stop;
  .goto(Position).

+packs_in_fov(ID,Type,Angle,Distance,Health,Position): Type < 1003 & yendocentro & nofijado
<-
  .print("Paquete visto");
  +aporpaquete;
  -nofijado;
  +fijado;
  -buscando;
  .stop;
  .goto(Position).

+friends_in_fov(ID,Type,Angle,Distance,Health,Position)
<-
  -+amenazavista;
  ?health(H);
  ?ammo(B);
  .look_at(Position);
  -+posicionenemigo(Position);
  .print("Disparo");
  if(Health > H ){
    if(B >= 15 & H < 40){
      .shoot(15,Position);
    }
    else{
      if(B >= 10){
        .shoot(10,Position);
      };
    };
  }
  else{
    .shoot(5,Position); 
  };
  if(Health==0){
    -amenazavista; 
  };
  ?ammo(BB); 
  -+balasIni(BB).

+!agirar: estado(E) & E<4
<-
  ?miradas(X);
  if(X <=4){
    ?mirando(L);
    .nth(E, L, P);
    .look_at(P);
    .wait(500); -estado(_);
    +estado(E+1);
    -+miradas(X+1);
    !agirar;
  }.

+!agirar: estado(E) & E=4
<-
  ?miradas(X);
  if(X <=4){
    -estado(_);
    +estado(0);
    !agirar;
  }.