#implementación difícil de sesiones a través de cookies
require 'base64'
require 'sinatra'

get '/' do 
    app = request.cookies[:nombre_app]
    app ||= "esto es una cookie"
    response.set_cookie :nombre_app, app
    erb %{Listo, cookie; <a href="/session">Sesiones!</a>}
end

get '/session' do 
    #un hash vacío
    sesion ||= {}
    #lo llenamos:
    sesion[:algo] = rand 4567 
    #pero en las cookies sólo pueden ir strings:
    sesion_codificada = Base64.encode64 Marshal.dump sesion
    response.set_cookie :sesion, sesion_codificada
    erb %{La sesion era #{sesion.inspect} y así se ve codificada#{sesion_codificada} <a href="/ver">  Verla!</a>}
end

get '/ver' do 
    sesion = request.cookies["sesion"]
    redirect '/session' unless sesion
    sesion_decodificada = Marshal.load Base64.decode64 sesion
    %{La sesion ha llegado: #{sesion_decodificada.inspect}, y estaba en esta cookie: #{sesion}}
end
