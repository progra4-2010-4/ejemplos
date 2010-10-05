#encoding=utf8

require 'sinatra'
require 'hpricot'

#devuelve texto plano
get '/' do 
    "¡hola mundo!"
end

#Devuelve un archivo en esta misma carpeta, lo transfiere como html
get '/agua' do
    send_file "hola.html"
end

#Obtiene 5 números aleatorios y los transfiere como texto plano
#una solución alterna: get('/rand') {%w[a b c d e].fill {rand(10)}.join("\n")}
#RETO: ¿por qué esa forma funciona?
get '/rand' do
 str = "" ; 5.times{str << "%s "%rand(10)}
 str.gsub! " ", "\n"
end

#Obtiene todos los hipervínculos en una página
get '/links' do
    page = Hpricot File.open "lista.html"
    links = []
    page.search "a" do |link|
        links << {:href =>  link.get_attribute('href'), :text => link.inner_text }
    end
    links.inspect

end
