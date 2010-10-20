#reimplementación de sesiones, esta vez usando las sesiones de sinatra
require 'sinatra'
enable :sessions

get '/' do 
    app = request.cookies[:nombre_app]
    app ||= "esto es una cookie"
    response.set_cookie :nombre_app, app
    erb %{Listo, cookie; <a href="/session">Sesiones!</a>}
end

get '/session' do 
    session[:algo] = rand 4567 
    #pero en las cookies sólo pueden ir strings:
    p response
    erb %{La sesion es #{session.inspect} y ahora se guardó sola en un cookie <a href="/ver">  Verla!</a>}
end

get '/ver' do 
    redirect '/session' unless session[:algo]
    %{La sesion ha llegado: #{session[:algo]}, y estaba en esta cookie: #{request.cookies["rack.session"]}}
end
