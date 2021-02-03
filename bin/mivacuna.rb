require 'cgi'

# 1. fill out basic info
#   review state & municipality enums before creating script
name = ''
last_name = ''
maiden_name = ''
curp = ''
# format dd/mm/YYYY
birth_date = ''
# MUJER/HOMBRE
gender = ''
# 1 - AGUASCALIENTES
# 2 - BAJA CALIFORNIA
# 3 - BAJA CALIFORNIA SUR
# ...
state = '' # CDMX
# based on state
# 1 (31) - Abalá
# ...
municipality = '' # Benito Juarez
# 5 digits
zip_code = ''
# 10 digits
contact_phone_1 = ''
# 10 digits
contact_phone_2 = ''
# valid contact email
contact_email_1 = ''
# valid contact email
contact_email_2 = ''
# HTML confirmation
output_file = "~/Downloads/0202vaccine-#{curp}.html"

# 2. Bild raw HTTP params
raw_data = ["nombre=#{CGI.escape(name)}", "paterno=#{CGI.escape(last_name)}",
            "materno=#{CGI.escape(maiden_name)}", "curp=#{CGI.escape(curp)}",
            "fechanac=#{CGI.escape(birth_date)}", "sexo=#{CGI.escape(gender)}",
            "entidadd=#{CGI.escape(state)}",
            "municipio=#{CGI.escape(municipality)}",
            "cp=#{CGI.escape(zip_code)}",
            "telefono_1=#{CGI.escape(contact_phone_1)}",
            "telefono_2=#{CGI.escape(contact_phone_2)}",
            "correoe=#{CGI.escape(contact_email_1)}",
            "correoea=#{CGI.escape(contact_email_2)}",
            'confirmar=Enviar'].join('&')

# 3. build URL command
curl_cmd = "
curl 'https://mivacuna.salud.gob.mx/index.php' \
  -H 'sec-ch-ua: \"Chromium\";v=\"88\", \"Google Chrome\";v=\"88\""\
  ", \";Not A Brand\";v=\"99\"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'Origin: https://mivacuna.salud.gob.mx' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_1)"\
  "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.96 Safari/537.36' \
  -H 'Referer: https://mivacuna.salud.gob.mx/' \
  --data-raw '#{raw_data}' \
  --compressed > #{output_file}"

# 4. signup loop
attempt = 0
begin
  result = system curl_cmd
  raise 'retry' unless result
  system 'echo "It is Done!!!!!!!!!!!!" | wall'
rescue StandardError
  attempt += 1
  pp "Failed attempt #{attempt}. Retrying...."
  retry
end
