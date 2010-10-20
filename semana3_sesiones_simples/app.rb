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

#esto es una template inline:

__END__

@@index
!!!
%html
    %head
        %meta{:charset=>"utf-8"}
        %title Session test
    %body
        #global
            %h2 Visitas en total
            =Visits.global
        #local
            %h2 Visitas tuyas
            =session[:visits]
