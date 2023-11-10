--  SALIDA ESTÁNDAR

SET SERVEROUTPUT ON

BEGIN
DBMS_OUTPUT.PUT_LINE('Mi primer bloque anónimo');
END;


--  USO DE VARIABLES

DECLARE
fechaAnt  DATE;
fechaPost DATE;
BEGIN
fechaAnt := TO_DATE(SYSDATE) - 1;
DBMS_OUTPUT.PUT_LINE('Fecha de ayer: '||fechaAnt);

fechaPost := TO_DATE(SYSDATE) + 1;
DBMS_OUTPUT.PUT_LINE('Fecha de mañana: '||fechaPost);
END;

--  USO DEL SELECT INTO
--  caso 1: el bueno 
DECLARE
fecCL   DATE;
genCL   CHAR(1);
BEGIN
SELECT fechaNacimCL, generoCL INTO fecCL, genCL
FROM CLIENTE
WHERE rutCL = '&RUT';

DBMS_OUTPUT.PUT_LINE('Fecha de nacimiento: '||fecCL);
DBMS_OUTPUT.PUT_LINE('Género: '||genCL);

exception
when NO_DATA_FOUND then DBMS_OUTPUT.PUT_LINE('rut no encontrado');

END;

--caso 3: el bueno


DECLARE
fecTJ   DATE;
estTJ   CHAR(1);
BEGIN
SELECT fechaApertTJ, estadoTJ INTO fecTJ, estTJ
FROM tarjeta
WHERE rutCL = '&RUT';

DBMS_OUTPUT.PUT_LINE('Fecha de apertura: '||fectj);
DBMS_OUTPUT.PUT_LINE('estado: '||estTJ);

exception
when NO_DATA_FOUND then DBMS_OUTPUT.PUT_LINE('rut no tiene tarjetas asociadas');
when TOO_MANY_ROWS then DBMS_OUTPUT.PUT_LINE('rut  tiene mas de 1 tarjetas asociada');
END;

--ejemplo declaracion de variables


SET SERVEROUTPUT ON


declare
genero char(1):='M';
suma number(3,0) :=0;
iva constant number (2,0):=19;
begin 
DBMS_OUTPUT.PUT_LINE('genero'||genero);
suma:= suma+10;
DBMS_OUTPUT.PUT_LINE ('suma'||suma);

end;



--mostrar la fecha de otorgamiento y el cupo disponible de una tarjeta en particular

DECLARE
fecTJ   DATE;
cupoDisp number (7,0);
BEGIN
SELECT fechaApertTJ, CUPODISPTJ INTO fecTJ, cupoDisp
FROM tarjeta
WHERE NUMEROTJ = &numeroTJ;

DBMS_OUTPUT.PUT_LINE('Fecha de apertura: '||fectj);
DBMS_OUTPUT.PUT_LINE('cupo: '||cupoDisp);

exception
when NO_DATA_FOUND then DBMS_OUTPUT.PUT_LINE('tarjeta no exixte');
END;

















