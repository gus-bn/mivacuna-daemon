# Mivacuna Daemon

**UPDATE [02/02/2021]: Desde las 18:00HRS, el sitio de encuentra en MANTENIMIENTO por lo que este SCRIPT NO ES VÁLIDO YA QUE NO EXISTE PÁGINA DE REGISTRO**: 

Script en Ruby para el registro en sitio web https://mivacuna.salud.gob.mx. Generación de un demonio que reintentará enviar el formulario de registro hasta generar un folio. Emula un "humano" intentando registrarse una y otra vez hasta lograrlo.

## Pre-requisitos
Este script requiere de las siguientes dependencias para ejecutarse:
* [RVM](http://rvm.io/)
* [Git](https://git-scm.com/)

## Inspiración e Historia

- Este es un proyecto personal que surge como respuesta a la baja disponibilidad del sitio oficial de registro de vacunación para adultos mayores [https://mivacuna.salud.gob.mx](https://mivacuna.salud.gob.mx)
- Desde su publicación en [medios](https://www.forbes.com.mx/noticias-registro-vacuna-se-cae-pagina-gobierno/) intenté registrar a mis seres queridos **elegibles** (mayores de 60 años) sin lograrlo debido a la sobrecarga de demanda en los sitios y la concurrencia que el gobierno no anticipó.
- A través de Ingeniería en reversa, logré emular el envío de formulario de manera automática, es decir, la equivalencia a un humano reintentando refrescar la página hasta lograr el registro.

## Disclaimer

- Este SW se distribuye de manera libre, sin ninguna garantía de acuerdo a la licencia [MIT](https://opensource.org/licenses/MIT)
- No busca causar daño o lucro de ningún tipo, sino lograr que la mayor cantidad de personas completen el registro a los cuales los cuidadan@s tienen derecho.
- Su objetivo es mejorar el manejo de la **concurrencia** de tal forma que se estabilice el número de peticiones simultáneas que tiene el sistema de gobierno.

**THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.**

### Ejecución

- Para configurar el script, llena los valores en `bin/mivacuna.rb`.
- Para los valores de `state` y `municipality` refiere a los archivos del dir `enum`
- **IMPORTANTE:** Localiza el municipio correspondiente a tu estado.
- Antes de continuar, asegúrate de contar con los siguientes datos de la persona que quieras registrar:
  - CURP
  - Código Postal
  - 2 números de contacto telefónico
  - 2 números de contacto email (correo electrónico)

#### Ejemplo
- Estado: **CDMX**
- Alcaldía (Municipio): **Benito Juarez**

1. Ingresa a `state.rb`, y confirma el valor **9** que corresponde a CDMX (DISTRITO FEDERAL)

```ruby
...
# 8 - CHIHUAHUA
# 5 - COAHUILA
# 6 - COLIMA
# 9 - DISTRITO FEDERAL
...
```

2. Ingresa a  `municipality.rb`, localiza el valor de **Benito Juarez** que corresponda al estado del paso anterior = **14**

```ruby
...
# 114 (7) - Benemérito de las Américas
# 45 (29) - Benito Juárez
# 71 (26) - Benito Juárez
# 14 (12) - Benito Juárez
# 27 (30) - Benito Juárez
# 5 (23) - Benito Juárez
# 14 (9) - Benito Juárez
# 4 (32) - Benito Juárez
...
```

3. Ingresa a [https://www.gob.mx/curp/](https://www.gob.mx/curp/) y obtén los datos personales de la persona que quieres registrar


4. Completa los demás valores de `bin/mivacuna.rb`:

```ruby
# 1. fill out basic info
#   review state & municipality enums before creating script
name = 'María'
last_name = 'Pérez'
maiden_name = 'López'
curp = 'PELMxxxxxxxxxxxxxx'
# format dd/mm/YYYY
birth_date = 'xx/xx/xx'
# MUJER/HOMBRE
gender = 'MUJER'
# 1 - AGUASCALIENTES
# 2 - BAJA CALIFORNIA
# 3 - BAJA CALIFORNIA SUR
# ...
state = '9' # CDMX
# based on state
# 1 (31) - Abalá
# ...
municipality = '14' # Benito Juarez
# 5 digits
zip_code = '11000'
# 10 digits
contact_phone_1 = '5511223344'
# 10 digits
contact_phone_2 = '5511223344'
# valid contact email
contact_email_1 = 'maria@hotmail.com'
# valid contact email
contact_email_2 = 'perez@gmail.com'
...
```

5. Una vez completado, corre el script via `ruby`

- `ruby bin/mivacuna.rb`


6. En cada iteración o intento, el script reintentará la ejecución:

```bash
mivacuna-daemon % ruby bin/mivacuna.rb
"curl (7) Failed to connect to mivacuna.salud.gob.mx 443: Operation Timed Out"
"Failed Attempt 1"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
    0           0          0       0       0    0:00:00  0:00:00 --:--:--   0

"curl (7) Failed to connect to mivacuna.salud.gob.mx 443: Operation Timed Out"
"Failed Attempt 2"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
    0           0          0       0       0    0:00:00  0:00:00 --:--:--   0
....
```

7. Cuando la ejecución sea satisfactoria, se enviará una notificación via `wall`

```bash
Broadcast Message from root@mycomptuter.local                                          
        (/dev/ttys007) at 00:17 CST...                                         

It is Done!!!!!!!!!!!!
```
