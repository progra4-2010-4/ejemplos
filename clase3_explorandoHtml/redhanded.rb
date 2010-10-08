#importar sinatra y hpricot
%w[sinatra hpricot open-uri].each {|lib| require lib}
#otra forma de importar: %w[sinatra hpricot nokogiri open-uri].map &method(:require)

get '/' do 
    send_file "plantilla.html"
end

