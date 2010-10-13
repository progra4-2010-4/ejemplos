require 'sinatra'

get('/'){ send_file "views/index.html" }


get '/calcu' do
    #Params es un hash que contiene ya sea los parámetros del get o el cuerpo decodificado del post
    x = params[:x].to_i #vienen como strings, los convertimos a enteros
    y = params[:y].to_i
    #los arreglos se pasan como arr[]=elem1&arr[]=elem2...
    #p params[:arr]
    #res es una variable de instancia, disponible para el resto de la respuesta
    @res = case params[:op]
        when "sum" then x + y 
        when "min" then x - y 
        when "div" then x / y
        when "mul" then x * y
    end

    #el método erb busca una plantilla llamada como el param y le
    #pasa las variables de instancia para generar el html
    erb :resultado
end

   


