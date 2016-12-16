% Aprendizaje Q-learning para grid

trials=1000;  % número de episodios  
nbucles=50;   % numero de repeticiones
epsilon=0.92; % exploracion-explotacion epsilon-greedy
rec=-0.04;   % recompensa general
gamma=0.95;   % factor de descuento

bucle = 1;
% Inicialización de variables
 ini=[19 14];
%  ini=[2 14];
%  fin=[14 19];
%ini=[14 2];
 fin=[1 16];



% Inicialización de variables
%%%%%%%%%%%%%%%%%%%%% COMPLETAR %%%%%%%%%%%%%%%%%
coste_vecindad=0;
[terminal,obstacle,p,action_cost,discount_factor,absorb,wrap_around,noop] = world(fin);
[filas,colum]=size(obstacle);
[T,T2,T1] = mi_mk_grid_world(filas, colum, p, obstacle, terminal, absorb, wrap_around, noop);

% Define número de estados y de acciones
nstates = filas*colum;
nact = 4;
frecuencias = zeros(nstates,1);

% Dibuja el escenario con colores como grid
numfigura=1;
dibuja_escenario(filas,colum,ini,fin,obstacle,terminal,numfigura);

util=[];
polit=[];
  while bucle<=nbucles   % repeticiones para promediar (opcional)
    % Defines R y Q inicial
    R = define_R(terminal,obstacle,action_cost,coste_vecindad,nstates,nact);
    R = R + rec;
    Q = R;

    % Calcula la politica óptima 'p' y la correspondiente Utilidad 'U' a partir de Q calculado previamente
    trial = 0;
    while trial~=trials    % episodios
       iteracion = 1;

       % Selección aleatoria del estado inicial s
       %%%%%%%%%%%%%%%%%%%%% COMPLETAR %%%%%%%%%%%%%%%%%
       fila = round(rand()*(filas-1)) + 1;
       columna = round(rand()*(colum-1)) + 1;
       estado = [ fila columna ];
       while  obstacle(estado(1), estado(2))
             fila = round(rand()*(filas-1)) + 1;
             columna = round(rand()*(colum-1)) + 1;
             estado = [ fila columna ];
       end   
       numEstado = (estado(2) - 1) * filas + estado(1);
       numEstadofin = (fin(2) - 1) * filas + fin(1);
       
       % Mientras no se llegue al estado final       
       while  numEstado ~= numEstadofin
           % Selección de siguiente estado según probabilidad de transición
           % Utiliza un modelo de transición T(s,s,s')=P(s'|s,a) para simular el comportamiento y generar
           % las muestras
           %%%%%%%%%%%%%%%%%%%%% COMPLETAR %%%%%%%%%%%%%%%%%
          [utilidad, accion, siguiente] = seleccion_siguiente(epsilon, nact, numEstado, Q, T);
           % calculo de alfa dependiente del numero de iteraciones y frecuencia
           frecuencias(numEstado) =  frecuencias(numEstado) + 1;
           alfa = frecuencias(numEstado) / (frecuencias(numEstado) + iteracion);
           
           %Calculo de Q, actualizacion
           Q(numEstado,accion) = Q(numEstado,accion) + alfa *(R(numEstado, accion) + gamma  * max(Q(siguiente,:)) -  Q(numEstado, accion));
           numEstado = siguiente;
         
           iteracion = iteracion + 1;
       end
       
       trial = trial + 1;
    end 

     % Obtiene las utilidades y la política óptima a partir de Q
     % Acumula U=Vmax de cada bucle para representación
     % Acumula políticas de cada bucle para promedio
     %%%%%%%%%%%%%%%%%%%%% COMPLETAR %%%%%%%%%%%%%%%%%
    U = max(Q, [], 2); 
    util = [util, U];
   [p,U]=calcula_p(Q);
    polit = [polit p];
    bucle=bucle+1;
end 
  %calculo de la media de Q de cada buble
%Aqui sacar las utilidades medias y las politicas mas repetidas
U = mean(util, 2);   
p = mode(polit, 2);
% Redimensiona el vector de 'U' como matriz 'Um' con las dimensiones del grid
Um= reshape(U,[filas colum]);

% Dibuja con colores las utilidades 'Um' en el grid
numfigura=2;
dibuja_utilidad(filas,colum,ini,fin,obstacle,terminal,Um,numfigura)

% Ordena las parejas 'utilidad_estados' de menor a mayor
estados=[1:nstates]';
utilidad_estados=sortrows([U estados],1);
% Obtiene las parejas estados-política en 'politica_global'
politica_global=[estados,p];

% Obtiene la política global en la retícula para todos los estados,
% representada como matriz en el grid
pol_global_matriz=flipdim(reshape(politica_global(:,2),[filas colum]),1)
figure(4)

for i=1:nbucles
    plot(1:nbucles, util(55, :), 1:nbucles, util(87, :), 1:nbucles, util(124, :), 1:nbucles, util(172, :), 1:nbucles, util(192, :));
end
% Calcula la secuencia de acciones y de estados (coordenadas) más útil
% desde el estado inicial al final, a partir de la 'politica_global'
% calculada. 
% Utiliza la matriz T1{a} del modelo
calcula_secuencia;
  
% Dibuja el camino a seguir en el grid desde el estado inicial al final, a
% partir de la secuencia calculada
% ngrafica es el numero correspondiente al gráfico a representar
numfigura=3;
camino = dibuja_camino(filas,colum,ini,fin,obstacle,terminal,secuencia,Um,numfigura)
  
  