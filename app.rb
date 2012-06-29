require './lib/models'

class App < Sinatra::Base
  helpers Sinatra::Param
  
  before do
    content_type :json
  end

  get '/plants/search' do
    param :q, String, blank: false
    param :scope, String, in: ['title', 'content'], default: 'title'
    
    case params[:scope]
    when 'title'
      @plants = Plant.filter(:common_name.ilike("%#{params[:q]}%") | :latin_name.ilike("#{params[:q]}%"))
    when 'content'
      @plants = Plant.filter("tsv @@ to_tsquery('english', ?)", "#{params[:q]}:*")
    end
    
    {
      plants: @plants.limit(25)
    }.to_json
  end
end
