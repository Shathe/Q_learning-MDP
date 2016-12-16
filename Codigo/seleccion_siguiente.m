% selecci�n de siguiente estado seg�n probabilidad de transici�n
% Utiliza un modelo de transici�n T(s,s,s')=P(s'|s,a) para simular el comportamiento y generar
% las muestras
% 'sigu' es una variable de selecci�n
function [utilidad, accion, siguiente] = seleccion_siguiente(epsilon, nact, numEstado, Q, T)

 
n = rand;
if n > epsilon
   % Exploraci�n
   accion =  mod (round(rand()*10) ,nact) + 1;
   utilidad = Q(numEstado, accion);
else
   % Explotaci�n
   [utilidad, accion] = max(Q(numEstado, :));
end

siguiente = find((cumsum(T(numEstado,accion,:)) - rand )>=0, 1) ;
