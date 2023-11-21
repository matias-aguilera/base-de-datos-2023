---cursores

---mostrar rut, apellido1, genero, tipo de los  clientes de los adultos mayores

set serveroutput on

declare

rut cliente.rutCL%type;
ape1 cliente.apellido1CL%type;
gen cliente.generoCL%type;
tipo cliente.tipoCL%type;


cursor adultMayor is    select rutCL, apellido1CL,generoCL, tipoCL
                        from cliente
                        where extract(year from sysdate)-extract(year from fechaNacimCL)<60;

begin

open adultMayor;

fetch adultMayor into rut,ape1,gen,tipo;
if (adultMayor%rowcount>0)then
    while(adultMayor%found)loop
    
    dbms_output.put_line('rut: '|| rut);
    dbms_output.put_line('apellido 1: '|| ape1);
    dbms_output.put_line('genero: '|| gen);
    dbms_output.put_line('tipo cliente: '|| tipo);
    
    
    fetch adultMayor into rut,ape1,gen,tipo;
    end loop;
else
dbms_output.put_line('no se encontraron clientes adultos mayores');
end if;
close adultMayor;

end;




--mostrar las tarjetas correspondientes a un cliente en particular
--los datos de interes son: nombre cliente, genero, tipo, numero de tarjeta, cupo disponible y estado tarjeta

declare
rut cliente.rutCL%type;
nombre cliente.nombreCL%type;
gen cliente.generoCL%type;
tipo  cliente.tipoCL%type;
numTJ  tarjeta.numeroTJ%type;
cdisp tarjeta.cupoDispTJ%type;
estTJ  tarjeta.estadoTJ%type;
existe number(1,0);




cursor TJcliente is   select nombreCL, generoCL,tipoCL,numeroTJ,cupodispTJ,estadoTJ
                    from cliente cl join tarjeta tj on cl.rutCL=tj.rutCL
                    where cl.rutCL=rut;
                    
                    
rut_malo exception;

begin 
rut:='&rut_cliente';
select count(rutCL) into existe from cliente where rutCL=rut;
if (existe=0) then
raise rut_malo;
else

    open TJcliente;
    fetch TJcliente into nombre,gen,tipo,numTJ,cdisp,estTJ;
    if(TJcliente%rowcount>0)then
         dbms_output.put_line('dato cliente: ');   
        dbms_output.put_line('nombre: '|| nombre);
        dbms_output.put_line('genero: '|| gen);
        dbms_output.put_line('tipo : '|| tipo);
        while(TJcliente%found)loop
        dbms_output.put_line('datos tarjeta');
        dbms_output.put_line('numero tarjeta: '|| numTJ);
        dbms_output.put_line('cupo disponible: '|| cdisp);
        dbms_output.put_line('estado tarjeta: '|| estTJ);
        fetch TJcliente into nombre,gen,tipo,numTJ,cdisp,estTJ;
        end loop;
    else
    dbms_output.put_line('no se encontraron tarjetas al rut asociado');
    end if;
    close TJcliente;
end if;    
exception
when rut_malo then  dbms_output.put_line('rut no encontrado');

end;


----implementar bloque anonimo que muestre las tarjetas con deuda que se encuentran bloqueadas
---los datos de interes son: numeros de tarjeta, tipo, fecha de apertura y monto de la deuda


declare

numtj tarjeta.numeroTJ%type;
tipo tarjeta.tipoTJ%type;
fecap tarjeta.fechaapertTJ%type;
deuda tarjeta.cupoTJ%type;


cursor tjdeuda is   select numeroTJ,tipoTJ,fechaApertTJ, (cupoTJ-cupodispTJ)
                    from tarjeta
                    where estadoTJ='B' and cupodispTJ < cupoTJ;



begin

open tjdeuda;
fetch tjdeuda into numtj,tipo,fecap,deuda;
if(tjdeuda%rowcount>0)then
    while(tjdeuda%found)loop
    dbms_output.put_line('numero: '||numtj);
    dbms_output.put_line('tipo: '||tipo);
    dbms_output.put_line('fecha de apertura: '||fecap);
    dbms_output.put_line('deuda:$ '||deuda);
      dbms_output.put_line('-------------');
    fetch tjdeuda into numtj,tipo,fecap,deuda;
    
    end loop;

else
  dbms_output.put_line('no se encontraron tarjetas bloqueadas con deuda ');
end if;

close tjdeuda;
end;




--para los partidos que se jugaron de visita, mostrar numero de partido, fecha,minutosjugados
--y el total de goles efectuados y quienes integraron el equipo respectivo.
--los datos del equipo son: nombre completo, posicion de juego, cantidad de goles y tarjetas amarillas


declare
begin
end;

select CODIGOPT,FECHAPT,DURACIONPT, sum(CANTIDADGOL), 




