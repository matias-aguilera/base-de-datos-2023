--salida estandar 

set serveroutput on 

begin 

dbms_output.put_line ('mi primer bloque anonimo');

end;


--uso de variables

declare
fechaAnt date;
fechaPost date;
begin 
fechaAnt := to_date(sysdate)-1;
dbms_output.put_line('fecha de ayer: '||fechaAnt);

fechaPost:= to_date(sysdate)+1;
dbms_output.put_line('fecga de mañana'||fechaPost);
end;

--uso del select into

declare
feccl date;
gencl char(1);

begin 
select FECHANACIMCL,GENEROCL into feccl, gencl
from cliente
where rutCL='&rut';

dbms_output.put_line('fecha de nacimiento: ' || feccl);
dbms_output.put_line('genero: ' || gencl);
end;