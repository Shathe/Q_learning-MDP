% Script de calculo de camino en un grid basado en utilidades

% Utiliza la funci�n 'iteracion_valor' para calcular las utilidades Q(s,a)
% A partir Q(s,a) calcula la pol�tica global �ptima para todos los estados
% Dibuja el camino en un grid coloreado: inicial (rojo), final (marr�n), obst�culos (azul), libre (verde)
% Itinerario (amarillo-naranja)

coste_vecindad=0;
russel=0;    % selecciona entre escenario Russel o uno general

if russel
 % Definici�n de coordenadas inicial y final ([fila columna] en la matriz) para el grid Russel
    ini=[1 3];
    fin=[10 10];
    
 % Definicion del grid para el grid Russel
 [terminal,obstacle,p,action_cost,discount_factor] = world_russel(fin);
 [filas,colum]=size(obstacle);
 [T,T1]=transicion_russel(filas, colum, p, obstacle, terminal);
else
  % Definici�n de coordenadas inicial y final para un grid general
  ini=[3 3];
  fin=[10 10];
            
  % Definici�n de un grid general grande. Incluye la opci�n de definir el
  % grid correspondiente al 'laberinto'
  [terminal,obstacle,p,action_cost,discount_factor,absorb,wrap_around,noop] = world(fin);
  [filas,colum]=size(obstacle);
  % calcula las matrices de transici�n para el modelo
  % [T,T2,T1] = mi_mk_grid_world(filas, colum, p, obstacle, terminal, absorb, wrap_around, noop);
end

% calcula las matrices de transici�n para el modelo
[T,T2,T1] = mi_mk_grid_world(filas, colum, p, obstacle, terminal, absorb, wrap_around, noop);

% Define n�mero de estados y de acciones
nstates = filas*colum;
nact = 4;

% Define la matriz de recompensas
R = define_R(terminal,obstacle,action_cost,coste_vecindad,nstates,nact);

% Dibuja el escenario con colores como grid
numfigura=1;
dibuja_escenario(filas,colum,ini,fin,obstacle,terminal,numfigura);

% Calcula la Utilidad 'U' y matriz 'Q' de todos los estados, as� como el n�mero
% de iteraciones 'iter' hasta convergencia. En 'util' se devuelve los
% valores de 'V' de todas la iteraciones para poder representarlas
% gr�ficamente
[U, Q,iter,util]= iteracion_valor(T, R, discount_factor);

% Calcula la politica �ptima 'p' y la correspondiente Utilidad 'U' a partir de Q calculado previamente
[p,U]=calcula_p(Q);

% Redimensiona el vector de 'U' como matriz 'Um' con las dimensiones del grid
Um= reshape(U,[filas colum])

% Dibuja con colores las utilidades 'Um' en el grid
numfigura=2;
dibuja_utilidad(filas,colum,ini,fin,obstacle,terminal,Um,numfigura)

% Ordena las parejas 'utilidad_estados' de menor a mayor
estados=[1:nstates]';
utilidad_estados=sortrows([U estados],1);
% Obtiene las parejas estados-pol�tica en 'politica_global'
politica_global=[estados,p];

% Obtiene la pol�tica global en la ret�cula para todos los estados,
% representada como matriz en el grid
pol_global_matriz=flipdim(reshape(politica_global(:,2),[filas colum]),1)

% Calcula la secuencia de acciones y de estados (coordenadas) m�s �til
% desde el estado inicial al final, a partir de la 'politica_global'
% calculada. 
% Utiliza la matriz T1{a} del modelo
calcula_secuencia;
  
% Dibuja el camino a seguir en el grid desde el estado inicial al final, a
% partir de la secuencia calculada
% ngrafica es el numero correspondiente al gr�fico a representar
numfigura=3;
camino = dibuja_camino(filas,colum,ini,fin,obstacle,terminal,secuencia,Um,numfigura)

