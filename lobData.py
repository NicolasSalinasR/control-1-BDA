import psycopg2
from faker import Faker


# Crear conexión
try:
    conexion = psycopg2.connect("dbname=control1 user=postgres password=postgresql")
except psycopg2.Error as e:
    print(f"Error al conectar a la base de datos: {e}")
    exit()

# Crear cursor
cursor = conexion.cursor()

# Create Faker instance
fake = Faker()

# TABLA CLIENTE
for _ in range(1000):
    # Generate fake data
    # Los nombres no pueden tener comillas simples o dobles, genera error en la consulta SQL
    nombre_cliente = fake.first_name().replace("'", "").replace('"', "")
    # Se genera una lista de nacionalidades y se elige una al azar
    nacionalidades = ["Chileno", "Argentino", "Peruano", "Boliviano", "Brasileño", "Colombiano", "Ecuatoriano", "Venezolano", "Paraguayo", "Uruguayo", "Mexicano", "Estadounidense", "Canadiense", "Cubano", "Guatemalteco", "Hondureño", "Salvadoreño", "Nicaragüense", "Costarricense", "Panameño", "Haitiano", "Dominicano"]
    nacionalidad_cliente = fake.random_element(nacionalidades)
    
    query = f"INSERT INTO Cliente (nombre_cliente, nacionalidad_cliente) VALUES ('{nombre_cliente}', '{nacionalidad_cliente}');"
    cursor.execute(query) # Se ejecuta la consulta
    
    
# Se hace commit para guardar los cambios
conexion.commit()

# TABLA SUELDO
for _ in range(100):  
    # Generate fake data
    monto_sueldo = fake.random_int(min=500000, max=1000000)
    # Se toman las fechas desde el dia de hoy hasta 5 años atras
    fecha_pago_sueldo = fake.date_between(start_date="-5y", end_date="today").strftime("%Y-%m-%d")
    
    # pasar a tipo date
    fecha_pago_sueldo = f"'{fecha_pago_sueldo}'"

    query = f"INSERT INTO Sueldo (monto_sueldo, fecha_pago_sueldo) VALUES ({monto_sueldo}, {fecha_pago_sueldo});"
    cursor.execute(query) # Se ejecuta la consulta 
    
    
# Se hace commit para guardar los cambios
conexion.commit()
    
for _ in range(100):  
    # Generate fake data
    nombre_compañia = fake.company()
    
    query = f"INSERT INTO Compañia (nombre_compañia) VALUES ('{nombre_compañia}');"
    cursor.execute(query) # Se ejecuta la consulta
    
    
# Se hace commit para guardar los cambios
conexion.commit()

# TABLA EMPLEADO
for _ in range(1000):
    # Generate fake data
    # Se debe reemplazar las comillas simples y dobles para evitar errores en la consulta SQL
    nombre_empleado = fake.first_name().replace("'", "").replace('"', "")
    
    # Se usan como ejemplo algunos cargos que puede tener un empleado y se elige uno al azar
    cagos = ["Piloto", "Azafata", "Mecanico", "Administrativo", "Tecnico", "Ingeniero", "Tripulante"]
    cargo_empleado = fake.random_element(cagos)
    id_sueldo = fake.random_int(min=1, max=100)
    id_compañia = fake.random_int(min=1, max=100)
    
    query = f"INSERT INTO Empleado (nombre_empleado, cargo_empleado, id_sueldo, id_compañia) VALUES ('{nombre_empleado}', '{cargo_empleado}', {id_sueldo}, {id_compañia});"
    cursor.execute(query) # Se ejecuta la consulta
    
    
# Se hace commit para guardar los cambios
conexion.commit()

# TABLA CLIENTE_COMPANIA
for _ in range(1000):  
    id_cliente = fake.random_int(min=1, max=1000)
    id_compañia = fake.random_int(min=1, max=100)
    
    query = f"INSERT INTO Cliente_compañia (id_cliente, id_compañia) VALUES ({id_cliente}, {id_compañia});"
    cursor.execute(query) # Se ejecuta la consulta
    
    
# Se hace commit para guardar los cambios
conexion.commit()
    
# TABLA EMPLEADO_COMPANIA
for _ in range(1000): 
    # Modelos de avion que se pueden usar y se elige uno al azar
    modelos_avion = ["Boeing 747", "Boeing 777", "Boeing 787", "Airbus A320", "Airbus A330", "Airbus A340", "Airbus A350", "Airbus A380", "Embraer E190", "Embraer E195", "Embraer E175", "Embraer E170", "Bombardier CRJ100", "Bombardier CRJ200", "Bombardier CRJ700", "Bombardier CRJ900", "Bombardier CRJ1000", "McDonnell Douglas MD-80", "McDonnell Douglas MD-90", "McDonnell Douglas MD-95", "McDonnell Douglas MD-11", "McDonnell Douglas MD-87", "McDonnell Douglas MD-88", "McDonnell Douglas MD-83", "McDonnell Douglas MD-82", "McDonnell Douglas MD-81"]
    nombre_modelo = fake.random_element(modelos_avion)
    
    query = f"INSERT INTO Modelo (nombre_modelo) VALUES ('{nombre_modelo}');"
    cursor.execute(query) # Se ejecuta la consulta
    
    
# Se hace commit para guardar los cambios
conexion.commit()
    
