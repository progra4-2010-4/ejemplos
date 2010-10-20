#Como dice {acá}[http://rack.rubyforge.org/doc/Rack/Session/Cookie.html], las sesiones están guardadas
#en una string codificada en base 64 que representa a un objeto serializado (con el módulo Marshal)
require 'base64'
require 'readline' #podríamos usar gets, pero suckea
#decodificamos y deserializamos el objeto:
original = Marshal.load Base64.decode64 Readline.readline 'la original: '
p "El hash decodificado es #{original.inspect}"
hack = Base64.encode64 Marshal.dump eval Readline.readline 'tu hack: '
p "Tu hack codificado es #{hack}"

