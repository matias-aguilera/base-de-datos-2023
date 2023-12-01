set serveroutput on

declare

fechaIni date;
fechaFin date;
cantIN inversion.codigoIN%type;
cantA number(20,0) ;
cantB number(20,0) ;
cantC number(20,0) ;
cantD number(20,0) ;
cantE number(20,0) ;
promIN inversion.montoIN%type;
error_fecha exception;

begin 
fechaIni:='$fecha_inicial';
fechaFin:='&fecha_Final';


if (fechaFin < fechaIni)then
    raise error_fecha;
end if;

select count(codigoIN) into cantIn from inversion where fechaIN between fechaIni and fechaFin;

select count(tipoFondoIN) into cantA from inversion where fechaIN between fechaIni and fechaFin and tipoIN='A' and vigente=1;
select count(tipoFondoIN) into cantB from inversion where fechaIN between fechaIni and fechaFin and tipoIN='B' and vigente=1;
select count(tipoFondoIN) into cantC from inversion where fechaIN between fechaIni and fechaFin and tipoIN='C' and vigente=1;
select count(tipoFondoIN) into cantD from inversion where fechaIN between fechaIni and fechaFin and tipoIN='D' and vigente=1;
select count(tipoFondoIN) into cantE from inversion where fechaIN between fechaIni and fechaFin and tipoIN='E' and vigente=1;

select nvl(avg(montoIN),0) into promIN from inversion where fechaIN between fechaIni and fechaFin and estadoIN=1;

dbms_output.put_line('cantidad de inversiones: '||cantIN);
dbms_output.put_line('cantidad de inversiones en fondo A: '||cantA);
dbms_output.put_line('cantidad de inversiones en fondo B: '||cantB);
dbms_output.put_line('cantidad de inversiones en fondo C: '||cantC);
dbms_output.put_line('cantidad de inversiones en fondo D: '||cantD);
dbms_output.put_line('cantidad de inversiones en fondo E: '||cantE);
dbms_output.put_line('cantidad promedio de inversiones vigente : '||promIN);


exception

when error_fecha then dbms_output.put_line('rango de fechas incorrecto');

end;