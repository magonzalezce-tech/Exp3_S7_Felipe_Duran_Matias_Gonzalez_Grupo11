CREATE TABLE REGION (
    id_region      NUMBER(2) GENERATED ALWAYS AS IDENTITY (START WITH 7 INCREMENT BY 2),
    nombre_region  VARCHAR2(25) NOT NULL,
    CONSTRAINT REGION_PK PRIMARY KEY (id_region)
);


CREATE TABLE IDIOMA (
    id_idioma      NUMBER(3) GENERATED ALWAYS AS IDENTITY (START WITH 25 INCREMENT BY 3),
    nombre_idioma  VARCHAR2(30) NOT NULL,
    CONSTRAINT IDIOMA_PK PRIMARY KEY (id_idioma)
);


CREATE TABLE ESTADO_CIVIL (
    id_estado_civil          VARCHAR2(2),
    descripcion_est_civil    VARCHAR2(25) NOT NULL,
    CONSTRAINT ESTADO_CIVIL_PK PRIMARY KEY (id_estado_civil)
);


CREATE TABLE GENERO (
    id_genero           VARCHAR2(3),
    descripcion_genero  VARCHAR2(25) NOT NULL,
    CONSTRAINT GENERO_PK PRIMARY KEY (id_genero)
);


CREATE TABLE TITULO (
    id_titulo           VARCHAR2(3),
    descripcion_titulo  VARCHAR2(60) NOT NULL,
    CONSTRAINT TITULO_PK PRIMARY KEY (id_titulo)
);


CREATE SEQUENCE SEQ_COMUNA 
START WITH 1101 
INCREMENT BY 6;

CREATE TABLE COMUNA (
    id_comuna      NUMBER(5),
    comuna_nombre  VARCHAR2(25) NOT NULL,
    cod_region     NUMBER(2) NOT NULL,
    CONSTRAINT COMUNA_PK PRIMARY KEY (id_comuna, cod_region),
    CONSTRAINT COMUNA_FK_REGION FOREIGN KEY (cod_region) 
        REFERENCES REGION (id_region)
);


CREATE SEQUENCE SEQ_COMPANIA 
START WITH 10 
INCREMENT BY 5;

CREATE TABLE COMPANIA (
    id_empresa      NUMBER(2),
    nombre_empresa  VARCHAR2(25) NOT NULL,
    calle           VARCHAR2(50) NOT NULL,
    numeracion      NUMBER(5) NOT NULL,
    renta_promedio  NUMBER(10) NOT NULL,
    pct_aumento     NUMBER(4,3) NOT NULL,
    cod_comuna      NUMBER(5) NOT NULL,
    cod_region      NUMBER(2) NOT NULL,
    CONSTRAINT COMPANIA_PK PRIMARY KEY (id_empresa),
    CONSTRAINT COMPANIA_UN_NOMBRE UNIQUE (nombre_empresa),
    CONSTRAINT COMPANIA_FK_COMUNA FOREIGN KEY (cod_comuna, cod_region) 
        REFERENCES COMUNA (id_comuna, cod_region)
);


CREATE TABLE PERSONAL (
    rut_persona         NUMBER(8),
    dv_persona          CHAR(1) NOT NULL,
    primer_nombre       VARCHAR2(25) NOT NULL,
    segundo_nombre      VARCHAR2(25),
    primer_apellido     VARCHAR2(25) NOT NULL,
    segundo_apellido    VARCHAR2(25),
    fecha_contratacion  DATE NOT NULL,
    fecha_nacimiento    DATE NOT NULL,
    email               VARCHAR2(100),
    calle               VARCHAR2(50) NOT NULL,
    numeracion          NUMBER(5) NOT NULL,
    sueldo              NUMBER(5) NOT NULL,
    cod_comuna          NUMBER(5) NOT NULL,
    cod_region          NUMBER(2) NOT NULL,
    cod_genero          VARCHAR2(3) NOT NULL,
    cod_estado_civil    VARCHAR2(2) NOT NULL,
    cod_empresa         NUMBER(2) NOT NULL,
    encargado_rut       NUMBER(8),
    CONSTRAINT PERSONAL_PK PRIMARY KEY (rut_persona),
    CONSTRAINT PERSONAL_FK_COMPANIA FOREIGN KEY (cod_empresa) REFERENCES COMPANIA(id_empresa),
    CONSTRAINT PERSONAL_FK_COMUNA FOREIGN KEY (cod_comuna, cod_region) REFERENCES COMUNA(id_comuna, cod_region),
    CONSTRAINT PERSONAL_FK_ESTADO_CIVIL FOREIGN KEY (cod_estado_civil) REFERENCES ESTADO_CIVIL(id_estado_civil),
    CONSTRAINT PERSONAL_FK_GENERO FOREIGN KEY (cod_genero) REFERENCES GENERO(id_genero),
    CONSTRAINT PERSONAL_PERSONAL_FK FOREIGN KEY (encargado_rut) REFERENCES PERSONAL(rut_persona)
);


