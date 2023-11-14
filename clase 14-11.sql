--mostrar el numero , cupo utilizado y estado de las tarjetas abiertas


set SERVEROUTPUT on

declare
numTJ number(8,0);
cupoUT number(7,0);
esTJ char (1);

begin
select numeroTJ,(cupoTJ-cupoDispTJ),estadoTJ into numTJ, cupoUT,esTJ
from tarjeta
where estadoTJ='C';

exception
when too_many_rows then dbms_output.put_line('la consulta devuelve mas de una fila');

end;


--mostrar el rut, fecha de nacimiento, tipo de un clientes en particulas y los datos de una de sus tarjetas

declare

rut cliente.rutCL%type;
fecha date;
tipo tarjeta%rowtype;
filaTJ tarjeta%rowtype;

begin

select cl.rutCL, fechaNacimCL,tipoCL, tj.* into rut, fecha, tipo, filaTJ
from cliente cl  join TARJETA tj  on cl.rutCL= tj.rutCL
where cl.rutCL='&rut_cliente' and numeroTJ=&numero_tarjeta;

dbms_output.put_line('rut cliente'||rut);
dbms_output.put_line('fecha nacimiento'||fecha);
dbms_output.put_line('tipo cliente'||tipo);
dbms_output.put_line('numero de tarjeta'||filaTJ.numeroTJ);
dbms_output.put_line('cupo disponible de tarjeta'||filaTJ.cupoDispTJ);
dbms_output.put_line('estado de tarjeta'||filaTJ.estadoTJ);

end;






declare

rut cliente.rutCL%type;
fecha date;
tipo tarjeta%rowtype;
filaTJ tarjeta%rowtype;
existe number(1,0);
nroTJ tarjeta.numeroTJ%type;

rut_no_existe exception;
tarjeta_no_existe exception;
begin
rut:='&rut_cliente';

select count(rutCL) into existe from cliente where rutCL=rut;

if(existe=0) then
    raise rut_no_existe;
else     

    select rutCL, fechaNacimCL,tipoCL into rut, fecha, tipo
    from cliente   
    where rutCL=rut; 

    nroTJ:=&numero_tarjeta;
    
    select count(numeroTJ) into existe from tarjeta where numeroTJ=nroTJ and rutCL=rut;
    
    if(existe=0) then
        raise tarjeta_no_existe;
    else

        select tarjeta.* into filatJ 
        from tarjeta
        where  numeroTJ=nroTJ;
 
            dbms_output.put_line('rut cliente'||rut);
            dbms_output.put_line('fecha nacimiento'||fecha);
            dbms_output.put_line('tipo cliente'||tipo);
            dbms_output.put_line('numero de tarjeta'||filaTJ.numeroTJ);
            dbms_output.put_line('cupo disponible de tarjeta'||filaTJ.cupoDispTJ);
            dbms_output.put_line('estado de tarjeta'||filaTJ.estadoTJ);
     end if;
   end if; 


exception

when rut_no_existe then dbms_output.put_line ('dato ingresado no de encuentra en la bd');
when tarjeta_no_existe then dbms_output.put_line ('tarjeta ingresada no se encuentra en la bd');

end;










--ingresar un/una cliente mayor de edad que no exista en la bd


set SERVEROUTPUT on

declare
rut cliente.rutCL%type;
existe number(1,0);
fecNac date;
cliente_existe exception;
begin
rut:='&rut_cliente';

select count(rutCL) into existe from cliente where rutCL=rut;

if(existe=1)then
    raise cliente_existe;
else
    fecNac:='&fecha_nacimiento';
    if(extract(year from sysdate)-extract(year from fecNac)<18) then
        raise menor_edad;
    end if;
end if;




exception
when cliente_existe then dbms_output.put_line ('cliente ya existe');

end;









