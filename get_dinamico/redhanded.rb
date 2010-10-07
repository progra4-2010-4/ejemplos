#importar sinatra, hpricot y la librería para solicitar e interpretar URIs
#%w[sinatra hpricot open-uri].each {|lib| require lib}
%w[sinatra hpricot open-uri].map &method(:require)

#Recibe una dirección de una página que bajar y una *función* a aplicar a cada link
#
#address:: la dirección a abrir
#condition:: un bloque anónimo que se ejecutará para cada link
def extraer_links(address, condition)
    links = []
    #la función open recibe una URI y pasa a un bloque el recurso recibido
    open address  do |page|
        #HPricot agarra un documento y lo convierte en una estructura manipulable
        html = Hpricot page.read
        #Vamos a buscar todos los anchor tags en el documento, y cada uno entrará al bloque
        html.search "a" do |link|
            #Agregaremos los links SÓLO SI pasan la condición
            links << {:text =>link.inner_text, :href=> link.get_attribute('href') , 
                :title=> link.get_attribute('title')} if condition.call link 
        end
    end
    #la última sentencia del método es implícitamente su valor de retorno
    links
end

#Este se conoce como CONTROLADOR: hace la lógica que prepara las VISTAS de cliente
get '/' do
    #este es un hash que mapea el sitio a sus propiedades
    sites = {"hn" => {:title=>"Hacker news",
                      :url =>"http://news.ycombinator.com/newest",
                      :cond => lambda {|link| link.get_attribute('href') =~ /http:\/\/.*/ }},

             "rh" => {:title=>"RedHanded",
                      :url=>"http://viewsourcecode.org/why/redhanded/",
                      :cond=>lambda {|link| link.inner_text == "#"}}
            }
    #si no viene ningún sitio, defaulteamos a redhanded
    site = params[:site] || "rh"
    #se crean variables de instancia. Todo en este texto esta dentro de una instancia de la clase Sinatra::Base
    #estas vars se pueden usar dentro de las views
    @links = extraer_links sites[site][:url],  sites[site][:cond]
    @site = sites[site][:title]
    #llamamos al metodo erb, que toma una plantilla y la llena dinamicamente para crear una VISTA
    erb :links
end

