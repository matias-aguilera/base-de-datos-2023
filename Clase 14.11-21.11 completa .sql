--  Mostrar el número, cupo utilizado y estado de las tarjetas abiertas

SET SERVEROUTPUT ON

DECLARE
numTJ   NUMBER(8,0);
cupoUT  NUMBER(7,0);
estTJ   CHAR(1);
BEGIN

SELECT numeroTJ, (cupoTJ - cupoDispTJ), estadoTJ INTO numTJ, cupoUT, estTJ
FROM TARJETA
WHERE estadoTJ = 'A';

EXCEPTION
WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('La consulta devuelve más de una fila');
END;


--  Mostrar el rut, fecha de nacimiento, tipo de un cliente en particular y los datos de una de sus tarjetas

-- OJO, tarjeta.* se comporta igual que en los group by, no los quiere
DECLARE
rut     CLIENTE.rutCL%TYPE;
fecha   DATE;
tipo    CLIENTE.tipoCL%TYPE;
filaTJ  TARJETA%ROWTYPE;

BEGIN
SELECT CLIENTE.rutcL, fechaNacimCL, tipoCL, TARJETA.* INTO rut, fecha, tipo, filaTJ
FROM CLIENTE JOIN TARJETA ON CLIENTE.rutCL = TARJETA.rutCL
WHERE CLIENTE.rutCL = '&RUT_CLIENTE' AND numeroTJ = &NUMERO_TARJ;

DBMS_OUTPUT.PUT_LINE('Rut del cliente: '||rut);
DBMS_OUTPUT.PUT_LINE('Fecha de nacimiento: '||fecha);
DBMS_OUTPUT.PUT_LINE('Tipo de cliente: '||tipo);

DBMS_OUTPUT.PUT_LINE('Número de tarjeta: '||filaTJ.numeroTJ);
DBMS_OUTPUT.PUT_LINE('Cupo disponible: '||filaTJ.cupoDispTJ);
DBMS_OUTPUT.PUT_LINE('Estado: '||filaTJ.estadoTJ);

END;

-- Versión 1.0
DECLARE
rut     CLIENTE.rutCL%TYPE;
fecha   DATE;
tipo    CLIENTE.tipoCL%TYPE;
filaTJ  TARJETA%ROWTYPE;

BEGIN
rut := '&RUT_CLIENTE';

SELECT CLIENTE.rutcL, fechaNacimCL, tipoCL INTO rut, fecha, tipo
FROM CLIENTE
WHERE CLIENTE.rutCL = rut;

SELECT TARJETA.* INTO filaTJ
FROM TARJETA
WHERE numeroTJ = &NUMERO_TARJ AND rutCL = rut;

DBMS_OUTPUT.PUT_LINE('Rut del cliente: '||rut);
DBMS_OUTPUT.PUT_LINE('Fecha de nacimiento: '||fecha);
DBMS_OUTPUT.PUT_LINE('Tipo de cliente: '||tipo);

DBMS_OUTPUT.PUT_LINE('Número de tarjeta: '||filaTJ.numeroTJ);
DBMS_OUTPUT.PUT_LINE('Cupo disponible: '||filaTJ.cupoDispTJ);
DBMS_OUTPUT.PUT_LINE('Estado: '||filaTJ.estadoTJ);

END;

-- Versión 2.0 (buena)
DECLARE
rut     CLIENTE.rutCL%TYPE;
fecha   DATE;
tipo    CLIENTE.tipoCL%TYPE;
filaTJ  TARJETA%ROWTYPE;

BEGIN
rut := '&RUT_CLIENTE';

SELECT CLIENTE.rutcL, fechaNacimCL, tipoCL INTO rut, fecha, tipo
FROM CLIENTE
WHERE CLIENTE.rutCL = rut;

SELECT TARJETA.* INTO filaTJ
FROM TARJETA
WHERE numeroTJ = &NUMERO_TARJ AND rutCL = rut;

DBMS_OUTPUT.PUT_LINE('Rut del cliente: '||rut);
DBMS_OUTPUT.PUT_LINE('Fecha de nacimiento: '||fecha);
DBMS_OUTPUT.PUT_LINE('Tipo de cliente: '||tipo);

DBMS_OUTPUT.PUT_LINE('Número de tarjeta: '||filaTJ.numeroTJ);
DBMS_OUTPUT.PUT_LINE('Cupo disponible: '||filaTJ.cupoDispTJ);
DBMS_OUTPUT.PUT_LINE('Estado: '||filaTJ.estadoTJ);

EXCEPTION
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Dato ingresado incorrecto (rut o número de tarjeta)');
END;


