#importar sinatra y hpricot
%w[sinatra hpricot open-uri].each {|lib| require lib}
#otra forma de importar: %w[sinatra hpricot nokogiri open-uri].map &method(:require)

def extraer_links(address, condition)
    links = []
    open address  do |page|
        html = Hpricot page.read
        html.search "a" do |link|
            links << {:text =>link.inner_text, :href=> link.get_attribute('href') , 
                :title=> link.get_attribute('title')} if condition.call link 
        end
    end
    links
end

get '/' do 
    send_file "plantilla.html"
end

get '/ejemplo' do
    extraer_links("http://viewsourcecode.org/why/redhanded/", lambda{|link| link.inner_text == "#"}).collect{|hsh| hsh[:title]}
end