CREATE TABLE TITULATION (
    cod_titulo      VARCHAR2(3),
    persona_rut     NUMBER(8),
    fecha_titulacion DATE NOT NULL,
    CONSTRAINT TITULACION_PK PRIMARY KEY (cod_titulo, persona_rut),
    CONSTRAINT TITULACION_FK_PERSONAL FOREIGN KEY (persona_rut) REFERENCES PERSONAL(rut_persona),
    CONSTRAINT TITULACION_FK_TITULO FOREIGN KEY (cod_titulo) REFERENCES TITULO(id_titulo)
);


CREATE TABLE DOMINIO (
    id_idioma    NUMBER(3),
    persona_rut  NUMBER(8),
    nivel        VARCHAR2(25) NOT NULL,
    CONSTRAINT DOMINIO_PK PRIMARY KEY (id_idioma, persona_rut),
    CONSTRAINT DOMINIO_FK_IDIOMA FOREIGN KEY (id_idioma) REFERENCES IDIOMA(id_idioma),
    CONSTRAINT DOMINIO_FK_PERSONAL FOREIGN KEY (persona_rut) REFERENCES PERSONAL(rut_persona)
);

ALTER TABLE PERSONAL 
ADD CONSTRAINT PERSONAL_EMAIL_UN UNIQUE (email);


ALTER TABLE PERSONAL 
ADD CONSTRAINT PERSONAL_DV_CK CHECK (dv_persona IN ('0','1','2','3','4','5','6','7','8','9','K','k'));


ALTER TABLE PERSONAL MODIFY sueldo NUMBER(8);
ALTER TABLE PERSONAL 
ADD CONSTRAINT PERSONAL_SUELDO_MIN_CK CHECK (sueldo >= 450000);

CREATE SEQUENCE SEQ_COMUNA
    START WITH 1101
    INCREMENT BY 6;

CREATE SEQUENCE SEQ_COMPANIA
    START WITH 10
    INCREMENT BY 5;


INSERT INTO REGION (nombre_region) VALUES ('METROPOLITANA');
INSERT INTO REGION (nombre_region) VALUES ('VALPARAISO');
INSERT INTO REGION (nombre_region) VALUES ('BIOBIO');
INSERT INTO REGION (nombre_region) VALUES ('DEL MAULE');


INSERT INTO IDIOMA (nombre_idioma) VALUES ('Inglés');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Portugués');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Francés');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Alemán');


INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (SEQ_COMUNA.NEXTVAL, 'Providencia', 7);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (SEQ_COMUNA.NEXTVAL, 'Viña del Mar', 9);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (SEQ_COMUNA.NEXTVAL, 'Concepción', 11);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (SEQ_COMUNA.NEXTVAL, 'Talca', 13);


INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (SEQ_COMPANIA.NEXTVAL, 'Carpenter Retail S.A.', 'Av. Vitacura', 1230, 850000, 0.052, 1101, 7);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (SEQ_COMPANIA.NEXTVAL, 'Logística Avanzada SPA', 'Calle Limache', 450, 680000, 0.045, 1107, 9);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (SEQ_COMPANIA.NEXTVAL, 'Distribuidora del Sur', 'O’Higgins', 890, 720000, 0.060, 1113, 11);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) 
VALUES (SEQ_COMPANIA.NEXTVAL, 'Textiles Carpenter', 'Av. Dos Sur', 105, 590000, 0.038, 1119, 13);

COMMIT;

SELECT *
FROM IDIOMA
