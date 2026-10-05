import pyodbc
import decimal
import datetime

class Estudiante:
    id: int = 0
    documento: str = ""
    nombre: str = ""
    apellido: str = ""
    programa: str = ""
    estado: str = ""

    def GetId(self) -> int:
        return self.id
    def SetId(self, value: int) -> None:
        self.id = value

    def GetDocumento(self) -> str:
        return self.documento
    def SetDocumento(self, value: str) -> None:
        self.documento = value

    def GetNombre(self) -> str:
        return self.nombre
    def SetNombre(self, value: str) -> None:
        self.nombre = value

    def GetApellido(self) -> str:
        return self.apellido
    def SetApellido(self, value: str) -> None:
        self.apellido = value

    def GetPrograma(self) -> str:
        return self.programa
    def SetPrograma(self, value: str) -> None:
        self.programa = value

    def GetEstado(self) -> str:
        return self.estado
    def SetEstado(self, value: str) -> None:
        self.estado = value


class Conexion:
    strConexion: str = """		
        Driver={MySQL ODBC 9.0 Unicode Driver};
        Server=localhost;
        Database=db_clase_07092026_is;
        PORT=3306;
        user=usuario_python;
        password=5sd64g56dfg54"""

    def ConsultarEstudiantesInline(self) -> list:
        conexion = pyodbc.connect(self.strConexion)
        consulta: str = """
            SELECT e.id, e.documento, e.nombre, e.apellido, p.nombre, es.nombre 
            FROM estudiantes e
            INNER JOIN programas p ON e.programa_id = p.id
            INNER JOIN estados es ON e.estado_id = es.id
        """
        cursor = conexion.cursor()
        cursor.execute(consulta)

        lista: list = []
        for elemento in cursor:
            estudiante: Estudiante = Estudiante()
            estudiante.SetId(elemento[0])
            estudiante.SetDocumento(elemento[1])
            estudiante.SetNombre(elemento[2])
            estudiante.SetApellido(elemento[3])
            estudiante.SetPrograma(elemento[4])
            estudiante.SetEstado(elemento[5])
            lista.append(estudiante)

        cursor.close()
        conexion.close()
        return lista

    def ConsultarEstudiantesStoredProcedure(self) -> list:
        conexion = pyodbc.connect(self.strConexion)
        consulta: str = "{CALL proc_select_estudiantes()}"
        cursor = conexion.cursor()
        cursor.execute(consulta)

        lista: list = []
        for elemento in cursor:
            estudiante: Estudiante = Estudiante()
            estudiante.SetId(elemento[0])
            estudiante.SetDocumento(elemento[1])
            estudiante.SetNombre(elemento[2])
            estudiante.SetApellido(elemento[3])
            estudiante.SetPrograma(elemento[4])
            estudiante.SetEstado(elemento[5])
            lista.append(estudiante)

        cursor.close()
        conexion.close()
        return lista


# Ejecución de prueba
conexion: Conexion = Conexion()

print("--- CONSULTA MEDIANTE STORED PROCEDURE ---")
lista_sp = conexion.ConsultarEstudiantesStoredProcedure()
for est in lista_sp:
    print(f"ID: {est.GetId()} | Doc: {est.GetDocumento()} | Nombre: {est.GetNombre()} {est.GetApellido()} | Programa: {est.GetPrograma()} | Estado: {est.GetEstado()}")

print("\n--- CONSULTA MEDIANTE INLINE SQL ---")
lista_inline = conexion.ConsultarEstudiantesInline()
for est in lista_inline:
    print(f"ID: {est.GetId()} | Doc: {est.GetDocumento()} | Nombre: {est.GetNombre()} {est.GetApellido()} | Programa: {est.GetPrograma()} | Estado: {est.GetEstado()}")