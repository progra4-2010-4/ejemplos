require 'sinatra'
enable :sessions
#cf: http://rack.rubyforge.org/doc/Rack/Session/Cookie.html

class Visits 
    @@global = 0
    def self.global; @@global; end
    def self.add 
        @@global +=1 
    end
end

get '/' do 
    session[:visits] ||= 0
    session[:visits] += 1
    Visits.add #una visita global (server)
    haml :index
end

#esto es una template inline (ver aquí: http://www.sinatrarb.com/intro)
#Está creada usando el lenguaje de plantillas haml (ver acá: http://haml-lang.com/ ) en lugar de erb
__END__

@@index
!!!
%html
    %head
        %meta{:charset=>"utf-8"}
        %link{:rel=>"stylesheet", :href=>"/style.css"}
        %title Session test
    %body
        %h1 Contador de visitas
        #global
            %span.counter= Visits.global
            %p Globales
        #local
            %span.counter= session[:visits]
            %p Tuyas