# TABLA AVION
for _ in range(1000):  
    vuelos_avion = fake.random_int(min=1, max=100)
    id_compañia = fake.random_int(min=1, max=100)
    id_modelo = fake.random_int(min=1, max=1000)
    
    query = f"INSERT INTO Avion (vuelos_avion, id_compañia, id_modelo) VALUES ({vuelos_avion}, {id_compañia}, {id_modelo});"
    cursor.execute(query) # Se ejecuta la consulta     
    
# Se hace commit para guardar los cambios
conexion.commit()
    
# TABLA VUELO
for _ in range(1000):
    id_compañia = fake.random_int(min=1, max=100)
    id_avion = fake.random_int(min=1, max=1000)
    
    query = f"INSERT INTO Vuelo (id_compañia, id_avion) VALUES ({id_compañia}, {id_avion});"
    cursor.execute(query) # Se ejecuta la consulta
    
    
# Se hace commit para guardar los cambios
conexion.commit()

# TABLA CLIENTE_VUELO
for _ in range(1000): 
    id_cliente = fake.random_int(min=1, max=1000)
    id_vuelo = fake.random_int(min=1, max=1000)
    
    query = f"INSERT INTO Cliente_vuelo (id_cliente, id_vuelo) VALUES ({id_cliente}, {id_vuelo});"
    cursor.execute(query) # Se ejecuta la consulta
    
    
# Se hace commit para guardar los cambios
conexion.commit()

# TABLA EMP_VUELO
for _ in range(1000):
    id_vuelo = fake.random_int(min=1, max=1000)
    id_empleado = fake.random_int(min=1, max=1000)
    
    query = f"INSERT INTO Emp_vuelo (id_vuelo, id_empleado) VALUES ({id_vuelo}, {id_empleado});"
    cursor.execute(query) # Se ejecuta la consulta
    
    
# Se hace commit para guardar los cambios
conexion.commit()
    
# TABLA SECCION
# Se usan como ejemplo las 3 clases de secciones que puede tener un avion
nombre_seccion = ["Primera Clase", "Clase Ejecutiva", "Clase Turista"]

query = f"INSERT INTO Seccion (nombre_seccion) VALUES ('{nombre_seccion[0]}');"
cursor.execute(query)

query = f"INSERT INTO Seccion (nombre_seccion) VALUES ('{nombre_seccion[1]}');"
cursor.execute(query)

query = f"INSERT INTO Seccion (nombre_seccion) VALUES ('{nombre_seccion[2]}');"
cursor.execute(query)


# Se hace commit para guardar los cambios
conexion.commit()

# TABLA COSTO
for _ in range(1000):
    valor_costo = fake.random_int(min=100000, max=1000000)
    
    query = f"INSERT INTO Costo (valor_costo) VALUES ({valor_costo});"
    cursor.execute(query) # Se ejecuta la consulta
    
    
# Se hace commit para guardar los cambios
conexion.commit()

# TABLA PASAJE    
for _ in range(950): 
    # Generate fake data
    # Se toman las fechas desde el dia de hoy hasta 5 años atras
    fecha_pasaje = fake.date_between(start_date="-5y", end_date="today").strftime("%Y-%m-%d")
    # Se genera una lista de paises y se elige uno al azar
    paises = ["Chile", "Argentina", "Peru", "Bolivia", "Brasil", "Colombia", "Ecuador", "Venezuela", "Paraguay", "Uruguay", "Mexico", "Estados Unidos", "Canada", "Cuba", "Guatemala", "Honduras", "El Salvador", "Nicaragua", "Costa Rica", "Panama", "Haiti", "Republica Dominicana"]
    origen_pasaje = fake.random_element(paises)
    destino_pasaje = fake.random_element(paises)
    id_vuelo = fake.random_int(min=1, max=1000)
    id_costo = fake.random_int(min=1, max=1000)
    id_seccion = fake.random_int(min=1, max=3)
    
    query = f"INSERT INTO Pasaje (fecha_pasaje, origen_pasaje, destino_pasaje, id_vuelo, id_costo, id_seccion) VALUES ('{fecha_pasaje}', '{origen_pasaje}', '{destino_pasaje}', {id_vuelo}, {id_costo}, {id_seccion});"
    cursor.execute(query) # Se ejecuta la consulta
    
# También es para la tabla de pasajes pero para generar el caso de personas que viajan harto en el periodo de un mes
for _ in range(50): 
    # Se toman las fechas desde el dia de hoy hasta 1 mes atras
    fecha_pasaje = fake.date_between(start_date="-1m", end_date="today").strftime("%Y-%m-%d")
    # Se genera una lista de paises y se elige uno al azar
    paises = ["Chile", "Argentina", "Peru", "Bolivia", "Brasil", "Colombia", "Ecuador", "Venezuela", "Paraguay", "Uruguay", "Mexico", "Estados Unidos", "Canada", "Cuba", "Guatemala", "Honduras", "El Salvador", "Nicaragua", "Costa Rica", "Panama", "Haiti", "Republica Dominicana"]
    origen_pasaje = fake.random_element(paises)
    destino_pasaje = fake.random_element(paises)
    id_vuelo = fake.random_int(min=1, max=4)
    id_costo = fake.random_int(min=1, max=4)
    id_seccion = 1
    
    query = f"INSERT INTO Pasaje (fecha_pasaje, origen_pasaje, destino_pasaje, id_vuelo, id_costo, id_seccion) VALUES ('{fecha_pasaje}', '{origen_pasaje}', '{destino_pasaje}', {id_vuelo}, {id_costo}, {id_seccion});"
    cursor.execute(query) # Se ejecuta la consulta

# Se hace commit para guardar los cambios
conexion.commit()