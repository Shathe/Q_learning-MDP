function [terminal,obstacle,p,action_cost,discount_factor,absorb,wrap_around,noop] = world(fin)
% Define la estructura del grid a utilizar en la b�squeda

r = 20; c = 20; 
p = 0.8;          % probabilidad de realizar correctamente la acci�n nominal
action_cost = 0;   % define la recompensa b�sica
discount_factor = 0.9;  % define el factor de descuento gamma

% Obst�culos
obstacle = zeros(r,c); obstacle(2,2)=1;
obstacle(5,[4:8])=1;
obstacle([10:16],12)=1;

% Define los obst�culos para el laberinto. Se usa s�lo para este escenario,
% para grid sencillo no se utiliza
% Script para definir laberinto: 'obstaculos_laberinto.m' 
obstaculos_laberinto;
% Objetivo
terminal = zeros(r,c); terminal(fin(1),fin(2))=1; 

% par�metros de definici�n de vecindad del grid (no tocar)
absorb = 0;
wrap_around = 0;
noop = 0;

end