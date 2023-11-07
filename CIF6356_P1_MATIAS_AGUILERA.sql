--1 Agregar a la tabla PARTIDO la columna estadoPT.
--Dominio= {P (Programado), J (Jugado), S (Suspendido)}

alter table PARTIDO
add estadoPT char(1) null;

--2 Programar un partido en el que se vaya a jugar de local, en cinco días más. Para estadio y
--club considera los valores 12 y 02, respectivamente
--? Ingresar una fila en la tabla EQUIPO para el partido que se acaba de programar

insert into PARTIDO (codigoPT ,fechaPT,codigoES,codigoCL ,situacionPT , duracionPT)
values(2222,'12-11-2023',12,02,'L',null);

--3 Para cada jugador, mostrar la cantidad total de minutos jugados a la fecha.
--Los datos de interés del jugador son: nombre completo, fecha de nacimiento,
--altura y posición.

select pl.codigoFB, nombresFB,apellido1FB,apellido2FB,fechaNacFB,alturaFB,posicionFB, sum(minutosjug) as minutos_jugado
from plantel pl left join equipo eq on pl.codigoFB=eq.codigoFB
group by pl.codigoFB, nombresFB,apellido1FB,apellido2FB,fechaNacFB,alturaFB,posicionFB;


--4 Para los delanteros, mostrar la cantidad de goles y tarjetas amarillas. Los datos de
--interés son: código del jugador, edad y las cantidades solicitadas.

select pl.codigoFB, extract(year from sysdate)- extract (year from fechaNacFB)as edad,count(cantidadGol),count(cantidadTarjAmar)
from plantel pl join equipo eq on pl.codigoFB=eq.codigoFB
where posicionFB='DL'
group by pl.codigoFB, extract(year from sysdate)- extract (year from fechaNacFB);

--5 Para un partido en particular, que se haya jugado de visita, mostrar los datos del
--equipo convocado

select eq.codigoPT,codigoFB,cantidadGol,minutosjug,cantidadTarjAmar,cantidadTarjRoja
from equipo eq join partido pa on eq.codigoPT=pa.codigoPT
where eq.codigoPT= &cod_partido and situacionPT ='V' ;




---6 Para los partidos jugados en un cierto rango de fechas, mostrar la fecha, la
--duración y la cantidad de jugadores de los equipos respectivos

--primer intento
select fechaPT,duracionPT
from partido
where fechaPT between '&fecha_ini' and '&fecha_fin';


--segundo intento
select fechaPT,duracionPT,count(rutFB)as num_jugadores             
from partido pa join equipo eq  on pa.codigoPT=eq.codigoPT
     join equipo eq join plantel pl on eq.codigoFB=pl.codigoFB
where fechaPT between '&fecha_ini' and '&fecha_fin'
group by fechaPT,duracionPT ;



--7 Mostrar la cantidad de jugadores por posición

select posicionFB, count(rutFB)as jugadores
from plantel
group by  posicionFB;


--8 Para los partidos que no registran minutos jugados, mostrar la fecha, estadio y
--situación

select fechaPT, codigoES, situacionPT
from partido
where duracionPT=0;

--no recuerdo si era null o 0


--9 Para los partidos jugados de visita en un mes en particular, mostrar el promedio de
--goles

select  eq.codigoPT,  avg(cantidadGol)
from equipo eq join partido pa on eq.codigoPT = pa.codigoPT 
where situacionPT='V'  and extract(month from fechaPT)='& ingrese_mes' 
group by eq.codigoPT;