-- Versión 3.0 (muy buena) - Aplicación de exepciones definidas por el usuario
DECLARE
rut     CLIENTE.rutCL%TYPE;
fecha   DATE;
tipo    CLIENTE.tipoCL%TYPE;
filaTJ  TARJETA%ROWTYPE;
existe  NUMBER(1,0);
nroTJ   TARJETA.numeroTJ%TYPE;

RUT_NOEXISTE      EXCEPTION;
TARJETA_NOEXISTE EXCEPTION;
BEGIN
rut := '&RUT_CLIENTE';

SELECT COUNT(rutCL) INTO existe FROM CLIENTE WHERE rutCL = rut;

IF(existe = 0)THEN
  RAISE RUT_NOEXISTE;
ELSE
  SELECT CLIENTE.rutcL, fechaNacimCL, tipoCL INTO rut, fecha, tipo
  FROM CLIENTE
  WHERE CLIENTE.rutCL = rut;

  nroTJ := &NUMERO_TARJ;

  SELECT COUNT(numeroTJ) INTO existe FROM TARJETA WHERE numeroTJ = nroTJ AND rutCL = rut;
  
  IF(existe = 0) THEN
    RAISE TARJETA_NOEXISTE;
  ELSE
    SELECT TARJETA.* INTO filaTJ
    FROM TARJETA
    WHERE numeroTJ = nroTJ;
    
    DBMS_OUTPUT.PUT_LINE('Rut del cliente: '||rut);
    DBMS_OUTPUT.PUT_LINE('Fecha de nacimiento: '||fecha);
    DBMS_OUTPUT.PUT_LINE('Tipo de cliente: '||tipo);
    
    DBMS_OUTPUT.PUT_LINE('Número de tarjeta: '||filaTJ.numeroTJ);
    DBMS_OUTPUT.PUT_LINE('Cupo disponible: '||filaTJ.cupoDispTJ);
    DBMS_OUTPUT.PUT_LINE('Estado: '||filaTJ.estadoTJ);
  END IF;
END IF;

EXCEPTION
WHEN RUT_NOEXISTE THEN DBMS_OUTPUT.PUT_LINE('Rut ingresado no se encuentra en la base de datos');
WHEN TARJETA_NOEXISTE THEN DBMS_OUTPUT.PUT_LINE('Tarjeta ingresada no se encuentra en la base de datos');
END;

--  Ingresar un/una cliente mayor de edad que no exista en la base de datos

SET SERVEROUTPUT ON

DECLARE
rut     CLIENTE.rutCL%TYPE;
existe  NUMBER(1,0);
fecnac  DATE;
nom cliente.nombreCL%type;
ape1  cliente.apellido1CL%type;
ape2  cliente.apellido2CL%type;
gen   cliente.generoCL%type;
codcom cliente.codigoCM%type;
tipo cliente.tipoCL%type;

CLIENTE_EXISTE  EXCEPTION;
MENOR_EDAD      EXCEPTION;
error_genero   exception;
error_comuna exception;
error_tipo exception;
BEGIN
rut := '&RUT_CLIENTE';

SELECT COUNT(rutCL) INTO existe FROM CLIENTE WHERE rutCL = rut;

IF(existe = 1)THEN
  RAISE CLIENTE_EXISTE;
ELSE
  fecNac := '&FECHA_NACIMIENTO';
  
  IF(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM fecNac) < 18)THEN
    RAISE MENOR_EDAD;
    
    else
       nom:='&nombre' ;
       ape1:='&apellido1' ;
       ape2:='&apellido2' ;
       
       gen:='&genero';
       if (gen not in ('F','M','O')) then
       raise error_genero;
       else
        codcom:=&codigo_comuna;
        
        select count(codigoCM) into existe from comuna
        where codigoCM=codcom;
        
        if existe = 0 then 
        raise error_comuna; 
        else
        
        tipo:= '&tipo_cliente';
        
        if tipo not in ('TD','TI','DC','PS','MT','ES') then
            raise error_tipo;
        else 
            --aqui esta todo ok
             insert into cliente
             values (rut,ape1,ape2,nom,fecnac,gen,codcom,tipo);
                    DBMS_OUTPUT.PUT_LINE('todo salio bien');
             
        end if;
        
         end if;
    end if;
    
  END IF;
    
END IF;
EXCEPTION
WHEN CLIENTE_EXISTE THEN DBMS_OUTPUT.PUT_LINE('Cliente ya se encuentra ingresado');
WHEN MENOR_EDAD THEN DBMS_OUTPUT.PUT_LINE('La persona es menor de edad, no puede ser cliente');
when error_genero then DBMS_OUTPUT.PUT_LINE('genero ingresado incorrecto');
when error_comuna then DBMS_OUTPUT.PUT_LINE('comuna ingresada incorrecta');
when error_tipo then DBMS_OUTPUT.PUT_LINE('tipo de cliente incorrecto');
END;



















