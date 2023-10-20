--  TARJETA.cupoTJ
ALTER TABLE TARJETA
ADD CONSTRAINT CK_cupoTJ CHECK(cupoTJ >= 100000 AND cupoTJ <= 3000000);

ALTER TABLE TARJETA
ADD CONSTRAINT CK_cupoTJ CHECK(cupoTJ BETWEEN 100000 AND 3000000);

--  TARJETA.cupoDispTJ
ALTER TABLE TARJETA
ADD CONSTRAINT CK_cupoDispTJ CHECK (cupoDispTJ BETWEEN 0 AND 3000000);

--  TARJETA.tipoTJ
ALTER TABLE TARJETA
ADD CONSTRAINT CK_tipoTJ CHECK (tipoTJ IN ('VISA','MASTERCARD'));

--  TARJETA.estadoTJ
ALTER TABLE TARJETA
ADD CONSTRAINT CK_estadoTJ CHECK (estadoTJ IN ('A','B','C'));

ALTER TABLE TARJETA
MODIFY estadoTJ DEFAULT 'A';

--  ELIMINACION DE UNA RESTRICCION
ALTER TABLE TARJETA
DROP CONSTRAINT CK_cupoTJ;


--  INSTRUCCIONES DML
--  OPERACIONES DE ACTUALIZACION

--  INSERT

INSERT INTO CLIENTE (rutCL, apellido1CL, apellido2CL, nombreCL, fechaNacimCL, generoCL, codigoCM, tipoCL)
VALUES('200466659','CEPEDA','ZAMORANO','NICOLAS','29-10-1998','M',06101,'ES');

INSERT INTO CLIENTE
VALUES('209558122','ALFARO','HOLM','CLAUDIO','22-01-2002','M',05304,'DC');


INSERT INTO TARJETA (numeroTJ, rutCL, fechaApertTJ, cupoTJ, cupoDispTJ, tipoTJ, fechaCierreTJ, estadoTJ)
VALUES(11111111,'200466659','16-09-2023',3000000,3000000,'VISA',NULL,'A');

INSERT INTO TARJETA (numeroTJ, rutCL, fechaApertTJ, cupoTJ, cupoDispTJ, tipoTJ, estadoTJ)
VALUES(22222222,'209558122',TO_DATE(SYSDATE),100000,100000,'MASTERCARD','A');

INSERT INTO TARJETA (numeroTJ, rutCL, fechaApertTJ, cupoTJ, cupoDispTJ, tipoTJ)
VALUES(33333333,'209558122',TO_DATE(SYSDATE),1000000,1000000,'MASTERCARD');


--  DELETE

DELETE FROM TARJETA;
DELETE TARJETA;



--update
--para el primer cliente ingresado, modifica el valor de la columna tipoCL a 'TI'

update CLIENTE set tipoCL='TI' where rutCL='200466659';

--para las tarjetas que no han sido utilizadas aumertar el cupo en 10%

update TARJETA set cupoTJ= cupoTJ + cupoDispTJ + cupoDispTJ * 0.1 , cupoDispTJ = cupoTJ
where cupoDispTJ = cupoTJ;


--cierra toda las tarjetas
update TARJETA set fechaCierreTJ = to_date(sysdate), estadoTJ='C' 
where estadoTJ='A';


---tabla afp
create table AFP(
codigoAFP    number (4,0)   not null,
nombreAFP    varchar2(13)     not null,
comisionAFP  number (3,2)    not null
);

alter table AFP
add constraint pK_AFP primary key(codigoAFP);



--mostrar todas las afp
select * from AFP;

--mostrar afp culla comision es inferior al 1%
select * from AFP where comisionAFP < 1.00;


