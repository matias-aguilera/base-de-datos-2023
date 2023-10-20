CREATE TABLE PERSONA
(rutPR          CHAR(9)     NOT NULL,
 fechaNacimPR   DATE        NOT NULL,
 generoPR       CHAR(1)     NOT NULL,
 codigoCMResid  NUMBER(5,0) NOT NULL,
 codigoNC       NUMBER(3,0) NOT NULL
);

ALTER TABLE PERSONA
ADD Detencion CHAR(1) NULL; -- Se tuvo que considerar NULL debido a que la tabla tenía valores

ALTER TABLE PERSONA
MODIFY Detencion NOT NULL;

ALTER TABLE PERSONA
DROP COLUMN Detencion;

DROP TABLE PERSONA;


--  BASE DE DATOS: TARJETA

CREATE TABLE CLIENTE
(rutCL        CHAR(9)       NOT NULL,
 apellido1CL  VARCHAR2(20)  NOT NULL,
 apellido2CL  VARCHAR2(20)  NOT NULL,
 nombreCL     VARCHAR2(20)  NOT NULL,
 fechaNacimCL DATE          NOT NULL,
 generoCL     CHAR(1)       NOT NULL,
 codigoCM     NUMBER(5,0)   NOT NULL,
 tipoCL       CHAR(2)       NOT NULL
);

CREATE TABLE TARJETA
(numeroTJ       NUMBER(8,0)   NOT NULL,
 rutCL          CHAR(9)       NOT NULL,
 fechaApertTJ   DATE          NOT NULL,
 cupoTJ         NUMBER(7,0)   NOT NULL,
 cupoDispTJ     NUMBER(7,0)   NOT NULL,
 tipoTJ         CHAR(10)      NOT NULL,
 fechaCierreTJ  DATE          NULL,
 estadoTJ       CHAR(1)       NOT NULL
);
 

--  INTEGRIDAD DE ENTIDAD

ALTER TABLE CLIENTE
ADD CONSTRAINT PK_CLIENTE PRIMARY KEY(rutCL);

ALTER TABLE TARJETA
ADD CONSTRAINT PK_TARJETA PRIMARY KEY(numeroTJ);

--  INTEGRIDAD REFERENCIAL

ALTER TABLE TARJETA
ADD CONSTRAINT FK_CLIENTE_TARJETA FOREIGN KEY(rutCL)
REFERENCES CLIENTE(rutCL);

--  INTEGRIDAD DE DOMINIO

--  CLIENTE.generoCL
--  Lista de valores

ALTER TABLE CLIENTE
ADD CONSTRAINT CK_generoCL  CHECK (generoCL IN ('F','M','O'));

ALTER TABLE CLIENTE
ADD CONSTRAINT CK_tipoCL  CHECK (tipoCL IN ('TD','TI','DC','PS','MT','ES'));



















