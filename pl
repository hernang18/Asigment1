BEGIN
  DBMS_OUTPUT.put_line('¡Hola Mundo!');
END;

CREATE OR REPLACE PROCEDURE hola_mundo IS
  l_mensaje VARCHAR2(100) := '¡Hola Mundo!';
BEGIN
  DBMS_OUTPUT.put_line(l_mensaje);
END hola_mundo;

BEGIN
   hola_mundo;
END;


BEGIN
  FOR i IN 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE ('Inside loop, i is ' || TO_CHAR(i));
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE ('Outside loop, i is ' || TO_CHAR(i));
END;


CREATE OR REPLACE FUNCTION HR.OPERAR_NUMEROS(P_NUMEROA   IN NUMBER,
                                             P_NUMEROB   IN NUMBER,
                                             P_OPERACION IN CHAR)
RETURN NUMBER
IS
  V_RESULTADO NUMBER;
BEGIN
CASE
  WHEN P_OPERACION = '+' THEN
    V_RESULTADO := P_NUMEROA + P_NUMEROB;
  WHEN P_OPERACION = '-' THEN
    V_RESULTADO := P_NUMEROA - P_NUMEROB;
  WHEN P_OPERACION = '*' THEN
    V_RESULTADO := P_NUMEROA * P_NUMEROB;
  WHEN P_OPERACION = '/' THEN
    -- Controlamos las divisiones por 0
    IF P_NUMEROB = 0 THEN
      V_RESULTADO := 0;
    ELSE
      V_RESULTADO := P_NUMEROA / P_NUMEROB;
    END IF;
  ELSE
    -- En caso de que P_OPERACION contenga un caracter
    -- que no sean +,-,* ó / se devolverá NULL
    V_RESULTADO := NULL;
END CASE;
  RETURN V_RESULTADO;
40
END;

-- Uso de la función HR.OPERAR_NUMEROS
DECLARE
V_NUMA        NUMBER;
V_NUMB        NUMBER;
V_OPERACION   CHAR(1);
V_RESULTADO   NUMBER;
BEGIN  
-- Podemos pasar los valores para los parámetros de entrada.
-- usando variables.
V_NUMA := 10;
V_NUMB := 30;
V_OPERACION := '+';
V_RESULTADO := HR.OPERAR_NUMEROS(V_NUMA,V_NUMB,V_OPERACION);
DBMS_OUTPUT.PUT_LINE(V_NUMA ||
                     V_OPERACION ||
                     V_NUMB ||
                     '=' ||
                       V_RESULTADO);

-- Procedimiento que devuelve un texto sobre la fecha actual
-- haciendo uso de un parámetro de salida.
CREATE OR REPLACE PROCEDURE HR.OBTENER_FECHA(P_TEXTO OUT VARCHAR2)
IS
BEGIN
  P_TEXTO := 'La fecha actual es ' || TO_CHAR(SYSDATE,'DD/MM/YYYY');
END;

DECLARE
  V_FECHA    VARCHAR2(200);
BEGIN
  -- Pasamos la variable V_FECHA a la función HR.OBTENER_FECHA.
  -- V_FECHA estará referenciada al parámetro P_TEXTO, cualquier cambio
  -- en P_TEXTO se verá reflejado en V_FECHA posteriormente.
  HR.OBTENER_FECHA(V_FECHA);
  DBMS_OUTPUT.PUT_LINE('Valor de V_FECHA: ' || V_FECHA);
END;

CREATE TABLE HR.CLIENTE (
        id NUMBER NOT NULL,
        nombres VARCHAR(200) NOT NULL,
        apellidos VARCHAR(200) NOT NULL,
        fecha_afiliacion DATE NOT NULL,
        PRIMARY KEY(id)
);


CREATE OR REPLACE PROCEDURE HR.REGISTRAR_CLIENTE(P_ID        IN OUT NUMBER,
                                                 P_NOMBRES   IN VARCHAR2,
                                                 P_APELLIDOS IN VARCHAR2,
                                                 P_FECHA     IN DATE)
IS
  V_CONTEO NUMBER;
BEGIN
  -- Se busca si es que el ID existe
  SELECT COUNT(cli.id)
    INTO V_CONTEO
    FROM hr.cliente cli
   WHERE cli.id = P_ID;
  -- En caso de que V_CONTEO exista como ID
  -- se creará un ID alternativo
  IF V_CONTEO > 0 THEN
    DBMS_OUTPUT.PUT_LINE('El id ' || P_ID || ' ya existe.');
    SELECT MAX(cli.id)
      INTO P_ID
      FROM hr.cliente cli;
    P_ID := P_ID + 1;
    DBMS_OUTPUT.PUT_LINE('El id ha sido reemplazado por ' || P_ID || '.');
  END IF;
   
  INSERT INTO hr.cliente(id,nombres,apellidos,fecha_afiliacion)
     VALUES (P_ID,P_NOMBRES,P_APELLIDOS, P_FECHA);
  DBMS_OUTPUT.PUT_LINE('Insertado cliente: '|| P_ID || ' ' || P_NOMBRES || ' ' || P_APELLIDOS);
END;

